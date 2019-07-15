package org.gocom.bps.wfclient.security;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.owasp.validator.html.AntiSamy;
import org.owasp.validator.html.Policy;
import org.owasp.validator.html.PolicyException;

import com.primeton.ext.access.http.HttpUrlHelper;

public class HttpSecurityFilter implements Filter {
	private static final String IS_OPEN_SECURITY = "isOpenSecurity";
	private boolean openSecurity;
	private String[] excludeURLs;
	private List<String> regexs;
	private FilterConfig config;
	private static final String ANTISAMY_SECURITY_XML = "/org/gocom/bps/wfclient/security/antisamy-security.xml";
	private static final String COMMON_ERROR_JSP = "/bps/wfclient/login/login.jsp";
	private static final String REFERER_HEAD = "Referer";

	private AntiSamy antiSamy = null;

	public void destroy() {
		this.config = null;
		this.excludeURLs = null;
		this.regexs = null;
		this.antiSamy = null;
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		String requestUrl = HttpUrlHelper.getRequestUrl(httpRequest, null);
		if (openSecurity && (excludeURLs==null||!HttpUrlHelper.isIn(requestUrl, excludeURLs))) {
			String referer = httpRequest.getHeader(REFERER_HEAD);
			if (referer != null) {
				String contextPath = httpRequest.getContextPath();
				if(requestUrl.contains(COMMON_ERROR_JSP)){
					chain.doFilter(httpRequest, response);
					return;
				}
				if (referer.indexOf(contextPath) < 0) {
					((HttpServletResponse) response).sendRedirect(contextPath+COMMON_ERROR_JSP);
					return;
				}
			}
			HttpSecurityServletRequest reqRequest = new HttpSecurityServletRequest(httpRequest, antiSamy, regexs);
			chain.doFilter(reqRequest, response);
			return;
		}
		chain.doFilter(request, response);
	}

	public void init(FilterConfig config) throws ServletException {
		this.config = config;
		this.openSecurity = Boolean.valueOf(this.config.getInitParameter(IS_OPEN_SECURITY));
		String excludeURLsStr = this.config.getInitParameter("Exclude");
		if (excludeURLsStr != null && excludeURLsStr.trim().length() > 0) {
			excludeURLs = excludeURLsStr.split(",");
		}
		String regexsStr = this.config.getInitParameter("regexs");
		if (regexsStr != null&&regexsStr.trim().length()>0) {
			regexs = Arrays.asList(regexsStr.split(","));
			regexs = Collections.unmodifiableList(regexs);
		}
		InputStream stream = null;
		Policy policy = null;
		try {
			stream = HttpSecurityFilter.class.getResourceAsStream(ANTISAMY_SECURITY_XML);
			policy = Policy.getInstance(stream);
			this.antiSamy = new AntiSamy(policy);
		} catch (PolicyException e) {
			e.printStackTrace();
		} finally {
			if (stream != null) {
				try {
					stream.close();
				} catch (IOException e) {
				}
			}
		}
	}

	public boolean getOpenSecurity() {
		return openSecurity;
	}

	public void setOpenSecurity(boolean openSecurity) {
		this.openSecurity = openSecurity;
	}

	public List<String> getRegexs() {
		return regexs;
	}

	public void setRegexs(List<String> regexs) {
		this.regexs = regexs;
	}
	
	
}
