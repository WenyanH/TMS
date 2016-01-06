$(document).ready(function(){
	
	 $(window).scroll(function () {

	        var scrolls = $(this).scrollTop();
	        if (scrolls>260){
	        	$("#toTop").fadeIn("slow");
	        }else{
	        	$("#toTop").fadeOut("slow");
	        }
	 });
	 
	 resizeWindow();
	 window.onresize = resizeWindow;
	 
	 $(".head-menu li").bind("click", function(){
		 $.cookie('headmenuId', null, { path: '/' });
		 var id = $(this).parent().parent().attr("id");
		 $.cookie('headmenuId', id, { expires:60, path: '/' });
	 });
	 
	 var headmenuId = $.cookie('headmenuId');
	 if (headmenuId!=null && headmenuId!="" && $("#"+headmenuId).length>0){
		$("#"+headmenuId).addClass("active");
	 }
});

function resizeWindow(){
	
	var winHeight = document.body.clientHeight - $("#footer").height() -120;
	$("#wrapper").css("min-height",winHeight);
	if ($("#menuContent_global").length>0){
		$("#menuContent_global").hide();	
	}
	
	
}

var loadingpart ={
	show : function(id){
		var img = "<img src=\""+webPath+"/resources/default/images/ajax-loaders/1.gif\" />"
		$("#"+id).html(img);
		$("#"+id).show();
	},
	hide : function(id){
		$("#"+id).html("");
		$("#"+id).hide();
	}
}

function argusAlert(str, callback){
	bootbox.alert(str, "OK", callback)
}

function argusConfirm(str,callback){
	bootbox.confirm(str, "Cancel", "OK", callback);
}

function argusAlertStrip(id,type,msg,detail){
	var icon = "icon-info-sign";
	var alertType = "alert-info";
	var alertstrip;
	if (type == "info"){
		icon = "icon-info-sign";
		alertType = "alert-info";
	} else if (type == "success"){
		icon = "icon-ok-sign";
		alertType = "alert-success";
	} else if (type == "error"){
		icon = "icon-remove-sign";
		alertType = "alert-error";
	} else if (type == "warning"){
		icon = "icon-exclamation-sign";
		alertType = "alert-warning";
	}
	if(typeof(detail) == 'undefined'){
		alertstrip = '<div class="alert '+alertType+'" style="display:none"> <a class="close" data-dismiss="alert" href="#"></a> <i class="'+icon+'"></i> '
						+ msg +'</div>';
	} else {

		alertstrip = '<div class="alert '+alertType+'" style="display:none"> <a class="close" data-dismiss="alert" href="#"></a> <h4><i class="'+icon+'"></i> '+ msg +'</h4>'
		+ detail.replace("\r\n","<br>") +'</div>';
	}
	
	
	$("#"+id).html(alertstrip);
	$("#"+id + " div:eq(0)").fadeIn("slow");

}

//回到页面最顶端
function scrollToTop(el, offeset) {
    pos = el ? el.offset().top : 0;
    jQuery('html,body').animate({
            scrollTop: pos + (offeset ? offeset : 0)
        }, 'slow');
}

var formTool={
		submitForm:function(form,callback,dataType){
			var option =
			{
			 	type:'post',
			 	dataType: dataType||'json',
			 	success:function(data){
			 		if($.isFunction(callback)){
			 			callback(data);
			 		}
			 	},
			 	error:function(response, textStatus, errorThrown){
			 		argusAlertStrip("alertMessage","error"," Error");
			 	},
			 	complete:function(){
			 		parent.Loading.stop();
			 	}
			 }
			formTool.ajaxSubmit(form,option);
	},
	ajaxSubmit:function(form,option){
		form.ajaxSubmit(option);
	}
}

var common = {
		tree : function(option){
			
			
			var setting = {
					async: {
						enable: true,
						url:webPath + "/mydetail/tree?iscompany=true"
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
						beforeClick: beforeClick,
						onClick: onClick
					}
				};
			
			
		},
		initClockIdAndPayId :function(){
			var id = $("#jobNumber").val();
			var clockId = $("#clockId").val();
			var payId = $("#payId").val();

			if(clockId==""){
				$("#clockId").val(id);
				this.isInitClockId = true;
			} else if (this.isInitClockId){
				$("#clockId").val(id);
			} 
			
			if(payId==""){
				$("#payId").val(id);
				this.isInitPayId = true;
			} else if (this.isInitPayId){
				$("#payId").val(id);
			} 
			
			
		},
		isInitClockId : true,
		isInitPayId : true
		
}
