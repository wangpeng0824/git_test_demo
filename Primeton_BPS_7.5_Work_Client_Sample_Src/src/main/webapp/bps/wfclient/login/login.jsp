<%@page import="org.gocom.bps.wfclient.login.HttpSecurityConfig"%>
<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
	if(request.getParameter("language")!=null){
		if(request.getParameter("language").equals("en")){
			Locale locale=new Locale("en", "US");
			request.setAttribute("LOCALE", locale);	
		}
		
		if(request.getParameter("language").equals("zh")){
			Locale locale=new Locale("zh", "CN");
			request.setAttribute("LOCALE", locale);	
		}
	}
	
	String contextPath=request.getContextPath();
   	String url = null;
   	HttpSecurityConfig securityConfig = HttpSecurityConfig.INSTANCE;
   	boolean isOpenSecurity = securityConfig.isOpenSecurity();
   	if(isOpenSecurity){
   		boolean isAllInHttps = securityConfig.isAllInHttps();
   		if(!isAllInHttps){
   			String ip = securityConfig.getHost();
   			String https_port = securityConfig.getHttps_port();
   			url = "https://" + ip + ":" + https_port + contextPath + "/bps/wfclient/login/validate4Login.jsp";
   		}else{
   			url = contextPath + "/bps/wfclient/login/validate4Login.jsp"; 
   		}
   	}else{
   		url = contextPath + "/bps/wfclient/login/validate4Login.jsp";
   	}
 %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/bps/wfclient/common/common.jsp"%>
