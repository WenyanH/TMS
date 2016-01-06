$(document).ready(function(){
	timerounding.sort();
	
});

var timerounding = {
		sort: function(){
			$("#timerounding-data-table").dataTable({
		        bAutoWidth : true,
		        columnDefs:[{
			    	orderable:false,//禁用排序
			    	targets:[5]   //指定的列
		    	}],
		    	bStateSave : true
		    });


		},

			loadtimerounding: function(){
			PageCtrl.load({
				url : webPath + "/roundingrules/list_nd",
				dom : "timerounding-table",
				param : {
					
				},
				callback : function() {
					timerounding.sort();
				}
			});
		},
		
		create : function() {
			
			$.layer({
                type: 1,
                title : "Create a new rounding rule",
                shadeClose: true,
                area : [ '750px', '390px' ],
                offset : [ '100px', '' ],
                page: {
                	url : webPath + '/roundingrules/create?pjax=true'
                },
                zIndex:2500
            });
			
		},
		
		update : function(id){
			
			$.layer({
                type: 1,
                title : "Modify a rounding rule",
                shadeClose: true,
                area : [ '750px', '390px' ],
                offset : [ '100px', '' ],
                page: {
                	url : webPath + '/roundingrules/update?pjax=true&id=' + id
                },
                zIndex:2500
            });		
			
		},
		
		save : function(){
			if ($("#alertMessage").html()!="")
        		$("#alertMessage").html("")
        		
        	if (!timerounding.validateRulesValue){
        		argusAlertStrip("alertMessage","warning"," Warning: Please check rounding rules.");
        		return false;
        	}
        		
			var id = $("#id").val();
			var code = $("#code").val();
			var name = $("#name").val();
			var active;
			var status = $("#active").attr("checked");
			if (status == "checked") {
				active = true;
			} else {
				active = false;
			}
			var description = $("#description").val();
			
			var rules = timerounding.oTable.fnGetNodes();
			if (rules.length==0){
				argusAlertStrip("alertMessage","warning"," Warning: Please set the 'Rounding Rules'.");
				return false;
			}
			
			var _rules = [];
			
			for(var i = 0; i < rules.length; i++){
				var _rule = {
					orderNumber : i,
					fromTime:$(rules[i]).find('.ruleFrom').val(),
					toT:$(rules[i]).find('.ruleTo').val(),
					value:$(rules[i]).find('.ruleValue').val(),
				}
				_rules.push(_rule);
			}
			
			
			var _result = {
				id : id,
				code : code,
				name : name,
				active : active,
				description : description,
				rules : _rules
			};
			
			Loading.start();
			PageCtrl.ajax({
				url : webPath + "/roundingrules/save",
				data : JSON.stringify(_result),
				dataType: "json",
				type : "post",
				contentType:"application/json",
				success : function(data) {
					Loading.stop();
					if (data.message=="success"){					
						argusAlertStrip("alertMessage","success"," Success");
						if ($("#keepon").length>0){
							timerounding.loadtimerounding();
							
							if ($("#keepon").attr("checked") == "checked"){
								$(":text").val("");
								$("#description").val("");
								timerounding.oTable.fnDeleteRow(rules);
							} else {
								$(".xubox_close").click();
							}
						} else {
							timerounding.loadtimerounding();
							$(".xubox_close").click();
						}
						
					}else if (data.message == "exist"){
						$("#timeroundingForm").closest('.help-inline').removeClass('ok');
						argusAlertStrip("alertMessage","warning"," Warning: Code or name has existed.");
					}else {
						argusAlertStrip("alertMessage","error"," Error");
					}
				}
			});
			
			
			return false;
		},
		remove : function () {
			var ids="";
			$('input[name="id"]:checked').each(function(){
				ids+=$(this).val()+",";
		    });

			argusConfirm("Confirm delete?",function(result){
				if(result){
					Loading.start();
					PageCtrl.ajax({
						url : webPath + "/roundingrules/delete?ids="+ids,
						type : "post",
						dataType: "json",
						success : function(data) {
							timerounding.loadtimerounding();
							Loading.stop();
						}
					});
				}
			});
		},
		initSavePage : function(){

			$('#timeroundingForm').validate({
				doNotHideMessage : true, //this option enables to show the error/success messages on tab switch.
				errorElement : 'span', //default input error message container
				errorClass : 'validate-inline', // default input error message class
				focusInvalid : false, // do not focus the last invalid input
				rules : {
					"code" : {
						required : true,
						minlength: 3
					},
					"name" : {
						required : true,
						minlength: 3
					}
				},


		        errorPlacement: function (error, element) { // render error placement for each input type
		            error.insertAfter(element); // for other inputs, just perform default behavoir
//		            if ($("#alertMessage").html()!="")
//		        		$("#alertMessage").html("")
		        },

		        invalidHandler: function (event, validator) { //display error alert on form submit   
		        	Loading.stop();
		        	
		        },

		        highlight: function (element) { // hightlight error inputs
		            $(element).closest('.help-inline').removeClass('ok'); // display OK icon
		            $(element).closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
		        },

		        unhighlight: function (element) { // revert the change dony by hightlight
		            $(element).closest('.control-group').removeClass('error'); // set error class to the control group
		        },

		        success: function (label) {
		            label.addClass('valid').closest('.control-group').removeClass('error'); // set success class to the control group
		            label.remove();
		            
		        },
		        
		        submitHandler: function(form){  
		        	timerounding.save();
		        },
		        
		        onfocusin: function( element, event ) {
		        	if ($("#alertMessage").html()!="")
		        		$("#alertMessage").html("")
		        }

			});
			
			
			timerounding.oTable = $('#rules_table').dataTable({
				bFilter: false,
				bLengthChange : false,
				bPaginate : false,
				bScrollInfinite : true,
				sScrollY : "154px",
				bInfo : false,
				columnDefs: [
				    {orderable:false,targets:[0,1,2,3,4]},
					{visible: false, targets: 0 }
				],
				order : [[ 0, "asc" ]]
				    
                
            });
			
			
			$('#addrules').click(function (e) {
                e.preventDefault();
                var rows = timerounding.oTable.fnGetNodes();
                if (rows.length>19){
                	argusAlertStrip("alertMessage","warning"," Warning: Rounding rules cannot exceed 20.");
                } else {
                	if (parseInt($(rows[rows.length-1]).find('.ruleTo').val())>=60){
                		argusAlertStrip("alertMessage","warning"," Warning: Rounding rules has reached 60, cannot add more.");
                		return;
                	}
                	var aiNew = timerounding.oTable.fnAddData(["99", "", "", "", ""]);
                    var nRow = timerounding.oTable.fnGetNodes(aiNew[0]);
                    var aData = timerounding.oTable.fnGetData(nRow);
                    var jqTds = $('>td', nRow);
                    
                    if (rows.length == 0){
                    	aData[0] = 0
                    	aData[1] = aData[0]+1;
                    } else {
//                    	console.info($(rows[rows.length-1]).find('.ruleTo'));

                    	aData[0] = parseInt($(rows[rows.length-1]).find('.ruleTo').val()) + 1
                    	aData[1] = aData[0]+1;	
                    }
                    
                    aData[2] = 0;
                    
                    jqTds[0].innerHTML = '<input autocomplete="off" name="ruleFrom" type="text" class="span12 ruleFrom" value="' + aData[0] + '" onkeyup="timerounding.validateRules(this);"  onafterpaste="timerounding.validateRules(this);" maxlength="2">';
                    jqTds[1].innerHTML = '<input autocomplete="off" name="ruleTo" type="text" class="span12 ruleTo" value="' + aData[1] + '" onkeyup="timerounding.validateRules(this);"  onafterpaste="timerounding.validateRules(this);" maxlength="2">';
                    jqTds[2].innerHTML = '<input autocomplete="off" name="ruleValue" type="text" class="span12 ruleValue" value="' + aData[2] + '" onkeyup="timerounding.validateRules(this);"  onafterpaste="timerounding.validateRules(this);" maxlength="2">';
                    jqTds[3].innerHTML = '<button class="removerules" onclick="" type="button"><i class="icon-trash"></i></button>';
                    
                }
                
                $('#rules_table tr td button.removerules').bind('click', function (e) {
                    e.preventDefault();
                    var nRow = $(this).parents('tr')[0];
                    timerounding.oTable.fnDeleteRow(nRow);
                    
                });
                
                
            });
			
			timerounding.bindRemoveRules();
		},
		bindRemoveRules : function(){
			var rows = timerounding.oTable.fnGetNodes();
			for(var i = 0; i < rows.length; i++){
				$(rows[i]).find('.removerules').bind("click", function (e){
					var nRow = $(this).parents('tr')[0];
                    timerounding.oTable.fnDeleteRow(nRow);
				});
				
			}
		},
		validateRules : function(obj){
			var o = $(obj);
			//o.val(obj.value.replace(/\D/g,0));
			if (/\D/g.test(o.val())){
				argusAlertStrip("alertMessage","warning"," Warning: Rounding rules must be a valid number.");
				o.addClass("text-red");
				o.addClass("red-border");
				timerounding.validateRulesValue = false;
				return;
			}else{
				
				if (o.attr("name")=="ruleValue"&&(o.val()>60||o.val()<0)){
					argusAlertStrip("alertMessage","warning"," Warning: Rounding rules \"Value\" must be between 0 and 60.");
					o.addClass("text-red");
					o.addClass("red-border");
					timerounding.validateRulesValue = false;
					return;
				}
				
				if (o.attr("name")=="ruleTo"&&(o.val()>60||o.val()<0)){
					argusAlertStrip("alertMessage","warning"," Warning: Rounding rules \"To\" must be between 0 and 60.");
					o.addClass("text-red");
					o.addClass("red-border");
					timerounding.validateRulesValue = false;
					return;
				}
				
				if (o.attr("name")=="ruleFrom"&&(o.val()>59||o.val()<0)){
					argusAlertStrip("alertMessage","warning"," Warning: Rounding rules \"From\" must be between 0 and 59.");
					o.addClass("text-red");
					o.addClass("red-border");
					timerounding.validateRulesValue = false;
					return;
				}
				
				var ruleFrom = o.parent().parent().find(".ruleFrom");
				var ruleTo = o.parent().parent().find(".ruleTo");
				
				if (parseInt(ruleFrom.val()) >= parseInt(ruleTo.val())){
					argusAlertStrip("alertMessage","warning"," Warning: Rounding rules \"To\" must be greater than \"From\".");
					ruleFrom.addClass("text-red");
					ruleFrom.addClass("red-border");
					ruleTo.addClass("text-red");
					ruleTo.addClass("red-border");
					timerounding.validateRulesValue = false;
					return;
				} else {
					ruleFrom.removeClass("text-red");
					ruleFrom.removeClass("red-border");
					ruleTo.removeClass("text-red");
					ruleTo.removeClass("red-border");
				}
				
				
			}
			
			o.removeClass("text-red");
			o.removeClass("red-border");
			timerounding.validateRulesValue = true;
		},
		validateRulesValue:true,
		oTable:""
		
		
};


