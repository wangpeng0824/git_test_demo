package org.gocom.bps.wfclient.task;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.eos.data.datacontext.IUserObject;
import com.eos.data.datacontext.UserObject;
import com.eos.foundation.PageCond;
import com.primeton.components.rest.annotation.JSONParam;
import com.primeton.workflow.api.WFServiceException;
import commonj.sdo.DataObject;
@Path("/rest/services/bps/wfclient/task")
@Consumes({MediaType.APPLICATION_JSON, MediaType.APPLICATION_FORM_URLENCODED})//resteasy 能够接受的数据类型
@Produces(MediaType.APPLICATION_JSON)//resteasy 能够支持返回的数据类型
public class TaskService {
	private static Log logger=LogFactory.getLog(TaskService.class);
	@POST
	@Path("/queryTaskList")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public Map<String, Object> queryTaskList(@JSONParam("taskType") String taskType,@JSONParam("permisssion") String permisssion,
			@JSONParam("scope") String scope,@JSONParam("page") PageCond page,@Context HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		page.setIsCount(true);
		HttpSession session=request.getSession();
		UserObject userobj=(UserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
		String id=userobj.getUserId();
		DataObject[] result;
		try {
			result = ServiceUtil.queryTaskList(id, permisssion, scope, page, taskType);
			resultMap.put("tasks", result);
			resultMap.put("total", page.getCount());
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}
	
	@POST
	@Path("/executeWorkItem")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> executeWorkItem(@JSONParam("workItemID") Long workItemID,@JSONParam("submitType") String submitType,
			@JSONParam("processInstID") Long processInstID,@JSONParam("reason") String reason,
			@JSONParam("participants") DataObject[] participants,@JSONParam("workItemFormData") HashMap workItemFormData,
			@Context HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpSession session=request.getSession();
		UserObject userobj=(UserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
		String id=userobj.getUserId();
		try {
			ServiceUtil.executeWorkItem(workItemID, submitType, id, reason, participants, processInstID, workItemFormData);
		} catch (Exception e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		return resultMap;
	}
	

}
