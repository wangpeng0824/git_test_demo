<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<html>
<!-- 
  - Author(s): Aoxq
  - Date: 2015-01-04 13:13:43
  - Description:
-->
<head>
<title></title> 
</head>
<body style="width: 99%; height: 95%;overflow:hidden" class="body-font">
    <table id="tableSearch" style="width:100%;">
        <tr>
            <td width="120px"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentStatus") %>：</td>
            <td >  
                <div id="agentStateList" class="nui-checkboxlist" onitemclick="onItemClick" textField="text" valueField="id"></div>
            </td>
            <td style="text-align:right;">  
                <a class="nui-button grayBtn" onclick="doQuery"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Query") %></a>
            </td>
        </tr>
    </table>
	<div id="dataGrid" showPager="false" style="margin-top:15px;width: 100%;"
      	dataField="agentList" class="nui-datagrid bpsDatagrid"  url=contextPath+"/rest/services/bps/wfclient/agent/queryMyAgent" >
		<div property="columns">
			<div name="action"  headerAlign="center" width="50" align="center" renderer="onActionRenderer"><%=I18nUtil.getMessage(request, "bps.wfclient.common.Operation") %></div>
			<div field="agentID"  headerAlign="center" width="100" align="center" visible="false"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentID") %></div>
			<div field="agentFrom"   headerAlign="center" width="100"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Principal") %></div>
			<div field="agentTo"  headerAlign="center" width="90" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Agents") %></div>
			<div field="agentToType"  headerAlign="center" width="70" align="center" renderer="doChangeAgentToType"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentType") %></div>
			<div field="agentType"  headerAlign="center" width="70" renderer="doChangeAgentType" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentMode") %></div>
			<div field="startTime" headerAlign="center" width="140" dateFormat="yyyy-MM-dd HH:mm:ss"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EffTime") %></div>
			<div field="endTime" headerAlign="center" width="140" dateFormat="yyyy-MM-dd HH:mm:ss"  align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.EndTime") %></div>
			<div field="state"  headerAlign="center" width="70" renderer="doJudgeState" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.Status") %> </div>
			<div field="agentReason" headerAlign="center" width="100" align="center"><%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentReason") %></div>
		</div>
    </div>

	<script type="text/javascript">
    	nui.parse();
    	//获取控件
    	var grid = nui.get("dataGrid");
    	var cobox=nui.get("selectState");
    	var agentStateList=nui.get("agentStateList");
    	//加载数据
    	grid.load({state:"ALL"});
    	
    	var stateType = [
			 { id : "ALL",text : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.All") %>"},
		 	 { id : "Y", text : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Effective") %>" }, 
		 	 { id : "N", text : "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Ineffective") %>" } ];
    	
    	//代理关系状态
		agentStateList.setData(stateType);
		agentStateList.selectAll();
		
		resizeDatagridHeight();
    	$(window).bind("resize", resizeDatagridHeight);
    	// 自动调整datagrid的外部高度,撑满屏幕
    	function resizeDatagridHeight(){
    		var realheight = window.innerHeight || (document.documentElement && document.documentElement.clientHeight) || document.body.clientHeight,
	    	realheight = realheight - 50 + "px";
	    	var datagridObj = document.getElementById("dataGrid");
	    	datagridObj.style.height=realheight;
    	}
    	
    	function onItemClick(e) {
    		if (e.item.id == "ALL") {
    			if (e.sender.isSelected(e.item)) {
    				e.sender.selectAll();
    			} else {
    				e.sender.deselectAll();
    			}
    		} else {
    			var allItem = e.sender.getAt(0);
    			if (e.sender.isSelected(e.item)) {
    				if (e.sender.getCount() - 1 == e.sender.getSelecteds().length) {
    					e.sender.select(allItem);
    				}    				
    			} else {
    				e.sender.deselect(allItem);
    			}
    		}
    	}
		
    	function onActionRenderer(e) {
            var action = ' <a class="dgBtn" href="javascript:doCheck(\'' + e + '\')"><%=I18nUtil.getMessage(request, "bps.wfclient.common.View") %></a>';
            return action;
        }
    	//根据代理关系查询
    	function doQuery(e) {
			var isAll=agentStateList.isSelected(agentStateList.getAt(0));
			if(isAll){
				grid.load({state : "ALL"});
			}else{
				
				var state=agentStateList.getValue();
				if(!state){
					tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.agent.QueryHints") %>",
			    					"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.QueryError") %>");
					return;
				}
				grid.load({state : state});
			}
		}
		
		//代理方式
		var agentType={
			"ALL":"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.FullAgent") %>",
			"PART":"<%=I18nUtil.getMessage(request, "bps.wfclient.agent.PartAgent") %>"};
    	//转换代理方式
    	function doChangeAgentType(e){
    		return agentType[e.value];
    	}
    	
    	//代理人类型
		var agentToType={
			"person":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Person") %>",
			"role":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Role") %>",
			"organization":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Organization") %>",
			"position":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Position") %>",
			"emp":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Emp") %>",
			"org":"<%=I18nUtil.getMessage(request, "bps.wfclient.bizdict.Org") %>"
			};
    	//转换代理人类型
    	function doChangeAgentToType(e){
    		return agentToType[e.value];
    	}
    	//判断是否生效
    	function doJudgeState(e){
			var record = e.record;
			var starttime=new Date(record.startTime).getTime();
			var endtime=new Date(record.endTime).getTime();
			var currenttime=new Date().getTime();
			if (starttime < currenttime && currenttime < endtime) {
				return "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Effective") %>";
			} else {
				return "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.Ineffective") %>";
			}
    		
    	}
    	
    	//代理信息查看
    	function doCheck(e){
    		var row = grid.getSelected();
        	//根据不同的代理类型打开相应查看页面
        	var type=row.agentType;
        	var target="";
        	if(type=="ALL") {
        	target=contextPath + "/bps/wfclient/agent/detailFullAgent.jsp";
        	}else {
        		target=contextPath + "/bps/wfclient/agent/detailPartAgent.jsp";
        	}
         	nui.open({
           		url: target,
           		title: "<%=I18nUtil.getMessage(request, "bps.wfclient.agent.AgentDetail") %>",
                cache: false,
           		width:  800,
				height : 460,
           		onload: function () {
             		var iframe = this.getIFrameEl();
                    iframe.contentWindow.setData(row);
             	}
           });
            
    	}
    </script>
</body>
</html>
