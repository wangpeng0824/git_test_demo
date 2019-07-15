package org.gocom.bps.wfclient.agent;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.gocom.bps.wfclient.common.CommonUtil;
import org.gocom.bps.wfclient.common.ServiceFactory;

import com.eos.workflow.api.IWFAgentManager;
import com.eos.workflow.api.IWFDefinitionQueryManager;
import com.eos.workflow.data.WFAgent;
import com.eos.workflow.data.WFAgentItem;
import com.eos.workflow.omservice.IWFOMService;
import com.eos.workflow.omservice.WFParticipant;
import com.primeton.workflow.api.WFServiceException;

import commonj.sdo.DataObject;

/**
 * @author Aoxq
 * @date 2015-01-08 13:33:24
 * 
 */
public class ServiceUtil {

	/**
	 * @throws WFServiceException 
	 * 查询代理信息
	 */
	public static List<WFAgent> queryAgent(String userID, String state)
			throws WFServiceException {
		IWFAgentManager agentManager = ServiceFactory.getWFAgentManager();
		List<WFAgent> agentList = agentManager.queryAgentByAgentFrom(userID);
		SimpleDateFormat timeTrans = new SimpleDateFormat("yyyyMMddHHmmss");
		Long currentTime = Long.parseLong(timeTrans.format(new Date()));
		List<WFAgent> result = new ArrayList<WFAgent>();
		for (WFAgent agent : agentList) {
			String agentTo=agent.getAgentTo();
			String  agentToType=agent.getAgentToType();
			agent.setAgentTo(CommonUtil.getPaticipantName(agentToType, agentTo));
			agent.setAgentFrom(CommonUtil.getPaticipantName("person", agent.getAgentFrom()));
			// @Review 修改比较方法
			long start = Long.parseLong(agent.getStartTime());
			long end = Long.parseLong(agent.getEndTime());
			// @review 字符串比较把字符串放前面
			if ("N".equals(state)) {

				if (start > currentTime || currentTime > end) {
					result.add(agent);
				}
			} else if ("ALL".equals(state)) {
				result.add(agent);
			} else {
				if (currentTime > start && currentTime < end) {
					result.add(agent);
				}
			}
		}
		for (WFAgent agent : result) {
			String startTime = agent.getStartTime();
			String endTime = agent.getEndTime();
			agent.setStartTime(CommonUtil.transTime(startTime));
			agent.setEndTime(CommonUtil.transTime(endTime));
		}
		return result;

	}
	




	/**
	 * @throws WFServiceException 
	 * 添加代理
	 */
	public static void addAgent(String agentFrom, WFParticipant[] agentTo,
			String agentType, Date startTime, Date endTime,
			String[] accessType, DataObject[] process, String agentReason)
			throws WFServiceException {
		//获取代理管理服务
		IWFAgentManager agentManager = ServiceFactory.getWFAgentManager();
		int length = process.length;
		//生成agentItem
		WFAgentItem agentItems[] = new WFAgentItem[length];
		for (int i = 0; i < length; i++) {
			WFAgentItem item = new WFAgentItem();
			item.setItemID(process[i].getString(0));
			item.setItemType(process[i].getString(2));
			agentItems[i] = item;
		}
		//设置agentItem中的accessType
		length = agentItems.length;
		int index = 0;
		for (int i = 0; i < length; i++) {
			if ("PROCESS".equals(agentItems[i].getItemType())) {
				if ("ALL".equals(agentType)) {
					agentItems[i].setAccessType("ALL");
				} else if ("PART".equals(agentType)) {
					agentItems[i].setAccessType(accessType[index]);
					index++;
				}

			}
		}
		//添加流程
		agentManager.createAgent(agentFrom, agentTo, agentType, startTime,
				endTime, agentItems, agentReason);
	}

	/**
	 * @throws WFServiceException 
	 * 删除代理
	 */
	public static int deleteAgent(long[] agentID) throws WFServiceException {
		IWFAgentManager agentManager = ServiceFactory.getWFAgentManager();
		int count = agentManager.deleteAgentBatch(agentID);
		return count;
	}

