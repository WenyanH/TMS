<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="webpath" uri="/WEB-INF/tlds/path.tld"%>

<head>
	<style>
		.file-input-name{
			position: inherit;
		}
	</style>
	<script type="text/javascript">

		var export_setting = {
			async: {
				enable: true,
				url:webPath + "/mydetail/tree?iscompany=false"
			},
			check: {
				enable: true,
				chkboxType: { "Y" : "s", "N" : "s" }
			},
			view: {
				showIcon: false
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			callback: {
				beforeClick: function(treeId, treeNode){
					var zTree = $.fn.zTree.getZTreeObj("exportTree");
					zTree.checkNode(treeNode, !treeNode.checked, null, true);
					return false;
				},
				onCheck: function(e, treeId, treeNode) {
					var zTree = $.fn.zTree.getZTreeObj("exportTree"),
					nodes = zTree.getCheckedNodes(true),
					v = "";
					for (var i=0, l=nodes.length; i<l; i++) {
						v += nodes[i].id + ",";
						$("#exportDevision").val((i+1)+ " selected");
					}
					if (v.length > 0 ) v = v.substring(0, v.length-1);
					
					 $("#exportDevisionValue").val(v);
					 if (v==""){
						 $("#exportDevision").val("");
					 }
				}
			}
		};
		var management_setting = {
				async: {
					enable: true,
					url:webPath + "/mydetail/tree?iscompany=false"
				},
				check: {
					enable: true,
					chkboxType: { "Y" : "s", "N" : "s" }
				},
				view: {
					showIcon: false
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				callback: {
					beforeClick: function(treeId, treeNode) {
						var zTree = $.fn.zTree.getZTreeObj("managementTree");
						zTree.checkNode(treeNode, !treeNode.checked, null, true);
						return false;
					},
					onCheck: function(e, treeId, treeNode) {
						var zTree = $.fn.zTree.getZTreeObj("managementTree"),
						nodes = zTree.getCheckedNodes(true),
						v = "";
						for (var i=0, l=nodes.length; i<l; i++) {
							v += nodes[i].id + ",";
							$("#managementName").val((i+1)+ " selected");
						}
						if (v.length > 0 ) v = v.substring(0, v.length-1);
						 $("#departments").val(v);
						 if (v==""){
							 $("#managementName").val("");
						 }
					}
				}
			};

		var department_setting = {
				async: {
					enable: true,
					url:webPath + "/mydetail/tree?iscompany=false"
				},
				view: {
					dblClickExpand: false,
					showIcon: false
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				callback: {
					onClick: function(e, treeId, treeNode) {
							if (treeNode.structure!=0){
								return false;
							}
							var zTree = $.fn.zTree.getZTreeObj("departmentTree"),
							nodes = zTree.getSelectedNodes(),
							n = "",
							v = "";
							for (var i=0, l=nodes.length; i<l; i++) {
								if(nodes[i].structure!='0'){
									argusAlertStrip("alertMessage","warning"," Warning: Only allows the selection of leaf nodest!");
									break;
								}
								n += nodes[i].name;
								v += nodes[i].id;
							}
							var departmentValue = $("#departmentValue");
							departmentValue.val(n);
							$("#departmentId").val(v);
							if (treeNode.pId == null){
								$("#departmentId").val("");
							}
							hideMenu();
					}
				}
			};
		
		function showExportTree() {
			var cityObj = $("#exportDevision");
			var cityOffset = $("#exportDevision").offset();
			$("#exportTreeContent").css({"z-index":"9999", left:cityOffset.left + "px", top:cityOffset.top + cityObj.outerHeight()-106 + "px"});
			$("#exportTree").width($("#exportDevision").width()-2);
			$("#exportTreeContent").show();
			$("body").bind("mousedown", onBodyDown);
		}
		
		function showDepartmentTree() {
			var cityObj = $("#departmentValue");
			var cityOffset = $("#departmentValue").offset();
			
			$("#departmentTreeContent").css({left:cityOffset.left + "px", top:cityOffset.top-358 + "px"});
			$("#departmentTree").width($("#departmentValue").width()-2);
			$("#departmentTreeContent").show();
			$("body").bind("mousedown", onBodyDown);
		}
		function showManagementTree() {
			var cityObj = $("#managementName");
			var cityOffset = $("#managementName").offset();
			
			$("#managementTreeContent").css({"z-index":"9999", left:cityOffset.left + "px", top:cityOffset.top + cityObj.outerHeight()-106 + "px"});
			$("#managementTree").width($("#managementName").width()-2);
			$("#managementTreeContent").show();
			$("body").bind("mousedown", onBodyDown);
		}
		function hideMenu() {
			$("#departmentTreeContent").fadeOut("fast");
			$("#managementTreeContent").fadeOut("fast");
			$("#exportTreeContent").fadeOut("fast");
			$("body").unbind("mousedown", onBodyDown);
		}
		function onBodyDown(event) {
			if (!(event.target.id == "menuBtn" || event.target.id == "departmentValue" || event.target.id == "departmentTreeContent" || $(event.target).parents("#departmentTreeContent").length>0
					||event.target.id == "managementName" || event.target.id == "managementTreeContent" || $(event.target).parents("#managementTreeContent").length>0
					||event.target.id == "exportDevision" || event.target.id == "exportTreeContent" || $(event.target).parents("#exportTreeContent").length>0)) {
				hideMenu();
			}
		}
		
		

	
</script>

</head>

<div class='row-fluid'>
	<div class='span12'>
		<div class='page-header'>
			<div class='pull-left title'>
				<span>
				<c:if test="${user.id!=null&&user.id!=''}">
				<fmt:message key="saveuser.info.updateuser" />
				</c:if>
				<c:if test="${user.id==null}">
				<fmt:message key="saveuser.info.createuser" />
				</c:if>
				</span>				
			</div>
			
		</div>
	</div>
</div>


	<form id="userForm" action='#' onsubmit="return false" class="form form-horizontal " enctype="multipart/form-data"  style="margin-bottom: 0;" method="post" accept-charset="UTF-8">
	<input class="span12" name="id" type="hidden" id="id" value="${user.id}"/>
	<div class='row-fluid'  >
			<div id="alertMessage"></div>
			<div class='row-fluid' >	
				<div class="span12 ">
					<div class="portlet box green">
						<div class="portlet-title">
							<div class="caption"><i class="icon-user"></i><fmt:message key="saveuser.info.userinfo" /><!--User Info--></div>
						</div>
						<div class="portlet-body">
							<div class='row-fluid'>
								<div class="span4">
									
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.photo" /><!--Photo:--></label>
										<div class="controls">
											<div class="box-content text-center">
					                        	<div class="row-fluid">
					                        	
						                        	<c:if test="${employee.photo==null||employee.photo==''}">
						                            <img src="<webpath:path/>/resources/default/images/user.png" style="margin-bottom:5px;" id="photo">
						                            </c:if>
						                            <c:if test="${employee.photo!=null&&employee.photo!=''}">
						                            <img src="data:image/png;base64,${employee.photo}" style="margin-bottom:5px;width:150px; height:150px; " id="photo" class="user-photo"/>
						                            </c:if>
					                            </div>
					                            <input title='Upload' type='file' id="fileUpload" name="fileUpload" style="display:none"/>
					                            <p id="upload-button" class="upload-button" style="display:none;left: 60px;">
													<button class="btn" type="button" style="margin-bottom:5px" onclick='$("#icon-upload").show();$("#file-upload-button").show();$("#upload-button").hide();$(".file-input-name").remove();'>
														<fmt:message key="saveuser.info.cancel" /><!--Cancel-->
													</button>
												</p>
					                        </div>
										</div>
									</div>
								
									
									
									
									<div class="control-group">
										<label class="control-label"><fmt:message key="saveuser.info.isemployee" /><!--Is Employee:--></label>
										<div class="controls">
											<div class='switch' data-off-label='<i class="icon-ban-circle"></i>' data-on-label='<i class="icon-ok"></i>' data-on='success' data-off="warning">
					                            <input  type='checkbox' name="isEmployee" id="isEmployee" <c:if test="${user.isEmployee}">checked</c:if> value="${user.isEmployee}"  onchange="user.isEmployee();"/>
					                        </div>
											
											
										</div>
									</div>
										
								</div>
								
								<div class="span4">
									
									<div class="control-group">
										<label class="control-label"><font color="red">*</font><fmt:message key="saveuser.info.email" /><!--Email:--></label>
										<div class="controls">
											<input class="span12" name="email" type="text" id="email" value="${user.email}" placeholder="Email will do for the login name."/>
											
										</div>
									</div>
									
									<c:if test="${user.id==null || user.id==''}">
									<input  type='checkbox' name="changePassword" id="changePassword"  value="" checked="checked" style="display:none"/>
									<div class="control-group">
										<label class="control-label"><font color="red">*</font><fmt:message key="saveuser.info.password" /><!--Password:--></label>
										<div class="controls">
											<input class="span12" name="password" id="password" value="" type="password"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label"><font color="red">*</font><fmt:message key="saveuser.info.confirmpassword" /><!--Confirm Password:--></label>
										<div class="controls">
											<input class="span12"  name="confirm_password"   type="password" id="confirm_password" value="" />
										</div>
									</div>
									</c:if>
									
									<c:if test="${user.id!=null && user.id!=''}">
									
									<div class="control-group">
										<label class="control-label"><fmt:message key="saveemployee.info.changepassword" /><!--Change Password--></label>
										<div class="controls">
											<div class='switch' data-off-label='<i class="icon-ban-circle"></i>' data-on-label='<i class="icon-ok"></i>' data-on='success' data-off="warning">
					                            <input  type='checkbox' name="changePassword" id="changePassword"  value=""  onchange="user.changePassword();"/>
					                        </div>
										</div>
									</div>
									
									<div class="control-group hide pw-div">
										<label class="control-label"><font color="red">*</font><fmt:message key="saveuser.info.password" /><!--Password:--></label>
										<div class="controls">
											<input class="span12" name="password" onfocus="this.type='password';" id="password" value=""/>
										</div>
									</div>
									
									<div class="control-group hide pw-div">
										<label class="control-label"><font color="red">*</font><fmt:message key="saveuser.info.confirmpassword" /><!--Confirm Password:--></label>
										<div class="controls">
											<input class="span12"  name="confirm_password"  onfocus="this.type='password';"  id="confirm_password" value="" />
										</div>
									</div>
									</c:if>
									
									
									<div class="control-group">
										<label class="control-label"><font color="red">*</font><fmt:message key="saveuser.info.firstname" /><!--First Name:--></label>
										<div class="controls">
											<input class="span12" name="firstName" type="text" id="firstName" value="${employee.firstName}"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label"><font color="red">*</font><fmt:message key="saveuser.info.lastname" /><!--Last Name:--></label>
										<div class="controls">
											<input class="span12" name="lastName" type="text" id="lastName" value="${employee.lastName}"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label"><fmt:message key="saveuser.info.middlename" /><!--Middle Name:--></label>
										<div class="controls">
											<input class="span12" name="middleName" type="text" id="middleName" value="${employee.middleName}"/>
										</div>
									</div>
									
									
									
								</div>
								
								<div class="span4">
									<div class="control-group">
										<label class="control-label"><fmt:message key="saveuser.info.exportdivision" /><!--Export Devision:--></label>
										<div class="controls">
											<input id="exportDevision" type="text" class="span12 input_cursor_pointer" readonly value=""  onclick="showExportTree();" />
											<input name="exportDevisions" id="exportDevisionValue" type="hidden"  value="${exportDevisions}" class="span12"  />
										
										</div>
									</div>
									<div class="control-group">
										<label class="control-label"><font color="red">*</font><fmt:message key="saveuser.info.role" /> <!--Role:--></label>
										<div class="controls" id="roleId-controls">
											<select id="roleId" name="roleId"  class="span12" data-placeholder=" " tabindex="1" onchange="user.isSupervisor()">
												<option value=""></option>
												<c:forEach var="role" items="${roleList}">
													<option value="${role.id}" <c:if test="${role.id==roleId}">selected='selected'</c:if>>${role.name}</option>
												</c:forEach>
											</select>
										</div>
									</div>
									<div class="control-group hide" id="managementControlGroup">
										<label class="control-label"><fmt:message key="saveemployee.info.management" /><!--Management:--></label>
										<div class="controls">
											<input name="departments" id="departments" type="hidden"  value="${userDepartments}" class="span12 "  />
											<input id="managementName" id="managementName" type="text" class="span12 input_cursor_pointer" readonly  onclick="showManagementTree();" />
											
										</div>
									</div>
									<div class="control-group hide" id="funControlGroup">
										<label class="control-label"><fmt:message key="saveemployee.info.function" /><!--Function:--></label>
										<div class="controls">
											<select name="funs" id="funs" multiple="multiple" class="" >
												 <c:forEach var="resource" items="${resources}" varStatus="status">
													<option value="${resource.id}" 
														<c:forEach var="userresource" items="${user.resources}">
												 			<c:if test="${userresource.id==resource.id}">selected='selected'</c:if>
														</c:forEach>
													>${resource.content}</option>
												</c:forEach>
											</select>
										</div>
									</div>
									
								</div>
								
							</div>
							
						</div>
					</div>
					
					
					
					<div class="portlet box green hide" id="employeeInfo">
						<div class="portlet-title">
							<div class="caption"><i class="icon-user"></i><fmt:message key="saveuser.info.employeeinfo" /> <!--Employee Info--></div>
						</div>
						<div class="portlet-body">
							<div class='row-fluid'>
								<div class="span4">
									<input name="employeeId"  type="hidden"  value="${employee.id}" class="span12 "  />
									
									
									
									<div class="control-group">
										<label class="control-label"><font color="red">*</font><fmt:message key="saveemployee.info.no" /><!--ID:--></label>
										<div class="controls">
											<input class="span12" onkeyup="common.initClockIdAndPayId()" name="jobNumber" type="text" id="jobNumber"  value="${employee.jobNumber}" maxlength="6"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">
										<font color="red">*</font><fmt:message key="saveemployee.info.hireOnDate" /><!--Hire on:--></label>
										<div class="controls input-append date" id="hireOnDatetime" data-date-format="yyyy-mm-dd" style="display: block;">
											<input class="span10" name="hireOnDateValue" type="text" id="hireOnDateValue" value="<fmt:formatDate value="${employee.hireOnDate}" type="date" pattern="yyyy-MM-dd"/>"/>
										    <span class='add-on' style="cursor: pointer;">
									           <i class='icon-calendar'></i>
									        </span>		
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">
										<font color="red">*</font><fmt:message key="saveemployee.info.terminateDate" /><!--terminateDate-->
										</label>
										<div class="controls input-append date" id="terminateDatetime" data-date-format="yyyy-mm-dd" style="display: block;">
											<input class="span10" name="terminateDateValue" type="text" id="terminateDate" value="<fmt:formatDate value="${employee.terminateDate}" type="date" pattern="yyyy-MM-dd"/>"/>
										    <span class='add-on' style="cursor: pointer;">
									           <i class='icon-calendar'></i>
									        </span>		
										</div>
									</div>
																		
																		
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.isexport" /><!--Is Export:--></label>
										<div class="controls">
										<label class="checkbox inline">
										<input type="checkbox" onchange="user.isExport()" name="isExport" id="isExport" value="true" <c:if test="${employee.isExport||employee.isExport==null}">checked="checked"</c:if>>
										<span><fmt:message key="saveemployee.info.isexport2" /><!--Is Export--></span>
										</label>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">
										<font color="red">*</font>${structureName}:<!--department:--></label>
										<div class="controls box box-nomargin" id="departmentId-controls">
										
											<input name="departmentValue" id="departmentValue" type="text" readonly value="${employeeDepartment.departmentName}" class="span12 input_cursor_pointer" onclick="showDepartmentTree();" />
											<input name="departmentId" id="departmentId" type="hidden"  value="${userDepartments}" class="span12 "  />
											
										</div>	
										
										
									</div>
									
								</div>
								
								<div class="span4">
								
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.name" /><!--Name:--></label>
										<div class="controls">
											<input class="span12" name="name" type="text" id="name" value="${employee.name}"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.title" /><!--First Name:-->
										</label>
										<div class="controls">
											<input class="span12" name="title" type="text" id="title" value="${employee.title}"/>
										</div>
									</div>
									
									
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.mobile" /><!--mobile:-->
										</label>
										<div class="controls">
											<input class="span12" name="mobile" type="text" id="mobile" value="${employee.mobile}"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.phone" /><!--phone--></label>
										<div class="controls">
											<input class="span12" name="phone" type="text" id="phone" value="${employee.phone}"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.fax" /><!--fax:-->
										</label>
										<div class="controls">
											<input class="span12" name="fax" type="text" id="fax" value="${employee.fax}"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.physical" /><!--Physical:--></label>
										<div class="controls">
										<input class="span12" name="physicalAddr" type="text" id="physicalAddr" value="${employee.physicalAddr}"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.postal" /><!--postalAddr-->
										</label>
										<div class="controls">
										<input class="span12" name="postalAddr" type="text" id="postalAddr" value="${employee.postalAddr}"/>	
										</div>
									</div>
								
								</div>
								
								<div class="span4">
									<div class="control-group">
										<label class="control-label">
										<font color="red">*</font><fmt:message key="saveemployee.info.clockId" /><!--clockId:-->
										</label>
										<div class="controls">
											<input class="span12" name="clockId" type="text" id="clockId" value="${employee.clockId}" onkeyup="common.isInitClockId=false;"/>
										</div>
									</div>
									
									<%-- <div class="control-group">
										<label class="control-label">
										<font color="red">*</font><fmt:message key="saveemployee.info.dailyHours" /><!--dailyHours:-->
										</label>
										<div class="controls">
											<input class="span12" name="dailyHoursValue" type="text" id="dailyHours" value="${employee.dailyHours}"/>
										</div>
									</div> --%>
									
									<div class="control-group">
										<label class="control-label">
										<font color="red">*</font><fmt:message key="saveemployee.info.payId" /><!--clockId:-->
										</label>
										<div class="controls">
											<input class="span12" name="payId" type="text" id="payId" value="${employee.payId}" onkeyup="common.isInitPayId=false;"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">
										<font color="red">*</font><fmt:message key="saveemployee.info.paygroup" /><!--paygroup:-->
										</label>
										<div class="controls" id="paygroupId-controls">
											<select id="paygroupId" name="paygroupId" class="span12" data-placeholder=" " tabindex="1">
											<option value=""></option>
											<c:forEach var="paygroup" items="${paygroupList}">
													<option value="${paygroup.id}" <c:if test="${paygroup.id==employee.payGroup.id}">selected='selected'</c:if>>${paygroup.name}</option>
											</c:forEach>
											</select>
										</div>
									</div>
									
									<%-- <div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.position" /><!--position:-->
										</label>
										<div class="controls">
										    <select id="positionId" name="positionId" class="span12" data-placeholder=" " tabindex="1">
											<option value=""></option>
											<c:forEach var="position" items="${positionList}">
													<option value="${position.id}" <c:if test="${position.id==positionId}">selected='selected'</c:if>>${position.name}</option>
											</c:forEach>
											</select>	
										</div>
									</div> --%>
									
									<%-- <div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.jobcode" /><!--jobcode:-->
										</label>
										<div class="controls">
											<select id="jobId" name="jobId" class="span12" data-placeholder=" " tabindex="1">
											<option value=""></option>
											<c:forEach var="job" items="${jobList}">
													<option value="${job.id}" <c:if test="${job.id==jobId}">selected='selected'</c:if>>${job.code}</option>
											</c:forEach>
											</select>
										</div>
									</div> --%>
									
									<div class="control-group">
										<label class="control-label">
										<fmt:message key="saveemployee.info.timeRounding" /><!--Time Rounding:-->
										</label>
										<div class="controls">
										    <select id="timeRoundingId" name="timeRoundingId" class="span12" data-placeholder=" " tabindex="1">
											<option value=""></option>
											<c:forEach var="timeRounding" items="${timeRoundingList}">
													<option value="${timeRounding.id}" <c:if test="${timeRounding.id==employee.timeRounding.id}">selected='selected'</c:if>>${timeRounding.name}</option>
											</c:forEach>
											</select>
										</div>
									</div>
									
								</div>
							</div>
						</div>
					</div>
					
					
				</div>
			</div>
			
				
				
			
			
			

	</div>
	<div class="row-fluid text-center" id="savebutton">
		<c:if test="${user.id==null}">
		<button class="btn btn-warning " type="button" onclick="user.saveAndContinue()">
			<i class="icon-save"></i> Save and continue to create
		</button>
		</c:if>
		<button class="btn btn-warning" type="submit">
			<i class="icon-save"></i> <fmt:message key="global.info.save" /><!--Save-->
		</button>
		
		<button class="btn btn-warning" onclick="user.backList()" type="button">
			<i class="icon-circle-arrow-left "></i>
			Back
		</button>
	</div>	
	
	</form>
	



<div id="departmentTreeContent" class="menuContent hide"   style="position: absolute;z-index: 999;">
	<ul id="departmentTree" class="ztree "  style="margin-top:0;height:240px; width:288px;"></ul>
</div>
<div id="exportTreeContent" class="menuContent "   style="display:none; position: absolute;">
	<ul id="exportTree" class="ztree "  style="margin-top:0; height:240px;width:288px;"></ul>
</div>
<div id="managementTreeContent" class="menuContent "   style="display:none; position: absolute;">
	<ul id="managementTree" class="ztree "  style="margin-top:0;height:240px; width:288px;"></ul>
</div>

<script src="<webpath:path/>/resources/default/js/tms/mydetail/user/user.js" type="text/javascript"></script>


<script>

var export_ztree = $.fn.zTree.init($("#exportTree"), export_setting);
var management_ztree = $.fn.zTree.init($("#managementTree"), management_setting);
var department_ztree = $.fn.zTree.init($("#departmentTree"), department_setting);


$(document).ready(function(){
	
	$(window).scroll(function() {
		var configscrolls = $(this).scrollTop();
		if (configscrolls > (document.body.scrollHeight - document.body.clientHeight - 50)) {
			$("#savebutton").removeClass("savebuttonfixed");
		} else {
			$("#savebutton").addClass("savebuttonfixed");
		}
		
	});

	window.onresize = function() {
		$("#savebutton").width($("#userForm").width()-20);
		resizeWindow();
	}
	
	var exportDevision = $("#exportDevisionValue").val();
	if (exportDevision!=""){
		var ed = exportDevision.split(",");
		for(var i=0; i<ed.length; i++){
			var node = export_ztree.getNodeByParam("id", ed[i], null);
			if(node==null) continue;
			export_ztree.checkNode(node, true, false);
		}
		$("#exportDevision").val(ed.length+ " selected");
	}
	var departments = $("#departments").val();
	if (departments!=""){
		var d = departments.split(",");
		for(var i=0; i<d.length; i++){
			var node = management_ztree.getNodeByParam("id", d[i], null);
			if(node==null) continue;
			management_ztree.checkNode(node, true, false);
		}
		$("#managementName").val(d.length+ " selected");
	}
	user.isEmployee();
	user.isSupervisor();
});
</script>

