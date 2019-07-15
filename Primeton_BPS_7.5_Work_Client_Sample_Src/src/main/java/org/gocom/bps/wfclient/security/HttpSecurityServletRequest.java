package org.gocom.bps.wfclient.security;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.owasp.validator.html.AntiSamy;
import org.owasp.validator.html.CleanResults;

import com.primeton.ext.access.http.processor.MultipartResolver;

public class HttpSecurityServletRequest extends HttpServletRequestWrapper {

	private static Log logger = LogFactory.getLog(HttpSecurityServletRequest.class);

	private AntiSamy antiSamy = null;

	private List<String> regexs = new ArrayList<String>();

	private HttpSecurityServletRequest(HttpServletRequest request, AntiSamy antiSamy) {
		super(request);
		this.antiSamy = antiSamy;
	}

	public HttpSecurityServletRequest(HttpServletRequest request, AntiSamy antiSamy, List<String> regexs) {
		this(request, antiSamy);
		this.regexs = regexs;
	}

	public String[] getParameterValues(String name) {
		String[] originalValues = super.getParameterValues(name);
		if (originalValues == null) {
			return null;
		}
		List<String> newValues = new ArrayList<String>(originalValues.length);
		for (String value : originalValues) {
			newValues.add(filterString(value));
		}
		return newValues.toArray(new String[newValues.size()]);
	}

	public Map<String, String[]> getParameterMap() {
		@SuppressWarnings("unchecked")
		Map<String, String[]> originalMap = super.getParameterMap();
		Map<String, String[]> filteredMap = new ConcurrentHashMap<String, String[]>(originalMap.size());
		for (String name : originalMap.keySet()) {
			filteredMap.put(name, getParameterValues(name));
		}
		return Collections.unmodifiableMap(filteredMap);
	}

	@Override
	public String getParameter(String name) {
		String value = super.getParameter(name);
		return filterString(value);
	}

	@Override
	public String getHeader(String name) {
		String value = super.getHeader(name);
		return filterString(value);
	}

	@Override
	public String getQueryString() {
		String value = super.getQueryString();
		return filterString(value);
	}

	public String filterString(String value) {
		if (StringUtils.isEmpty(value))
			return value;
		String oldValue = value;

		try {
			value = decode(value, MultipartResolver.getEncoding());
		} catch (UnsupportedEncodingException e) {
			logger.debug(e);
			value = oldValue;// 解码出错，不合法；使用原来字符串
		} catch (Throwable t) {
			logger.debug(t);
			value = oldValue;// 解码出错，不合法；使用原来字符串
		}

		try {
			// 增加正则匹配
			value = filterExtralString(value);

			CleanResults cr = this.antiSamy.scan(value);
			if (cr.getNumberOfErrors() > 0) {
				// log
			}
			return cr.getCleanHTML();
		} catch (Exception e) {
			throw new IllegalStateException(e.getMessage(), e);
		}
	}

	private String filterExtralString(String value) {
		for (String regex : regexs) {
			value = value.replaceAll(regex, "");
		}
		return value;
	}

	/**
	 * Decodes a <code>application/x-www-form-urlencoded</code> string using a
	 * specific encoding scheme. The supplied encoding is used to determine what
	 * characters are represented by any consecutive sequences of the form "
	 * <code>%<i>xy</i></code>".
	 * <p>
	 * <em><strong>Note:</strong> The <a href=
	 * "http://www.w3.org/TR/html40/appendix/notes.html#non-ascii-chars">
	 * World Wide Web Consortium Recommendation</a> states that
	 * UTF-8 should be used. Not doing so may introduce
	 * incompatibilites.</em>
	 * 
	 * @param s
	 *            the <code>String</code> to decode
	 * @param enc
	 *            The name of a supported <a
	 *            href="../lang/package-summary.html#charenc">character
	 *            encoding</a>.
	 * @return the newly decoded <code>String</code>
	 * @exception UnsupportedEncodingException
	 *                If character encoding needs to be consulted, but named
	 *                character encoding is not supported
	 * @see URLEncoder#encode(java.lang.String, java.lang.String)
	 * @since 1.4
	 */
	protected static String decode(String s, String enc) throws UnsupportedEncodingException, IllegalArgumentException {

		boolean needToChange = false;
		int numChars = s.length();
		StringBuffer sb = new StringBuffer(numChars > 500 ? numChars / 2 : numChars);
		int i = 0;

		if (enc.length() == 0) {
			throw new UnsupportedEncodingException("URLDecoder: empty string enc parameter");
		}

		char c;
		byte[] bytes = null;
		while (i < numChars) {
			c = s.charAt(i);
			switch (c) {
			/*
			 * do not decoder +
			 * 
			 * case '+': sb.append(' '); i++; needToChange = true; break;
			 */
			case '%':
				/*
				 * Starting with this instance of %, process all consecutive
				 * substrings of the form %xy. Each substring %xy will yield a
				 * byte. Convert all consecutive bytes obtained this way to
				 * whatever character(s) they represent in the provided
				 * encoding.
				 */

				try {

					// (numChars-i)/3 is an upper bound for the number
					// of remaining bytes
					if (bytes == null)
						bytes = new byte[(numChars - i) / 3];
					int pos = 0;

					while (((i + 2) < numChars) && (c == '%')) {
						bytes[pos++] = (byte) Integer.parseInt(s.substring(i + 1, i + 3), 16);
						i += 3;
						if (i < numChars)
							c = s.charAt(i);
					}

					// A trailing, incomplete byte encoding such as
					// "%x" will cause an exception to be thrown

					if ((i < numChars) && (c == '%'))
						throw new IllegalArgumentException("URLDecoder: Incomplete trailing escape (%) pattern");

					sb.append(new String(bytes, 0, pos, enc));
				} catch (NumberFormatException e) {
					throw new IllegalArgumentException("URLDecoder: Illegal hex characters in escape (%) pattern - " + e.getMessage());
				}
				needToChange = true;
				break;
			default:
				sb.append(c);
				i++;
				break;
			}
		}

		return (needToChange ? sb.toString() : s);
	}

}
