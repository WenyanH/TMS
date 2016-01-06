package com.tms.vo;

import com.tms.entity.Department;

public class ZTreeNode {
    private String id;
	private String pId;
	private String name;
	private boolean open;
	private Integer structure = 5;
	private Boolean chkDisabled = false;
	
	public ZTreeNode(){}
	public ZTreeNode(String id,String pId,String name,int level,boolean open){
		this.id=id;
		this.pId=pId;
		this.name=name;
		this.open=open;
	}
	public ZTreeNode(Department department,String pId,boolean open){
		this.id=department.getId();
		this.pId=pId;
		this.name=department.getDepartmentName();
		this.open=open;
		if (department.getCompanyStructure()!=null)
			this.structure = department.getCompanyStructure().getLevel().ordinal();
		
		if (this.structure!=0) this.chkDisabled = true;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getpId() {
		return pId;
	}
	public void setpId(String pId) {
		this.pId = pId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isOpen() {
		return open;
	}
	public void setOpen(boolean open) {
		this.open = open;
	}
	public Integer getStructure() {
		return structure;
	}
	public void setStructure(Integer structure) {
		this.structure = structure;
	}
	public Boolean getChkDisabled() {
		return chkDisabled;
	}
	public void setChkDisabled(Boolean chkDisabled) {
		this.chkDisabled = chkDisabled;
	}
	
	
}
