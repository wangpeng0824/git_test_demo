package org.gocom.bps.wfclient.process;

import com.eos.workflow.api.BPSServiceClientFactory;
import com.eos.workflow.api.IBPSServiceClient;
import com.eos.workflow.api.IWFDefinitionQueryManager;
import com.primeton.bps.component.manager.api.BPSMgrServiceClientFactory;
import com.primeton.bps.component.manager.api.IBPSMgrServiceClient;
import com.primeton.workflow.api.WFServiceException;
import com.primeton.workflow.bizresource.manager.api.IWFBizCatalog4PermManager;
import com.primeton.workflow.manager.api.IBPSWSManager;

public class WSServiceClientFacade {
	
	public static IBPSServiceClient getWSServiceClient() {
		IBPSServiceClient client = null;
        try {
            client = BPSServiceClientFactory.getDefaultClient();
        } catch (WFServiceException e) {
            throw new RuntimeException("Bps MgrClient[" + "default" + "] is not existed!");
        }
        return client;

	}
	
	public static IBPSMgrServiceClient getWSMgrServiceClient() {
		IBPSMgrServiceClient client = null;
        try {
            client = BPSMgrServiceClientFactory.getDefaultClient();
        } catch (WFServiceException e) {
            throw new RuntimeException("Bps MgrClient[" + "default" + "] is not existed!");
        }
        return client;

	}
	
	public static IWFBizCatalog4PermManager getWFBizCatalog4PermManager() {
		return getWSMgrServiceClient().getWFBizCatalog4PermManager();
	}
	
	public static IBPSWSManager getBPSWSManager() {
		return getWSMgrServiceClient().getBPSWSManager();
	}
	
	public static  IWFDefinitionQueryManager getDefinitionQueryManager() {
		return getWSServiceClient().getDefinitionQueryManager();
	}
}
