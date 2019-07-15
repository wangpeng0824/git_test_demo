package org.gocom.bps.wfclient;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.gocom.bps.wfclient.login.HttpSecurityConfig;

import com.primeton.bps.web.control.I18nUtil;

public class BpsClientListener implements ServletContextListener {

	public void contextDestroyed(ServletContextEvent arg0) {

	}

	public void contextInitialized(ServletContextEvent event) {
		HttpSecurityConfig httpSecurityConfig=HttpSecurityConfig.INSTANCE;
		ServletContext context=event.getServletContext();
		String isOpenSecurity=context.getInitParameter("isOpenSecurity");
		if(isOpenSecurity==null||isOpenSecurity==""){
			isOpenSecurity="false";
		}
		httpSecurityConfig.setOpenSecurity(Boolean.parseBoolean(isOpenSecurity));
		String isAllInHttps=context.getInitParameter("isAllInHttps");
		if(isAllInHttps==null||isAllInHttps==""){
			isAllInHttps="false";
		}
		httpSecurityConfig.setAllInHttps(Boolean.parseBoolean(isAllInHttps));
		String host=context.getInitParameter("host");
		if(host==null||host==""){
			host="";
		}
		httpSecurityConfig.setHost(host);
		String httpport=context.getInitParameter("http-port");
		if(httpport==null||httpport==""){
			httpport="";
		}
		httpSecurityConfig.setHttp_port(httpport);
		String httpsport=context.getInitParameter("https-port");
		if(httpsport==null||httpsport==""){
			httpsport="";
		}
		httpSecurityConfig.setHttps_port(httpsport);
		I18nUtil.registerResource("org/gocom/bps/wfclient/i18n/i18n.properties");
		I18nUtil.registerResource("org/gocom/bps/wfclient/i18n/i18n_zh_CN.properties");
		I18nUtil.registerResource("org/gocom/bps/wfclient/i18n/i18n_en_US.properties");			
	}
}
