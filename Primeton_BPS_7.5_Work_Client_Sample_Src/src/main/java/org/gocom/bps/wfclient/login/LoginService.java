package org.gocom.bps.wfclient.login;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.primeton.components.rest.annotation.JSONParam;

/**
 * 登录用的rest
 * 
 * @author wuyuhou
 *
 */
@Path("/rest/services/bps/wfclient/login")
@Consumes({MediaType.APPLICATION_JSON, MediaType.APPLICATION_FORM_URLENCODED})//resteasy 能够接受的数据类型
@Produces(MediaType.APPLICATION_JSON)//resteasy 能够支持返回的数据类型
public class LoginService{
	private static Log logger=LogFactory.getLog(LoginService.class);
	
	@POST
	@Path("/login")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public Map<String, Object> login(@JSONParam("userName") String userName,@JSONParam("password") String password,
			@JSONParam("domainID") String domainID,@JSONParam("language") String language,
			@Context HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Integer result;
		try {
			result = Validate4Login.validate4Login(userName, password, domainID, language,request);
			resultMap.put("result", result);
		} catch (Exception e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		return resultMap;
	}

}