	/**
	 *  
	 * @throws WFServiceException 
	 * 查询agentItem的详细信息
	 */
	public static ProActInfo[] queryProActInfo(String agentID,
			String agentType, String isModify) throws WFServiceException {
		IWFAgentManager agentManager = ServiceFactory.getWFAgentManager();
		List<WFAgentItem> agentItem = agentManager
				.queryAgentItemsByAgentID(Long.parseLong(agentID));
		IWFDefinitionQueryManager queryManager = ServiceFactory
				.getDefinitionQueryManager();
		if (agentItem != null) {
			int length = agentItem.size();
			ProActInfo[] proActInfo = new ProActInfo[length];
			for (int i = 0; i < length; i++) {
				ProActInfo info = new ProActInfo();
				String type = agentItem.get(i).getItemType();
				String id = agentItem.get(i).getItemID();
				info.setItemID(id);
				info.setItemType(type);
				info.setAccessType(agentItem.get(i).getAccessType());
				proActInfo[i] = info;
			}
			if ("PART".equals(agentType)) {
				for (int i = 0; i < length; i++) {
					String type = proActInfo[i].getItemType();
					String id = proActInfo[i].getItemID();
					String name = "";
					if ("PROCESS".equals(type)) {
						name = queryManager
								.queryProcessByID(Long.parseLong(id))
								.getProcessChName();
						proActInfo[i].setItemName(name);
					} else if ("ACTIVITY".equals(type)) {
						if ("Y".equals(isModify)) {
							int index = id.indexOf("$");
							name = queryManager.getActivity(
									Long.parseLong(id.substring(index + 1)),
									id.substring(0, index)).getName();
							proActInfo[i].setItemName(name);
						} else {
							int index = id.indexOf("$");
							proActInfo[i].setItemID(id.substring(0, index));
							proActInfo[i].setProDefID(id.substring(index + 1));
							name = queryManager
									.getActivity(
											Long.parseLong(proActInfo[i]
													.getProDefID()),
											proActInfo[i].getItemID())
									.getName();
							proActInfo[i].setItemName(name);
						}

					} 
				}
			} else {
				for (int i = 0; i < length; i++) {
					String type = proActInfo[i].getItemType();
					String id = proActInfo[i].getItemID();
					String name = "";
					String fullName="";
					if ("PROCESS".equals(type)) {
						name = queryManager
								.queryProcessByID(Long.parseLong(id))
								.getProcessChName();
						fullName=queryManager
								.queryProcessByID(Long.parseLong(id))
								.getProcessDefName();
						proActInfo[i].setItemName(name);
						proActInfo[i].setProFullName(fullName);;
					}
				}
				return proActInfo;
			}
			return proActInfo;
		}
		ProActInfo[] proActInfo = new ProActInfo[0];
		return proActInfo; //@Review  1.14返回一个空数组
	}

	/**
	 * @return 
	 * @throws WFServiceException 
	 * 
	 */
	public static WFParticipant queryParticipant(String agentID)
			throws WFServiceException {
		IWFAgentManager agentManager = ServiceFactory.getWFAgentManager();
		WFAgent agentDetail = agentManager.queryAgentDetail(Long
				.parseLong(agentID));
		String typeCode = agentDetail.getAgentToType();
		String participantID = agentDetail.getAgentTo();
		IWFOMService om = ServiceFactory.getWFOMService();
		WFParticipant agentTo = om.findParticipantByID(typeCode, participantID);
		return agentTo;
	}

	/**
	 * @throws WFServiceException 
	 * 
	 */
	public static void modifyAgent(String agentID, String agentFromID,
			String[] accessType, WFParticipant agentTo, String agentType,
			Date startTime, Date endTime, DataObject[] process,
			String agentReason) throws WFServiceException {
		IWFAgentManager agentManager = ServiceFactory.getWFAgentManager();
		agentManager.modifyAgent(Long.parseLong(agentID), agentFromID, agentTo,
				startTime, endTime, agentReason);
		int length = process.length;
		int index = 0;
		WFAgentItem agentItems[] = new WFAgentItem[length];
		for (int i = 0; i < length; i++) {
			WFAgentItem item = new WFAgentItem();
			item.setItemID(process[i].getString(0));
			item.setItemType(process[i].getString(2));
			if ("PROCESS".equals(item.getItemType())) {

				if ("ALL".equals(agentType)) {
					item.setAccessType("ALL");
				} else if ("PART".equals(agentType)) {
					item.setAccessType(accessType[index]);
					index = index + 1;
				}
			}
			agentItems[i] = item;
		}
		if(agentItems.length>0){
			agentManager
			.modifyAgentItem(Long.parseLong(agentID), "SET", agentItems);
		}else if(agentItems.length==0){
			agentManager.clearAgentItem(Long.parseLong(agentID));
		}
		
	}

