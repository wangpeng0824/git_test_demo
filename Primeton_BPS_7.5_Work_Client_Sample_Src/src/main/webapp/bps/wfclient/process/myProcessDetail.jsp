<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"  "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>

<head>
<title></title>
	<style type="text/css">
		body{
			background-color:#f7f7f7
		}
	</style>
</head>
<body style="height:95%; width: 97%">
	
	<div id="tabs" class="nui-tabs" activeIndex="0" style="width:100%;height:95%;" bodyStyle="padding:0;">
        	<div title="<%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcessGraph") %>" refreshOnClick="true" style="height:100%;width:100%">
				<div id="processgraph" class="nui-bps-processgraph"  showParticipants="true"></div> 
	    	</div>
	    	<div title="<%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcDetail") %>" refreshOnClick="true" >
	    		<div id="form"  style="height:60%;width:100%">
					<table id="graphTable" class="nui-form-table" style="border:none" width="100%">	
						<tr>
							<td class="nui-form-label" ><%=I18nUtil.getMessage(request, "bps.wfclient.process.BIID") %>:</td>
							<td><input id="processInstID"  name="processInstID" class="nui-textbox asLabel" readOnly="true"/></td>
							
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcDefID") %>:</td>
							<td><input id="processDefID"  name="processDefID" class="nui-textbox asLabel" readOnly="true"/></td>
						</tr>		
						<tr>
							<td class="nui-form-label" ><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcessInsName") %>:</td>
							<td ><input id="processInstName"  name="processInstName" class="nui-textbox asLabel" readOnly="true"/></td>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcessInsDes") %>:</td>
							<td><input id="processInstDesc"  name="processInstDesc" class="nui-textbox asLabel" readOnly="true"/></td>
							
						</tr>			
						<tr>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.Creator") %>:</td>
							<td><input id="creator"  name="creator" class="nui-textbox asLabel" readOnly="true"/></td>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.Status") %>:</td>
							<td><input id="currentState"  name="currentState" class="nui-combobox asLabel" 
										data="[{id:'1',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Unstart") %>'},
										{id:'2',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Running") %>'},
										{id:'3',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Suspend") %>'},
										{id:'7',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Finish") %>'},
										{id:'8',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Terminate") %>'},
										{id:'10',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Activating") %>'},
										{id:'-1',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.AppExcep") %>'}]"
										 readOnly="true"/></td>
						</tr>
						<tr>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.CreationTime") %>:</td>
							<td><input id="createTime"  name="createTime" class="nui-datepicker asLabel" format="yyyy-MM-dd HH:mm:ss" readOnly="true" width="100%"/></td>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.STime") %>:</td>
							<td><input id="startTime"  name="startTime" class="nui-datepicker asLabel" format="yyyy-MM-dd HH:mm:ss" readOnly="true" width="100%"/></td>
						</tr>
						<tr>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.EndTime") %>:</td>
							<td><input id="endTime"  name="endTime" class="nui-datepicker asLabel" format="yyyy-MM-dd HH:mm:ss" readOnly="true" width="100%"/></td>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.FinalTime") %>:</td>
							<td><input id="finalTime"  name="finalTime" class="nui-datepicker asLabel" format="yyyy-MM-dd HH:mm:ss" readOnly="true" width="100%"/></td>
							</tr>
						<tr>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.TimeLimit") %>:</td>
							<td><input id="limitNumDesc"  name="limitNumDesc" class="nui-textbox asLabel" readOnly="true"/></td>
							
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.RemindTime") %>:</td>
							<td><input id="remindTime"  name="remindTime" class="nui-datepicker asLabel" format="yyyy-MM-dd HH:mm:ss" readOnly="true" width="100%"/></td>
						</tr>	
						<tr>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.Timeout") %>:</td>
							<td><input id="isTimeOut"  name="isTimeOut" class="nui-combobox asLabel" data="[{id:'Y',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Yes") %>'},{id:'N',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.No") %>'}]"
								readOnly="true"/></td>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.Overtime") %>:</td>
							<td><input id="timeOutNumDesc"  name="timeOutNumDesc" class="nui-textbox asLabel" readOnly="true"/></td>
						</tr>
						<tr>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ParentProcID") %>:</td>
							<td><input id="parentProcID"  name="parentProcID" class="nui-textbox asLabel" readOnly="true"/></td>
						</tr>			
						<tr>
							<td class="nui-form-label"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcName") %>:</td>
							<td colspan="3"><input id="processDefName"  name="processDefName" class="nui-textbox asLabel" readOnly="true" width="100%"/></td>
						</tr>
					</table>
				</div>
	    	</div>
	    	 <div name="pressDiv" title="<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.PreInfo")%>">
				<div id="pressDetail" class="nui-bps-fetchmessagelist">
					<div name="pressDetail" property="column">
				        <div field="createTime"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.PressTime")%></div>
				        <div field="producer"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.PreProducer")%></div>
				        <div field="content"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.PreDetial")%></div>
			        </div>
				</div>
	    	</div>
	   		<div id="annotateDiv" title="<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.AnnInfo")%>">
				<div id="annotateDetail" class="nui-bps-fetchmessagelist">
					<div name="annotateDetail" property="column">
				        <div field="createTime"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.AnnTime")%></div>
				        <div field="producer"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.AnnProducer")%></div>
				        <div field="content"><%=I18nUtil.getMessage(request, "bps.wfclient.myTask.AnnDetail")%></div>
			        </div>
				</div>	 	
	    	</div>
		</div>
		<div class="bottomBtnDiv">
			<a id="btnCancel" class="nui-button redBtn"  onclick="doCancel"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Closed") %></a>
		</div>
	<script type="text/javascript">
    	nui.parse();
    	var form = new nui.Form("form");
    	timeOutNumBox=nui.get("timeOutNumDesc");
    	limitNumBox=nui.get("limitNumDesc");
    	//取消
    	 function doCancel() {
    		closeWindow("cancle");
	    }
	    //转换时间格式
	    function changeTimeType(time){
    		var daylen=time.indexOf("Days");
    		var hourlen=time.indexOf("Hours");
    		var minlen=time.indexOf("Minutes");
    		var day=time.substring(0,daylen);
    		var hour=time.substring(daylen+4,hourlen);
    		var min=time.substring(hourlen+5,minlen);
    		return day+"<%=I18nUtil.getMessage(request, "bps.wfclient.common.Days")%>"+hour+
    						"<%=I18nUtil.getMessage(request, "bps.wfclient.common.Hours")%>"+min+
    						"<%=I18nUtil.getMessage(request, "bps.wfclient.common.Minutes")%>";
    	}
        //加载数据
        function setData(data){
        	var info=nui.clone(data);
        	if(info.parentProcID==0){
        		info.parentProcID="";
        	}
        	var processImg = nui.get("processgraph");
        	processImg.setProcInstID(info.processInstID);
        	processImg.load();
    		form.setData(info);
    		
        	if(data.limitNumDesc){
    			limitNumBox.setValue(changeTimeType(data.limitNumDesc));
    		}
    		if(data.timeOutNumDesc){
    			timeOutNumBox.setValue(changeTimeType(data.timeOutNumDesc));
    		}
    		var tabObj = nui.get("tabs");
    		tabObj.on("activechanged", function (e) {
           		var title = tabObj.getActiveTab().title;
    			if(title=="<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.PreInfo")%>"){
    				var processInstID = nui.get("processInstID").value;
    				var pressDetailObj = nui.get("pressDetail");
					var data = {processInstID:processInstID};
					pressDetailObj.setRestMethod("queryPressListByProcessInstID");
					pressDetailObj.load(data);
    			}
    			if(title=="<%=I18nUtil.getMessage(request, "bps.wfclient.myTask.AnnInfo")%>"){
    				var processInstID = nui.get("processInstID").value;
    				var pressDetailObj = nui.get("annotateDetail");
					var data = {processInstID:processInstID};
					pressDetailObj.setRestMethod("queryAnnotateListByProcessInstID");
					pressDetailObj.load(data);
    			}
        	});
    		
    	}
    	
    </script>
</body>
</html>