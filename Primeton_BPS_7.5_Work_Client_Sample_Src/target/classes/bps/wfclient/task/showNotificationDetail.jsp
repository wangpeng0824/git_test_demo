<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>

<head>
<title>Title</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body>
	<form id="from1">
		<fieldset>
			<table class="nui-form-table" width="100%">
				<tr>
					<td class="nui-form-label"><label for="notificationID$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.NoticeID")%>:</label></td>
					<td><input id="notificationID" name="notificationID"
						class="nui-textbox asLabel " readOnly="true" /></td>
					<td class="nui-form-label"><label for="title$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.Title")%>:</label></td>
					<td><input id="title" name="title"
						class="nui-textbox asLabel " readOnly="true" /></td>
				</tr>
				<tr>
					<td class="nui-form-label"><label for="createTime$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.CreateTime")%>:</label></td>
					<td><input id="createTime" name="createTime"
						class="nui-datepicker asLabell" readOnly="true"
						style="width: 100%" format="yyyy-MM-dd HH:mm:ss" /></td>
					<td class="nui-form-label"><label for="remindTime$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.RemindTime")%>:</label></td>
					<td><input id="remindTime" name="remindTime"
						format="yyyy-MM-dd HH:mm:ss" class="nui-datepicker asLabell "
						readOnly="true" style="width: 100%" /></td>
				</tr>
				<tr>
					<td class="nui-form-label"><label for="confirmTime$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.ReadTime")%>:</label></td>
					<td><input id="confirmTime" name="confirmTime"
						class="nui-datepicker asLabell" readOnly="true" format="yyyy-MM-dd HH:mm:ss" style="width: 100%"/></td>
					<td class="nui-form-label"><label for="sender$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.Sender")%>:</label></td>
					<td><input id="sender" name="sender"
						class="nui-textbox asLabel " readOnly="true" /></td>
				</tr>
				<tr>
					<td class="nui-form-label"><label for="actInstName$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.ActInstName")%>:</label></td>
					<td><input id="actInstName" name="actInstName"
						class="nui-textbox asLabel " readOnly="true" /></td>
					<td class="nui-form-label"><label for="procInstName$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.ProcInstName")%>:</label></td>
					<td><input id="procInstName" name="procInstName"
						class="nui-textbox asLabel " readOnly="true" /></td>
				</tr>
				<tr>
					<td class="nui-form-label"><label for="workItemID$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.WorkItemID")%>:</label></td>
					<td><input id="workItemID" name="workItemID"
						class="nui-textbox asLabel " readOnly="true" /></td>
					<td class="nui-form-label"><label for="workItemName$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.WorkItemName")%>:</label></td>
					<td><input id="workItemName" name="workItemName"
						class="nui-textbox asLabel " readOnly="true" /></td>
				</tr>
				<tr>
					<td class="nui-form-label"><label for="state$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.Status")%>:</label></td>
					<td><input id="state" name="state"
						class="nui-textbox asLabel" readOnly="true" width="100%" /></td>
					<td class="nui-form-label"><label for="timeOutFlag$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.TimeOutFlag")%>:</label></td>
					<td><input id="timeOutFlag" name="timeOutFlag"
						class="nui-textbox asLabel" readOnly="true" /></td>
				</tr>
				<tr>
				<td class="nui-form-label" colspan="1"><label for="message$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.Message")%>:</label></td>
					<td colspan="3"><input id="message" name="message"
						class="nui-textbox asLabel " style="width:90%"  readOnly="true" /></td>
				</tr>
				
				<tr>
				<td class="nui-form-label" colspan="1"><label for="actionURL$text"><%=I18nUtil.getMessage(request, "bps.wfclient.notification.CustomURL")%>:</label></td>
					<td colspan="3"><input id="actionURL" name="actionURL"
						class="nui-textbox asLabel" style="width:100%" readOnly="true" /></td>
				</tr>
				<tr>
					<td colspan="4" align="center"><a id="executeButton" class="nui-button redBtn"
						onclick="confirm"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Confirm")%></a> <a class="nui-button redBtn" onclick="doCancel"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Cancel")%></a></td>
				</tr>
			</table>
		</fieldset>
	</form>
	<script type="text/javascript">
		nui.parse();
		var form = new nui.Form("#from1");
		var notificationID;
		var stateBox=nui.get("state");
		var timeOutFlagBox=nui.get("timeOutFlag");
		function initData(row, state) {
			notificationID = row.notificationID;
			form.setData(row);
			if (state == "VIEWED") {
				nui.get("executeButton").setVisible(false);
				stateBox.setValue("<%=I18nUtil.getMessage(request, "bps.wfclient.notification.Readed")%>");
			}else if(state=="UNVIEWED"){
				stateBox.setValue("<%=I18nUtil.getMessage(request, "bps.wfclient.notification.UNReaded")%>");
			}
			if(row.timeOutFlag=="Y"){
				timeOutFlagBox.setValue("<%=I18nUtil.getMessage(request, "bps.wfclient.notification.IsTimeOut")%>");
			}else if(row.timeOutFlag=="N"){
				timeOutFlagBox.setValue("<%=I18nUtil.getMessage(request, "bps.wfclient.notification.NoTimeOut")%>");
			}
			var fields = form.getFields();
			for (var i = 0; i < fields.length; i++) {
				var c = fields[i];
				if (c.setReadOnly)
					c.setReadOnly(true); //只读
				if (c.setIsValid)
					c.setIsValid(true); //去除错误提示
				if (c.addCls)
					c.addCls("asLabel"); //增加asLabel外观
			}
		}
		function confirm() {
			var data = {
				notificationID : notificationID
			};
			var json = nui.encode(data);//将数据转换成json格式		    	
			nui.ajax({
						url : contextPath+"/rest/services/bps/wfclient/notice/confrimNotification",
						type : 'POST',
						data : json,
						success : function(text) {
							doOK();
						}
					});
		}
		function doCancel() {
			closeWindow("cancle");
		}

		function doOK() {
			closeWindow("ok");
		}

		function closeWindow(action) {
			if (window.CloseOwnerWindow) {
				return window.CloseOwnerWindow(action);
			} else {
				window.close();
			}
		}
	</script>
</body>
</html>
