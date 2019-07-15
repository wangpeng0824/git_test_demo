package org.gocom.bps.wfclient.process;

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
import com.eos.foundation.PageCond;
import com.eos.workflow.data.WFProcessDefine;
import com.eos.workflow.data.WFProcessInst;
import com.primeton.bps.data.WFBizCatalog;
import com.primeton.components.rest.annotation.JSONParam;
import com.primeton.workflow.api.WFServiceException;
import com.primeton.workflow.bizresource.manager.api.IWFBizCatalog4PermManager;
import commonj.sdo.DataObject;
@Path("/rest/services/bps/wfclient/process")
@Consumes({MediaType.APPLICATION_JSON, MediaType.APPLICATION_FORM_URLENCODED})//resteasy 能够接受的数据类型
@Produces(MediaType.APPLICATION_JSON)//resteasy 能够支持返回的数据类型
public class ProcessService  {
	private static Log logger=LogFactory.getLog(ProcessService.class);
	@POST
	@Path("/queryMyProcess")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> queryMyProcess(@JSONParam("queryType") String queryType,@JSONParam("page") PageCond page,
			@Context HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		page.setIsCount(true);
		HttpSession session=request.getSession();
		UserObject userobj=(UserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
		String id=userobj.getUserId();
		List list = null;
		try {
			list = MyProcessUtil.queryMyProcess(id, queryType);
			List processList=MyProcessUtil.myPageCond(list, page);
			resultMap.put("processList", processList);
			resultMap.put("total", page.getCount());
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}
	
	@POST
	@Path("/getProcessCatalogs")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> getProcessCatalogs(@JSONParam("myField") WFBizCatalog myField,@Context HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			List<BizCatalog> catalogs=null;
			if(myField.getCatalogUUID()==null){
				List<WFBizCatalog> bizCatalogList=BizProcessUtil.getRootCatalog();
				List<WFProcessDefine> processDefList = null;
				catalogs=BizProcessUtil.convertCatalog(bizCatalogList, processDefList);
			}else{
				IWFBizCatalog4PermManager bizCatalog4PermManager=WSServiceClientFacade.getWFBizCatalog4PermManager();
				HttpSession session=request.getSession();
				UserObject userobj=(UserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
				String id=userobj.getUserId();
				List<WFBizCatalog> catalogSubList=bizCatalog4PermManager.getCatalogSubByUserid(id, "0", myField.getCatalogUUID());
				List<WFProcessDefine> processDefList = null;
				catalogs=BizProcessUtil.convertCatalog(catalogSubList, processDefList);
			}
			resultMap.put("catalogs", catalogs);
		}catch(Exception e){
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}
	
	@POST
	@Path("/queryPublishedProcessWithCatalog")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> queryPublishedProcessWithCatalog(@JSONParam("catalogUUID") String catalogUUID,@JSONParam("page") PageCond page){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			page.setIsCount(true);
			DataObject[] processListWithCatalog=BizProcessUtil.getPublishProcWithCatalogId(catalogUUID, page);
			resultMap.put("processListWithCatalog", processListWithCatalog);
			resultMap.put("total", page.getCount());
		}catch(Exception e){
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}
	
	@POST
	@Path("/createStartProcessInst")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> createStartProcessInst(@JSONParam("procInst") WFProcessInst procInst,@JSONParam("form") DataObject form){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ProcessStart start=new ProcessStart();
		try{
			start.createAndStartProcInst(procInst, form);
		}catch(Exception e){
			resultMap.put("exception", e);
			logger.error(null,e);
		}		
		return resultMap;
	}
}
