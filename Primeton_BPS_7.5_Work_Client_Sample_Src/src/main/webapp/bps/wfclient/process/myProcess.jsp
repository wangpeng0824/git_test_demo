<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"  "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>

<head>
	<title></title>
</head>
<body style="width: 99%;height:97%; overflow:hidden" class="body-font">
	
	<div id="dataGrid"  allowAlternating="true" showPager="false"  pageSize="10" 
      		 dataField="processList" class="nui-datagrid bpsDatagrid" 
      		 url=contextPath+"/rest/services/bps/wfclient/process/queryMyProcess" style="width:100%;">
		<div property="columns">
        	 <div name="action" width="48" headerAlign="center" align="center" renderer="onActionRenderer" cellStyle="padding:0;"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Operation") %></div>       
        	 <div field="processInstID" width="88" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.process.BIID") %></div>    
        	 <div field="processInstName" width="88" headerAlign="center"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.process.BIName") %></div> 
        	 <div field="processInstDesc" width="88" headerAlign="center"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcessInsDes") %></div> 
       	 	 <div field="creator" width="95" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.process.Creator") %></div>
       	 	 <div field="currentState" width="70" headerAlign="center"   align="center" renderer="doChangeState"><%=I18nUtil.getMessage(request, "bps.wfclient.process.Status") %></div>
           	 <div field="startTime"  width="160" headerAlign="center"  dateFormat="yyyy-MM-dd HH:mm:ss" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.process.STime") %></div>
      		 <div field="endTime" name="endTime" width="160" headerAlign="center"  dateFormat="yyyy-MM-dd HH:mm:ss" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.process.EndTime") %></div>
         </div>
    </div>
    <div class="pager" style="height:30px;width:100%">
		<div id="pager" class="nui-bpspager" datagridId="dataGrid"></div>
	</div>
	<script type="text/javascript">
    	nui.parse();
    	var grid = nui.get("dataGrid");
    	var queryType = '<%=request.getParameter("queryType")%>';
		if (queryType != "finish") {
    		grid.hideColumn("endTime");
    	}
    	grid.load({queryType:queryType});
    	var pager = nui.get("pager");
    	pager.setDatagridParams({queryType:queryType});
    	
    	//流程状态类型
    	var processState={
    		"1":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Unstart") %>",
    		"2":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Running") %>",
    		"3":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Suspend") %>",
    		"7":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Finish") %>",
    		"8":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Terminate") %>",
    		"10":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Activating") %>",
    		"-1":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.AppExcep") %>"
    		};
    	function doChangeState(e){
    		return processState[e.value];
    	}
    	
    	function onActionRenderer(e) {
            var action = ' <a class="dgBtn" href="javascript:doCheck(\'' + e + '\')"><%=I18nUtil.getMessage(request, "bps.wfclient.common.View") %></a>';
            return action;
        }
    	
    	resizeDatagridHeight();
    	$(window).bind("resize", resizeDatagridHeight);
    	// 自动调整datagrid的外部高度,撑满屏幕
    	function resizeDatagridHeight(){
    		var realheight = window.innerHeight || (document.documentElement && document.documentElement.clientHeight) || document.body.clientHeight,
	    	realheight = realheight -60 - 20 + "px";
	    	var datagridObj = document.getElementById("dataGrid");
	    	datagridObj.style.height=realheight;
    	}
    	
    	//查看详细信息
    	function doCheck(e){
    		var row = grid.getSelected();
         	nui.open({
           		url: contextPath + "/bps/wfclient/process/myProcessDetail.jsp",
           		title: "<%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcDetail") %>",
           		type:'POST',
                cache: false,
                contentType:'text/json',
           		width: 680,
				height: 530,
           		onload: function () {
             		var iframe = this.getIFrameEl();
                    iframe.contentWindow.setData(row);
             		}
              });
    	}
    </script>
</body>
</html>