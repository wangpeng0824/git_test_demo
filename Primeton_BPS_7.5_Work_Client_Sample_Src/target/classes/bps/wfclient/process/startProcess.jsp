<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>

<head>
<title></title>
	<style type="text/css">
		body{
			background-color:#f7f7f7
		}
	</style>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />  
</head>
<body>
	<form id="procInstForm">
		<div>
			<table id="startProcForm" class="nui-form-table" style="height:100%;width:100%">
				<tr>
					<td class="form_label" style="text-align:right;white-space:nowrap"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcessInsName") %>:</td>
					<td><input class="nui-textbox" errorMode="none" name="processInstName" required="true" width="290px"/><font style="color:red">*</font></td>
				</tr>
				<tr>
					<td class="form_label" style="text-align:right;white-space:nowrap"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcessInsDes") %>:</td>
					<td><input class="nui-textbox" name="processInstDesc" width="290px"/></td>
				</tr>
				<tr>
					<td class="form_label" style="text-align:right;"><%=I18nUtil.getMessage(request, "bps.wfclient.process.BPName") %>:</td>
					<td ><input class="nui-textbox" id="processDefName" name="processDefName" width="290px" enabled="false"/></td>
				</tr>
				<tr style="border-top:none">
					<td colspan="2"><input class="nui-textbox" id="processDefID" name="processDefID" width="100%" visible="false"/></td>
				</tr>
			</table>
		</div>
	</form>
	<form id="businessForm">
		<div  id="procStart" class="nui-bps-showprocstartform"></div>
	</form>
	<div style="position:absolute;left:0px;bottom:10px;text-align:center;width:96%">
		<a class="nui-button redBtn" onclick="doStart"><%=I18nUtil.getMessage(request, "bps.wfclient.process.Start") %></a>
		<a class="nui-button redBtn" onclick="doCancel"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Cancel") %></a>
    </div>
	
	<script type="text/javascript">
    	nui.parse();
    	function setData(rowData){
      		nui.get("processDefName").setValue(rowData.processDefName);
      		nui.get("processDefID").setValue(rowData.processDefID);
      		var procStart = nui.get("procStart");
    		procStart.setProcessID(rowData.processDefID);
    		procStart.load();
    	}
    	
    	function doStart(){
			
			var json = {};    		
    		var procInstForm = new nui.Form("#procInstForm");
    		procInstForm.validate();
    		if(!procInstForm.isValid()){
    			tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.process.PleaseInputProName") %>");
    			return;
    		}
    		var procJson = procInstForm.getData();
    		var processInstName=procJson.processInstName;
    		var nameLength=getLength(processInstName);
    		if(nameLength>256){
    			tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.process.NameLengthNotice") %>");
    			return;
    		}
    		var businessForm = new nui.Form("#businessForm");
    		businessForm.validate();
    		if(!businessForm.isValid()){
    			tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Required") %>");
    			return;
    		}
    		var businessJson = businessForm.getData();
    		
    		json.procInst = procJson;
    		json.form = businessJson;
    		
    		nui.ajax({
     		 	url:contextPath+"/rest/services/bps/wfclient/process/createStartProcessInst",
     		 	type:'POST',
	            data:json,
	            cache: false,
      		 	success:function(text) {
      		 	 	if(text.exception) {    //@Review 直接判断Exception是否定义
          		 		var exception=text.exception.message;
          		 		var reason;          
          		 		if(exception.indexOf("21040001")>=0){
          		 			reason="<%=I18nUtil.getMessage(request, "bps.wfclient.rpocess.ProcessUndefined") %>";
          		 		}else{
          		 			reason="<%=I18nUtil.getMessage(request, "bps.wfclient.process.StartFailure") %>";
          		 		}
          		 		window.top.nui.alert(reason, "<%=I18nUtil.getMessage(request, "bps.wfclient.process.StartProcess") %>");
          		 		//@Review 把function去掉
          		 	} else {
          		 		tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.process.StartSuccess") %>", 
      		 					"<%=I18nUtil.getMessage(request, "bps.wfclient.process.Result") %>"); 
         			closeWindow("success");
          		 	}
          		 }
          		});
    	}
    	
    	function doCancel(e){
    		 if (window.CloseOwnerWindow) return window.CloseOwnerWindow(e);
             else window.close();   
    	}
    	
    	//获取流程实例名称长度
        function getLength(name){
        	var len = 0; 
			name = name.split(""); 
			for (var i=0;i<name.length;i++) { 
				if (name[i].charCodeAt(0)<299) { 
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