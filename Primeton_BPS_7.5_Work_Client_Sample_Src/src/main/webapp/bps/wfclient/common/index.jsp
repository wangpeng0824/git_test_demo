<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<html>
<head>
<title>BPS Work Client</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/bps/wfclient/common/css/tabs.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/bps/wfclient/common/css/style-client.css">
<script type=text/javascript>
	
	nui.parse();
	var menu = [	
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.MyTask") %>", id:"myTask"},
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.MyProcess") %>", id:"myProcess"},
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.StartProcess") %>", id:"processMgr"},
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.SetAgent") %>", id:"proxySet"},
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.MyAgent") %>", id:"proxyQry"}
			   ];
				
	var tabs = {
				 myTask:
					[{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.PendingTask") %>", url: contextPath + "/bps/wfclient/task/taskList.jsp?taskType=self", refreshOnClick: true},
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.FinishedTask") %>", url: contextPath + "/bps/wfclient/task/taskList.jsp?taskType=finishedSelf", refreshOnClick: true},
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.EntrustedTask") %>", url: contextPath + "/bps/wfclient/task/taskList.jsp?taskType=entrust", refreshOnClick: true},
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.Entr-FinishedTask") %>", url: contextPath + "/bps/wfclient/task/taskList.jsp?taskType=finishedEntrust", refreshOnClick: true},
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.UnReadNotice") %>", url: contextPath + "/bps/wfclient/task/notificationList.jsp?state=UNVIEWED", refreshOnClick: true},
					{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.ReadedNotice") %>", url: contextPath + "/bps/wfclient/task/notificationList.jsp?state=VIEWED", refreshOnClick: true}
				],
					
	             myProcess:
           			[{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.PendingProcess") %>", url: contextPath+"/bps/wfclient/process/myProcess.jsp?queryType=backlog", refreshOnClick: true},
           			{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.HandleProcess") %>", url: contextPath+"/bps/wfclient/process/myProcess.jsp?queryType=complete", refreshOnClick: true},
           			{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.FinishedProcess") %>", url: contextPath+"/bps/wfclient/process/myProcess.jsp?queryType=finish", refreshOnClick: true}
           			],
		                     
	           	 processMgr:
               		[{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.StartProcess") %>", url: contextPath+"/bps/wfclient/process/processManager.jsp", refreshOnClick: true}],
				
				 proxySet:
					[{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.SetAgent") %>", url: contextPath + "/bps/wfclient/agent/agentList.jsp", refreshOnClick: true}],
					
				 proxyQry :
				  	[{title: "<%=I18nUtil.getMessage(request, "bps.wfclient.common.MyAgent") %>", url: contextPath + "/bps/wfclient/agent/myAgent.jsp", refreshOnClick: true}]
	};
				 
	function init(){
		initMenu("myTask");
		menuListener();
		showTabs("myTask");
	}
	
	function initMenu(actMenu){
		$.each(menu,function(index,obj){
			if(obj.id==actMenu){
				$("#menu").append('<div id = "'+obj.id+'" class="menu" style="background:white;color:#393939">'+obj.title+'</div>');
			}else{
				$("#menu").append('<div id = "'+obj.id+'" class="menu">'+obj.title+'</div>');
			}
				
		}); 
	}
			 
	function menuListener() {
		var  menuObj = $(".menu");
		$.each(menuObj, function(key, val){
			var link = menuObj[key];
			link.onclick = function() {
				menuToggle(menuObj,link);
				var linkID = $(link).attr("id");
				showTabs(linkID);
			};
		});
	} 
	
	function menuToggle(menuObj,toggleLink){
		$.each(menuObj,function(key,val){
			var link = menuObj[key];
			$(link).css("background","#393939");
			$(link).css("color","#9a9a9a");
			$(toggleLink).css("background","white");
			$(toggleLink).css("color","#393939");
		});
	}
	
	function showTabs(linkID){
		var tabsObj = nui.get("tabs");
		tabsObj.removeAll();
		$.each(tabs,function(index,obj){
			if(linkID==index){
				$.each(obj, function(key, val){
					tabsObj.addTab(val); 
				});
				tabsObj.activeTab(tabsObj.getTab(0));
			}
		});
	}
	
	function doLogout(){
		window.location.href=contextPath+"/bps/wfclient/login/logout.jsp";
	}
	window.onload = init;
</script>
<style type="text/css">
	.bottom{
		
	}
	.copyRight{
		color:#9a9a9a;
		width:100%;
		z-index:100;
		position:fixed;
		left:0px;
		bottom:0px;
		margin-left: auto;
		margin-right: auto;
		text-align: center;
		background-image:url(./imgs/BottomBg.png);
	}
</style>
</head>
<body style="margin:0;width: 98%; height:100%;overflow-x:hidden">
	<div id="main" class="main">
		<div id="layout" class="nui-layout" style="height:100%; width:100%">
			<div id="west" region="west" splitSize="0" showSplit="false" showHeader="false" >
				<div id ="west-north" align="center">
					<table id ="logo">
						<tr><td class="form_label"><%=I18nUtil.getMessage(request, "bps.wfclient.common.BPSWorkClient") %></td></tr>
						<tr><td class="form_label"><img style="width:80px;height:80px" src="imgs/logo.png"/></td></tr>
						<%HttpSession session=request.getSession(); %>
						<tr><td class="form_label" id="user"><%=session.getAttribute("UserName")%></td></tr>
						<tr><td><a href="#" onclick="doLogout()"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Logout") %></a></td></tr>
						<tr><td> </td></tr>
					</table>
				</div>
				<div id ="west-center">
					<div id="menu"></div>
					<div id="menu-bottom"></div>
				</div>
			</div>
			<div title="center" region="center" width="100%">
				<div id ="tabs" class="nui-tabs" width="100%" height="100%"></div>
			</div>
		</div>
	</div>
 
		<div class="copyRight">(c) Copyright Primeton 2015. All Rights Reserved.</div> 
	
</body>
</html>
