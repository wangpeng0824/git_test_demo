<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>
<!-- 
  - Author(s): Aoxq
  - Date: 2014-12-18 10:05:46
  - Description:
-->
<head>
<title></title>
</head>
<body style="width: 99%;overflow:hidden" class="body-font">
	
        <table id="tableSearch" style="width:100%;">
            <tr>
                <td width="120px"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentStatus") %>：</td>
                <td >  
                    <div id="agentStateList" class="nui-checkboxlist" onitemclick="onItemClick"
        				textField="text" valueField="id"></div>
                </td>
                <td style="text-align:right;">  
                    <a class="nui-button grayBtn" onclick="doQuery"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Query") %></a>
                </td>
            </tr>
        </table>
    
	<div style="margin-top:15px;padding: 0px;">
		<table id="agentQueryTable" style="width: 100%;">
			<tr>
				<td style="width: 100%;">
					<a class="nui-button grayBtn" id="btnRemove" onclick="doRemove"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Delete") %></a>
					<span class="separator"></span> 
					<a class="nui-button grayBtn" id="btnAddFull" onclick="doAddFullAgent"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AddFAgent") %></a> 
					<a class="nui-button grayBtn" id="btnAddPart" onclick="doAddPartAgent"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AddIperAgent") %></a>
				</td>
			</tr>
		</table>
	</div>
	<div id="dataGrid" multiSelect="true"  showPager="false"
			dataField="agentList" class="nui-datagrid bpsDatagrid" style="width:100%; "
			url=contextPath+"/rest/services/bps/wfclient/agent/queryAgent" >
		<div property="columns">
			<div type="checkcolumn" width="20"></div>
			<div name="action" width="60" cellCls="textof_clip" headerAlign="center" align="center" renderer="onActionRenderer" cellStyle="padding:0;"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Operation") %></div>
			<div field="agentID" width="40"  headerAlign="center" align="center" visible="false"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentID") %></div>
			<div field="agentTo" width="40"  headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Agents") %></div>
			<div field="agentToType" width="40"  headerAlign="center" align="center" renderer="doChangeAgentToType"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentType") %></div>
			<div field="agentType" width="40"  headerAlign="center" renderer="doChangeAgentType" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentMode") %></div>
			<div field="startTime" width="80" headerAlign="center" dateFormat="yyyy-MM-dd HH:mm:ss"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EffTime") %></div>
			<div field="endTime" width="80" headerAlign="center" dateFormat="yyyy-MM-dd HH:mm:ss"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EndTime") %></div>
			<div field="state"  width="40" headerAlign="center" renderer="doJudgeState" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Status") %></div>
			<div field="agentReason" width="40" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentReason") %></div>
		</div>
	
	</div>

	<script type="text/javascript">
		nui.parse();
		//获取控件
		var grid = nui.get("dataGrid");
		var cobox = nui.get("selectState");
		var agentStateList=nui.get("agentStateList");
		//定义ComboBox中的Data
		var stateType = [
			 { id : "ALL",text : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.All") %>"},
		 	 { id : "Y", text : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Effective") %>" }, 
		 	 { id : "N", text : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Ineffective") %>" } ];
		
		//代理关系状态
		agentStateList.setData(stateType);
		agentStateList.selectAll();
		
		resizeDatagridHeight();
		$(window).bind("resize", resizeDatagridHeight);
    	// 自动调整datagrid的外部高度,撑满屏幕
    	function resizeDatagridHeight(){
    		var realheight = window.innerHeight || (document.documentElement && document.documentElement.clientHeight) || document.body.clientHeight,
	    	realheight = realheight -100+ "px";
	    	var datagridObj = document.getElementById("dataGrid");
	    	datagridObj.style.height=realheight;
    	}
		
		//加载数据
		grid.load({state: "ALL"});
		
		function onActionRenderer(e) {
            var action = ' <a class="dgBtn" href="javascript:doCheck(\'' + e + '\')"><%=I18nUtil.getMessage(request, "bps.wfclient.common.View") %></a>'+
            			' <a class="dgBtn" href="javascript:doModify(\'' + e + '\')"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Alter") %></a>';
            return action;
        }
		
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
		
		//代理方式
		var agentType={
			"ALL":"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.FullAgent") %>",
			"PART":"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.PartAgent") %>"};
			
		
		//转换代理方式
		function doChangeAgentType(e) {
			return agentType[e.value];
		}
		
		//代理人类型
		var agentToType={
			"person":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Person") %>",
			"role":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Role") %>",
			"organization":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Organization") %>",
			"position":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Position") %>",
			"emp":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Emp") %>",
			"org":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Org") %>"
			};
		
		//转换代理人类型
		function doChangeAgentToType(e) {
			return agentToType[e.value];
			
		}
		//打开添加完全代理页面
		function doAddFullAgent(e) {
			nui.open({
				url : contextPath + "/bps/wfclient/agent/editFullAgent.jsp",
				title : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.AddFAgent") %>",
				width : 640,
				height : 320,
				ondestroy : function(action) {
					if (action != "cancel")
						grid.reload();
				}
			});
		}
		//根据代理方式查询信息
		function doQuery(e) {
			var isAll=agentStateList.isSelected(agentStateList.getAt(0));
			if(isAll){
				grid.load({state : "ALL"});
			}else{
				
				var state=agentStateList.getValue();
				if(!state){
			    	tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.QueryHints") %>",
			    					"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.QueryError") %>");
			    	return;
				}
				grid.load({state : state});
			}
		}
		//判断是否生效
		function doJudgeState(e) {
			var record = e.record;
			var starttime = new Date(record.startTime).getTime();
			var endtime = new Date(record.endTime).getTime();
			var currenttime = new Date().getTime();
			if (starttime < currenttime && currenttime < endtime) {
				return "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Effective") %>";
			} else {
				return "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Ineffective") %>";
			}

		}
		//删除数据
		function doRemove(e) {
			var rows = grid.getSelecteds();
			var lines = rows.length;
			if (lines > 0) {
				window.top.nui.confirm("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.ConfirmDelete") %>",
							"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SetAgent") %>",
				function(action) {
					if (action == "ok") {
						var ids = [];
						var length = rows.length
						for (var i = 0; i < length; i++) {
							ids.push(rows[i].agentID);
							}
						
						grid.loading("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Deleting") %>");
						nui.ajax({
							url : contextPath+"/rest/services/bps/wfclient/agent/deleteAgent",
							data : {agentID : ids},
							cache : false,
							success : function(result) {
									grid.unmask();
								if (result.exception) {
									tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.DeleteFailed") %>",
									"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SetAgent") %>");
									} else {
										grid.reload();
										tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.DeleteSuccess") %>",
									"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SetAgent") %>");
									}
								}
								});
							}
						});
			} else {
				tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.PleaseSelectRecord") %>");
			}
		}

		//代理信息查看
		function doCheck(e) {
			var row = grid.getSelected();
			var data = row;
			//根据不同的代理类型打开相应查看页面
			var type = data.agentType;
			var target = "";
			if (type == "ALL") {
				target = contextPath + "/bps/wfclient/agent/detailFullAgent.jsp";
			} else {
				target = contextPath + "/bps/wfclient/agent/detailPartAgent.jsp";
			}
			nui.open({
				url : target,
				title : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentDetail") %>",
				type : 'POST',
				cache : false,
				contentType : 'text/json',
				width : 800,
				height : 460,
				onload : function() {
					var iframe = this.getIFrameEl();
					iframe.contentWindow.setData(data);
				}
			});
		}

		//代理信息修改
		function doModify(e) {
			var row = grid.getSelected();
			var data = row;
			//根据代理类型打开相应的修改页面
			var type = data.agentType;
			var target = "";
			var wid = "";
			var hei = "";
			if (type == "ALL") {
				target = contextPath + "/bps/wfclient/agent/editFullAgent.jsp";
				wid = 650;
				hei = 320;
			} else {
				target = contextPath + "/bps/wfclient/agent/editPartAgent.jsp";
				wid = 650;
				hei = 520;
			}
			nui.open({
				url : target,
				title : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.UpdateAgentRealation") %>",
				type : 'POST',
				cache : false,
				contentType : 'text/json',
				width : wid,
				height : hei,
				onload : function() {
					var iframe = this.getIFrameEl();
					iframe.contentWindow.setData(data);
				},
				ondestroy : function(action) {
					if (action != "cancel")
						grid.reload();
				}
			});
		}

		//添加部分代理
		function doAddPartAgent(e) {
			nui.open({
				url : contextPath + "/bps/wfclient/agent/editPartAgent.jsp",
				title : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.AddIperAgent") %>",
				width : 650,
				height : 520,
				ondestroy : function(action) {
					if (action != "cancel")
						grid.reload();
				}
			});
		}
	</script>
</body>
</html>
