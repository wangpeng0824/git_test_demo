<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>
<head>
	<title></title>
</head>
<body style="width:97%; height:90%;">
	<div id="form1" style="width: 97%">
		<table id="tableReason" style="width: 100%">	
			<tr>
				<td align="left">
					<label id="personLabel" for="reason$text" style="width: 300px"></label>
				</td>
				<td>
					<input id="participants" errorMode="none" name="participants" required="true" class="nui-bps-select-participant" width="300px"/>
					<font style="color:red">*</font>
				</td>
			</tr>
			<tr>
				<td align="left">
					<label id="reasonLabel" for="reason$text" style="width: 300px"></label>
				</td>
				<td>
					<input id="reason"  name="reason" class="nui-textarea" height="180px" width="300px"/>
				</td>
			</tr>
		</table>
	</div>
	<div style="width:97%;text-align:center;position:absolute;bottom:10px;">
		<a class="nui-button redBtn"  onclick="doConfirm"><%=I18nUtil.getMessage(request, "bps.control.common.confirm")%></a>
		<a class="nui-button redBtn"  onclick="closeWindow('cancel')"><%=I18nUtil.getMessage(request, "bps.control.common.cancel")%></a>
	</div>
		
	<script type="text/javascript">
    	nui.parse();
    	var controlTitle="";
    	function initData(submitData, participant) {
    		document.getElementById("personLabel").outerText = submitData.submitTypeDisplayName + "<%=I18nUtil.getMessage(request, "bps.wfclient.reason.Personals")%>:";
    		document.getElementById("reasonLabel").outerText = submitData.submitTypeDisplayName + "<%=I18nUtil.getMessage(request, "bps.wfclient.reason.Reason")%>:";
    		controlTitle=submitData.submitTypeDisplayName + "<%=I18nUtil.getMessage(request, "bps.wfclient.reason.Personals")%>";
    		if (submitData.submitType == "delegate" || submitData.submitType == "help") {
    			var selectParticipantObj = nui.get("participants");
    			//selectParticipantObj.setAgentFrom(participant);
    			selectParticipantObj.setSelectorTitle(controlTitle);
    			if(submitData.participants!=null && submitData.participants.length>0)
    			{
    				selectParticipantObj.setText(submitData.participants[0].texts);
    				selectParticipantObj.setValue(submitData.participants[0].ids);
    			}
    		} else {
    			document.getElementById("tableReason").deleteRow(0);
    		}    		
    	}
    	
    	function returnData() {
    		return {participants : nui.get("participants").getData(), reason : nui.get("reason").getValue()};
    	}
    	
    	function doConfirm() {
    		var form = new mini.Form("#form1");
            form.validate();
            if (form.isValid() == false){
				tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.reason.SelectWarnMsg")%>");          
            	return;    		
            }
    		closeWindow("ok");
	    }
    </script>
</body>
</html>