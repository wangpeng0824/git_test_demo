package org.gocom.bps.wfclient.task;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.gocom.bps.wfclient.common.CommonUtil;
import org.gocom.bps.wfclient.common.ServiceFactory;

import com.eos.foundation.data.DataObjectUtil;
import com.eos.workflow.api.IWFAppointActivityManager;
import com.eos.workflow.api.IWFFreeFlowManager;
import com.eos.workflow.api.IWFRelativeDataManager;
import com.eos.workflow.api.IWFSecurityManager;
import com.eos.workflow.api.IWFWorkItemManager;
import com.eos.workflow.api.IWFWorklistQueryManager;
import com.primeton.workflow.api.WFReasonableException;
import com.primeton.workflow.api.WFServiceException;

import commonj.sdo.DataObject;

/**
 * 服务调用工具类
 * 
 * @author Administrator
 *
 */
public class ServiceUtil {
	
	public static DataObject[] queryTaskList(String personID, String permission, String scope, DataObject pagecond, String taskType) throws WFServiceException {
		IWFWorklistQueryManager queryManager = ServiceFactory.getWFWorklistQueryManager();
		if ("self".equals(taskType)) {
			DataObject[] taskList = queryManager.queryPersonWorkItems4SDO(personID, permission, scope, null);
			if (taskList != null) {
				IWFSecurityManager secruityManager = ServiceFactory.getWFSecurityManager();
				IWFFreeFlowManager freeflowManager = ServiceFactory.getWFFreeFlowManager();
				IWFAppointActivityManager applintActivityManager = ServiceFactory.getWFAppointActivityManager();
				for (DataObject task : taskList) {
					long workItemID = task.getLong("workItemID");
					task.set("currentParticipant", personID);
					//验证已登陆人员是否具有工作项操作的权限
					task.set("hasAccessWorkItemPermission", secruityManager.hasAccessWorkItemPermission(workItemID));
					//是否是自由流
					task.set("isFreeActivity", freeflowManager.isFreeActivity(workItemID));
					//是否需要指派后继活动参与者
					task.set("isNeedAppointNextActivityParticipant", applintActivityManager.isNeedAppointNextActivityParticipant(workItemID));
				}
			}
			taskList=CommonUtil.myPageCond(taskList, pagecond);
			return taskList;
		} else if ("finishedSelf".equals(taskType)) {
			DataObject[] taskList = queryManager.queryPersonFinishedWorkItems4SDO(personID, scope, false, null);
			taskList=CommonUtil.myPageCond(taskList, pagecond);
			return taskList;
		} else if ("entrust".equals(taskType)) {
			DataObject[] taskList = queryManager.queryPersonEntrustWorkItems4SDO(personID, scope, null);
			taskList=CommonUtil.myPageCond(taskList, pagecond);
			return taskList;
		} else if ("finishedEntrust".equals(taskType)) {
			DataObject[] taskList = queryManager.queryPersonEntrustFinishedWorkItems4SDO(personID, scope, false, null);	
			taskList=CommonUtil.myPageCond(taskList, pagecond);
			return taskList;
		} else {
			return new DataObject[0];
		}		
	}
	
	public static void executeWorkItem(long workItemID, String submitType, 
			String personID, String reason, DataObject[] participants, long processInstID, Map<String, Object> workItemFormData) throws WFServiceException, WFReasonableException {
		if ("get".equals(submitType)) {//领取
			ServiceFactory.getWFWorkItemManager().assignWorkItemToSelf(workItemID);
		} else if ("cancelGet".equals(submitType)) {//取消领取
			ServiceFactory.getWFWorkItemManager().withdrawWorkItem(workItemID);
		} else if ("delegate".equals(submitType)) {
			ServiceFactory.getWFDelegateManager().delegateWorkItem4SDO(workItemID, participants, "DELEG");
			ServiceFactory.getWFProcessLogManager().addProcessLog4SDO(workItemID, "代办", personID, reason, null);
		} else if ("help".equals(submitType)) {
			ServiceFactory.getWFDelegateManager().delegateWorkItem4SDO(workItemID, participants, "HELP");
			ServiceFactory.getWFProcessLogManager().addProcessLog4SDO(workItemID, "协办", personID, reason, null);
		} else if ("redo".equals(submitType)) {
			ServiceFactory.getWFDelegateManager().redoDelegatedWorkItem(workItemID);
			ServiceFactory.getWFProcessLogManager().addProcessLog4SDO(workItemID, "重做", personID, reason, null);
		} else if ("reject".equals(submitType)) {
			ServiceFactory.getWFDelegateManager().rejectDelegatedWorkItem(workItemID);
			ServiceFactory.getWFProcessLogManager().addProcessLog4SDO(workItemID, "拒绝", personID, reason, null);
		} else if ("withdraw".equals(submitType)) {
			ServiceFactory.getWFDelegateManager().withdrawDelegatedWorkItem(workItemID);
			ServiceFactory.getWFProcessLogManager().addProcessLog4SDO(workItemID, "收回", personID, reason, null);
		} else {
			if ("save".equals(submitType)) {
				//保存工作项
				if (workItemFormData != null && workItemFormData.size() > 0) {
					IWFRelativeDataManager relativeDataManager = ServiceFactory.getWFRelativeDataManager();
					relativeDataManager.setRelativeDataBatch(processInstID, workItemFormData);
				}
			} else {
				IWFWorkItemManager workItemManager = ServiceFactory.getWFWorkItemManager();
	
				//如果自动表单不为空：保存相关数据，完成工作项
				if (workItemFormData != null && workItemFormData.size() > 0) {
					workItemManager.finishWorkItemWithRelativeData(workItemID, workItemFormData, false);				
				} else { // 完成工作项
					workItemManager.finishWorkItem(workItemID, false);
				}
			}
		}
	}
	
	

}
