<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>
<head>
	<title><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.TList")%></title>
</head>
<body style="width: 97%;height:80%;" class="body-font"> 
    <table id="tableSearch" width="100%" height="72px">
        <tr>
            <td style="white-space:nowrap"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.ExePer")%>：</td>
            <td align="left" width="180px">
                <div id="permissionList" class="nui-checkboxlist" onitemclick="onItemClick" textField="text" valueField="id">
                </div>
            </td>
            <td align="right" valign="middle" colspan="2" rowspan="2">  
                <a class="nui-button grayBtn" onclick="doSearch()"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Query")%></a>
            </td>
        </tr>
        <tr>
            <td width="70px" style="white-space:nowrap"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Source")%>：</td>
            <td align="left" width="300px">  
                <div id="taskFromList" class="nui-checkboxlist" onitemclick="onItemClick" textField="text" valueField="id">
                </div>
            </td>
        </tr>
    </table>
    
	<div id="taskListId" class="nui-datagrid bpsDatagrid" style="margin-top:15px;width: 100%" showpager="false"
		url=contextPath+"/rest/services/bps/wfclient/task/queryTaskList" allowAlternating="true"
	    dataField="tasks" pageSize="10" onbeforeload="onBeforeDataGridLoad">
	    <div property="columns">
	        <div name="action" headerAlign="center" cellCls="textof_clip" align="center" renderer="onActionRenderer" width="100px"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Operation")%></div>
	        <div field="workItemID" headerAlign="center" align="center" width="65px"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.WorkItemID")%></div>    
	        <div field="workItemName" headerAlign="center" align="center" width="80px"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.WorkItemName")%></div>                            
	        <div field="processDefName" headerAlign="center" align="center" width="200px"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.ProcDefName")%></div>
	        <div field="processInstName" headerAlign="center" align="center" width="100px"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.ProcessInstName")%></div>                                
	        <div headerAlign="center" align="center" renderer="onCurrentStateRenderer" width="50px"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Status")%></div>
	        <div name="assistantName" field="assistantName" headerAlign="center" align="center" width="70px"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Assignee")%></div>
	        <div field="createTime" headerAlign="center" align="center" dateFormat="yyyy-MM-dd HH:mm:ss" width="130px"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.StartTime")%></div> 
	        <div headerAlign="center" align="center" renderer="onTimeoutRenderer" width="40"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.IsTimeOut")%></div>                 
	    </div>
	</div>
	<div class="pager" style="height:30px;width:100%">
		<div id="pager" class="nui-bpspager" datagridId="taskListId"></div>
	</div>
	<script type="text/javascript">
    	nui.parse();
    	//任务类型
    	var taskType = '<%=request.getParameter("taskType")%>';  	
    	//执行权限
    	var permissionListObj = nui.get("permissionList");
    	if (taskType == "self") {
	    	var permissionListData = [
	    		{"id" : "ALL", "text" : "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.All")%>"},
	    		{"id" : "PRIVATE", "text" : "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Personal")%>"},
	    		{"id" : "PUBLIC", "text" : "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Public")%>"}
	    	];
	    	permissionListObj.setData(permissionListData);
	    	permissionListObj.selectAll();
    	} else {
    		var searchTableObj = document.getElementById("tableSearch");
    		searchTableObj.deleteRow(0);
    		var rows = searchTableObj.getElementsByTagName("tr");
    		var td = document.createElement("td");
    		td.innerHTML="<a class='nui-button grayBtn' onclick='doSearch()'><%=I18nUtil.getMessage(request, "bps.wfclient.common.Query")%></a>";
    		td.align="right";
    		td.valign="middle";
    		td.colspan="2";
    		rows.item(0).appendChild(td);
    		searchTableObj.height="48";
    	}
    	
    	//任务来源
    	var taskFromListObj = nui.get("taskFromList");
    	var taskFromListData = [
    		{"id" : "ALL", "text" : "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.All")%>"},
    		{"id" : "DELEG", "text" : "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Delegate")%>"},
    		{"id" : "HELP", "text" : "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Help")%>"}
    	];
    	if (taskType != "entrust") {
    		taskFromListData.push({"id" : "AGENT", "text" : "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Agent")%>"});
    	}
    	if (taskType == "self" || taskType == "finishedSelf") {
    		taskFromListData.push({"id" : "SELF", "text" : "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Self")%>"});
    	}
    	
    	taskFromListObj.setData(taskFromListData);
    	taskFromListObj.selectAll();
    	
    	//任务列表
    	var taskListDataGridObj = nui.get("taskListId");
    	if (taskType != "entrust") {
    		taskListDataGridObj.hideColumn("assistantName");
    	}
    	doLoadTaskList();
    	
    	resizeDatagridHeight();
    	$(window).bind("resize", resizeDatagridHeight);
    	// 自动调整datagrid的外部高度,撑满屏幕
    	function resizeDatagridHeight(){
    		var realheight = window.innerHeight || (document.documentElement && document.documentElement.clientHeight) || document.body.clientHeight;
    		if(taskType != "self" && (navigator.userAgent.indexOf('Firefox') >= 0 || navigator.userAgent.indexOf('Chrome') >= 0)){
				realheight  -= 25;
			}
	    	realheight = realheight - (taskType == "self" ? 150 : 125) - 20  + "px";
	    	var datagridObj = document.getElementById("taskListId");
	    	datagridObj.style.height=realheight;
    	}
    	
    	//checkbox点击事件
    	function onItemClick(e) {
    		if (e.item.id == "ALL") {
    			if (e.sender.isSelected(e.item)) {
    				e.sender.selectAll();
    			} else {
    				e.sender.deselectAll();
    			}
    		} else {
    			var allItem = e.sender.getAt(0);
    			if (e.sender.isSelected(e.item)) {
    				if (e.sender.getCount() - 1 == e.sender.getSelecteds().length) {
    					e.sender.select(allItem);
    				}    				
    			} else {
    				e.sender.deselect(allItem);
    			}
    		}
    	}
        
        //查询
        function doSearch() {
        	doLoadTaskList();
        }
        
        //加载任务列表
        function doLoadTaskList() {
        	taskListDataGridObj.load(null, function(res){
        		if(res.exception) {
        			tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.FailedLoad")%>");
        		}        		
        	}, function() {
        		tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.FailedLoad")%>");
        	});
        }
    	
    	//操作
    	function onActionRenderer(e) {
            var s = "";
            if (taskType == "self") {
	            if (e.record.hasAccessWorkItemPermission) {
	            	s = s +  '<a class="dgBtn" href="javascript:doOperate(' + e.rowIndex + ', false)"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Execute")%></a> ';
	            }
            } else if (taskType == "entrust") {
            	s = s +  '<a class="dgBtn" href="javascript:doOperate(' + e.rowIndex + ', false)"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.Withdraw")%></a> ';
            }
            s = s + '<a class="dgBtn" href="javascript:doOperate(' + e.rowIndex + ', true)"><%=I18nUtil.getMessage(request, "bps.wfclient.common.View")%></a> ';
                       
            return s;
        }
        
        //工作项状态
        var workItemState={
        	"4":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.WaitingRecieve")%>",
        	"8":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Suspend")%>",
        	"10":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Running")%>",
        	"12":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Finish")%>",
        	"13":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Terminate")%>"
        };
        function onCurrentStateRenderer(e) {
        	return workItemState[e.row.currentState];
        }
        
        //超时
        var timeFlag={
        	"Y":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Yes")%>",
        	"N":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.No")%>"
        };
        function onTimeoutRenderer(e) {
        	return timeFlag[e.row.isTimeOut];
        }
        var doload = true;
        //数据加载参数传递
        function onBeforeDataGridLoad(e) {
	        var params = e.params;
	        if (taskType == "self") {  
		        var perssionValue = permissionListObj.getValue();
		        if(perssionValue == ""){
		        	tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.ExecutiveAuthority")%>");
		        	e.cancel = true;
		        }
		        if (permissionListObj.getCount() == permissionListObj.getSelecteds().length) {
		        	perssionValue = "ALL";
		        }
		        params.permisssion = perssionValue;
	        }
	        var scopeValue = taskFromListObj.getValue();
	        if(scopeValue == ""){
	        	tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.TaskSource")%>");
	        	e.cancel = true;
	        }
	        if (taskFromListObj.getCount() == taskFromListObj.getSelecteds().length) {
	        	scopeValue = "ALL";
	        }
	    	params.scope = scopeValue;
	    	params.taskType = taskType;
	    }
	    
	    //执行操作
	    function doOperate(rowIndex, isShowDetail) {
	    	var row = taskListDataGridObj.getRow(rowIndex);
	    	var url = contextPath + "/bps/wfclient/task/forwardByWorkItem.jsp?workItemID="+row.workItemID;
	    	var title = "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.WorkExecu")%>";
	    	var width=700;
	    	if (isShowDetail) {
	    		url = contextPath + "/bps/wfclient/task/task.jsp";
		    	title = "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.WorkDetail")%>";
		    	//width=800;
	    	} else if (taskType == "entrust"){
	    		url = contextPath + "/bps/wfclient/task/task.jsp";
	    		title = "<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.RecoverWorkItem")%>";
	    		//width=800;
	    	}
	    	
		    nui.open({
				url: url,
				title: title,
				width: width,
				height: 550,
				onload: function () {
					var iframe = this.getIFrameEl();
					if(iframe.contentWindow.initData) {
						iframe.contentWindow.initData(row, taskType, isShowDetail);
					}	
				},
				ondestroy: function (action){
					if (action == "ok") {
						taskListDataGridObj.load();
					} else if (action == "execute") {  
						doOperate(rowIndex, false);					
					}
				}
			});
	    }
    </script>
</body>
</html>
