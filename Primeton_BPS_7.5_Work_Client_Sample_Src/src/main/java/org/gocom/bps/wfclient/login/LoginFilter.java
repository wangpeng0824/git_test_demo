package org.gocom.bps.wfclient.login;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.gocom.bps.wfclient.BpsClientListener;

import com.eos.access.http.LocaleHelper;
import com.eos.data.datacontext.DataContextManager;
import com.eos.data.datacontext.IUserObject;
import com.eos.data.datacontext.UserObject;
import com.eos.workflow.helper.BPSDataFactory;
import com.primeton.ext.data.datacontext.http.MUODataContext;
import com.primeton.ext.data.sdo.helper.ExtendedXSDHelper;

/**
 * 登录拦截器（独立流程客户端用）
 * 
 * @author wuyuhou
 *
 */
public class LoginFilter implements Filter {

	public void init(FilterConfig arg0) throws ServletException {
		BPSDataFactory.createSDOPageCond();
		
		loadXSD("META-INF/das/Criteria.xsd");
		loadXSD("META-INF/das/AnyType.xsd");
		loadXSD("META-INF/das/Unique.xsd");
		loadXSD("META-INF/das/Dict.xsd");
		loadXSD("META-INF/das/AccessClient.xsd");
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		//设置UTF-8编码
		request.setCharacterEncoding("UTF-8");
		
		HttpServletRequest httpServletRequest = (HttpServletRequest) request;
		HttpServletResponse httpServletResponse = (HttpServletResponse) response;
		HttpSession session = httpServletRequest.getSession(false);		
		
		//没有登录
		if (!UserManager.isLogin(session)) {
			String currentURL = httpServletRequest.getRequestURI();	
			String loginURL ="/bps/wfclient/login/login.jsp";
			
			//登录页面不需要过滤
			if (!(currentURL.endsWith(loginURL) 
					||currentURL.endsWith("/rest/services/bps/wfclient/login/login")
					||currentURL.endsWith("/bps/wfclient/login/validate4Login.jsp")
					|| currentURL.endsWith("/index.jsp") 
					|| currentURL.toLowerCase().endsWith(".js") 
					|| currentURL.toLowerCase().endsWith(".css") 
					|| currentURL.toLowerCase().endsWith(".png") 
					|| currentURL.toLowerCase().endsWith(".bmp") 
					|| currentURL.toLowerCase().endsWith(".gif") 
					|| currentURL.toLowerCase().endsWith(".jpg"))) {
				
				// 如果不是登录页面，则都要从session中取出用户信息，如果取不到，则表示该用户没有登陆，需要从登陆页面
				httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + loginURL);
				return;
			}
		} else {			
			//用户信息设定
			UserObject user = (UserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
			Map map = new HashMap();
			map.put(IUserObject.KEY_IN_CONTEXT, user);
			MUODataContext context = new MUODataContext(map,new String[] { UserObject.KEY_IN_CONTEXT });
			DataContextManager.current().setMUODataContext(context);
			Locale locale = (Locale)session.getAttribute(LocaleHelper.LOCALE_ATTRIBUTE_NAME);
			if (locale != null) {
				DataContextManager.current().setCurrentLocale(locale);
			}				
		}
		chain.doFilter(request, response);

	}
	
	private static void loadXSD(String xsdPath) {
		InputStream in = null;
		try {
			in = LoginFilter.class.getClassLoader().getResourceAsStream(xsdPath);
			if (in == null) {
				throw new FileNotFoundException(xsdPath);
			}
			ExtendedXSDHelper.eINSTANCE.define(in, null);
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (Throwable ignore) {
					
				}
			}
		}
	}

	public void destroy() {

	}

}
