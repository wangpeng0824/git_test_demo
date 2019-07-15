package org.gocom.bps.wfclient.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.eos.foundation.data.DataObjectUtil;
import com.eos.workflow.omservice.IWFOMService;
import com.eos.workflow.omservice.WFParticipant;
import com.primeton.workflow.api.ParticipantType;
import com.primeton.workflow.api.WFServiceException;
import commonj.sdo.DataObject;
/**
 * @author Aoxq
 * @date 2015-01-08 13:33:24
 * 通用工具类
 */
public class CommonUtil {
	
	
	//查询参与者Name
	public static String getPaticipantName(String typeCode,String id) throws WFServiceException{
		IWFOMService FOMService=ServiceFactory.getWFOMService();
		WFParticipant participant=null;
		if(typeCode==null){
			List<ParticipantType> partType=FOMService.getParticipantTypes();
			for(ParticipantType type:partType ){
				String code=type.getCode();
				try{
					participant=FOMService.findParticipantByID(code, id);
				}catch(Exception e){
					
				}finally{
					if(participant!=null){
						break;
					}
				}
			}
		}else if(typeCode.equals("person")){
			String [] type=new String[2];
			type[0]="person";
			type[1]="emp";
			for(String code:type){
				try{
					participant=FOMService.findParticipantByID(code, id);
				}catch(Exception e){
					
				}finally{
					if(participant!=null){
						break;
					}
				}
			}
		}else{
			participant=FOMService.findParticipantByID(typeCode, id);
		}
		String name=null;
		if(participant!=null){
			name=participant.getName();
		}else{
			name=id;
		}
		
		return name;
	}
	
	//@Review  修改格式化时间的方法
	//格式化时间
	public static String transTime(String time) {
		if(time!=null){
			SimpleDateFormat transTime = new SimpleDateFormat("yyyyMMddHHmmss"); //@Review 1.14
			Date date = null;
			try {
				date = transTime.parse(time);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			transTime.applyPattern("yyyy-MM-dd HH:mm:ss");
			return transTime.format(date);
		}
		return null;
	}
	
	//数据分页
	public static DataObject[] myPageCond(DataObject[] list,DataObject pagecond) {
		int count=list.length;
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
		List resultList=new ArrayList();;
		for(int i=begin;i<end;i++){
			resultList.add(list[i]);
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
		DataObject[] result=DataObjectUtil.convertDataObjects(resultList, "com.eos.workflow.data.WFWorkItem", true);
		return result;
	}
}
