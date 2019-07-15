package org.gocom.bps.wfclient.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.primeton.spring.support.DataObjectUtil;
import commonj.sdo.DataObject;
import commonj.sdo.Property;

public class BpsDataObjectUtil {
	
	public static void copyPropertiesToDataObject(Map<String, Object> map, DataObject dataObject){
		if(map == null || dataObject == null){
			return;
		}
		for(String key : map.keySet()){
			dataObject.set(key, map.get(key));
		}
	}
	
	public static void copyDataObjectProperties(DataObject dataObject, Map<String, Object> map){
		if(map == null || dataObject == null){
			return;
		}
		
		@SuppressWarnings("unchecked")
		List<Property> propertyList = dataObject.getInstanceProperties();
		Object value ;
		for(Property prop : propertyList){
			value = dataObject.get(prop);
			if(value instanceof DataObject[] ||value instanceof DataObject){
				continue;
			}
			map.put(prop.getName(), value);
		}
	}
	
	public static DataObject createDataObject(String entityName){
		if(StringUtils.isEmpty(entityName)){
			entityName = DataObject.class.getName();
		}
		return DataObjectUtil.createDataObject(entityName);
	}

	public static void convertDataObjectArrayToList(DataObject[] dataList,
			List<Map<String, Object>> list) {
		if(dataList == null || dataList.length == 0 || list == null){
			return;
		}
		
		Map<String, Object> map = null;
		for(DataObject obj : dataList){
			map = new HashMap<String, Object>();
			copyDataObjectProperties(obj, map);
			list.add(map);
		}
	}
	
}
