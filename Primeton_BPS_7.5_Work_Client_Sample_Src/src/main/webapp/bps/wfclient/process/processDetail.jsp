<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
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
<body style="width: 97%;height:320px">
	<div  class="nui-tabs" style="width:100%;height:100%;" activeIndex="0">
		<div id="processGraphTab" title="<%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcessGraph") %>" style="height: 95%;width: 99%">
			<div id="processgraph" class="nui-bps-processgraph"  showParticipants="true" style="height:100%"></div>
		</div>
	    
	    <div id="processDetailTab" title="<%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcDetail") %>">
			<div id ="form" style="height:100%">
	        	<table id="processDetail" class="nui-form-table" style="width:100%">           
	           		<tr>
		                <td style="text-align:right;width:30%"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcDefID") %>:</td>
		                <td><input id="processDefID" name="processDefID" class="nui-textbox asLabel" readOnly="true" width="100%"/></td>
	            	</tr>
	            	<tr>
		                <td style="text-align:right"><%=I18nUtil.getMessage(request, "bps.wfclient.process.Status") %>:</td>
		                <td><input id="currentState" name="currentState" class="nui-combobox asLabel" 
		                data="[{id:'1',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Unpublished") %>'},
          {id:'2',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Test") %>'},
          {id:'3',text:'<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Published") %>'}]"
										 readOnly="true" width="100%"/></td>
	            	</tr>
	            	<tr>
		                <td style="text-align:right"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcName") %>:</td>
		                <td><input id="processDefName" name="processDefName" class="nui-textbox asLabel" readOnly="true" width="100%"/></td>
	            	</tr>
	            	<tr>
		                <td style="text-align:right"><%=I18nUtil.getMessage(request, "bps.wfclient.process.CreationTime") %>:</td>
		                <td><input id="createTime" formatter="yyyy-MM-dd HH:mm:ss" name="createTime" class="nui-textbox asLabel" readOnly="true" width="100%"/></td>
	            	</tr>
	            	<tr>
		                <td style="text-align:right"><%=I18nUtil.getMessage(request, "bps.wfclient.process.UpdateTime") %>:</td>
		                <td><input id="updateTime" name="updateTime" class="nui-textbox asLabel" readOnly="true" width="100%"/></td>
	            	</tr>
	            	<tr>
		                <td style="text-align:right"><%=I18nUtil.getMessage(request, "bps.wfclient.process.VersionNumber") %>:</td>
		                <td><input id="versionSign" name="versionSign" class="nui-textbox asLabel" readOnly="true" width="100%"/></td>
	            	</tr>
	            	<tr>
		                <td style="text-align:right"><%=I18nUtil.getMessage(request, "bps.wfclient.process.VersionDescription") %>:</td>
		                <td><input id="versionDesc" name="versionDesc" class="nui-textbox asLabel" readOnly="true" width="100%"/></td>
	            	</tr>
	            	<tr>
		                <td style="text-align:right"><%=I18nUtil.getMessage(request, "bps.wfclient.process.PackageName") %>:</td>
		                <td><input id="packageName" name="packageName" class="nui-textbox asLabel" readOnly="true" width="100%"/></td>
	            	</tr>
	            </table>
            </div>
	    </div>
	</div>

	<div style="width: 100%; padding-top: 10px" align="center">
		<a class="nui-button redBtn" onclick="doStart"><%=I18nUtil.getMessage(request, "bps.wfclient.process.StartProcess") %></a>
        <a class="nui-button redBtn" onclick="doCancel"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Closed") %></a>
    </div>

	<script type="text/javascript">
    	nui.parse();
    	var form = new nui.Form("#form");
    	function setData(rowData){
    		var processGraphObj = nui.get("processgraph");
    		processGraphObj.setProcDefID(rowData.processDefID);
    		processGraphObj.load();
    		if(rowData.createTime){
    			rowData.createTime = nui.formatDate(rowData.createTime, "yyyy-MM-dd HH:mm:ss");
    		}
    		if(rowData.updateTime){
    			rowData.updateTime = nui.formatDate(rowData.updateTime, "yyyy-MM-dd HH:mm:ss");
    		}
      		form.setData(rowData);
    	}
    	
    	function doStart(){
    		var _this = window;
    		var data = nui.clone(form.getData());
    		nui.open({
       			 url: contextPath+"/bps/wfclient/process/startProcess.jsp",
       			 title: "<%=I18nUtil.getMessage(request, "bps.wfclient.process.StartProcess") %>",
       			 type:'POST',
       			 width: 550,
       			 height: 350,
       			 onload: function () {
         			 var iframe = this.getIFrameEl();
                   	 iframe.contentWindow.setData(data);
                   	 if (_this.CloseOwnerWindow)
		    		 	return _this.CloseOwnerWindow();
		             else _this.close();  
         		 }
	        });
    	}
    	
    	function doCancel(e){
    		 if (window.CloseOwnerWindow)
    		 	return window.CloseOwnerWindow(e);
             else window.close();   
    	}
    </script>
</body>
</html>