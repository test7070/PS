<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
            $(document).ready(function() {
                _q_boxClose();
                q_getId();
                q_gf('', 'z_orde2ordc_gu');

            });

            function q_gfPost() {
                $('#q_report').q_report({
                    fileName : 'z_orde2ordc_gu',
                    options : [{
                        type : '0',
                        name : 'accy',
                        value : q_getId()[4] //[1]
                    }, {
                        type : '6', //[2]
                        name : 'xnoa'
                    }, {
                        type : '5', //[3]
                        name : 'xmount',
                        value : ("0@毛需求,1@淨需求量").split(',')
                    }]
                });
                q_popAssign();
                q_getFormat();
                q_langShow();

                var btn = document.getElementById('btnOk');
                btn.insertAdjacentHTML("afterEnd", "<input type='button' id='btnOrde2ordc' style='font-size: 16px; font-weight: bold; color: blue; cursor: pointer;' value='轉採購'>");

                if (window.parent.q_name == 'orde') {
                    var wParent = window.parent.document;
                    $('#txtXnoa').val(wParent.getElementById("txtNoa").value);
                }
                
                $('#btnOrde2ordc').click(function() {
                	if(!emp($('#txtXnoa').val())){
                    	q_gt('view_orde', "where=^^ noa='"+$('#txtXnoa').val()+"' ^^ ", 0, 0, 0, "orde2ordc", r_accy);
                    }else{
		            	alert('請輸入訂單編號!!');
		            }
                });

            }

            function q_boxClose(s2) {
            }

            function q_gtPost(t_name) {
                switch (t_name) {
                    case 'orde2ordc':
                        var as = _q_appendData("view_orde", "", true);
                        if (as[0] != undefined) {
                        	//檢查是否已轉採購或進貨
		                    q_func('qtxt.query.orde_ordc_rc2_gu', 'orde.txt,orde_ordc_rc2_gu,' + encodeURI(r_accy) + ';' + encodeURI($('#txtXnoa').val()));
                        } else {
                            alert('訂單不存在!!');
                        }
                        break;
                }
            }

            function q_funcPost(t_func, result) {
                switch(t_func) {
                	case 'qtxt.query.orde_ordc_rc2_gu':
                		var as = _q_appendData("tmp0", "", true, true);
                		if (as[0] != undefined) {//已產生採購單
                			if(dec(as[0].rc2mount)>0){
                				alert('採購單已進貨禁止重新產生!!');
                			}else{
                				if (confirm("已轉採購單是否重新產生?")) {
                					q_func('qtxt.query.orde2ordc_gu_1', 'orde.txt,orde2ordc_gu,' + encodeURI(r_accy) + ';' + encodeURI($('#txtXnoa').val())+ ';' + encodeURI($('#Xmount select').val())+ ';' + encodeURI(r_name));
                					$('#btnOrde2ordc').val('產生中....').attr('disabled', 'disabled').css('font-weight', '' ).css('color', '');
                				}
                			}
                			
                		}else{//未產生採購單
                			if (confirm("確定要轉採購單?")) {
	                			q_func('qtxt.query.orde2ordc_gu_0', 'orde.txt,orde2ordc_gu,' + encodeURI(r_accy) + ';' + encodeURI($('#txtXnoa').val())+ ';' + encodeURI($('#Xmount select').val())+ ';' + encodeURI(r_name));
	                			$('#btnOrde2ordc').val('產生中....').attr('disabled', 'disabled').css('font-weight', '' ).css('color', '');
	                		}
                		}
                		break;
                    case 'qtxt.query.orde2ordc_gu_0':
                        var as = _q_appendData("tmp0", "", true, true);
                        if (as[0] != undefined) {
                        	if(dec(as[0].counts)>0)
                            	alert('採購單產生成功。');
                            else
                            	alert('採購單產生失敗。');
                        }
                        $('#btnOrde2ordc').val('轉採購').removeAttr('disabled').css('font-weight', 'bold').css('color', 'blue');
                        break;
					case 'qtxt.query.orde2ordc_gu_1':
                        var as = _q_appendData("tmp0", "", true, true);
                        if (as[0] != undefined) {
                            alert('已重新產生採購單!!');
                        }
                        $('#btnOrde2ordc').val('轉採購').removeAttr('disabled').css('font-weight', 'bold').css('color', 'blue');
                        break;
                }
            }
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>