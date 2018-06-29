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
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}

			q_desc = 1;
			q_tables = 's';
			var q_name = "vcce";
			var q_readonly = ['txtNoa', 'txtWeight', 'txtWorker', 'txtWorker2', 'txtComp', 'txtAcomp', 'txtSales','textCuft'];
			var q_readonlys = ['txtOrdeno','txtTheory','txtNo2','txtStore','txtStore','txtNotv','txtNotv2'];
			var bbmNum = [['txtWeight', 15, 3, 1], ['txtTotal', 10, 2, 1]];
			var bbsNum = [['txtMount', 10, 0, 1], ['txtEcount', 10, 0, 1], ['txtAdjcount', 10, 0, 1],];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwCount2 = 10;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array(
				['txtCustno', 'lblCustno', 'cust', 'noa,comp,tel,fax,trantype,zip_comp,addr_comp', 'txtCustno,txtComp,txtTel,txtFax,cmbTrantype,txtZip_post,txtAddr_post', 'cust_b.aspx'],
				['txtOrdeno', '', 'orde', 'noa,custno,comp,trantype,stype,tel,fax,addr2,salesno,sales,cno,acomp,paytype', 'txtOrdeno,txtCustno,txtComp,cmbTrantype,cmbStype,txtTel,txtFax,txtAddr_post,txtSalesno,txtSales,txtCno,txtAcomp,txtPaytype', ''],
				['txtProductno_', 'btnProduct_', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_', 'ucaucc_b.aspx'],
				['txtStyle_', 'btnStyle_', 'style', 'noa,product', 'txtStyle_', 'style_b.aspx'], 
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx'],
				['txtRackno_', 'btnRackno_', 'rack', 'noa,rack,storeno,store', 'txtRackno_', 'rack_b.aspx']
			);

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				var t_db=q_db.toLocaleUpperCase();
				window.parent.document.title='發貨作業';
				q_gt('acomp', "where=^^(dbname='"+t_db+"' or not exists (select * from acomp where dbname='"+t_db+"')) ^^ stop=1", 0, 0, 0, "cno_acomp");
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}

				mainForm(1);
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtCldate', r_picd],['txtDate1', r_picd],['txtDate2', r_picd],['txtEtcdate', r_picd],['txtEtctime','99:99']];
				q_mask(bbmMask);
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbStype", q_getPara('orde.stype'));
				q_cmbParse("combPaytype", q_getPara('vcc.paytype'));

				var t_where = "where=^^ 1=0 ^^ stop=100";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				
				$('#cmbStype').change(function() {
					HiddenTreat();
				});				
				
				$('#btnOrdeimport').click(function() {
					var ordeno = $('#txtOrdeno').val();
					var t_where = " 1=1 and noa in (select noa from view_orde where stype='"+$('#cmbStype').val()+"') and isnull(enda,0)=0 and isnull(cancel,0)=0 ";
					if (ordeno.length > 0)
						t_where += " and noa='" + ordeno + "'";
					t_where += q_sqlPara2('custno', $('#txtCustno').val());
					q_box("ordes_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordeimport', "95%", "95%", q_getMsg('popOrde'));
				});
				$('#txtAddr_post').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});
			}
			
			function sleep(milliseconds) {
                var start = new Date().getTime();
                for (var i = 0; i < 1e7; i++) {
                    if ((new Date().getTime() - start) > milliseconds) {
                        break;
                    }
                }
            }
            
            function q_funcPost(t_func, result) {
                switch(t_func) {
                	case 'qtxt.query.toinvo':
                	 var as = _q_appendData("tmp0", "", true, true);
                        if (as[0] != undefined) {
                            abbm[q_recno]['invo'] = as[0].invo;
                            $('#txtInvo').val(as[0].invo);
							alert('Invoice產生完畢!!');
                            /*if (as[0].invo.length > 0) {
                                q_func('invo_post.post', r_accy + ',' + as[0].invo + ',1');
                            }*/
                        }
                		break;
                    case 'qtxt.query.tovcc':
                        var as = _q_appendData("tmp0", "", true, true);
                        if (as[0] != undefined) {
                            abbm[q_recno]['caseno2'] = as[0].vccno;
                            $('#txtCaseno2').val(as[0].vccno);
							
                            if (as[0].vccno.length > 0) {
                                q_func('vcc_post.post', as[0].accy + ',' + as[0].vccno + ',1');
                            }
                            alert('出貨單產生完畢!!');
                        }
                        break;
                }
            }

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'packing':
						ChangeCuft();
						break;
					case 'ordeimport':
						if (q_cur > 0 && q_cur < 4) {
							if (!b_ret || b_ret.length == 0){
								b_pop = '';
								return;
							}
							for (var i = 0; i < b_ret.length; i++) {
								b_ret[i].vemnotv=q_sub(dec(b_ret[i].mount),dec(b_ret[i].vemount));
								b_ret[i].vewnotv=q_sub(dec(b_ret[i].weight),dec(b_ret[i].veweight));
								if(b_ret[i].vemnotv<0){b_ret[i].vemnotv=0;}
								if(b_ret[i].vewnotv<0){b_ret[i].vewnotv=0;}
							}
							
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtOrdeno,txtNo2,txtProductno,txtProduct,txtUnit,txtSpec,txtMount,txtWeight'
								, b_ret.length, b_ret, 'noa,no2,productno,product,unit,spec,vemnotv,vewnotv', 'txtProductno');
							if (b_ret[0].noa != undefined) {
								var t_where = "where=^^noa='" + b_ret[0].noa + "'^^";
								q_gt('view_orde', t_where, 0, 0, 0, "", r_accy);
							}
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
            
            var StyleList = ''
            var t_uccArray = new Array;
			var focus_addr = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'cno_acomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							z_cno = as[0].noa;
							z_acomp = as[0].acomp;
							z_nick = as[0].nick;
						}
						break;
					case 'packing':
						var as = _q_appendData("packing", "", true);
						var t_cuft=0;
						if (as[0] != undefined) {
							for (var i = 0; i < as.length; i++) {
								t_cuft=q_add(t_cuft,dec(as[i].cuft));
							}
						}
						$('#textCuft').val(t_cuft);
					break;
					case 'custaddr':
						var as = _q_appendData("custaddr", "", true);
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].post + '@' + as[i].addr;
							}
						}
						document.all.combAddr.options.length = 0;
						q_cmbParse("combAddr", t_item);
						break;
					case 'ordei':
						var as = _q_appendData("ordei", "", true);
						var t_lcno = '';
						var t_imemo = '';
						var t_pmemo = '';
						var t_conn = '';
						if (as[0] != undefined) {
							t_lcno = as[0].lcno;
							t_imemo = as[0].invoicememo;
							t_pmemo = as[0].packinglistmemo;
							t_conn = as[0].conn;
						}
						$('#txtLcno').val(t_lcno);
						$('#txtImemo').val(t_imemo);
						$('#txtPmemo').val(t_pmemo);
						$('#txtConn').val(t_conn);
						break;
					case 'view_orde':
						var orde = _q_appendData("view_orde", "", true);
						if (orde[0] != undefined){
							$('#txtOrdeno').val(orde[0].noa);
							$('#txtCno').val(orde[0].cno);
							$('#txtAcomp').val(orde[0].acomp);
							$('#txtCustno').val(orde[0].custno);
							$('#txtComp').val(orde[0].comp);
							$('#txtTel').val(orde[0].tel);
							$('#txtFax').val(orde[0].fax);
							$('#txtTrantype').val(orde[0].trantype);
							$('#txtPaytype').val(orde[0].paytype);
							if(orde[0].addr2!=''){
								$('#txtZip_post').val(orde[0].post2);
								$('#txtAddr_post').val(orde[0].addr2);
							}else{
								$('#txtZip_post').val(orde[0].post);
								$('#txtAddr_post').val(orde[0].addr);
							}
							$('#txtSalesno').val(orde[0].salesno);
							$('#txtSales').val(orde[0].sales);
							$('#txtMemo').val(orde[0].memo);
							
							var t_ordeno = trim(orde[0].noa);
							if (!emp(t_ordeno)) {
								var t_where = "where=^^ noa='" + t_ordeno + "' ^^";
								q_gt('ordei', t_where, 0, 0, 0, "", r_accy);
							}
						}
						break;
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + focus_addr).val(as[0].addr_fact);
							focus_addr = '';
						}
						break;
					case q_name:
						if (q_cur == 4)
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
                        }
                        break;
				}
			}

			function btnOk() {
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				if(HiddenTreat('rack')){
					var t_rackErr = '';
					for(var j=0;j<q_bbsCount;j++){
						var thisProductno = $.trim($('#txtProductno_'+j).val());
						var thisStoreno = $.trim($('#txtStoreno_'+j).val());
						var thisRackno = $.trim($('#txtRackno_'+j).val());
						if(thisProductno.length >0){
							if(thisStoreno.length == 0 || thisRackno.length == 0){
								t_rackErr += '表身第 ' + (j+1) + " 筆 倉庫或料架編號未填寫!! \n";
							}
						}
					}
					if($.trim(t_rackErr).length > 0){
						alert(t_rackErr);
						return;
					}
				}
				
				//107/06/08
				if(q_getPara('sys.project').toUpperCase()=='AD' || q_getPara('sys.project').toUpperCase()=='JO'){
					var t_where1="1=0";
					var t_where2="1=0";
					for(var i=0;i<q_bbsCount;i++){
						if(!emp($('#txtOrdeno_'+i).val()) && !emp($('#txtNo2_'+i).val())){
							t_where1+=" or noa='"+$('#txtOrdeno_'+i).val()+"' and no2='"+$('#txtNo2_'+i).val()+"'";
							t_where2+=" or ordeno='"+$('#txtOrdeno_'+i).val()+"' and no2='"+$('#txtNo2_'+i).val()+"'";
						}
					}
					
					t_where1="where=^^"+t_where1+"^^";
					t_where2="where=^^("+t_where2+") and noa!='"+$('#txtNoa').val()+"' ^^";
					var t_as=[],t_err2='';
					//抓取訂單量
					q_gt('view_ordes', t_where1, 0, 0, 0, "",r_accy,1);
					var as = _q_appendData("view_ordes", "", true);
					for(var i=0;i<q_bbsCount;i++){
						if(!emp($('#txtOrdeno_'+i).val()) && !emp($('#txtNo2_'+i).val())){
							var texists=false;
							for(var j=0;j<as.length;j++){
								if($('#txtOrdeno_'+i).val()==as[j].noa && $('#txtNo2_'+i).val()==as[j].no2){
									texists=true;
									t_as.push({
										'ordeno':as[j].noa,
										'no2':as[j].no2,
										'mount':dec(as[j].mount),
										'weight':dec(as[j].weight),
										'newvemount':0,
										'newveweight':0,
										'vemount':0,
										'veweight':0
									});
									
									break;
								}
							}
							if(!texists){
								t_err2='表身第'+(i+1)+'項訂單不存在，請重新匯入!!';
								break;
							}
						}
					}
					
					if(t_err2.length>0){
						alert(t_err2);
						return;
					}
					
					//已派車
					q_gt('view_vcces', t_where2, 0, 0, 0, "",r_accy,1);
					var as = _q_appendData("view_vcces", "", true);
					for(var i=0;i<as.length;i++){
						for(var j=0;j<t_as.length;j++){
							if(as[i].ordeno==t_as[j].ordeno && as[i].no2==t_as[j].no2){
								t_as[j].vemount=q_add(dec(t_as[j].vemount),dec(as[i].mount));
								t_as[j].veweight=q_add(dec(t_as[j].veweight),dec(as[i].weight));
								break;	
							}
						}
					}
					//本次
					for(var i=0;i<q_bbsCount;i++){
						if(!emp($('#txtOrdeno_'+i).val()) && !emp($('#txtNo2_'+i).val())){
							for(var j=0;j<t_as.length;j++){
								if($('#txtOrdeno_'+i).val()==t_as[j].ordeno && $('#txtNo2_'+i).val()==t_as[j].no2){
									t_as[j].newvemount=q_add(dec(t_as[j].newvemount),dec($('#txtMount_'+i).val()));
									t_as[j].newveweight=q_add(dec(t_as[j].newveweight),dec($('#txtWeight_'+i).val()));
									break;
								}
							}
						}
					}
					
					//判斷(目前只判斷數量)
					for(var j=0;j<t_as.length;j++){
						if(t_as[j].mount<t_as[j].vemount+t_as[j].newvemount){
							t_err2='訂單【'+t_as[j].ordeno+'-'+t_as[j].no2+'】派車數量大於訂單數量!!\n';
						}
					}
					
					if(t_err2.length>0){
						alert(t_err2);
						return;
					}
				}
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
				sum();

				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				
				var t_cnoascii=String.fromCharCode(dec(z_cno.substr(0,1))+64);
				if(!(t_cnoascii>='A' && t_cnoascii<='Z')){
					t_cnoascii='';
				}
				if(!(q_getPara('sys.project').toUpperCase()=='AD' || q_getPara('sys.project').toUpperCase()=='JO')){
					t_cnoascii='';
				}
				
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_vcce') +t_cnoascii+ $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}
			function size_change() {
				if (q_cur == 1 || q_cur == 2) {
					$('input[id*="textSize"]').removeAttr('disabled');
				} else {
					$('input[id*="textSize"]').attr('disabled', 'disabled');
				}
				
				for (var j = 0; j < q_bbsCount; j++) {
                        $('#textSize1_' + j).show();
                        $('#textSize2_' + j).show();
                        $('#textSize3_' + j).show();
                        $('#textSize4_' + j).show();
                        $('#textSize5_' + j).show();
                        $('#x1_' + j).show();
                        $('#x2_' + j).show();
                        $('#x3_' + j).show();
                        $('#x4_' + j).show();
                        $('#textSize1_' + j).val($('#txtDime_' + j).val());
                        $('#textSize2_' + j).val($('#txtWidth_' + j).val());
                        $('#textSize3_' + j).val($('#txtLengthb_' + j).val());
                        $('#textSize4_' + j).val($('#txtRadius_' + j).val());
                        $('#textSize5_' + j).val($('#txtLengthc_' + j).val());
               }
			}
			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;

				q_box('vcce_s.aspx', q_name + '_s', "500px", "360px", q_getMsg("popSeek"));
			}

			function combPaytype_chg() {
				var cmb = document.getElementById("combPaytype");
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtPaytype').val(cmb.value);
				cmb.value = '';
			}

			function combPay_chg() {
			}

			function combAddr_chg() {
				if (q_cur == 1 || q_cur == 2) {
					$('#txtAddr_post').val($('#combAddr').find("option:selected").text());
					$('#txtZip_post').val($('#combAddr').find("option:selected").val());
				}
			}
			
			function getTheory(b_seq) {
                t_Radius = $('#txtRadius_' + b_seq).val();
                t_Width = $('#txtWidth_' + b_seq).val();
                t_Dime = $('#txtDime_' + b_seq).val();
                t_Lengthb = $('#txtLengthb_' + b_seq).val();
                t_Lengthc = $('#txtLengthc_' + b_seq).val();
                t_Project = q_getPara('sys.project').toUpperCase();
                t_Mount = $('#txtMount_' + b_seq).val();
                t_Style = $('#txtStyle_' + b_seq).val();
                t_Productno = $('#txtProductno_' + b_seq).val();
                var theory_setting = {
                    calc : StyleList,
                    ucc : t_uccArray,
                    radius : t_Radius,
                    width : t_Width,
                    dime : t_Dime,
                    lengthb : t_Lengthb,
                    lengthc : t_Lengthc,
                    project : t_Project,
                    mount : t_Mount,
                    style : t_Style,
                    productno : t_Productno,
                    round : 3
                };
                return theory_st(theory_setting);
            }

			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#txtWeight_' + j).change(function() {
							sum();
						});
						$('#txtMount_' + j).change(function() {
                            sum();
                        });
						//計算理論重
                        $('#textSize1_' + j).change(function() {
                            sum();
                        });
                        $('#textSize2_' + j).change(function() {
                            sum();
                        });
                        $('#textSize3_' + j).change(function() {
                            sum();
                        });
                        $('#textSize4_' + j).change(function() {
                            sum();
                        });
                        $('#textSize5_' + j).change(function() {
                            sum();
                        });
					}
				}
				_bbsAssign();
				HiddenTreat();
				size_change();
			}

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				var t_where = "where=^^ 1=0 ^^ stop=100";
				q_gt('custaddr', t_where, 0, 0, 0, "");
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				size_change();
				$('#txtDatea').focus();

				if (!emp($('#txtCustno').val())) {
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^ stop=100";
					q_gt('custaddr', t_where, 0, 0, 0, "");
				}
			}

			function btnPrint() {
				t_where = "noa='" + $('#txtNoa').val() + "'";
				q_box("z_vccestp_ps.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, '', "95%", "95%", q_getMsg('popPrint'));
			}

			function wrServer(key_value) {
				var i;

				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['product']) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['datea'] = abbm2['datea'];
				as['custno'] = abbm2['custno'];

				return true;
			}

			function sum() {
			    
			    var t_mount = 0, t_price = 0, t_money = 0, t_moneyus = 0, t_weight = 0, t_total = 0, t_tax = 0;
                var t_mounts = 0, t_prices = 0, t_moneys = 0, t_weights = 0;
                var t_unit = '';
			    for (var j = 0; j < q_bbsCount; j++) {
                    t_unit = $.trim($('#txtUnit_' + j).val()).toUpperCase();
                    var t_product = $.trim($('#txtProduct_' + j).val());
                    if (t_unit.length == 0 && t_product.length > 0) {
                        if (t_product.indexOf('管') > 0)
                            t_unit = '支';
                        else
                            t_unit = 'KG';
                        $('#txtUnit_' + j).val(t_unit);
                    }

                    q_tr('txtDime_' + j, q_float('textSize1_' + j));
                    q_tr('txtWidth_' + j, q_float('textSize2_' + j));
                    q_tr('txtLengthb_' + j, q_float('textSize3_' + j));
                    q_tr('txtRadius_' + j, q_float('textSize4_' + j));
                    q_tr('txtLengthc_' + j, q_float('textSize5_' + j));
                    $('#txtTheory_' + j).val(getTheory(j));
                    t_weights = q_float('txtWeight_' + j);
                    t_prices = q_float('txtPrice_' + j);
                    t_mounts = q_float('txtMount_' + j);
                    t_counta = (q_float('txtOmount_' + j) ? q_div(q_float('txtOmount_' + j),100): 1);
                    if (t_weights.length!=0) {
                        t_moneys = q_mul(q_mul(t_prices, t_weights),t_counta);
                    } else {
                        t_moneys = q_mul(q_mul(t_prices, t_mounts),t_counta);
                    }
                    t_weight = q_add(t_weight, t_weights);
                    t_mount = q_add(t_mount, t_mounts);
                    t_money = q_add(t_money, t_moneys);
                    $('#txtTotal_' + j).val(FormatNumber(t_moneys));
                }
                
                $('#txtWeight').val(FormatNumber(t_weight));
                $('#txtMoney').val(FormatNumber(t_money));
                $('#txtTotal').val(FormatNumber(t_total));
			}

			function refresh(recno) {
				_refresh(recno);
				HiddenTreat();
				ChangeCuft();
			}
			
			function ChangeCuft(){
				if(emp($('#txtNoa').val())){
					$('#textCuft').val('');
				}else{
					var t_where = "where=^^ noa='" + $('#txtNoa').val()+ "' ^^";
					q_gt('packing', t_where, 0, 0, 0, "");
				}
			}
			
			function HiddenTreat(returnType){
				returnType = $.trim(returnType).toLowerCase();
				var hasStyle = q_getPara('sys.isstyle');
				var isStyle = (hasStyle.toString()=='1'?$('.isStyle').show():$('.isStyle').hide());
				var hasSpec = q_getPara('sys.isspec');
				var isSpec = (hasSpec.toString()=='1'?$('.isSpec').show():$('.isSpec').hide());
				var hasRackComp = q_getPara('sys.rack');
				var isRack = (hasRackComp.toString()=='1'?$('.isRack').show():$('.isRack').hide());
				if(returnType=='style'){
					return (hasStyle.toString()=='1');
				}else if(returnType=='spec'){
					return (hasSpec.toString()=='1');
				}else if(returnType=='rack'){
					return (hasRackComp.toString()=='1');
				}
				if($('#cmbStype').val()=='3'){
					$('.isexport').show();
					if(q_getPara('sys.isport')=='1'){ //外銷
						$('.isport').show();
					}
				}else{
					$('.isexport').hide();
					$('.isport').hide();
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				HiddenTreat();
				if (t_para) {
					$('#btnBoaj').removeAttr('disabled');
					$('#btnToinvo').removeAttr('disabled');
					$('#btnTovcc').removeAttr('disabled');
					$('#btnPack').removeAttr('disabled');
					$('#combAddr').attr('disabled', 'disabled');
				} else {
					$('#btnBoaj').attr('disabled', 'disabled');
					$('#btnToinvo').attr('disabled', 'disabled');
					$('#btnTovcc').attr('disabled', 'disabled');
					$('#btnPack').attr('disabled', 'disabled');
					$('#combAddr').removeAttr('disabled');
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
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}

			function q_popPost(s1) {
				switch (s1) {
					case 'txtCustno':
						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^ stop=100";
							q_gt('custaddr', t_where, 0, 0, 0, "");
						}
						break;
					case 'txtProductno_':
                        var t_productno = $.trim($('#txtProductno_'+b_seq).val());
                        var t_style = $.trim($('#txtStyle_'+b_seq).val());
                        var t_comp = q_getPara('sys.comp');             
                        q_gt('getproduct',"where=^^[N'"+t_productno+"',N'"+t_style+"',N'"+t_comp+"')^^", 0, 0, 0, "getproduct_"+b_seq); 
                        $('#txtStyle_' + b_seq).focus();
                        break;
                    case 'txtStyle_':
                        var t_productno = $.trim($('#txtProductno_'+b_seq).val());
                        var t_style = $.trim($('#txtStyle_'+b_seq).val());
                        var t_comp = q_getPara('sys.comp');             
                        q_gt('getproduct',"where=^^[N'"+t_productno+"',N'"+t_style+"',N'"+t_comp+"')^^", 0, 0, 0, "getproduct_"+b_seq); 
                        $('#txtStyle_'+b_seq).blur();
                        break;
				}
			}
			
			function FormatNumber(n) {
                var xx = "";
                if (n < 0) {
                    n = Math.abs(n);
                    xx = "-";
                }
                n += "";
                var arr = n.split(".");
                var re = /(\d{1,3})(?=(\d{3})+$)/g;
                return xx + arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
            }

		</script>
		<style type="text/css">
			#dmain {
			}
			.dview {
				float: left;
				width: 28%;
			}
			.tview {
				margin: 0;
				padding: 2px;
				border: 1px black double;
				border-spacing: 0;
				font-size: medium;
				background-color: #FFFF66;
				color: blue;
				width: 100%;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border: 1px black solid;
			}
			.dbbm {
				float: left;
				width: 70%;
				margin: -1px;
				border: 1px black solid;
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
				/*width: 9%;*/
			}
			.tbbm .tdZ {
				width: 3%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: blue;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 97%;
				float: left;
			}
			.txt.c2 {
				width: 14%;
				float: left;
			}
			.txt.c3 {
				width: 26%;
				float: left;
			}
			.txt.c4 {
				width: 25%;
				float: left;
			}
			.txt.c5 {
				width: 60%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
			}
			.txt.c7 {
				width: 98%;
				float: left;
			}
			.txt.c8 {
				float: left;
				width: 65px;
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
			.tbbm td input[type="button"] {
				float: left;
				width: auto;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			.dbbs {
				width: 1810px;
			}
			.tbbs a {
				font-size: medium;
			}

			.num {
				text-align: right;
			}
			.tbbs tr.error input[type="text"] {
				color: red;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.tbbs {
				FONT-SIZE: medium;
				COLOR: blue;
				TEXT-ALIGN: left;
				BORDER: 1PX LIGHTGREY SOLID;
				width: 100%;
				height: 98%;
			}

			.tbbs .td1 {
				width: 4%;
			}
			.tbbs .td2 {
				width: 6%;
			}
			.tbbs .td3 {
				width: 8%;
			}
			.tbbs .td4 {
				width: 2%;
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="width: 1260px;">
			<div class="dview" id="dview" style="float: left;  width:32%;"  >
				<table class="tview" id="tview"   border="1" cellpadding='2'  cellspacing='0' style="background-color: #FFFF66;">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:30%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:35%"><a id='vewComp'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='comp,4'>~comp,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm' style="width: 68%;float:left">
				<table class="tbbm"  id="tbbm"   border="0" cellpadding='2'  cellspacing='0'>
					<tr class="tr0" style="height: 0px;">
						<td class="td1" style="width: 105px;"> </td>
						<td class="td2" style="width: 105px;"> </td>
						<td class="td4" style="width: 105px;"> </td>
						<td class="td5" style="width: 105px;"> </td>
						<td class="td5" style="width: 105px;"> </td>
						<td class="td3" style="width: 105px;"> </td>
						<td class="td4" style="width: 130px;"> </td>
						<td class="td6" style="width: 105px;"> </td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td class="td2"><input id="txtDatea"  type="text" class="txt c1"/></td>
						<td class="td4"><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td class="td5" colspan="2"><input id="txtNoa"  type="text" class="txt c1"/></td>
						<td class="td3"><span> </span><a id="lblStype" class="lbl"> </a></td>
						<td class="td4"><select id="cmbStype" class="txt c1"> </select></td>
						<td class="td6"> </td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblAcomp" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCno"  type="text" class="txt c1"/></td>
						<td class="td3" colspan="3"><input id="txtAcomp"  type="text" class="txt c7"/></td>
						<td class="td3"><span> </span><a id="lblOrdeno" class="lbl"> </a></td>
						<td class="td4"><input id="txtOrdeno"  type="text" class="txt c1"/></td>
						<td class="td6"><input id="btnOrdeimport" type="button"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblCustno" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCustno"  type="text" class="txt c1"/></td>
						<td class="td3" colspan="3"><input id="txtComp"  type="text" class="txt c7"/></td>
						<td class="td4"><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td class="td5"><input id="txtPaytype" type="text" class="txt c1"/></td>
						<td class="td6"><select id="combPaytype" class="txt c1" onchange='combPaytype_chg();'> </select></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblTel" class="lbl"> </a></td>
						<td class="td2" colspan="4"><input id="txtTel"  type="text" class="txt c7"/></td>
						<td class="td1"><span> </span><a id="lblFax" class="lbl"> </a></td>
						<td class="td2" colspan="2"><input id="txtFax"  type="text" class="txt c7"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblAddr_post" class="lbl"> </a></td>
						<td class="td2" colspan="4">
							<input id="txtZip_post"  type="text" class="txt c7" style="width: 25%;"/>
							<input id="txtAddr_post"  type="text" class="txt c7" style="width: 68%;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg();'> </select>
						</td>
						<td class="td3"><span> </span><a id="lblTrantype" class="lbl"> </a></td>
						<td class="td4" colspan="2"><select id="cmbTrantype" class="txt c1"> </select></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblCardeal" class="lbl btn"> </a></td>
						<td class="td2"><input id="txtCardealno"  type="text" class="txt c1"/></td>
						<td class="td3" colspan="3"><input id="txtCardeal"  type="text" class="txt c1"/></td>
						<td class="td6"><span> </span><a id="lblCarno" class="lbl"> </a></td>
						<td class="td7" colspan="2"><input id="txtCarno"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td class="td1"><span> </span><a id="lblWeight" class="lbl"> </a></td>
						<td class="td2"><input id="txtWeight"  type="text" class="txt c1 num"/></td>
						<td class="td3"><span> </span><a class="lbl">總金額</a></td>
						<td class="td4" colspan="2"><input id="txtTotal" type="text" class="txt c1 num"/></td>
						<td class="td5"><span> </span><a id="lblSales" class="lbl btn"> </a></td>
                        <td class="td7"><input id="txtSalesno"  type="text" class="txt c1"/></td>
                        <td class="td8"><input id="txtSales"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td class="td5"><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td class="td6"><input id="txtWorker" type="text" class="txt c1" /></td>
						<td class="td7"><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td class="td8"><input id="txtWorker2" type="text" class="txt c1" /></td>
						<td class="isexport"> </td>
						<td class="isexport"> </td>
						<td class="isexport"> </td>
					</tr>
				</table>
			</div>
			<div class='dbbs' >
				<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
					<tr style='color:White; background:#003366;' >
						<td align="center">
							<input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
						</td>
						<td align="center" style="width:150px;"><a id='lblUno_pa'>領料爐號</a></td>
						<td align="center" style="width:50px; cursor: e-resize;"><a id="lblStyle_st"></a></td>
						<td align="center" style="width:150px;"><a id='lblProductno_s'> </a></td>
						<td align="center" style="width:120px; cursor: e-resize;"><a>板面</a></td>
						<td align="center" style="width:360px;" id='Size'><a id='lblSize_help'>厚度 x 寬度/OD x 長度/ID x 寬度2 x 寬度3 </a></td>
						<td align="center" style="width:89px;"><a id='lblMount_s'> </a></td>
						<td align="center" style="width:89px;"><a id='lblWeight_pa'>重量<BR>理論重</a></td>
						<td align="center" style="width:51px;"><a id='lblUnit_s'> </a></td>
						<td align="center" style="width:38px;"><a id='lblEnds_s'> </a></td>
						<td align="center" style="width:89px;"><a id='lblNotv_s'> </a></td>
						<td align="center" style="width:89px;display: none;"><a id='lblAdjcount_s'> </a></td>
						<td align="center" style="width:90px;"><a id='lblStoreno_s'> </a></td>
						<td align="center" style="width:128px;" class="isRack"><a id='lblRackno_s'> </a></td>
						<td align="center" style="width:180px;" ><a id='lblMemo_s'> </a></td>
					</tr>
					<tr style='background:#cad3ff;'>
						<td style="width:1%;">
							<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
							<input id="txtNoq.*" type="text" style="display:none;"/>
						</td>
						<td><input type="text" id="txtUno.*" style="width: 95%; text-align: center; background: rgb(237, 237, 238);" readonly="readonly" disabled="disabled"></td>
						<td><input type="text" id="txtStyle.*" style="width: 85%; text-align: center; background: rgb(237, 237, 238);" readonly="readonly" disabled="disabled"></td>
						<td>
							<input class="txt c1" id="txtProductno.*" type="text"  style="width: 80%;"/>
							<input class="btn"  id="btnProduct.*" type="button" value='.' style=" font-weight: bold;" />
							<input class="txt c1" id="txtProduct.*" type="text" />
						</td>
						<td><input type="text" id="txtSpec.*" style="width: 95%; text-align: center; background: rgb(237, 237, 238);" readonly="readonly" disabled="disabled"></td>
						<td class="st hide01">
							<input class="txt num" id="textSize1.*" type="text" style="float: left; width: 55px; background: rgb(237, 237, 238);" readonly="readonly" disabled="disabled">
							<div id="x1_0" style="float: left;display:block;width:20px;padding-top: 4px;">x</div>
							<input class="txt num" id="textSize2.*" type="text" style="float: left; width: 55px; background: rgb(237, 237, 238);" readonly="readonly" disabled="disabled">
							<div id="x2_0" style="float: left;display:block;width:20px;padding-top: 4px;">x</div>
							<input class="txt num" id="textSize3.*" type="text" style="float: left; width: 55px; background: rgb(237, 237, 238);" readonly="readonly" disabled="disabled">
							<div id="x3_0" style="float: left;display:block;width:20px;padding-top: 4px;">x</div>
							<input class="txt num" id="textSize4.*" type="text" style="float: left; width: 55px; background: rgb(237, 237, 238);" readonly="readonly" disabled="disabled">
							<div id="x4_0" style="float: left;display:block;width:20px;padding-top: 4px;">x</div>
                        	<input class="txt num" id="textSize5.*" type="text" style="float: left; width: 55px; background: rgb(237, 237, 238);" readonly="readonly" disabled="disabled">
							<!--上為虛擬下為實際-->
							<input id="txtRadius.*" type="text" style="display: none; background: rgb(237, 237, 238);" readonly="readonly">
							<input id="txtWidth.*" type="text" style="display: none; background: rgb(237, 237, 238);" readonly="readonly">
							<input id="txtDime.*" type="text" style="display: none; background: rgb(237, 237, 238);" readonly="readonly">
							<input id="txtLengthb.*" type="text" style="display: none; background: rgb(237, 237, 238);" readonly="readonly">
								<input id="txtLengthc.*" type="text" style="display: none; background: rgb(237, 237, 238);" readonly="readonly">
							</td>
						<td><input class="txt num c1" id="txtMount.*" type="text"/></td>
						<td><input class="txt num c1" id="txtWeight.*" type="text"/>
						    <input class="txt num c1" id="txtTheory.*" type="text"/>
						</td>
						<td><input class="txt c1" id="txtUnit.*" type="text" /></td>
						<td align="center"><input id="chkEnda.*" type="checkbox"/></td>
						<td>
							<input class="txt num c1" id="txtNotv.*" type="text" />
							<input class="txt num c1" id="txtNotv2.*" type="text" />
						</td>
						<td style="display: none;"><input class="txt num c1" id="txtAdjcount.*" type="text" /></td>
						<td>
							<input id="txtStoreno.*" type="text" class="txt c1" style="width: 75%"/>
							<input class="btn"  id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;" />
							<input id="txtStore.*" type="text" class="txt c1"/>
						</td>
						<td class="isRack">
							<input class="btn"  id="btnRackno.*" type="button" value='.' style="float:left;" />
							<input id="txtRackno.*" type="text" class="txt c1" style="width: 70%"/>
						</td>
						<td><input class="txt c1" id="txtMemo.*" type="text" />
						    <input class="txt c1" id="txtOrdeno.*" type="text" style="width: 70%" />
                            <input class="txt c1" id="txtNo2.*" type="text" style="width: 25%"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>