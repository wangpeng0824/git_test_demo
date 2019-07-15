<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>

<head>
	<title></title>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body style="width: 99%; height: 97%;overflow-y:hidden" class="body-font">
	<div class="nui-splitter" width="100%" height="100%">
        <div size="200" minSize="160" showCollapseButton="true" style="height:100%">
            <ul id="tree" class="nui-tree" showTreeIcon="true" height="100%" showTreeLines="false"
	 			url=contextPath+"/rest/services/bps/wfclient/process/getProcessCatalogs"  resultAsTree="false"
	 				dataField="catalogs" textField="catalogName" idField="catalogUUID" parentField="parentCatalogUUID"
	 					onbeforeload = "onBeforeTreeLoad" onnodeselect = "onNodeSelect">        
    		</ul>
        </div>
	    <div showCollapseButton="false">
            <div id="dataGrid" showPager="fasle" allowAlternating="true" pageSize="10" dataField="processListWithCatalog" 
            	class="nui-datagrid bpsDatagrid" style="width:100%;"
		 		url=contextPath+"/rest/services/bps/wfclient/process/queryPublishedProcessWithCatalog">
	    		<div property="columns">
					<div name="action" width="100" cellCls="textof_clip" headerAlign="center" align="center" renderer="onActionRenderer"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Operation") %></div>   
		            <div field="processDefID" width="70" headerAlign="center" align="center" ><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcDefID") %></div>        
		            <div field="processDefName" width="150" headerAlign="center" align="center" ><%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcName") %></div>
		            <div field="versionSign" width="60" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.process.VersionNumber") %></div> 
		            <div field="processDefOwner" width="80" headerAlign="center" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.process.VersionOwner") %></div> 
		            <div field="updateTime" width="135" headerAlign="center" align="center" dateFormat="yyyy-MM-dd HH:mm:ss"><%=I18nUtil.getMessage(request, "bps.wfclient.process.LastModified") %></div>
	        	</div>
        	</div>
    		<div class="pager">
				<div id="pager" class="nui-bpspager" datagridId="dataGrid"></div>
			</div>
	  	</div>
    </div>  

   <script type="text/javascript">
		nui.parse();
    	var grid = nui.get("dataGrid");
		grid.load();
    	
    	resizeDatagridHeight();
    	$(window).bind("resize", resizeDatagridHeight);
    	function resizeDatagridHeight(){
    		var realheight = window.innerHeight || (window.document.documentElement && window.document.documentElement.clientHeight) || window.document.body.clientHeight,
	    	realheight = realheight - 80 + "px";
	    	var datagridObj = document.getElementById("dataGrid");
	    	datagridObj.style.height=realheight;
    	}
    	
   		function onBeforeTreeLoad(e) {
	        var node = e.node;      
	        var params = e.params;  
        	params.myField = {"catalogUUID":node.catalogUUID}; 
    	} 
        	
    	function onNodeSelect(e) {
            var node = e.node;
            var isLeaf = e.isLeaf;
            if(node.catalogUUID=="-1"){
            	isLeaf = false;
            }
    		grid.load({catalogUUID:node.catalogUUID});
    		
		  	var pager = nui.get("pager");
    		pager.setDatagridParams({catalogUUID:node.catalogUUID});
            
   	 	}
       	 	
   	 	function onActionRenderer(e) {
            var actions = '<a class="dgBtn" href="javascript:doStart(' + e.rowIndex + ')"><%=I18nUtil.getMessage(request, "bps.wfclient.process.Start") %></a> ';
            actions = actions + '&nbsp;<a class="dgBtn" href="javascript:showDetail(' + e.rowIndex + ')"><%=I18nUtil.getMessage(request, "bps.wfclient.common.View") %></a> ';
            return actions;
   	 	}
   	 	
   	 	function showDetail(rowIndex) {
    		var row = grid.getRow(rowIndex);
    		nui.open({
       			 url: contextPath + "/bps/wfclient/process/processDetail.jsp",
       			 title: "<%=I18nUtil.getMessage(request, "bps.wfclient.process.ProcDetail") %>",
       			 type:'POST',
                 cache: false,
       			 width: 620,
       			 height: 400,
       			 onload: function () {
         			var iframe = this.getIFrameEl();
                   	iframe.contentWindow.setData(row);
         		 }
        	});
    	}
	    	
	    function doStart(rowIndex){
			var row = grid.getRow(rowIndex);
         	nui.open({
       			 url: contextPath + "/bps/wfclient/process/startProcess.jsp",
       			 title: "<%=I18nUtil.getMessage(request, "bps.wfclient.process.StartProcess") %>",
       			 type:'POST',
       			 width: 500,
       			 height: 250,
       			 onload: function () {
         			 var iframe = this.getIFrameEl();
                   	 iframe.contentWindow.setData(row);
         		 }
            });
		}	
	</script>
</body>
</html>