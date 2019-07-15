package org.gocom.bps.wfclient.process;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.gocom.bps.wfclient.common.ServiceFactory;

import com.eos.workflow.api.IWFProcessInstManager;
import com.eos.workflow.data.WFProcessInst;
import com.eos.workflow.omservice.IWFOMService;
import com.eos.workflow.omservice.WFParticipant;
import com.primeton.bps.component.manager.api.BPSMgrServiceClientFactory;
import com.primeton.workflow.api.WFRuntimeException;
import com.primeton.workflow.api.WFServiceException;
import com.primeton.workflow.commons.logging.LogService;
import com.primeton.workflow.commons.logging.impl.WFTraceLogger;
import com.primeton.workflow.manager.api.AutoFormFieldTagBean;
import commonj.sdo.DataObject;

public class ProcessStart {
	
	private WFTraceLogger logger = WFTraceLogger.getWFTraceLogger(ProcessStart.class);
	
	public void createAndStartProcInst(WFProcessInst processInst ,DataObject dataObject){
		
		@SuppressWarnings("unused")
		int result = 0;
		try {			
			List<AutoFormFieldTagBean> formFields = BPSMgrServiceClientFactory.getDefaultClient().getBPSWSManager().getProcessFormfields(
					processInst.getProcessDefID(), null, null, null, false);	
			Map<String,Object> map = new HashMap<String, Object>();
			for(AutoFormFieldTagBean formField:formFields){
				String path = formField.getPath();
				String type = formField.getDataType();
				
				String value = dataObject.getString(formField.getPath());
				
				if(type.equals("user")){
					//value需要解析成乡音的数据id,name,typeCode
					if(value == null) continue;
					WFParticipant[] participant=convertToParticipants(value);
					String path1 = path+"/"+"id";
					map.put(path1, participant[0].getId()); 
					
					String path2 = path+"/"+"name";
					map.put(path2, participant[0].getName()); 
					
					String path3 = path+"/"+"typeCode";
					map.put(path3, participant[0].getTypeCode()); 
					
				}else{
					//value 需要解析成path
					if(value == null) continue;
					map.put(path, value); 
				}
			}
			IWFProcessInstManager procInstMgr = ServiceFactory.getWFProcessInstManager();
			procInstMgr.createAndStartProcInstAndSetRelativeData(processInst.getProcessDefName(), processInst.getProcessInstName(), processInst.getProcessInstDesc(), true, map);
			result = 1;
		} catch (Exception e) {
			logger.log(LogService.LEVEL_ERROR,e);  
			result = 0;
			throw new WFRuntimeException(e.getMessage(),e);
		}
	}
	
	private  WFParticipant[] convertToParticipants(
			String value) throws WFServiceException {
		List<WFParticipant> participants = new ArrayList<WFParticipant>();
		if(StringUtils.isEmpty(value)){
			return new WFParticipant[0];
		}
		
		IWFOMService omService = ServiceFactory.getWFOMService();
		String participantArray[] = StringUtils.split(value, ",");
		for(String participantStr : participantArray){
			String[] par = StringUtils.split(participantStr, "|");
			participants.add(omService.findParticipantByID(par[0], par[1]));
		}
		return participants.toArray(new WFParticipant[participants.size()]);
	}

}
