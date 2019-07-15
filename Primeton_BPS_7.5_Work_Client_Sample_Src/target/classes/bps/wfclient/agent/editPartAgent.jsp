<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@page import="com.eos.data.datacontext.DataContextManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<%HttpSession session=request.getSession(); %>
<html>
<!-- 
  - Author(s): Aoxq
  - Date: 2014-12-29 13:37:32
  - Description:
-->
<head>
<title>Title</title>
	<style type="text/css">
		body{
			background-color:#f7f7f7
		}
	</style>
</head>
<body style="width:98%;height:95%;">
		<div id="dataform" style="height:45%;margin:5px 5px 0px 5px;">
			<table id="agentInfoTable" style="width:100%;table-layout:fixed;" class="nui-form-table">
				<tr>
					<td class="nui-form-label" style="vertical-align: inherit;text-align:right;width:20%">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Principal") %>:</label>
					</td>
					<td style="vertical-align: inherit;text-align:left;width:30%">
						 <input class="nui-hidden" id="operation" name="operation">
						 <input class="nui-hidden" id="agentID" name="agentID">
             			 <input class="nui-textbox" name="agentFromName" enabled="false" style="width:130px" id="agentFromName"/>
            		</td>
            		<td class="nui-form-label" style="vertical-align: inherit;text-align:right;width:15%">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentMode") %>:</label>
					</td>
					<td  style="vertical-align: inherit;text-align:left;width:35%">
						<input class="nui-textbox" value="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.PartAgent") %>"  style="width:160px" enabled="false"/>
					</td>
				</tr>
				<tr>
					<td class="nui-for-label"style="vertical-align: inherit;text-align:right;">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Agents") %>:</label>
					</td>
					<td style="vertical-align: inherit;text-align:left;">
             			 <input errorMode="none" id="selectParticipant" style="width:130px" name="agentTo" selectorMaxCount="1"  required="true" class="nui-bps-select-participant" allowInput="false" />
             			 <font style="color:red">*</font>
            		</td>
            		<td class="nui-form-label" style="vertical-align: inherit;text-align:right;">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EffTime") %>:</label>
					</td>
					<td style="vertical-align: inherit;text-align:left;">
             			 <input  errorMode="none" name="startTime" id="startTime" class="nui-datepicker" style="width:160px" required="true" showTime="true"
             			 allowInput="false" format="yyyy-MM-dd HH:mm:ss" showOkButton="true" showClearButton="false"/>
             			 <font style="color:red">*</font>
            		</td>
				</tr>
				<tr>
					<td class="nui-form-label" style="vertical-align: inherit;text-align:right;">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Aproactivities") %></label>
					</td>
					<td style="vertical-align: inherit;text-align:left;">
						<input class="nui-hidden" name="accessType">
             			<input  errorMode="none" id="selectProAct" name="process" class="nui-bps-select-process-activity"  
             					required="true"  containActivity="true" style="width:130px" onvaluechanged="onValueChanged" allowInput="false"/>
             			<font style="color:red">*</font>
            		</td>
            		<td class="nui-form-label" style="vertical-align: inherit;text-align:right;">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EndTime") %>:</label>
					</td>
					<td style="vertical-align: inherit;text-align:left;">
             			 <input  errorMode="none" name="endTime" style="width:160px" class="nui-datepicker" required="true"  id="endTime"
        					format="yyyy-MM-dd HH:mm:ss" allowInput="false" showTime="true" showOkButton="true" showClearButton="false"/>
        					<font style="color:red">*</font>
            		</td>
				</tr>
				<tr style="border-bottom:1px solid #DCDCDC">
					<td class="nui-form-label" style="vertical-align: inherit;text-align:right;">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentReason") %>:</label>
					</td>
					<td colspan="3" style="vertical-align: inherit;">
						<textarea errorMode="none"  class="nui-textarea" id="agentReason" style="vertical-align: inherit;width:431px;height:90px;" required="true" name="agentReason"></textarea>
						<font style="color:red">*</font>
					</td>
				</tr>
			</table>
		</div>	
		<div class="nui-panel" id="panel" title="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Aproactivities") %>" style="margin-top:10px;width:100%;" > 
			<div id="dataGrid" url=contextPath+"/rest/services/bps/wfclient/agent/queryPartAgentInfo"
					 allowCellEdit="true" allowCellSelect="true"  onrowclick="rowclick" showPager="false"
					dataField="proActInfo" class="nui-datagrid" style="width:100%;height:160px;" allowCellEdit="true"> 
				<div property="columns"> 
					<div field="itemID" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcActDef") %></div> 
					<div field="itemType" headerAlign="center" align="center" renderer="doChangeProcessType" ><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Type") %></div>
					<div field="itemName" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcActName") %></div> 
					<div field="accessType" headerAlign="center" renderer="accessRenderer" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcOperationPermission") %><input class="nui-combobox" 
							data="[{id:'ALL',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.All") %>'},{id:'STARTPROC',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.StartProc") %>'},{id:'EXEWI',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Exewi") %>'}]" 
							  id="selectAccess" property="editor"/>  
					</div> 
					<div field="proDefID" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.ProcAct") %></div> 
				</div>	
			</div> 
		</div>
	<div class="bottomBtnDiv">
		<a class="nui-button redBtn" id="btnSave" onclick="doSave"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Save") %></a>
		<a class="nui-button redBtn" id="btnCancel" onclick="doCancel"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Closed") %></a> 
	</div> 

	<script type="text/javascript">
    	nui.parse();
    	//获取控件
    	var form = new nui.Form("dataform");
    	var selectParticipant=nui.get("selectParticipant");
    	var selectProAct=nui.get("selectProAct");
    	var agentFrom=nui.get("agentFromName");
    	var grid=nui.get("dataGrid");
    	var agentReason=nui.get("agentReason");
    	var name="<%=session.getAttribute("UserName") %>";
    	var userID="<%=session.getAttribute("UserID") %>";
    	agentFrom.setValue(name);
    	selectParticipant.setAgentFrom(userID);	
    	
    	//操作权限类型
         var proOperateType={
         	"ALL":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.All") %>",
         	"STARTPROC":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.StartProc") %>",
         	"EXEWI":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Exewi") %>"
         };
    			 
        function accessRenderer(e) {
            return proOperateType[e.value];
        }
        
        function onValueChanged(){
        	var data= form.getData();
        	var process=selectProAct.getData();
    		data.process=process;
        	if(data.operation=="modify") {
    			grid.setUrl(contextPath+"/rest/services/bps/wfclient/agent/queryPartAgentInfo");
    			grid.load({process:data.process,agentID:data.agentID});
    		} else {
    			grid.setUrl(contextPath+"/rest/services/bps/wfclient/agent/getProActInfo");
    			grid.load({process:data.process});
    		}
        }
        
    	//流程活动类型
		var agentItemType={
			"PROCESS":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Process") %>",
			"ACTIVITY":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Activity") %>"
		};
    	//转换流程活动类型
		function doChangeProcessType(e) {
			return  agentItemType[e.value];
		}
    	
    	//dataGrid列选中是进行判断是否可编辑
    	function rowclick(e){
    		var row=grid.getSelected ( );
    		var type=row.itemType;
    		if(type=="ACTIVITY"){
    			grid.setAllowCellEdit(false);       //@Review   看看visible后是否还需要enable
    		}
    		else {
    			grid.setAllowCellEdit(true); 
    		}
    			
    	}
    	
    	//提交
    	function doSave(e){
    		form.validate();
    		if(form.isValid()==false){
    			tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Required") %>");
    			return;
    		}
    		var reason=agentReason.getValue();
    		if(getReasonLength(reason)>240){ 
    			window.top.nui.alert("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentLength") %>", 
    						"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SetAgent") %>");
    			return;
    		}
    		var data= form.getData();
    		var agentTo=selectParticipant.getData();
    		data.agentTo=agentTo;
    		var process=selectProAct.getData();
    		data.process=process;
    		var list=grid.getData();
    		var length=list.length;
    		var accessType=[];
    		for(var i=0;i<length;i++) {
    			if(list[i].itemType=="PROCESS") {
    				accessType.push(list[i].accessType);
    			}
    		}
    		data.agentType="PART";
    		data.accessType=accessType;
    		//判断是新添加还是修改，提交数据到相应的逻辑流
    		var operation=data.operation;
    		var target="";
    		if(operation=="modify") {
    			data.agentTo=data.agentTo[0];
    			target=contextPath+"/rest/services/bps/wfclient/agent/modifyAgent";
    		}
    		else {
    			target=contextPath+"/rest/services/bps/wfclient/agent/addAgent";  
    		}
       		nui.ajax({
         		 url:target,
          		 data:data,
          		 cache:false,
          		 success:function(result) {
          		 	if(result.exception) {
          		 		var exception=result.exception;
          		 		var reason;          
          		 		if(exception.indexOf("agent existed")>=0){
          		 			reason="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.TimeOverlappingError") %>";
          		 		}else if(exception.indexOf("agent to self")>=0){
          		 			reason="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.ToSelfError") %>";
          		 		}else if(exception.indexOf("After the start time")>=0){
          		 			reason="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.TimeError") %>";
          		 		}else{
          		 			reason="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentError") %>";
          		 		}
          		 		window.top.nui.alert(reason, "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SetAgent") %>");
          		 	} else {
          		 		tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SaveSuccessful") %>",
          		 			 "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SetAgent") %>"); 
             			closeWindow("success");
          		 	}
          		 	
          		 }
          		});
    	}
    	
    	//取消
    	function doCancel(e){
            closeWindow("cancel");
          }
         
         //预览页选择修改操作后，在打开修改操作窗口时的数据加载
         function setData(data){
         	var info=nui.clone(data);
        	var agentID=info.agentID;
        	info.agentFromName="<%=session.getAttribute("UserName") %>";
        	info.operation="modify";
        	form.setData(info);
        	var json ={agentID:agentID,agentType:data.agentType,isModify:"Y"};
        	nui.ajax({
         		 url:contextPath+"/rest/services/bps/wfclient/agent/queryAgentInfo",
          		 data:json,
          		 cache:false,
          		 success: function(result){
          		 	if(result.exception) { 
          		 		tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.LoadFail") %>",
          		 						 "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SetAgent") %>");
          		 	} else {
          		 		selectParticipant.setData(result.agentTo);
          		 		selectProAct.setData(result.proActInfo);
          		 		grid.setUrl(contextPath+"/rest/services/bps/wfclient/agent/queryPartAgentInfo");
            			grid.load({process:result.proActInfo,agentID:info.agentID});
          		 	}
          		 }
          		});
        }
        
        //获取代理原因长度
        function getReasonLength(reason){
        	var len = 0; 
			reason = reason.split(""); 
			for (var i=0;i<reason.length;i++) { 
				if (reason[i].charCodeAt(0)<299) { 
					len++; 
				} else { 
					len+=2; 
				} 
			} 
			return len; 
        }
    </script>
</body>
</html>
