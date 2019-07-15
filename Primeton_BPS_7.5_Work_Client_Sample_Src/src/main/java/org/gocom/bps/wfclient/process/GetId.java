/**
 * 
 */
package org.gocom.bps.wfclient.process;

import commonj.sdo.DataObject;

/**
 * @author Aoxq
 * @date 2015-01-04 17:50:08
 *
 */
public class GetId {

	/**
	 * @param workItemList
	 * @return
	 * @author Aoxq
	 */
	public static String getWorkItemId(DataObject[] workItemList) {
		int length=workItemList.length;
		String id="";
		if(length==0) {
			id="0";
		}
		
		for(int i=0;i<length;i++) {
			id=id+workItemList[i].getString("processInstID");
			if(i!=length-1) {
				id=id+",";
			}
		}
		return id;
	}

}
