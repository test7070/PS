<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
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
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
            }
            
			q_tables = 's';
			var q_name = "get";
			var q_readonly = ['txtNoa','txtWorker','txtWeight','txtWorker2'];
			var q_readonlys = ['txtOrdeno', 'txtNo2'];
			var bbmNum = [];
			var bbsNum = [['textSize1', 10, 3, 1], ['textSize2', 10, 2, 1], ['textSize3', 10, 3, 1], ['textSize4', 10, 2, 1], ['txtRadius', 10, 3, 1], ['txtWidth', 10, 2, 1], ['txtDime', 10, 3, 1], ['txtLengthb', 10, 2, 1], ['txtMount', 10, 0, 1], ['txtGmount', 10, 0, 1], ['txtGweight', 10, 3, 1], ['txtWeight', 10, 3, 1]];
			var bbmMask = [];
			var bbsMask = [];
			q_desc = 1;
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			brwCount2 = 8;
			aPop = new Array(
				['txtStoreno', 'lblStore', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx'],
				['txtUno_', 'btnUno_', 'view_uccc', 'uno,productno,product,spec,radius,width,dime,lengthb,style,class,eweight,emount', '0txtUno_,txtProductno_,txtProduct_,txtSpec_,txtRadius_,txtWidth_,txtDime_,txtLengthb_,txtStyle_,txtClass_,txtGweight_,txtGmount_', 'uccc_seek_b.aspx?;;;1=0', '95%', '60%']
				, ['txtProductno_', 'btnProduct_', 'ucc', 'noa,product', 'txtProductno_', 'ucc_b.aspx']
            	, ['txtStyle_', 'btnStyle_', 'style', 'noa,product', 'txtStyle_', 'style_b.aspx']
				,['txtCustno', 'lblCustno', 'cust', 'noa,comp', 'txtCustno,txtComp', 'cust_b.aspx']
			);
			
			var para = new Array();//若有值就自動新增修改
			var parent;
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				
	            try{
	            	para = JSON.parse(q_getId()[3].replace('1=1^^',''));
	            	if(para.noa==undefined || para.length==0){
		            }else{
		            	q_content = "where=^^noa='"+para.noa+"'^^ ";
		            }
	            }catch(e){
	            }    
	            q_gt('style', '', 0, 0, 0, '');
			});
			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function sum() {
				var t1 = 0, t_unit, t_mount, t_weight = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_weight = q_add(t_weight, q_float('txtGweight_' + j));
					// 重量合計
					t_unit = $('#txtUnit_' + j).val();
					t_mount = (!t_unit || emp(t_unit) || trim(t_unit).toLowerCase() == 'kg' ? $('#txtWeight_' + j).val() : $('#txtMount_' + j).val());
					// 計價量
					$('#txtTotal_' + j).val(round(q_mul(dec($('#txtPrice_' + j).val()), dec(t_mount)), 0));
				}// j
			}

            function mainPost() {// 載入資料完，未 refresh 前
                document.title = "出庫作業"; //web.title
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtCucdate', r_picd]];
				q_mask(bbmMask);
                q_cmbParse("cmbTypea", ('').concat(new Array('','裁剪','加工','進貨','退貨','盤點','調料')));
                q_cmbParse("cmbKind", q_getPara('sys.stktype'));

				/* 若非本會計年度則無法存檔 */
				/*$('#txtDatea').focusout(function() {
					if ($(this).val().substr(0, 3) != r_accy) {
						$('#btnOk').attr('disabled', 'disabled');
						alert(q_getMsg('lblDatea') + '非本會計年度。');
					} else {
						$('#btnOk').removeAttr('disabled');
					}
				});*/
				//變動尺寸欄位
				$('#cmbKind').change(function() {
					size_change();
				});
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ordes':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0) {
								b_pop = '';
								return;
							}
							var i, j = 0;
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtSize,txtDime,txtWidth,txtLengthb,txtUnit,txtOrdeno,txtNo2', b_ret.length, b_ret, 'productno,product,spec,size,dime,width,lengthb,unit,noa,no2', 'txtProductno,txtProduct,txtSpec');
							/// 最後 aEmpField 不可以有【數字欄位】
							bbsAssign();
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			var StyleList = '';
			var t_uccArray = new Array;
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'style' :
						var as = _q_appendData("style", "", true);
						StyleList = new Array();
						StyleList = as;
						if(para.noa==undefined || para.noa.length==0){
							q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
						}else{
							q_gt('view_get', q_content, 0, 0, 0, 'isExistGet');
						}
						break;
					case 'isExistGet' :
						//判斷要執行 新增 OR 修改 
						var as = _q_appendData("view_get", "", true);
						if(as[0]!=undefined && as[0].noa.length>0){
							para.auto = function(){btnModi();};	
							para.insdisabled = true;
						}else{
							para.auto = function(){btnIns();};	
							para.insdisabled = false;
						}	
						q_gt('view_vcc', q_content, 0, 0, 0, 'getVcc');
						break;	
					case 'getVcc':
						var as = _q_appendData("view_vcc", "", true);
						if(as[0]!=undefined){
							para.custno = as[0].custno;
							para.comp = as[0].comp;	
						}
						q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
						
						break;
					case q_name:
						t_uccArray = _q_appendData("ucc", "", true);
						if (q_cur == 4)// 查詢
							q_Seek_gtPost();
						break;
					default:
						if(t_name.substring(0, 11) == 'getproduct_'){
     						var t_seq = parseInt(t_name.split('_')[1]);
	                		as = _q_appendData('dbo.getproduct', "", true);
	                		if(as[0]!=undefined){
	                			$('#txtProduct_'+t_seq).val(as[0].product);
	                		}else{
	                			$('#txtProduct_'+t_seq).val('');
	                		}
	                		break;
                        }
				} /// end switch
			}

			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				Unlock(1);
			}
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.get_vcc':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							if(as[0].msg.length>0)
								alert(as[0].msg);
						}
						break;
					case 'qtxt.query.postDelete':
						//done;
						break;
					case 'qtxt.query.postUpdate':
						var t_noa = $('#txtNoa').val();
						if(t_noa.length>0){
							q_func('qtxt.query.post1', 'get_rk.txt,post,'+t_noa+';1;' + r_userno );
						}
						break;
					case 'qtxt.query.post1':
						//done;
						break;
					default:
						try{
							if(t_func.substring(0,11)=='qtxt.query.'){
								t_para = JSON.parse(t_func.substring(11,t_func.length));	
								if(t_para.action=='post0'){
									var item = {action:'post1',noa:t_para.noa,condition:'1',userno:t_para.userno};
									q_func('qtxt.query.'+JSON.stringify(item), 'get_rk.txt,post,'+t_para.noa+';1;' + t_para.userno +';');
								}else if(t_para.action=='post1'){
									//done!!
								}
							}
						}catch(e){}
						break;
				}
			}

			function btnOk() {
				Lock(1, {
					opacity : 0
				});
				if ($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())) {
					alert(q_getMsg('lblDatea') + '錯誤。');
					Unlock(1);
					return;
				}
				//倉庫
				if($.trim($('#txtStoreno').val()).length>0)
				{
					for(var i=0;i<=q_bbsCount;i++){
						$('#txtStoreno_'+i).val($.trim($('#txtStoreno').val()));
					}
				}
				$('#txtWorker').val(r_name);
				sum();
				var t_noa = trim($('#txtNoa').val());
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")/// 自動產生編號
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_get') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('getst_s.aspx', q_name + '_s', "500px", "450px", q_getMsg("popSeek"));
			}

			function getTheory(b_seq) {
				t_Radius = $('#txtRadius_' + b_seq).val();
				t_Width = $('#txtWidth_' + b_seq).val();
				t_Dime = $('#txtDime_' + b_seq).val();
				t_Lengthb = $('#txtLengthb_' + b_seq).val();
				t_Mount = $('#txtGmount_' + b_seq).val();
				t_Style = $('#txtStyle_' + b_seq).val();
				t_Productno = $('#txtProductno_' + b_seq).val();
				var theory_setting = {
					calc : StyleList,
					ucc : t_uccArray,
					radius : t_Radius,
					width : t_Width,
					dime : t_Dime,
					lengthb : t_Lengthb,
					mount : t_Mount,
					style : t_Style,
					productno : t_Productno,
					round : 3
				};
				return theory_st(theory_setting);
			}

			function bbsAssign() {/// 表身運算式
				for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
					$('#lblNo_' + j).text(j + 1);
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#btnMinus_' + j).click(function() {
							btnMinus($(this).attr('id'));
						});
						$('#txtGweight_' + j).change(function(e) {
							sum();
						});
						$('#txtStyle_' + j).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace('txtStyle_', '');
                            $('#btnStyle_'+n).click();
                        });
                        $('#txtProductno_' + j).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace('txtProductno_', '');
                            $('#btnProduct_'+n).click();
                        });
						//將虛擬欄位數值帶入實際欄位並計算公式----------------------------------------------------------
						$('#textSize1_' + j).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if ($('#cmbKind').val().substr(0, 1) == 'A') {
								q_tr('txtDime_' + n, q_float('textSize1_' + n));
							} else if ($('#cmbKind').val().substr(0, 1) == 'B') {
								q_tr('txtRadius_' + n, q_float('textSize1_' + n));
							}
							q_tr('txtGweight_' + n, getTheory(n));
						});
						$('#textSize2_' + j).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if ($('#cmbKind').val().substr(0, 1) == 'A') {
								q_tr('txtWidth_' + n, q_float('textSize2_' + n));
							} else if ($('#cmbKind').val().substr(0, 1) == 'B') {
								q_tr('txtWidth_' + n, q_float('textSize2_' + n));
							}
							q_tr('txtGweight_' + n, getTheory(n));
						});
						$('#textSize3_' + j).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if ($('#cmbKind').val().substr(0, 1) == 'A') {
								q_tr('txtLengthb_' + n, q_float('textSize3_' + n));
							} else if ($('#cmbKind').val().substr(0, 1) == 'B') {
								q_tr('txtDime_' + n, q_float('textSize3_' + n));
							} else {//鋼筋、胚
								q_tr('txtLengthb_' + n, q_float('textSize3_' + n));
							}
							q_tr('txtGweight_' + n, getTheory(n));
						});
						$('#textSize4_' + j).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if ($('#cmbKind').val().substr(0, 1) == 'A') {
								q_tr('txtRadius_' + n, q_float('textSize4_' + n));
							} else if ($('#cmbKind').val().substr(0, 1) == 'B') {
								q_tr('txtLengthb_' + n, q_float('textSize4_' + n));
							}
							q_tr('txtGweight_' + n, getTheory(n));
						});
						$('#txtGmount_' + j).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							q_tr('txtGweight_' + n, getTheory(n));
						});
						//-------------------------------------------------------------------------------------
					}
				}//j
				_bbsAssign();
				size_change();
			}

			function btnIns() {
				_btnIns();
				$('#cmbKind').val(q_getPara('vcc.kind'));
				if(para.noa==undefined || para.noa.length==0){
					$('#txtNoa').val('AUTO');
				}else{
					$('#txtNoa').val(para.noa);
					$('#txtCustno').val(para.custno);
					$('#txtComp').val(para.comp);
				}
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
				$('#cmbTypea').val('領料');
				
				if(q_getPara('sys.project').toUpperCase()=='PE')
					$('#cmbKind').val('A1');
					
				size_change();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtProduct').focus();
				size_change();
				sum();
			}

            function btnPrint() {
                q_box('z_getst_ps.aspx' + "?;;;;" + r_accy + ";noa=" + trim($('#txtNoa').val()), '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;

				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['uno'] && !as['productno'] && !as['product'] && !as['spec']) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['date'] = abbm2['date'];
				as['custno'] = abbm2['custno'];
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				//q_popPost('txtProductno_');
				$('input[id*="txtProduct_"]').each(function() {
					thisId = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
					$(this).attr('OldValue', $('#txtProductno_' + thisId).val());
				});
				size_change();
			}

			function q_popPost(s1) {
				switch (s1) {
					case 'txtProductno_':
						var t_productno = $.trim($('#txtProductno_'+b_seq).val());
	                	var t_style = $.trim($('#txtStyle_'+b_seq).val());
	                	var t_comp = q_getPara('sys.comp');          	
	                	q_gt('getproduct',"where=^^[N'"+t_productno+"',N'"+t_style+"',N'"+t_comp+"')^^", 0, 0, 0, "getproduct_"+b_seq); 
                        $('#txtStyle_' + b_seq).focus();
						break;
					case 'txtStyle_':
						console.log(b_seq);
                   		var t_productno = $.trim($('#txtProductno_'+b_seq).val());
	                	var t_style = $.trim($('#txtStyle_'+b_seq).val());
	                	var t_comp = q_getPara('sys.comp');          	
	                	q_gt('getproduct',"where=^^[N'"+t_productno+"',N'"+t_style+"',N'"+t_comp+"')^^", 0, 0, 0, "getproduct_"+b_seq); 
                        $('#txtStyle_'+b_seq).blur();
                        break;
					case 'txtUno_':
						var thisRet = getb_ret();
						size_change();
						if(thisRet){
							var t_uno = trim($('#txtUno_' + b_seq).val()).toUpperCase().substring(0, 1);
							if ('XYZ'.indexOf(t_uno) > -1 && trim(t_uno) != '') {
								$('#txtProductno_' + b_seq).focus();
							} else {
								//if(trim(t_uno) == '') b_seq = x_bseq;
								if (thisRet.length >= 1) {
									$('#txtUno_' + b_seq).val(thisRet[0].uno);
								}
								$('#txtMount_' + b_seq).focus();
							}
						}
						break;
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				size_change();
				//alert(empty);
				if(empty==undefined &&!(para.noa==undefined || para.noa.length==0) && (para.flag==undefined || para.flag==false)){
					para.flag = true;
					//alert(q_cur);
					para.auto();
				}
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				size_change();
			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function btnTop() {
				_btnTop();
			}

			function btnPrev() {
				_btnPrev();
			}

			function btnPrevPage() {
				_btnPrevPage();
			}

			function btnNext() {
				_btnNext();
			}

			function btnNextPage() {
				_btnNextPage();
			}

			function btnBott() {
				_btnBott();
			}

			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}

			function btnDele() {
				var t_noa = $('#txtNoa').val();
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}

			function size_change() {
				if (q_cur == 1 || q_cur == 2) {
					$('input[id*="textSize"]').removeAttr('disabled');
				} else {
					$('input[id*="textSize"]').attr('disabled', 'disabled');
				}
				$('#cmbKind').val((($('#cmbKind').val()) ? $('#cmbKind').val() : q_getPara('vcc.kind')));
				var t_kind = (($('#cmbKind').val()) ? $('#cmbKind').val() : '');
				t_kind = t_kind.substr(0, 1);
				if (t_kind == 'A') {
					$('#lblSize_help').text("厚度x寬度/ODx長度/ID");
					$('#Size').css('width', '220px');
					for (var j = 0; j < q_bbsCount; j++) {
						$('#textSize1_' + j).show();
						$('#textSize2_' + j).show();
						$('#textSize3_' + j).show();
						$('#textSize4_' + j).hide();
						$('#x1_' + j).show();
						$('#x2_' + j).show();
						$('#x3_' + j).hide();
						$('#txtSpec_' + j).css('width', '220px');
						$('#textSize1_' + j).val($('#txtDime_' + j).val());
						$('#textSize2_' + j).val($('#txtWidth_' + j).val());
						$('#textSize3_' + j).val($('#txtLengthb_' + j).val());
						$('#textSize4_' + j).val(0);
						$('#txtRadius_' + j).val(0);
					}
				} else if (t_kind == 'B') {
					$('#lblSize_help').text(q_getPara('sys.lblSizeb'));
					for (var j = 0; j < q_bbsCount; j++) {
						$('#textSize1_' + j).show();
						$('#textSize2_' + j).show();
						$('#textSize3_' + j).show();
						$('#textSize4_' + j).show();
						$('#x1_' + j).show();
						$('#x2_' + j).show();
						$('#x3_' + j).show();
						$('#txtSpec_' + j).css('width', '300px');
						$('#textSize1_' + j).val($('#txtRadius_' + j).val());
						$('#textSize2_' + j).val($('#txtWidth_' + j).val());
						$('#textSize3_' + j).val($('#txtDime_' + j).val());
						$('#textSize4_' + j).val($('#txtLengthb_' + j).val());
					}
				} else {//鋼筋和鋼胚
					$('#lblSize_help').text(q_getPara('sys.lblSizec'));
					for (var j = 0; j < q_bbsCount; j++) {
						$('#textSize1_' + j).hide();
						$('#textSize2_' + j).hide();
						$('#textSize3_' + j).show();
						$('#textSize4_' + j).hide();
						$('#x1_' + j).hide();
						$('#x2_' + j).hide();
						$('#x3_' + j).hide();
						$('#txtSpec_' + j).css('width', '55px');
						$('#textSize1_' + j).val(0);
						$('#txtDime_' + j).val(0);
						$('#textSize2_' + j).val(0);
						$('#txtWidth_' + j).val(0);
						$('#textSize3_' + j).val($('#txtLengthb_' + j).val());
						$('#textSize4_' + j).val(0);
						$('#txtRadius_' + j).val(0);
					}
				}
				if(q_getPara('sys.project').toUpperCase()=='RS')
					$('.rs_hide').hide();
			}
		</script>
		<style type="text/css">
            .dview {
                float: left;
                width: 220px;
                border-width: 0px;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
            }
            .tview tr {
                height: 30px;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: #FFFF66;
                color: blue;
            }
            .dbbm {
                float: left;
                width: 1200px;
                border-radius: 5px;
            }
            .tbbm {
                padding: 0px;
                border: 1px white double;
                border-spacing: 0;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .tbbm tr {
                height: 35px;
            }
            .tbbm tr td {
                width: 16%;
            }
            .tbbm .tdZ {
                width: 1%;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: black;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn {
                color: #4297D7;
                font-weight: bolder;
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 100%;
                float: left;
            }
            .txt.num {
                text-align: right;
            }
            .tbbm td {
                margin: 0 -1px;
                padding: 0;
            }
            .tbbm td input[type="text"] {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                float: left;
            }
            .tbbm select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
            }
            .dbbs {
                width: 1500px;
            }
            .tbbs a {
                font-size: medium;
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
            .num {
                text-align: right;
            }
            select {
                font-size: medium;
            }
            #dbbt {
                width: 1250px;
            }
            #tbbt {
                margin: 0;
                padding: 2px;
                border: 2px pink double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: pink;
                width: 100%;
            }
            #tbbt tr {
                height: 35px;
            }
            #tbbt tr td {
                text-align: center;
                border: 2px pink double;
            }
		</style>
	</head>
	<body ondragstart="return false" draggable="false" ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();" ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<!--#include file="../inc/toolbar.inc"-->
		<div style="overflow: auto;display:block;width:1600px;">
			<div class="dview" id="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:20%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewStoreno'> </a></td>
					</tr>
					<tr>
						<td ><input id="chkBrow.*" type="checkbox" style=""/></td>
						<td align="center" id="datea">~datea</td>
						<td align="center" id="storeno store,4">~storeno ~store,4</td>
					</tr>
				</table>
			</div>
			<div class="dbbm">
				<table class="tbbm"  id="tbbm">
					<tr style="height:1px;"> <td></td> <td></td> <td></td> <td></td> <td></td> <td></td> <td class="tdZ"></td> </tr>
					<tr>
						<td><span> </span><a id="lblType" class="lbl"> </a></td>
						<td><select id="cmbTypea" class="txt c1"> </select></td>
						<td><span> </span><a id="lblDatea" class="lbl" > </a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblNoa" class="lbl" > </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCustno" class="lbl btn" > </a></td>
						<td colspan="3">
							<input id="txtCustno" type="text" class="txt" style="width:50%;"/>
							<input id="txtComp" type="text" class="txt" style="width:50%;"/>
						</td>
						<td><span> </span><a id="lblKind" class="lbl" > </a></td>
						<td><select id="cmbKind" class="txt c1"> </select></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblStore" class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtStoreno" type="text" class="txt" style="width:50%;"/>
							<input id="txtStore" type="text" class="txt" style="width:50%;"/>
						</td>
						<td><span> </span><a id="lblVno" class="lbl"> </a></td>
						<td><input id="txtVno" type="text" class="txt c1"/></td>
						<td><input id="btnStk" type="button" style="display:none;"/></td>
					</tr>
                    <tr>
						<td><span> </span><a id="lblWaste" class="lbl"> </a></td>
						<td><input id="txtWaste" type="text" class="txt c1"/><input id="btnWaste" type="button" style="display:none;"/></td>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl" > </a></td>
						<td colspan='5'><textarea id="txtMemo" rows="4" style="width: 100%;" > </textarea></td>
					</tr>
				</table>
			</div>
		</div>

		<div class="dbbs">
			<table id="tbbs" class="tbbs" style="text-align:center">
				<tr style='color:white; background:#003366;' >
					<td  align="center" style="width:30px;"><input class="btn" id="btnPlus" type="button" value="+" style="font-weight: bold;" /></td>
					<td align="center" style="width:20px;">序</td>
					<td align="center" style="width:280px;"><a>爐號</a></td>
					<td align="center" style="width:120px;"><a>品名</a></td>
					<td align="center" style="width:30px;"><a id="lblStyle_st"> </a></td>
					<td align="center" style="width:80px;"><a>板面</a></td>
					<td align="center" id='Size'><a id='lblSize_help'> </a><BR><a id='lblSize_st'> </a></td>
					<td align="center" style="width:250px;" class="rs_hide"><a>尺寸</a></td>
					<td align="center" style="width:80px;"><a id='lblGmount_st'> </a></td>
					<td align="center" style="width:50px;"><a>理論重</a></td>
					<td align="center" style="width:50px;"><a>出庫重</a></td>
					<td align="center" style="width:50px; display:none;"><a>倉庫</a></td>
					<td align="center" style="width:200px;"><a>備註</a></td>
				</tr>

				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" /><input id="txtNoq.*" type="text" style="display: none;" /></td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td><input class="btn" id="btnUno.*" type="button" value="." style="font-weight:bold;width:1%;" /><input id="txtUno.*" type="text" style="width:75%;"/></td>
					<td>
						<input id="txtProductno.*" type="text" style="width:95%;" />
						<input type="text" id="txtProduct.*" style="width:95%;display:none;" />
						<input class="btn" id="btnProduct.*" type="button" style="display:none;"/>
					</td>
					<td>
						<input type="text" id="txtStyle.*" style="width:95%;text-align:center;" />
						<input id="btnStyle.*" type="button" style="display:none;" value="."/>
					</td>
					<td><input id="txtClass.*" type="text" style='width: 95%;'/></td>
					<td>
						<input class="txt num" id="textSize1.*" type="text" style="float: left;width:55px;" disabled="disabled"/>
						<div id="x1.*" style="float: left;display:block;width:20px;padding-top: 4px;" >x</div>
						<input class="txt num" id="textSize2.*" type="text" style="float: left;width:55px;"  disabled="disabled"/>
						<div id="x2.*" style="float: left;display:block;width:20px;padding-top: 4px;">x</div>
						<input class="txt num" id="textSize3.*" type="text" style="float: left;width:55px;" disabled="disabled"/>
						<div id="x3.*" style="float: left;display:block;width:20px;padding-top: 4px;">x</div>
						<input class="txt num" id="textSize4.*" type="text"  style="float: left;width:55px;" disabled="disabled"/>
						<!--上為虛擬下為實際-->
						<input id="txtRadius.*" type="text" style="display:none;"/>
						<input id="txtWidth.*" type="text" style="display:none;"/>
						<input id="txtDime.*" type="text" style="display:none;"/>
						<input id="txtLengthb.*" type="text" style="display:none;"/>
						<input id="txtSpec.*" type="text" style="float:left;"/>
					</td>
					<td class="rs_hide"><input class="txt " id="txtSize.*" type="text" style="width:95%;"/></td>
					<td><input class="txt num" id="txtGmount.*" type="text" style="width:95%;"/></td>
					<td><input class="txt num" id="txtWeight.*" type="text" style="width:95%;"/></td>
					<td><input class="txt num" id="txtGweight.*" type="text" style="width:95%;"/></td>
					<td style="display:none;"><input class="txt " id="txtStoreno.*" type="text" style="width:95%;"/></td>
					<td><input class="txt" id="txtMemo.*" type="text" style="width:95%;"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden"/>
	</body>
</html>