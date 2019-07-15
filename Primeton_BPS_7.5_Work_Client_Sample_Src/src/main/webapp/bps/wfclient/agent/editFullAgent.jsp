<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@page import="com.eos.data.datacontext.DataContextManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<%HttpSession session = request.getSession(); %>
<html>
<!-- 
  - Author(s): Aoxq
  - Date: 2014-12-18 10:36:12
  - Description:
-->
<head>
<title></title>
	<style type="text/css">
		body{
			background-color:#f7f7f7
		}
	</style>
</head>
<body style="width:98%;height:90%;">
		<div id="dataform" style="height:90%;margin:5px 20px 0px 5px;">
			<table id="agentInfoTable" style="width:100%;table-layout:fixed;" class="nui-form-table">
				<tr>
					<td class="nui-form-label" style="vertical-align: inherit;text-align:right;width:20%" >
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Principal") %>:</label>
					</td>
					<td style="vertical-align: inherit;text-align:left;width:30%" >
						 <input class="nui-hidden" id="agentID" name="agentID">
						 <input class="nui-hidden" name="operation" id="operation">
             			 <input id="agentFromName"  name="agentFromName" class="nui-textbox" style="width:130px" enabled="false"/>
            		</td>
            		<td class="nui-form-label" style="vertical-align: inherit;text-align:right;width:15%">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentMode") %>:</label>
					</td>
					<td  style="vertical-align: inherit;text-align:left;width:35%">
						<input class="nui-textbox" value="<%=I18nUtil.getMessage(request, "bps.wfclient.agent.FullAgent") %>" style="width:160px"  enabled="false" />
					</td>
				</tr>
				<tr>
					<td class="nui-form-label"style="vertical-align: inherit;text-align:right;">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Agents") %>:</label>
					</td>
					<td style="vertical-align: inherit;text-align:left;">
						<input errorMode="none"  id="selectParticipant" name="agentTo" selectorMaxCount="1"  style="width:130px"  required="true" 
             			 	class="nui-bps-select-participant" allowInput="false" />
             			 <font style="color:red">*</font>
            		</td>
            		<td class="nui-form-label"  style="vertical-align: inherit;text-align:right;">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EffTime") %>:</label>
					</td>
					<td style="vertical-align: inherit;text-align:left;" >
             			 <input errorMode="none" name="startTime" id="startTime" class="nui-datepicker"   required="true" style="width:160px" showTime="true"
             			 allowInput="false" format="yyyy-MM-dd HH:mm:ss" showOkButton="true" showClearButton="false"/>
             			 <font style="color:red">*</font>
            		</td>
				</tr>
				<tr>
					<td class="nui-form-lable" style="vertical-align: inherit;text-align:right;">
						<label style="white-space: nowrap;"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AddExcProcess") %>:</label>
					</td>
					<td style="vertical-align: inherit;text-align:left;">
             			<input id="selectProcess" name="process"  style="width:130px" class="nui-bps-select-process-activity"  allowInput="false" />
            		</td>
            		<td class="nui-form-lable" style="vertical-align: inherit;text-align:right;">
            			<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EndTime") %>:</label>
            		</td>
					<td style="vertical-align: inherit;text-align:left;">
             			 <input errorMode="none" name="endTime" class="nui-datepicker" style="width:160px" required="true"  id="endTime"
        					format="yyyy-MM-dd HH:mm:ss" allowInput="false" showTime="true" showOkButton="true" showClearButton="false"/>
        					<font style="color:red">*</font>
            		</td>
				</tr>
				<tr>
					<td class="nui-form-label" style="vertical-align: inherit;text-align:right;">
						<label><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentReason") %>:</label>
					</td>
					<td colspan="3">
						<textarea errorMode="none" class="nui-textarea" id="agentReason" style="vertical-align: inherit;width:431px;height:90px;" required="true" name="agentReason"></textarea>
						<font style="color:red">*</font>
					</td>
				</tr>
			</table>
		</div>	
	<div class="bottomBtnDiv">
		<a class="nui-button redBtn" id="btnSave" onclick="doSave"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Save") %></a>
        <a class="nui-button redBtn" id="btnCancel" onclick="doCancel"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Closed") %></a>
	</div>
	<script type="text/javascript">
    	nui.parse();
    	//获取控件
    	var form = new nui.Form("dataform");
    	var agentFrom=nui.get("agentFromName");
    	var check=nui.get("addProcess");
    	var selectParticipant=nui.get("selectParticipant");
    	var selectProcess=nui.get("selectProcess");
    	var agentReason=nui.get("agentReason");
    	//获取当前登录人名字
    	var name="<%=session.getAttribute("UserName") %>";
    	var userID="<%=session.getAttribute("UserID") %>";
    	selectParticipant.setAgentFrom(userID);
    	agentFrom.setValue(name);
    	//提交
    	function doSave(e){
    		form.validate();
    		//数据校验
    		if(!form.isValid()) {
    			tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Required") %>");
    			return;
    		}
    		var reason=agentReason.getValue();
    		if(getReasonLength(reason)>240){
    			window.top.nui.alert("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentLength") %>", 
    						"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SetAgent") %>");
    			return;
    		}
    		var data = form.getData();
    		var agentTo=selectParticipant.getData();
    		data.agentTo=agentTo;
    		if(data.process!="") {
    			var process=selectProcess.getData();
    			data.process=process;
    		}
    		data.agentType="ALL";
    		//判断是新添加还是修改，提交到相应的逻辑流
    		var operation=data.operation;
    		var target="";
    		if(operation=="modify") {
    			data.agentTo=data.agentTo[0];
    			target=contextPath+"/rest/services/bps/wfclient/agent/modifyAgent";
    		}
    		else {
    			target=contextPath+"/rest/services/bps/wfclient/agent/addAgent";
    		}
       		nui.ajax({      //@Review 1.14   改为nui.ajax 
         		 url:target,
          		 data:data,
          		 cache:false,     //@Review 不使用encode和decode，contentType
          		 success:function(result) {
          		 	if(result.exception) {    //@Review 直接判断Exception是否定义
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
          		 		//@Review 把function去掉
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
         
         //预览页选择修改后，在打开窗口时进行的数据加载
        function setData(data){
        	var info=nui.clone(data);
        	var agentID=info.agentID;             
        	info.agentFromName="<%=session.getAttribute("UserName") %>";
        	info.operation="modify";
        	form.setData(info);
        	//@Review  info直接在data里面加
        	nui.ajax({
         		 url:contextPath+"/rest/services/bps/wfclient/agent/queryAgentInfo",
          		 data:{agentID:agentID},
          		 cache:false,
          		 success: function(result){
          		 	//@Review 判断text是否有异常，改text的命名
          		 	if(result.exception) { 
          		 		tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.LoadFail") %>",
          		 						 "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.SetAgent") %>");
          		 	} else {
          		 		selectParticipant.setData(result.agentTo);
          		 		if(result.proActInfo!=""){
          		 			selectProcess.setData(result.proActInfo);
          		 		}
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
