<%@page import="java.util.StringTokenizer"%>
<%@page import="com.primeton.ext.engine.core.processor.DirectPageflowDispatcher"%>
<%@page import="com.primeton.engine.core.impl.context.PageflowRuntimeContext"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.workflow.data.WFWorkItem"%>
<%@page import="com.eos.workflow.api.IWFWorkItemManager"%>
<%@page import="org.gocom.bps.wfclient.common.ServiceFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
<%
	String workItemIDStr = request.getParameter("workItemID");//redirect支持
	long workItemID = 0;
	if(!StringUtils.isBlank(workItemIDStr)){
		workItemID = Long.parseLong(workItemIDStr);
	}else{
		workItemID = (Long)request.getAttribute("workItemID");
	}
	if(workItemID <= 0){
		return;
	}	
	WFWorkItem workItem = ServiceFactory.getWFWorkItemManager().queryWorkItemDetail(workItemID);
	
	String actionURL = workItem.getActionURL();
	
	request.setAttribute("workItemID", workItem.getWorkItemID());
	if(StringUtils.equals("W", workItem.getUrlType())){//web页面，以/开头，不包含应用名的相对路径
		request.getRequestDispatcher(actionURL).forward(request, response);//跳转，没有传递参数的需求，原来也这么跳转
		out.clear();
		out = pageContext.pushBody();
	}else if(StringUtils.equals("F", workItem.getUrlType())){//页面流
		request.setAttribute("processInstID", workItem.getProcessInstID());
		
		request.removeAttribute("_eosFlowAction");
		String flowName = null;
		String queryString = null;
		long processInstID = workItem.getProcessInstID();
		
		if(actionURL == null) throw new Exception("**自定义URL为空**");
		
		if(actionURL.indexOf('?')!=-1){
			flowName = actionURL.substring(0,actionURL.indexOf('?'));
			queryString = actionURL.substring(actionURL.indexOf('?')+1);
		}else{
			flowName = actionURL;
		}
		
		if(flowName == null || flowName.trim().length() == 0) throw new Exception("**自定义URL为空**");
		
		PageflowRuntimeContext pc = new PageflowRuntimeContext();
		pc.set("workitem", workItem);
		pc.set("relateData", ServiceFactory.getWFRelativeDataManager().getRelativeData(processInstID, "/"));
		pc.set("_flowID",flowName);
		
		if(queryString == null || queryString.trim().length() == 0) {
			DirectPageflowDispatcher.dispatch(request, response, pc);
		} else {
			String name = null;
			String value = null;
			
			String temp = null;
			
			StringTokenizer st = new StringTokenizer(queryString,"&");
			while(st.hasMoreTokens()){
				temp = st.nextToken();
				if(temp.indexOf("=")!=-1){
					name = temp.substring(0,temp.indexOf("="));
					value = temp.substring(temp.indexOf("=")+1);
					pc.set(name,value);
				}else{
					pc.set(temp,temp);
				}
			}
			
			DirectPageflowDispatcher.dispatch(request, response, pc);				
		}
	}else if(StringUtils.equals("O", workItem.getUrlType())){
		if(actionURL == null) throw new Exception("**自定义URL为空**");
%>
<html>
<body>
<form id="form1"  >
<input type="hidden" name="workItemID" value='<%=workItemID%>'/>
</form>
<script>
	var form1 = document.getElementById('form1');
	form1.action = '<%=actionURL %>';
	form1.submit();
</script>
<body>
</html>
<% 		
	}else{
		request.getRequestDispatcher("task.jsp").forward(request, response);
		out.clear();
		out = pageContext.pushBody(); 
	}
	
	
%>