<%@page session="false" pageEncoding="utf-8" %>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.2" %>
<%@taglib prefix="cpn" uri="http://sling.composum.com/cpnl/1.0" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="javax.jcr.Session" %>
<%@ page import="javax.jcr.nodetype.ConstraintViolationException" %>
<%@ page import="javax.jcr.query.Query" %>
<%@ page import="javax.jcr.version.Version" %>
<%@ page import="javax.jcr.version.VersionManager" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="org.apache.sling.api.resource.ResourceUtil" %>
<sling:defineObjects/>
<%
    /**
     * Collects all versionables that are not contained in the workspace anymore, and checks them out in
     * /var/composum/content/cpl:attic (folder like jcr:versionHistory), content removed.
     * This ensures that oak-upgrade will not discard those version histories.
     * We collect all the cpl:versionHistory of /jcr:root/var/composum/content//element(jcr:content,cpl:VersionReference) ,
     * subtract the jcr:versionHistory of all /jcr:root/content//element(*,mix:versionable).
     * Unclear: check out "highest" version of all releases?
     */
// SELECT [n.cpl:versionHistory] FROM [cpl:VersionReference] AS n WHERE ISDESCENDANTNODE(n, '/var/composum/content')
// SELECT [n.jcr:versionHistory] FROM [mix:versionable] AS n WHERE ISDESCENDANTNODE(n, '/content')

    final String ATTIC_PATH = "/var/composum/content/cpl:attic";

    Set<String> versionHistories = new HashSet<>();
    String queryReleased = "SELECT [cpl:versionHistory] FROM [cpl:VersionReference] WHERE ISDESCENDANTNODE('/var/composum/content')";
    for (Iterator<Map<String, Object>> it = resourceResolver.queryResources(queryReleased, Query.JCR_SQL2); it.hasNext(); ) {
        String historyUuid = String.valueOf(it.next().get("cpl:versionHistory"));
        versionHistories.add(historyUuid);
    }
    String queryInContent = "SELECT [jcr:versionHistory] FROM [mix:versionable] WHERE ISDESCENDANTNODE('/content')";
    for (Iterator<Map<String, Object>> it = resourceResolver.queryResources(queryInContent, Query.JCR_SQL2); it.hasNext(); ) {
        String historyUuid = String.valueOf(it.next().get("jcr:versionHistory"));
        versionHistories.remove(historyUuid);
    }

    String queryInAttic = "SELECT [jcr:versionHistory] FROM [mix:versionable] WHERE ISDESCENDANTNODE('" + ATTIC_PATH + "')";
    for (Iterator<Map<String, Object>> it = resourceResolver.queryResources(queryInAttic, Query.JCR_SQL2); it.hasNext(); ) {
        String historyUuid = String.valueOf(it.next().get("jcr:versionHistory"));
        versionHistories.remove(historyUuid);
    }
%>

Orphaned version histories are:
<%= versionHistories %>

<%
    Session session = resourceResolver.adaptTo(Session.class);
    VersionManager versionManager = session.getWorkspace().getVersionManager();
    String report = "Restore log:<br>";

    String versionInfoQuery = "SELECT [cpl:version], [cpl:versionableUuid], [cpl:versionHistory] FROM [cpl:VersionReference] WHERE ISDESCENDANTNODE('/var/composum/content')";

    Set<String> processedVersionHistories = new HashSet<>();
    for (Iterator<Map<String, Object>> it = resourceResolver.queryResources(versionInfoQuery, Query.JCR_SQL2); it.hasNext(); ) {
        Map<String, Object> versionReference = it.next();
        String historyUuid = String.valueOf(versionReference.get("cpl:versionHistory"));
        if (versionHistories.contains(historyUuid) && !processedVersionHistories.contains(historyUuid)) {
            processedVersionHistories.add(historyUuid);
            String versionUuid = String.valueOf(versionReference.get("cpl:version"));
            String versionableUuid = String.valueOf(versionReference.get("cpl:versionableUuid"));
            String pathInAttic = ATTIC_PATH + "/" + versionableUuid;

            Version version = (Version) session.getNodeByIdentifier(versionUuid);
            version = version.getContainingHistory().getRootVersion();
            // we keep the default path in the restored path, since it's changed.
            String oldPath = version.getContainingHistory().getProperty("default").getString();
            oldPath = StringUtils.removeStart(oldPath, pathInAttic); // if it's restored for the second time.
            String newPath = pathInAttic + oldPath;
            ResourceUtil.getOrCreateResource(resourceResolver, ResourceUtil.getParent(newPath), "sling:Folder", "sling:Folder", true);
            report = report + " restoring for " + historyUuid + " originally at " + oldPath + " at " + newPath + " <br>";
            try {
                versionManager.restore(newPath, version, false);
            } catch (ConstraintViolationException e) {
                String versionpath = version.getPath();
                try {
                    // if it's an asset, the root version is not restorable, since it doesn't contain jcr:data. Take the next version.
                    version = version.getSuccessors()[0];
                    versionManager.restore(newPath, version, false);
                } catch (Exception e1) {
                    throw new Exception("Problem restoring " + versionpath + " because of " + e1, e1);
                }
            }
        }
    }
%>
<hr>
<%= report %>
DONE
