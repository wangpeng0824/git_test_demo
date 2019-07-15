<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<meta http-equiv=X-UA-Compatible content="IE=8,chrome=1">
<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<!--@REVIEW 完成后下面的引入的js压缩成一个统一的然后引入到common.jsp中[liuxiang]  -->
<script src="<%=request.getContextPath() %>/common/nui/nui.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/common/nui/locale/<%=I18nUtil.getLocale(request)%>.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/web/control/js/selectResource.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/web/control/js/showProcStartAndWorkItemForm.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/web/control/js/fetchMessageList.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/web/control/js/appointActivityOrStepParticipant.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/web/control/js/graph4BPS.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/web/control/js/processGraph.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/web/control/js/bpsPager.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/web/control/js/nui-ext.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/wfclient/common/js/common.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/bps/web/control/locale/i18n_<%=I18nUtil.getLocale(request)%>.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/bps/wfclient/common/css/common.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/bps/web/control/css/pager.css">
<script>
	var contextPath = "<%=request.getContextPath()%>";
</script>