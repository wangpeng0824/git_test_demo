<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>
<!-- 
  - Author(s): Aoxq
  - Date: 2014-12-25 14:53:30
  - Description:
-->
<head>
<title></title>
</head>
<body>
	<fieldset style="width:97%;height:50%;">
		<div id="dataform" style="padding-top:5px;"> 
			<table id="editFullAgentTable"  style="width:100%;height:95%;table-layout:fixed;" class="nui-form-table">
				<tr>
					<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Principal") %>:</td>
					<td style="text-align:left;width:30%">
             			<input class="nui-textbox asLabel" id="agentFrom" name="agentFrom"/>
            		</td>
            		<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Agents") %>:</td>
					<td>
             			<input class="nui-textbox asLabel" id="agentTo" name="agentTo" />
            		</td>
				</tr>
				<tr>
					<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EffTime") %>:</td>
					<td>
             			 <input name="startTime" id="startTime" class="nui-textbox asLabel"   style="width:70%"/>
            		</td>
            		<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EndTime") %>:</td>
					<td>
             			 <input name="endTime" id="endTime" class="nui-textbox asLabel"  style="width:70%"/>
            		</td>
				</tr>
				<tr>
					<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentMode") %>:</td>
					<td>
						<input style="vertical-align:middle" class="nui-textbox asLabel" id="agentType" value="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.FullAgent") %>" />
					</td>
            		<td style="vertical-align: inherit;text-align:right;"></td>
					<td></td>
				</tr>
				<tr>
					<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentReason") %>:</td>
					<td colspan="3" style="vertical-align: inherit;">
						<textarea class="nui-textarea asLabel" id="agentReason" style="width:100%;"  name="agentReason"></textarea>
					</td>
				</tr>
			</table> 
		</div>	
	</fieldset> 
	<div class="nui-panel" title="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.ListProcess") %>" style="width:100%;" showToolbar="true"> 
		<div id="datagrid"  pageSize="5"  url=contextPath+"/rest/services/bps/wfclient/agent/detailAgent"
				dataField="processInfo" class="nui-datagrid" style="width:100%;height:160px;" showPager="false"> 
			<div property="columns"> 
				<div field="itemID" width="1" headerAlign="center"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcDID") %></div> 
				<div field="itemName" width="2" headerAlign="center"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcAlias") %></div> 
				<div field="proFullName" width="3" headerAlign="center"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcName") %></div> 
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
    	var grid=nui.get("datagrid");
    	var agentID=null;
    	
    	//数据加载
    	function setData(data){
    		var info=nui.clone(data);
    		agentID=info.agentID;
    		info.startTime=nui.formatDate(info.startTime,"yyyy-MM-dd HH:mm:ss");
    		info.endTime=nui.formatDate(info.endTime,"yyyy-MM-dd HH:mm:ss");
    		form.setData(info);
    		grid.load({agentID:agentID});
    	}
    	
    	//取消
    	function doCancel(e){
            closeWindow("cancel");
        }
    </script>
</body>
</html>