<%@page import="com.primeton.bps.component.manager.api.BPSMgrServiceClientFactory" %>
<%@page import="java.util.Locale" %>
<html>
<head>
<title><%=I18nUtil.getMessage(request, "bps.wfclient.login.loginTitle")%></title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />   
</head>
<body style="width: 98%; height: 95%; background:url(<%=contextPath%>/bps/wfclient/common/imgs/loginBg.png);background-position: center;
	background-repeat: no-repeat;background-attachment: fixed;" >
	<%
		boolean mul = BPSMgrServiceClientFactory.getDefaultClient().getBPSWSManager().isMultiTenantMode();
 	%>

		<form id ="loginform"  method="post">
		<div style="width:400px;height:250px;background:#E7E7E7; position:absolute;left:50%;top:50%;  margin:-125px 0 0 -200px">
			<table id="loginTable" style="width:300px;left:50px;top:50px; border-collapse: collapse;">
			<tr id="isDomain">
				<td colspan="3">
					<input  id ="domainID" name="domainID"  type="text" value="<%=I18nUtil.getMessage(request, "bps.wfclient.login.DomainID")%>" style="width:294px;height:24px;font:18px 微软雅黑;color:#9a9a9a;" />
				</td>
			</tr>
			<tr style="height:16px;">
				<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="3">
					<input  id ="userName" name="userName" autocomplete="off" type="text" value="<%=I18nUtil.getMessage(request, "bps.wfclient.login.userName")%>" style="width:294px;height:24px;font:18px 微软雅黑;color:#9a9a9a"/>
					<input type="text" id="language" name="language" style="display:none;">
					<input type="password" style="display:none;">
				</td>
			</tr>
			<tr style="height:16px;">
				<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="3">
					<div style=" position: relative;">
						<input id="password" name="password" type="password" oninput="onvalueChange(this)" style="width:294px;height:24px;" autocomplete="off">
						<span id="passwordText" onClick="onClick(this)" style="height:20px;line-height:20px;top:2px;width:294px;left:4px;font:18px 微软雅黑;color:#9a9a9a; position: absolute;dispplay:inline;"><%=I18nUtil.getMessage(request, "bps.wfclient.login.passwordText")%></span>
					</div>
				</td>
			</tr>
			<tr style="height:26px;">
				<td colspan="3"></td>
			</tr>
			<tr>
				<td id="loginBtn" colspan="3" style="width:296px;height:34px;cursor:pointer;background:#df3f24;font:20px 微软雅黑;color:white;text-align:center;">
					<%=I18nUtil.getMessage(request, "bps.wfclient.login.loginBtnText")%>
				</td>
			</tr>
		</table>
		</div>
		<div style="width:400px;height:24px;background:RGBA(255,255,255,0.00);position:absolute;left:50%;top:50%;  margin:125px 0 0 -200px">
			<table style="border-collapse: collapse;width:100%;height:100%；font:12pt 微软雅黑;">
				<tr>
					<td style="width:30px"></td>
					<td id ="I18nZhBtn" style="width:60px;background:#E7E7E7;text-align:center;color:#393939;cursor:pointer"><%=I18nUtil.getMessage(request, "bps.wfclient.login.i18NzhBtnText")%></td>
					<td style="width:2px"></td>
					<td id ="I18nEnBtn" style="width:60px;background:#393939;text-align:center;color:#9a9a9a;cursor:pointer"><%=I18nUtil.getMessage(request, "bps.wfclient.login.i18NenBtnText")%></td>
					<td></td>
				</tr>
			</table>
		</div>
		
	</form>
	
	<script type="text/javascript">
		 if(window.top!=window){
			window.top.location = window.location;
			}
    	nui.parse();
    	var language = "<%=request.getParameter("language")%>";
    	var loginfail="<%=request.getParameter("loginfail")%>";
    	if(loginfail=="true"){
    		tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.login.invalid")%>");
		    
    	}
    	 if(language=="en"){
				document.getElementById("I18nZhBtn").style.background="#393939";
				document.getElementById("I18nZhBtn").style.color="#9a9a9a";
				document.getElementById("I18nEnBtn").style.background="#E7E7E7";
				document.getElementById("I18nEnBtn").style.color="#393939";
		}
		function onClick(e){
			e.style.display="none";
			$("#password").focus();
		}
		function onvalueChange(e){
			$("#passwordText").css("display","none");
		}
    	var passwordText=document.getElementById("passwordText");
    	var password=document.getElementById("password");
		$("#userName").bind("focus",focus);
		$("#domainID").bind("focus",focus);
		$("#password").bind("focus",focus);
		
		$("#userName").bind("blur",blur);
		$("#domainID").bind("blur",blur);
		$("#password").bind("blur",blur);
		var defaultUserName = "<%=I18nUtil.getMessage(request, "bps.wfclient.login.userName")%>";
		var passwordText="<%=I18nUtil.getMessage(request, "bps.wfclient.login.passwordText")%>";
		var damoainIDText="<%=I18nUtil.getMessage(request, "bps.wfclient.login.DomainID")%>";
		function focus(e){
			e = e || window.event;
			e = e.target || e.srcElement;
			if(e.id == "userName"){
				if(e.value ==defaultUserName){
					e.value = "";
				}
			}else if(e.id == "password"){
				$("#passwordText").css("display","none");
			}else if(e.id == "domainID"){
				if(e.value == damoainIDText){
					e.value = "";
				}
			}
		}
		function blur(e){
			e = e || window.event;
			e = e.target || e.srcElement;
			if(e.id == "userName"){
				if(e.value.trim() == ""){
					e.value =defaultUserName;
				}
			}else if(e.id == "password"){
				if(e.value.trim() == ""){
					$("#passwordText").css("display","inline");
				}
			}else if(e.id == "domainID"){
				if(e.value.trim() == ""){
					e.value = damoainIDText;
				}
			}
		}
		
		function doLogin(){
			var domainIDObj = $("#domainID");
			var domainID = domainIDObj.attr("value");
			var userNameObj = $("#userName");
			var userName = userNameObj.attr("value");
			var passwordObj = $("#password");
			var password = passwordObj.attr("value");
			var passwordTextObj = $("#passwordText");
			var result = true;
			if(<%=mul%>){
				if(domainID==""||domainID==" <%=I18nUtil.getMessage(request, "bps.wfclient.login.DomainID")%>"){
					domainIDObj.css("border","1px solid #e14125");
					result = false;
				}
			}else{
				if(userName==""||userName==defaultUserName){
					userNameObj.css("border","1px solid #e14125");
					result = false;
				}
			}
			
			if(password==""){
				passwordObj.css("border","1px solid #e14125");
				passwordTextObj.css("border","1px solid #e14125");
				result = false;
			}
			
			
			if(language==null){
				language = "zh"
			}else if(language=="en_US"){
				language = "en";
			}else if(language=="zh_CN"){
			    language="zh";
			}
			
			if(result){
				var form = document.getElementById('loginform');
	      		var languageBox = document.getElementById('language');
	      		languageBox.value=language;
	      		form.action="<%=url%>";
	      		form.submit();
			}
				<%-- //var json;
				//if(<%=mul%>){
				//	 json ={userName:userName,password:password,domainID:domainID,language:language};
				//}else{
				//	 json ={userName:userName,password:password,language:language};	
					 
				//} --%>
				
				 <%-- nui.ajax({
	     		 	url:contextPath+"/rest/services/bps/wfclient/login/login",
	     		 	type:'POST',
		            data:json,
		            cache: false,
	      		 	success:function(text) {
		      		 	if(text.result==1) {
		      		 		window.location.href=contextPath+"/bps/wfclient/common/index.jsp";
		      		 	} else {
		      		 		tfcToast.take("<%=I18nUtil.getMessage(request, "bps.wfclient.login.invalid")%>");
		      		 		userNameObj.css("border","1px solid #e14125");
		      		 		passwordObj.css("border","1px solid #e14125");
		      		 	}
	      		 	}
	      		});	  --%>
	      		
			//}
		}
		
		function loginSuccess(){
			
		}
		
		function eventListener(){
			var loginTable = $("#loginTable");
			var isDomainObj = $("#isDomain");
			if(<%=mul%>){
				loginTable.css("top","29px");
				isDomainObj.css("display","block");
				
				var domainIDObj = $("#domainID");
				domainIDObj[0].onkeydown = function(obj){					
					var domainID = domainIDObj.attr("value");
					if(domainID==" <%=I18nUtil.getMessage(request, "bps.wfclient.bps.wfclient.login.DomainID")%>"){
						domainIDObj.attr("value","");
					}
					domainIDObj.attr("value",obj.value);
				};
			}else{
				isDomainObj.css("display","none");
			}
			
			var passwordObj = $("#password");
			
			passwordObj[0].onkeydown = function(e){
				e = e||event;
			 	if(e.keyCode==13){ 
	 				doLogin();
	          	}
			};
			
			
			
			var loginBtnObj = $("#loginBtn");
			loginBtnObj[0].onclick= function (){
				doLogin();
			};
			
			var I18nEnBtn = $("#I18nEnBtn");
			I18nEnBtn[0].onclick=function (){
				location.href="login.jsp?language=en";
			};
			
			var I18nZhBtn = $("#I18nZhBtn");
			I18nZhBtn[0].onclick=function (){
				location.href="login.jsp?language=zh";
			};
		}
		
		window.onload = eventListener;
	</script>

</body>
</html>