	/**
	 * @return 
	 * @throws WFServiceException 
	 * 
	 */
	public static ProActInfo[] getProActInfo(ProActInfo[] proAct)
			throws WFServiceException {

		int length = proAct.length;
		ProActInfo[] proActInfo = new ProActInfo[length];
		for (int i = 0; i < length; i++) {
			ProActInfo proact = new ProActInfo();
			String type = proAct[i].getItemType();
			if ("PROCESS".equals(type)) {
				proact.setProDefID("");
				proact.setItemID(proAct[i].getItemID());
				proact.setItemName(proAct[i].getItemName());
				proact.setItemType(type);
				proact.setAccessType("ALL");
			} else if ("ACTIVITY".equals(type)) {
				String id = proAct[i].getItemID();
				int index = id.indexOf("$");
				String itemID=id.substring(0, index);
				proact.setItemID(itemID);
				proact.setProDefID(id.substring(index + 1));
				String itemName=proAct[i].getItemName();
				itemName=itemName.replace("("+itemID+")","");
				proact.setItemName(itemName);
				proact.setAccessType("");
				proact.setItemType(type);
			}
			proActInfo[i] = proact;
		}
		return proActInfo;
	}

	/**
	 * @return 
	 * @throws WFServiceException 
	 * 
	 */
	public static List<ProActInfo> contrastProActInfo(ProActInfo[] proAct,
			ProActInfo[] proActInfo) throws WFServiceException {
		int len_db = proAct.length;
		int length = proActInfo.length;
		List<ProActInfo> result = new ArrayList<ProActInfo>(length);
		for (int i = 0; i < len_db; i++) {
			String key_db = proAct[i].getItemID() + proAct[i].getItemType();
			for (int j = 0; j < length; j++) {
				String key = proActInfo[j].getItemID()
						+ proActInfo[j].getItemType();
				if (key.equals(key_db)) {
					proActInfo[j] = proAct[i];
				}
			}

		}
		for (int i = 0; i < length; i++) {
			result.add(proActInfo[i]);
		}
		return result;

	}

	/**
	 * @return 
	 * @throws WFServiceException 
	 * 
	 */
	public static List<WFAgent> queryMyAgent(String agentTo, String state)
			throws WFServiceException {
		IWFAgentManager agentManager = ServiceFactory.getWFAgentManager();
		List<WFAgent> agentList = agentManager.queryAgentByAgentTo(agentTo,
				true);
		DateFormat timeTrans = new SimpleDateFormat("yyyyMMddHHmmss");
		Long currentTime = Long.parseLong(timeTrans.format(new Date()));
		List<WFAgent> result = new ArrayList<WFAgent>();
		for (WFAgent agent : agentList) {
			String name=agent.getAgentTo();
			String  type=agent.getAgentToType();
			agent.setAgentTo(CommonUtil.getPaticipantName(type,name));
			name=agent.getAgentFrom();
			agent.setAgentFrom(CommonUtil.getPaticipantName("person", name));
			// @Review 修改比较方法
			long start = Long.parseLong(agent.getStartTime());
			long end = Long.parseLong(agent.getEndTime());
			// @review 字符串比较把字符串放前面
			if ("N".equals(state)) {
				if (start > currentTime || currentTime > end) {
					result.add(agent);
				}
			} else if ("ALL".equals(state)) {
				result.add(agent);
			} else {
				if (currentTime > start && currentTime < end) {
					result.add(agent);
				}
			}
		}
		for (WFAgent agent : result) {
			String startTime = agent.getStartTime();
			String endTime = agent.getEndTime();
			agent.setStartTime(CommonUtil.transTime(startTime));
			agent.setEndTime(CommonUtil.transTime(endTime));
		}
		return result;
	}

}
