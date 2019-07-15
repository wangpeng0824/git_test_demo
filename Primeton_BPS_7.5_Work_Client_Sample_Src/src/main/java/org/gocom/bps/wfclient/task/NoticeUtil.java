package org.gocom.bps.wfclient.task;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.gocom.bps.wfclient.common.CommonUtil;
import org.gocom.bps.wfclient.common.ServiceFactory;

import com.eos.das.entity.IDASCriteria;
import com.eos.data.datacontext.IUserObject;
import com.eos.workflow.api.BPSServiceClientFactory;
import com.eos.workflow.api.IWFNotificationManager;
import com.eos.workflow.data.WFNotificationInst;
import com.eos.workflow.omservice.IWFOMService;
import com.eos.workflow.omservice.WFParticipant;
import com.primeton.workflow.api.PageCond;
import com.primeton.workflow.api.ParticipantType;
import com.primeton.workflow.api.WFServiceException;
import com.primeton.workflow.commons.utility.StringUtil;

/**
 * 通知业务工具类
 * 
 * @author Administrator
 * 
 */
public class NoticeUtil {

	
	/**
	 * 确认通知
	 * 
	 * @param notificationID
	 * @throws WFServiceException
	 */
	public static void confirmNotification(long notificationID) throws WFServiceException {
		IWFNotificationManager confirmNotificationManager = ServiceFactory
				.getIWFNotificationManager();
		confirmNotificationManager.confirmNotification(notificationID);

	}

	/**
	 * 根据criteria条件查询通知列表
	 * @param criteria
	 * @param pageCond
	 * @return
	 * @throws WFServiceException
	 * @throws ParseException
	 */
	public static List<WFNotificationInst> queryNotificationsCriteria(
			IDASCriteria criteria, PageCond pageCond)
			throws WFServiceException, ParseException {
		IWFNotificationManager queryNotificationsCriteria = ServiceFactory
				.getIWFNotificationManager();
		List<WFNotificationInst> notificationList = queryNotificationsCriteria
				.queryNotificationsCriteria(criteria, null);
        notificationList = stringToDate(notificationList);
        notificationList=myPageCond(notificationList, pageCond);
		return notificationList;
	}
	/**
	 * 将通知的时间格式转换成所需要的格式
	 * @param notificationList
	 * @return
	 * @throws ParseException
	 */
	public static List<WFNotificationInst> stringToDate(List<WFNotificationInst> notificationList) throws ParseException {
		Iterator<WFNotificationInst> it = notificationList.iterator();
		while (it.hasNext()) {
			WFNotificationInst notificationInst = it.next();
			if (notificationInst.getCreateTime() != null) {
				String createTime = CommonUtil.transTime(notificationInst.getCreateTime());
				notificationInst.setCreateTime(createTime);
			}
			if (notificationInst.getConfirmTime() != null) {
				String confirmTime = CommonUtil.transTime(notificationInst.getConfirmTime());
				notificationInst.setConfirmTime(confirmTime);
			}
			if (notificationInst.getRemindTime() != null) {
				String remindTime = CommonUtil.transTime(notificationInst.getRemindTime());
				notificationInst.setRemindTime(remindTime);
			}
			if(notificationInst.getFinalTime()!=null){
				String finalTime=CommonUtil.transTime(notificationInst.getFinalTime());
				notificationInst.setFinalTime(finalTime);
			}
		}

		return notificationList;
	}


	
	
	public static String getParticipantScopeString(HttpServletRequest request){
		StringBuilder sb = new StringBuilder(50);
		HttpSession session=request.getSession();
		String participantID = null;
		if (session!= null) {
			IUserObject userObject = (IUserObject)session.getAttribute(IUserObject.KEY_IN_CONTEXT);
			participantID = userObject.getUserId();			
		}
		if(StringUtil.isNullOrBlank(participantID)){
			return sb.toString();
		}
		try {
			List<WFParticipant> participantList = BPSServiceClientFactory.getDefaultClient().getOMService().
			getParticipantScope(getLeafParticipantType(), participantID);			
			if(null == participantList || participantList.isEmpty()){
				return sb.toString();
			}
			int len = participantList.size();
			int i=0;
			for(;i<len-1;i++){
					sb.append(getGlobalWFParticipantID(participantList.get(i)));
				sb.append(",");
			}
			sb.append(getGlobalWFParticipantID(participantList.get(i)));
		} catch (WFServiceException e) {
			e.printStackTrace();
		}
		return sb.toString();
	}
	
	private static String getGlobalWFParticipantID(WFParticipant participant) throws WFServiceException{
	   IWFOMService omService = BPSServiceClientFactory.getDefaultClient().getOMService();
       return makeGlobalID(omService.getParticipantType(participant.getTypeCode()).getPrefix(),participant.getId());
   }
	private static String getLeafParticipantType() throws WFServiceException {
		String leafType = null;
		ParticipantType pt = null;
		List<ParticipantType> ptl = BPSServiceClientFactory.getDefaultClient().getOMService().getParticipantTypes();
		for (Iterator<ParticipantType> iter = ptl.iterator(); iter.hasNext();) {
			pt = (ParticipantType) iter.next();
			if(pt.isLeafParticipant()){
				leafType = pt.getCode();     
			}
		}	
		return leafType;
	}
	
   private static String makeGlobalID(char prefix,String localID){
       return prefix+"{"+localID+"}";
   }
   
   public static List<WFNotificationInst>  myPageCond(List<WFNotificationInst> list,PageCond pagecond) {
		int count=list.size();
		int length=pagecond.getLength();
		int totalPage=(int)Math.ceil((double)count/length);
		int begin=pagecond.getBegin();
		int currentPage=0;
		if(begin==0){
			currentPage=1;
		}else{
			currentPage=begin/length+1;
		}
		int end=currentPage*length;
		if (end>count)
			end=count;
		List<WFNotificationInst> resultList=new ArrayList<WFNotificationInst>();;
		for(int i=begin;i<end;i++){
			resultList.add(list.get(i));
		}
		if(currentPage==1){
			pagecond.setFirst(true);
			pagecond.setLast(false);
		}else if (currentPage==totalPage){
			pagecond.setFirst(false);
			pagecond.setLast(true);
		}
		pagecond.setCount(count); 
		pagecond.setTotalPage(totalPage);
		pagecond.setCurrentPage(currentPage);
		
		return resultList;
	}
}




	