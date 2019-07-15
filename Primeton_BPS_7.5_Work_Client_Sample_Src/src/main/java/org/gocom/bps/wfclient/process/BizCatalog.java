/**
 * 
 */
package org.gocom.bps.wfclient.process;

import java.io.Serializable;

/**
 * @author wanglei
 * 
 */
public class BizCatalog implements Serializable {

	private static final long serialVersionUID = -4933632164498927955L;

	private String catalogUUID;
	private String catalogName;
	private String parentCatalogUUID;
	private boolean isLeaf;
	private boolean expanded;
	private String img;

	public String getCatalogUUID() {
		return catalogUUID;
	}

	public void setCatalogUUID(String catalogUUID) {
		this.catalogUUID = catalogUUID;
	}

	public String getCatalogName() {
		return catalogName;
	}

	public void setCatalogName(String catalogName) {
		this.catalogName = catalogName;
	}

	public String getParentCatalogUUID() {
		return parentCatalogUUID;
	}

	public void setParentCatalogUUID(String parentCatalogUUID) {
		this.parentCatalogUUID = parentCatalogUUID;
	}

	public boolean getIsLeaf() {
		return isLeaf;
	}

	public void setIsLeaf(boolean isLeaf) {
		this.isLeaf = isLeaf;
	}

	public boolean getExpanded() {
		return expanded;
	}

	public void setExpanded(boolean expanded) {
		this.expanded = expanded;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

}
