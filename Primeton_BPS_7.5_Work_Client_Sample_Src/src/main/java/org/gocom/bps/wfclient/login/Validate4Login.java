
package org.gocom.bps.wfclient.login;


import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.gocom.bps.wfclient.common.ServiceFactory;

import com.eos.access.http.LocaleHelper;
import com.eos.access.http.OnlineUserManager;
import com.eos.data.datacontext.DataContextManager;
import com.eos.data.datacontext.IMUODataContext;
import com.eos.data.datacontext.ISessionMap;
import com.eos.data.datacontext.IUserObject;
import com.eos.data.datacontext.UserObject;
import com.eos.workflow.api.BPSServiceClientFactory;
import com.eos.workflow.omservice.IWFOMService;
import com.eos.workflow.omservice.IWFPermissionService;
import com.eos.workflow.omservice.WFParticipant;
import com.primeton.ext.common.muo.MUODataContextHelper;
import com.primeton.ext.data.datacontext.http.MUODataContext;
import com.primeton.workflow.api.WFServiceException;
import com.primeton.workflow.model.consts.RunTimeConst;

/**
 * 登录校验
 * 
 * @author wanglei (mailto:wanglei@primeton.com)
 */

public class Validate4Login {
	
	@SuppressWarnings("unused")
	public static int validate4Login(String userName, String pwd, String domainID, String language, HttpServletRequest request) throws WFServiceException {
		int result = 0;
		UserObject userObj = (UserObject)getUserObject();
		boolean isNewUserObject = false;
		if (userObj == null) {
			userObj = new UserObject();
			isNewUserObject = true;
		}
		userObj.setUserId(userName);

		userObj.getAttributes().put(RunTimeConst.TENANT_ID, domainID);
		if (isNewUserObject) {
			Map map = new HashMap();
			map.put(IUserObject.KEY_IN_CONTEXT, userObj);
			MUODataContext context = new MUODataContext(map, new String[] { UserObject.KEY_IN_CONTEXT });
			DataContextManager.current().setMUODataContext(context);
		}
		try {
			IWFPermissionService service = BPSServiceClientFactory.getDefaultClient().getWFPermissionService();
			boolean success = service.validate(userObj.getUserId(), pwd, null);
			if (success) {
				success = service.hasPermission(userObj.getUserId(), IWFPermissionService.PERM_BPSCLIENT);
			}			

			if (success) {
				userName = getPaticipantName("person", userName);
				userObj.setUserName(userName);
				OnlineUserManager.login(userObj);
				
				Locale locale = null;
				if ("zh".equals(language)) {
					locale = new Locale("zh", "CN");
				}
				if ("en".equals(language)) {
					locale = new Locale("en", "US");
				}
				HttpSession session = request.getSession(true);
				session.setAttribute(LocaleHelper.LOCALE_ATTRIBUTE_NAME, locale);
				session.setAttribute(IUserObject.KEY_IN_CONTEXT, userObj);
				session.setAttribute("UserName", userObj.getUserName());
				session.setAttribute("UserID", userObj.getUserId());
				ISessionMap sessionMap = DataContextManager.current().getSessionCtx();
				if (sessionMap == null) {
					sessionMap = MUODataContextHelper.getMapContextFactory().getSessionMap();
				}
				sessionMap.put(LocaleHelper.LOCALE_ATTRIBUTE_NAME, locale);
				result = 1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	private static String getPaticipantName(String typeCode, String id) throws WFServiceException {
		IWFOMService FOMService = ServiceFactory.getWFOMService();
		WFParticipant participant = FOMService.findParticipantByID(typeCode, id);
		String name = participant.getName();
		return name;
	}
	
	private static IUserObject getUserObject() {
		IUserObject userObject = null;
		try {
			ISessionMap sessionMap = DataContextManager.current().getSessionCtx();
			if (sessionMap != null) {
				userObject = sessionMap.getUserObject();
			}
			if (userObject == null) {
				IMUODataContext muo = DataContextManager.current().getMUODataContext();
				if (muo != null) {
					userObject = muo.getUserObject();
				}
			}
		} catch (Exception ignore) {
		}
		return userObject;
	}
}

