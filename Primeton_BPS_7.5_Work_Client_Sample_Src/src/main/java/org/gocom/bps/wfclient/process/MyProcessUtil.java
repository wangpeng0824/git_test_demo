/**
 * 
 */
package org.gocom.bps.wfclient.process;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.gocom.bps.wfclient.common.CommonUtil;
import org.gocom.bps.wfclient.common.ServiceFactory;

import com.eos.workflow.api.IWFProcessInstManager;
import com.eos.workflow.api.IWFWorklistQueryManager;
import com.eos.workflow.data.WFProcessInst;
import com.primeton.workflow.api.WFServiceException;

import commonj.sdo.DataObject;

/**
 * @author Aoxq
 * @date 2015-01-13 16:33:01
 *
 */
public class MyProcessUtil {

	/**
	 * @author Aoxq
	 * @return 
	 * @throws WFServiceException 
	 * 
	 */
	public static List<WFProcessInst> queryMyProcess(String personID,
			String queryType) throws WFServiceException {
		IWFWorklistQueryManager workManager = ServiceFactory
				.getWFWorklistQueryManager();
		IWFProcessInstManager proInstManager = ServiceFactory
				.getWFProcessInstManager();
		List<WFProcessInst> result = new ArrayList<WFProcessInst>();
//		DataObject[] state = BusinessDictUtil.getCurrentDictInfoByType("WFDICT_ProcessState");
		int stateRun = 2;
		int stateHangUp = 3;
		int stateFinish = 7;
//		int length = state.length;
//		for (int k = 0; k < length; k++) {
//			String name = state[k].getString(1);
//			int id = state[k].getInt(0);
//			if ("运行".equals(name))
//				stateRun = id;
//			else if ("挂起".equals(name))
//				stateHangUp = id; 
//			else if ("完成".equals(name))
//				stateFinish = id;
//		} 
		if ("backlog".equals(queryType)) {
			DataObject[] itemList = workManager.queryPersonWorkItems4SDO(
					personID, "ALL", "ALL", null);
			int itemlen = itemList.length;
			Set<Long> set = new HashSet<Long>();
			for (int i = 0; i < itemlen; i++) {
				DataObject item = itemList[i];
				Long proInstID = item.getLong("processInstID");
				if (set.contains(proInstID))
					continue;
				WFProcessInst proInst = proInstManager
						.queryProcessInstDetail(proInstID);
				proInst.setStartTime(CommonUtil.transTime(proInst.getStartTime()));
				proInst.setCreateTime(CommonUtil.transTime(proInst.getCreateTime()));
				proInst.setFinalTime(CommonUtil.transTime(proInst.getFinalTime()));
				proInst.setRemindTime(CommonUtil.transTime(proInst.getRemindTime()));
				proInst.setCreator(CommonUtil.getPaticipantName("person", proInst.getCreator()));
				result.add(proInst);
				set.add(proInstID);
			}
		} else {
			DataObject[] itemList = workManager
					.queryPersonFinishedWorkItems4SDO(personID, "ALL", true,
							null);
			int itemlen = itemList.length;
			Set<Long> set = new HashSet<Long>();
			for (int i = 0; i < itemlen; i++) {
				DataObject item = itemList[i];
				Long proInstID = item.getLong("processInstID");
				WFProcessInst proInst = proInstManager
						.queryProcessInstDetail(proInstID);
				if (set.contains(proInstID))
					continue;
				proInst.setStartTime(CommonUtil.transTime(proInst.getStartTime()));
				if ("complete".equals(queryType)) {

					if (proInst.getCurrentState() == stateRun
							|| proInst.getCurrentState() == stateHangUp) {
						proInst.setStartTime(CommonUtil.transTime(proInst.getStartTime()));
						proInst.setEndTime(CommonUtil.transTime(proInst.getEndTime()));
						proInst.setCreateTime(CommonUtil.transTime(proInst.getCreateTime()));
						proInst.setFinalTime(CommonUtil.transTime(proInst.getFinalTime()));
						proInst.setRemindTime(CommonUtil.transTime(proInst.getRemindTime()));
						proInst.setCreator(CommonUtil.getPaticipantName("person", proInst.getCreator()));
						result.add(proInst);
						set.add(proInstID);
					}
				} else {
					if (proInst.getCurrentState() == stateFinish) {
						proInst.setStartTime(CommonUtil.transTime(proInst.getStartTime()));
						proInst.setEndTime(CommonUtil.transTime(proInst.getEndTime()));
						proInst.setCreateTime(CommonUtil.transTime(proInst.getCreateTime()));
						proInst.setFinalTime(CommonUtil.transTime(proInst.getFinalTime()));
						proInst.setRemindTime(CommonUtil.transTime(proInst.getRemindTime()));
						proInst.setCreator(CommonUtil.getPaticipantName("person", proInst.getCreator()));
						result.add(proInst);
						set.add(proInstID);
					}
				}
			}
		}

		return result;

	}


	


	/**
	 * @return 
	 * 
	 */
	public static List<WFProcessInst> myPageCond(List<WFProcessInst> list,DataObject pagecond) {
		int count=list.size();
		int length=pagecond.getInt("length");
		int totalPage=(int)Math.ceil((double)count/length);
		int begin=pagecond.getInt("begin");
		int currentPage=0;
		if(begin==0){
			currentPage=1;
		}else{
			currentPage=begin/length+1;
		}
		int end=currentPage*length;
		if (end>count)
			end=count;
		List<WFProcessInst> result=new ArrayList<WFProcessInst>();
		for(int i=begin;i<end;i++){
			result.add(list.get(i));
		}
		if(currentPage==1){
			pagecond.set("isFirst", true);
			pagecond.set("isLast", false);
		}else if (currentPage==totalPage){
			pagecond.set("isFirst",false);
			pagecond.set("isLast", true);
		}
		pagecond.set("count", count);
		pagecond.set("totalPage", totalPage);
		pagecond.set("currentPage", currentPage);
		return result;
	}
	
	
}
