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
                
                $('#btnOrda2ordb').click(function() {
                	if(!emp($('#txtXnoa').val()))
                    	q_gt('view_orde', "where=^^ noa='"+$('#txtXnoa').val()+"' ^^ ", 0, 0, 0, "orde2ordc", r_accy);
                });

            }

            function q_boxClose(s2) {
            }

            function q_gtPost(t_name) {
                switch (t_name) {
                    case 'orde2ordc':
                        var as = _q_appendData("view_orde", "", true);
                        if (as[0] != undefined) {
                        	
                            if (confirm("確定要轉採購?")) {
                                var bdate = !emp($('#txtOdate1').val()) ? $('#txtOdate1').val() : '#non';
                                var edate = !emp($('#txtOdate2').val()) ? $('#txtOdate2').val() : '#non';
                                var bworkgno = !emp($('#txtWorkgno1').val()) ? $('#txtWorkgno1').val() : '#non';
                                var eworkgno = !emp($('#txtWorkgno2').val()) ? $('#txtWorkgno2').val() : '#non';
                                var bpno = !emp($('#txtXproductno1a').val()) ? $('#txtXproductno1a').val() : '#non';
                                var epno = !emp($('#txtXproductno2a').val()) ? $('#txtXproductno2a').val() : '#non';
                                var otherworkgall = !emp($('#q_report').data('info').sqlCondition[7].getValue()) ? $('#q_report').data('info').sqlCondition[7].getValue() : '#non';
                                var benddate = !emp($('#txtEnddate1').val()) ? $('#txtEnddate1').val() : '#non';
                                var eenddate = !emp($('#txtEnddate2').val()) ? $('#txtEnddate2').val() : '#non';
                                var ordc = !emp($('#q_report').data('info').sqlCondition[10].getValue()) ? $('#q_report').data('info').sqlCondition[10].getValue() : '#non';
                                var safe = !emp($('#q_report').data('info').sqlCondition[11].getValue()) ? $('#q_report').data('info').sqlCondition[11].getValue() : '#non';
                                var store = !emp($('#q_report').data('info').sqlCondition[12].getValue()) ? $('#q_report').data('info').sqlCondition[12].getValue() : '#non';
                                var workgall = !emp($('#q_report').data('info').sqlCondition[13].getValue()) ? $('#q_report').data('info').sqlCondition[13].getValue() : '#non';

                                var t_where = r_accy + ';' + bdate + ';' + edate + ';' + bworkgno + ';' + eworkgno + ';' + bpno + ';' + epno + ';' + otherworkgall + ';' + benddate + ';' + eenddate + ';' + ordc + ';' + safe + ';' + store + ';' + workgall + ';' + r_userno + ';' + q_getPara('sys.key_orda');
                                var t_para = "r_comp=" + q_getPara('sys.comp') + ",r_accy=" + r_accy + ",r_cno=" + r_cno;
                                //q_gtx("z_orde2ordc_gu4", t_where + ";;" + t_para + ";;z_orde2ordc_gu;;" + q_getMsg('qTitle'));
                                q_func('qtxt.query.ordc', 'orde.txt,ordc_gu,' + t_where);
                            }
                        } else {
                            alert('訂單不存在!!');
                        }
                        break;
                }
            }

            function q_funcPost(t_func, result) {
                switch(t_func) {
                    case 'qtxt.query.ordc':
                        var as = _q_appendData("tmp0", "", true, true);
                        if (as[0] != undefined) {
                            alert('採購單產生成功。');
                        }
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