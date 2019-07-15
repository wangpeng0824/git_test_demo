<%@page import="org.gocom.bps.wfclient.login.HttpSecurityConfig"%>
<%@page import="com.primeton.bps.web.control.I18nUtil"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.gocom.bps.wfclient.login.Validate4Login"%>
<%@page import="com.eos.system.utility.StringUtil"%>
<%@page import="com.eos.system.Constants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%	
	String contextPath = request.getContextPath();
	String url=contextPath + "/bps/wfclient/login/login.jsp";
	String domainID=request.getParameter("domainID");
	String userName=request.getParameter("userName");
	String pwd=request.getParameter("password");
	String language=request.getParameter("language");
	
	//用户名为空认为用户直接访问此页面；直接返回登录页面
	if(StringUtils.isEmpty(userName)){
		if(StringUtil.isNotNullAndBlank(language)){
			url = url + "?language="+language;
		}
		response.sendRedirect(url);
		return;
	}
	
	if(domainID.equals(I18nUtil.getMessage(request, "bps.wfclient.login.DomainID"))){
		domainID=null;
	}
	int result=Validate4Login.validate4Login(userName, pwd, domainID, language, request);
	if(result==1){
		url=contextPath + "/bps/wfclient/common/index.jsp";
		if(StringUtil.isNotNullAndBlank(language)){
			url = url + "?language="+language;
		}
	}else{
		url=contextPath + "/bps/wfclient/login/login.jsp?loginfail=true";
		if(StringUtil.isNotNullAndBlank(language)){
			url = url + "&language="+language;
		}
	}
	HttpSecurityConfig securityConfig = HttpSecurityConfig.INSTANCE;
   	boolean isOpenSecurity = securityConfig.isOpenSecurity();
   	if(isOpenSecurity){
   		boolean isAllInHttps = securityConfig.isAllInHttps();
   		if(!isAllInHttps){
   			String ip = securityConfig.getHost();
   			String http_port = securityConfig.getHttp_port();
   			url = "http://" + ip + ":" + http_port + url;
			String serverType = HttpSecurityConfig.INSTANCE.getServerType();
			//System.out.println(serverType);
			if(!(StringUtils.equals(serverType, Constants.SERVER_TYPE_WEBLOGIC) || StringUtils.equals(serverType, Constants.SERVER_TYPE_WEBSPHERE))){
				String sessionID = session.getId();
				Cookie cookie = new Cookie("JSESSIONID", sessionID);
				cookie.setPath(contextPath);
				response.addCookie(cookie);
	   		}
		}
   	}
	response.sendRedirect(url);
 %>