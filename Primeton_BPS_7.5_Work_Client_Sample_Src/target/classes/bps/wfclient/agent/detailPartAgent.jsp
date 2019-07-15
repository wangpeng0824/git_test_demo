<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>
<!-- 
  - Author(s): Aoxq
  - Date: 2014-12-30 16:34:49
  - Description:
-->
<head>
<title>Title</title> 
</head>
<body>
	<fieldset style="width:97%;height:50%;"> 
		<div id="dataform" style="padding-top:5px;"> 
			<table id="agentInfoTable" style="width:100%;height:90%;table-layout:fixed;" class="nui-form-table">
				<tr>
					<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Principal") %>:</td>
					<td style="text-align:left;width:30%">
             			<input class="nui-textbox asLabel" id="agentFrom" name="agentFrom"  />
            		</td>
            		<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Agents") %>:</td>
					<td style="text-align:left;">
             			<input class="nui-textbox asLabel" id="agentTo" name="agentTo"  />
            		</td>
				</tr>
				<tr>
					<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EffTime") %>:</td>
					<td style="text-align:left;">
             			<input name="startTime" id="startTime" class="nui-textbox asLabel" style="width:70%"/>
            		</td>
            		<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EndTime") %>:</td>
					<td style="text-align:left;">
             			 <input name="endTime" id="endTime" class="nui-textbox asLabel" style="width:70%"/>
            		</td>
				</tr>
				<tr>
					<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentMode") %>:</td>
					<td style="text-align:left;">
						<input class="nui-textbox asLabel" id="agentType" value="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.PartAgent") %>"/>
					</td>
            		<td style="text-align:right;"></td>
					<td style="text-align:left;"></td>
				</tr>
				<tr>
					<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentReason") %>:</td>
					<td colspan="3">
						<textarea class="nui-textarea asLabel" id="agentReason" style="width:100%;"  name="agentReason" ></textarea>
					</td>
				</tr>
			</table> 
		</div>	
	</fieldset> 
	<div class="nui-panel" title="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Aproactivities") %>" style="width:100%;" > 
		<div id="datagrid"  pageSize="5"  url=contextPath+"/rest/services/bps/wfclient/agent/detailAgent"
				dataField="processInfo" class="nui-datagrid"  style="width:100%;height:160px;" showPager="false"> 
			<div property="columns"> 
				<div field="itemID" headerAlign="center" align="center" ><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcActDef") %></div> 
				<div field="itemType" headerAlign="center" align="center" renderer="doChangeProcessType"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Type") %></div>
				<div field="itemName" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcActName") %></div> 
				<div field="accessType" headerAlign="center" renderer="accessRenderer" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcOperationPermission") %></div> 
				<div field="proDefID" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcAct") %></div> 
			</div>	
		</div> 
		
	</div>
	<div class="bottomBtnDiv">
		<a id="btnCancel" class="nui-button redBtn"  onclick="doCancel"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Closed") %></a> 
	</div>

	<script type="text/javascript">
    	nui.parse();
    	//获取控件
    	var form = new nui.Form("dataform");
    	var agentID=null;
    	var grid=nui.get("datagrid");
		
		//流程活动类型
		var agentItemType={
			"PROCESS":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Process") %>",
			"ACTIVITY":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Activity") %>"
		};
		
		//转换流程活动类型
		function doChangeProcessType(e) {
			return  agentItemType[e.value];
		}
    	//数据加载
    	function setData(data){
    		var info=nui.clone(data);
    		agentID=info.agentID;
    		info.startTime=nui.formatDate(info.startTime,"yyyy-MM-dd HH:mm:ss");
    		info.endTime=nui.formatDate(info.endTime,"yyyy-MM-dd HH:mm:ss");
    		form.setData(info);
    		grid.load({agentID:agentID,agentType:data.agentType});
    	}
    	
    	//取消
    	function doCancel(e){
            closeWindow("cancel");
          }
         
         //操作权限类型
         var proOperateType={
         	"ALL":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.All") %>",
         	"STARTPROC":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.StartProc") %>",
         	"EXEWI":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Exewi") %>"
         };
         
         //操作权限映射
         function accessRenderer(e){
         	return proOperateType[e.value];
         }
    </script>
</body>
</html>
