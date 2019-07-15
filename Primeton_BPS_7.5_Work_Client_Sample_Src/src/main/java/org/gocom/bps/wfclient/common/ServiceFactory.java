/**
 * 
 */
package org.gocom.bps.wfclient.common;

import com.eos.workflow.api.BPSServiceClientFactory;
import com.eos.workflow.api.IWFAgentManager;
import com.eos.workflow.api.IWFAppointActivityManager;
import com.eos.workflow.api.IWFDefinitionQueryManager;
import com.eos.workflow.api.IWFDelegateManager;
import com.eos.workflow.api.IWFFreeFlowManager;
import com.eos.workflow.api.IWFNotificationManager;
import com.eos.workflow.api.IWFProcessInstManager;
import com.eos.workflow.api.IWFProcessLogManager;
import com.eos.workflow.api.IWFRelativeDataManager;
import com.eos.workflow.api.IWFSecurityManager;
import com.eos.workflow.api.IWFWorkItemManager;
import com.eos.workflow.api.IWFWorklistQueryManager;
import com.eos.workflow.omservice.IWFOMService;
import com.primeton.workflow.api.WFServiceException;


/**
 * 服务获取工厂
 * 
 * @author Administrator
 *
 */
public class ServiceFactory {
	
	/**
	 * 取得工作项查询服务
	 * 
	 * @return 工作项查询服务
	 * @throws WFServiceException 
	 */
	public static IWFWorklistQueryManager getWFWorklistQueryManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getWorklistQueryManager();
	}

	/**
	 * 取得工作项管理服务
	 * 
	 * @return 工作项管理服务
	 * @throws WFServiceException 
	 */
	public static IWFWorkItemManager getWFWorkItemManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getWorkItemManager();
	}
	
	/**
	 * 取得工作流安全权限管理服务
	 * 
	 * @return 工作流安全权限管理服务
	 * @throws WFServiceException 
	 */
	public static IWFSecurityManager getWFSecurityManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getSecurityManager();
	}
	
	/**
	 * 取得自由流相关操作服务
	 * 
	 * @return 自由流相关操作服务
	 * @throws WFServiceException 
	 */
	public static IWFFreeFlowManager getWFFreeFlowManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getFreeFlowManager();
	}
	
	/**
	 * 取得指派活动及参与者管理服务
	 * 
	 * @return 指派活动及参与者管理服务
	 * @throws WFServiceException 
	 */
	public static IWFAppointActivityManager getWFAppointActivityManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getAppointActivityManager();
	}
	
	/**
	 * 取得工作流相关数据管理服务
	 * 
	 * @return 工作流相关数据管理服务
	 * @throws WFServiceException 
	 */
	public static IWFRelativeDataManager getWFRelativeDataManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getRelativeDataManager();
	}
	
	/**
	 * 取得工作项代办管理服务
	 * 
	 * @return 工作项代办管理服务
	 * @throws WFServiceException 
	 */
	public static IWFDelegateManager getWFDelegateManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getDelegateManager();
	}
	
	/**
	 * 取得工作流实例相关的日志管理服务
	 * 
	 * @return 工作流实例相关的日志管理服务
	 * @throws WFServiceException 
	 */
	public static IWFProcessLogManager getWFProcessLogManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getProcessLogManager();
	}
	
	
	
	/**
	 * 取得代理管理服务
	 * 
	 * @return 代理管理服务
	 * @throws WFServiceException 
	 */
	public static IWFAgentManager getWFAgentManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getAgentManager();
	}
	
	public static IWFNotificationManager getIWFNotificationManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getNotificationManager();
	}
	
	/**
	 * 取得流程结构查询器
	 * 
	 * @return 流程结构查询器
	 * @throws WFServiceException 
	 */
	public static IWFDefinitionQueryManager  getDefinitionQueryManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getDefinitionQueryManager();
	}
	
	/**
	 * 取得组织机构服务
	 * 
	 * @return 组织机构服务
	 * @throws WFServiceException 
	 */
	public static IWFOMService   getWFOMService() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getOMService();
	}
	
	/**
	 * 获取流程实例管理器接口
	 * 
	 * @return 流程实例管理器接口
	 * @throws WFServiceException 
	 */
	public static IWFProcessInstManager getWFProcessInstManager() throws WFServiceException {
		return BPSServiceClientFactory.getDefaultClient().getProcessInstManager();
	}
	
}
