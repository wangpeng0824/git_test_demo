package org.gocom.bps.wfclient.process;

import java.util.ArrayList;
import java.util.List;

import org.gocom.bps.wfclient.common.CommonUtil;
import org.gocom.bps.wfclient.common.ServiceFactory;

import com.eos.foundation.data.DataObjectUtil;
import com.eos.workflow.api.IWFDefinitionQueryManager;
import com.eos.workflow.data.WFProcessDefine;
import com.primeton.bps.data.WFBizCatalog;
import com.primeton.bps.web.control.I18nUtil;
import com.primeton.workflow.api.WFServiceException;

import commonj.sdo.DataObject;

public class BizProcessUtil {

	private enum imgSrc {

		folder("../common/imgs/folder.gif");

		public final String value;

		imgSrc(String value) {
			this.value = value;
		}
	}

	/**
	 * 获取业务流程顶层业务目录
	 * 
	 * @return
	 */
	public static List<WFBizCatalog> getRootCatalog() {
		List<WFBizCatalog> list = new ArrayList<WFBizCatalog>();

		{
			WFBizCatalog catalog = new WFBizCatalog();
			catalog.setPKValue("-1");
			catalog.setCatalogName(I18nUtil.getMessage("bps.wfclient.process.defaultBizCatalog"));// 默认业务目录
			catalog.setCatalogUUID("-1");
			catalog.setIsLeaf("1");
			catalog.setOrderID(1);
			catalog.setSeq("-1.");

			list.add(catalog);
		}

		{
			WFBizCatalog catalog = new WFBizCatalog();
			catalog.setPKValue("1");
			catalog.setCatalogName(I18nUtil.getMessage("bps.wfclient.process.domainBusinessDir"));// 领域业务目录
			catalog.setCatalogUUID("1");
			catalog.setIsLeaf("0");
			catalog.setOrderID(2);
			catalog.setSeq("1.");

			list.add(catalog);
		}

		return list;
	}

	/**
	 * 将业务目录和流程转化为菜单信息
	 * 
	 * @param catalogList
	 * @return
	 */
	public static List<BizCatalog> convertCatalog(
			List<WFBizCatalog> bizCatalogList,
			List<WFProcessDefine> processDefList) {

		List<BizCatalog> catalogs = new ArrayList<BizCatalog>();

		if (bizCatalogList != null) {
			for (WFBizCatalog bizCatalog : bizCatalogList) {

				BizCatalog catalog = new BizCatalog();
				catalog.setCatalogUUID(bizCatalog.getCatalogUUID());
				catalog.setCatalogName(bizCatalog.getCatalogName());
				catalog.setParentCatalogUUID(bizCatalog.getParentCatalogUUID());
				if (bizCatalog.getIsLeaf().equals("0")) {
					catalog.setIsLeaf(false);
					catalog.setExpanded(false);
					catalog.setImg(imgSrc.folder.value);
				}
				if (bizCatalog.getIsLeaf().equals("1")) {
					catalog.setIsLeaf(true);
					catalog.setExpanded(true);
					catalog.setImg(imgSrc.folder.value);
				}
				catalogs.add(catalog);
			}
		}
		return catalogs;
	}

	/**
	 * 将业务目录和流程转化为菜单信息
	 * 
	 * @param catalogList
	 * @return
	 */
	public static DataObject[] getPublishProcWithCatalogId(String catalogUUID,DataObject page) {
		DataObject[] processList = null ;
		try {
			IWFDefinitionQueryManager definitionQueryManager = ServiceFactory.getDefinitionQueryManager();
			processList = definitionQueryManager.queryPublishedProcesses4SDOWithCatalog(catalogUUID, null);
			processList=CommonUtil.myPageCond(processList, page);
		} catch (WFServiceException e) {
			e.printStackTrace();
		}
		return processList;
	}
	
}
