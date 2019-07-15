package org.gocom.bps.wfclient.agent;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
import com.eos.workflow.data.WFAgent;
import com.eos.workflow.omservice.WFParticipant;
import com.primeton.components.rest.annotation.JSONParam;
import com.primeton.workflow.api.WFServiceException;
import commonj.sdo.DataObject;
@Path("/rest/services/bps/wfclient/agent")
@Consumes({MediaType.APPLICATION_JSON, MediaType.APPLICATION_FORM_URLENCODED})//resteasy 能够接受的数据类型
@Produces(MediaType.APPLICATION_JSON)//resteasy 能够支持返回的数据类型
public class AgentService  {
	
	private static Log logger=LogFactory.getLog(AgentService.class);
	@POST
	@Path("/queryAgent")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> queryAgent(@JSONParam("state") String state,@Context HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpSession session=request.getSession();
		UserObject userobj=(UserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
		String id=userobj.getUserId();
		List<WFAgent> agentList;
		try {
			agentList = ServiceUtil.queryAgent(id, state);
			resultMap.put("agentList", agentList);
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}
	
	@POST
	@Path("/detailAgent")
	public Map<String, Object> detailAgent(@JSONParam("agentID") String agentID,@JSONParam("agentType") String agentType){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ProActInfo[] processInfo;
		try {
			processInfo = ServiceUtil.queryProActInfo(agentID, agentType, null);
			resultMap.put("processInfo", processInfo);
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}
	
	@POST
	@Path("/deleteAgent")
	public Map<String, Object> deleteAgent(@JSONParam("agentID") long[] agentID) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int count;
		try {
			count = ServiceUtil.deleteAgent(agentID);
			resultMap.put("processInfo", String.valueOf(count));
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}
	
	@POST
	@Path("/modifyAgent")
	public Map<String, Object>  modifyAgent(@JSONParam("agentID") String agentID,@JSONParam("agentReason") String agentReason,
			@JSONParam("agentTo") WFParticipant agentTo,@JSONParam("agentType") String agentType,
			@JSONParam("startTime") Date startTime,@JSONParam("endTime") Date endTime,
			@JSONParam("process") DataObject[] process,@JSONParam("accessType") String[] accessType,
			@Context HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpSession session=request.getSession();
		UserObject userobj=(UserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
		String id=userobj.getUserId();
		try {
			ServiceUtil.modifyAgent(agentID, id, accessType, agentTo, agentType, startTime, endTime, process, agentReason);
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		return resultMap;
		
	}
	
	@POST
	@Path("/addAgent")
	public Map<String, Object>  addAgent(@JSONParam("agentReason") String agentReason,
			@JSONParam("agentTo") WFParticipant[] agentTo,@JSONParam("agentType") String agentType,
			@JSONParam("startTime") Date startTime,@JSONParam("endTime") Date endTime,
			@JSONParam("process") DataObject[] process,@JSONParam("accessType") String[] accessType,
			@Context HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpSession session=request.getSession();
		UserObject userobj=(UserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
		String id=userobj.getUserId();
		try {
			ServiceUtil.addAgent(id, agentTo, agentType, startTime, endTime, accessType, process, agentReason);
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		return resultMap;
	}
	
	@POST
	@Path("/queryAgentInfo")
	public Map<String, Object>  queryFullAgentInfo(@JSONParam("agentID") String agentID,@JSONParam("isModify") String isModify,
			@JSONParam("agentType") String agentType){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ProActInfo[] proActInfo;
		try {
			proActInfo = ServiceUtil.queryProActInfo(agentID, agentType, isModify);
			WFParticipant agentTo=ServiceUtil.queryParticipant(agentID);
			resultMap.put("proActInfo", proActInfo);
			resultMap.put("agentTo", agentTo);
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		return resultMap;
	}
	
	@POST
	@Path("/queryPartAgentInfo")
	public Map<String, Object>  queryPartAgentInfo(@JSONParam("agentID") String agentID,@JSONParam("process") ProActInfo[] process){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ProActInfo[] proAct_db;
		try {
			proAct_db = ServiceUtil.queryProActInfo(agentID, "PART", "");
			ProActInfo[] proAct=ServiceUtil.getProActInfo(process);
			List<ProActInfo> proActInfo=ServiceUtil.contrastProActInfo(proAct_db, proAct);
			resultMap.put("proActInfo", proActInfo);
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}
	
	@POST
	@Path("/getProActInfo")
	public Map<String, Object>  getProActInfo(@JSONParam("process") ProActInfo[] process) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ProActInfo[] proActInfo;
		try {
			proActInfo = ServiceUtil.getProActInfo(process);
			resultMap.put("proActInfo", proActInfo);
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		return resultMap;
	}
	
	@POST
	@Path("/queryMyAgent")
	public Map<String, Object> queryMyAgent(@JSONParam("state") String state,@Context HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpSession session=request.getSession();
		UserObject userobj=(UserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
		String id=userobj.getUserId();
		List<WFAgent> agentList;
		try {
			agentList = ServiceUtil.queryMyAgent(id, state);
			resultMap.put("agentList", agentList);
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}

}
