package org.gocom.bps.wfclient.task;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

import com.eos.das.entity.DASManager;
import com.eos.das.entity.ExpressionHelper;
import com.eos.das.entity.IDASCriteria;
import com.primeton.components.rest.annotation.JSONParam;
import com.primeton.workflow.api.PageCond;
import com.primeton.workflow.api.WFServiceException;
import com.primeton.workflow.commons.utility.StringUtil;
import commonj.sdo.DataObject;
@Path("/rest/services/bps/wfclient/notice")
@Consumes({MediaType.APPLICATION_JSON, MediaType.APPLICATION_FORM_URLENCODED})//resteasy 能够接受的数据类型
@Produces(MediaType.APPLICATION_JSON)//resteasy 能够支持返回的数据类型
public class NoticeService{
	private static Log logger=LogFactory.getLog(NoticeService.class);
	@POST
	@Path("/queryNotificationList")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> queryNotificationList(@JSONParam("state") String state,@JSONParam("page") PageCond page,
			@JSONParam("search") String search,@JSONParam("searchData") DataObject searchData,
			@Context HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List notificationList=new ArrayList();
		try{
			String recipientStr=NoticeUtil.getParticipantScopeString(request);
			IDASCriteria criteria = DASManager.createCriteria("com.eos.workflow.data.WFNotificationInst");
			criteria.desc("notificationID");
			page.setIsCount(true);
			if(search==null){
				
				if(StringUtil.isNotNullAndBlank(recipientStr)){
					String[] recipint=recipientStr.split(",");
					criteria.add(ExpressionHelper.in("recipient", recipint));
				}
				if(StringUtil.isNotNullAndBlank(state)){
					criteria.add(ExpressionHelper.eq("state", state));
				}
				if(StringUtil.isNotNullAndBlank((String)searchData.get("timeOutFlag"))){
					criteria.add(ExpressionHelper.eq("timeOutFlag", searchData.get("timeOutFlag")));
				}
				
				notificationList=NoticeUtil.queryNotificationsCriteria(criteria, page);
			}else if(search.equals("search")){
				
				if(StringUtil.isNotNullAndBlank(recipientStr)){
					String[] recipint=recipientStr.split(",");
					criteria.add(ExpressionHelper.in("recipient", recipint));
				}
				if(StringUtil.isNotNullAndBlank(state)){
					criteria.add(ExpressionHelper.eq("state", state));
				}
				if(StringUtil.isNotNullAndBlank((String)searchData.get("notificationID"))){
					criteria.add(ExpressionHelper.eq("notificationID", searchData.get("notificationID")));
				}
				if(StringUtil.isNotNullAndBlank((String)searchData.get("timeOutFlag"))){
					criteria.add(ExpressionHelper.eq("timeOutFlag", searchData.get("timeOutFlag")));
				}
				if(StringUtil.isNotNullAndBlank((String)searchData.get("title"))){
					criteria.add(ExpressionHelper.like("title", "%"+searchData.get("title")+"%"));
				}
				if(StringUtil.isNotNullAndBlank((String)searchData.get("message"))){
					criteria.add(ExpressionHelper.like("message", "%"+searchData.get("message")+"%"));
				}
				notificationList=NoticeUtil.queryNotificationsCriteria(criteria, page);
			}
			resultMap.put("notificationList", notificationList);
			resultMap.put("total", page.getCount());
		}catch(Exception e){
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		
		return resultMap;
	}
	
	@POST
	@Path("/confrimNotification")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> confrimNotification(@JSONParam("notificationID") Long notificationID){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			NoticeUtil.confirmNotification(notificationID);
		} catch (WFServiceException e) {
			resultMap.put("exception", e);
			logger.error(null,e);
		}
		return resultMap;
	}

}
