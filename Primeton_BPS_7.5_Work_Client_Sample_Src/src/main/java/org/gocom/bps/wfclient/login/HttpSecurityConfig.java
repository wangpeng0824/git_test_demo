package org.gocom.bps.wfclient.login;

import com.eos.internal.system.IServerTypeAware;
import com.eos.internal.system.ServerTypeAwareManager;
public class HttpSecurityConfig {
public static final HttpSecurityConfig INSTANCE = new HttpSecurityConfig();
	
	private boolean isOpenSecurity = false;
	
	private boolean isAllInHttps = false;
	
	private String host = "";
	
	private String http_port = "";
	
	private String https_port = "";	
	
	
	
	public void setOpenSecurity(boolean isOpenSecurity) {
		this.isOpenSecurity = isOpenSecurity;
	}

	public void setAllInHttps(boolean isAllInHttps) {
		this.isAllInHttps = isAllInHttps;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public void setHttp_port(String http_port) {
		this.http_port = http_port;
	}

	public void setHttps_port(String https_port) {
		this.https_port = https_port;
	}

	/**
	 * 获取服务器类型
	 * @return
	 */
	public String getServerType(){
		IServerTypeAware serverTypeAware = ServerTypeAwareManager.getCurrentServerTypeAware();

		if (serverTypeAware != null) {
			return serverTypeAware.getServerType();
		}
		return null;
	}

	/**
	 * 是否开启安全模式
	 * @return Returns the isUseSecurity.
	 */
	public boolean isOpenSecurity() {
		return isOpenSecurity;
	}

	/**
	 * 是否全部使用安全模式
	 * @return Returns the isAllInHttps.
	 */
	public boolean isAllInHttps() {
		return isAllInHttps;
	}

	/**
	 * 获取主机ip
	 * @return Returns the host.
	 */
	public String getHost() {
		return host;
	}

	/**
	 * 获取http端口
	 * @return Returns the http_port.
	 */
	public String getHttp_port() {
		return http_port;
	}

	
	/**
	 * 获取https端口
	 * @return Returns the https_port.
	 */
	public String getHttps_port() {
		return https_port;
	}

	
}
