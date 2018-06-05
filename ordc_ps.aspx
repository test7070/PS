<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title></title>
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

			q_tables = 't';
			var q_name = "ordc";
			var q_readonly = ['txtTgg', 'txtAcomp', 'txtNoa', 'txtWorker', 'txtWorker2', 'txtMoney', 'txtWeight', 'txtTotal', 'txtTax', 'txtTotalus'];
			var q_readonlys = ['txtC1', 'txtNotv', 'txtNo3', 'txtOrdbno', 'txtNo2'];
			var q_readonlyt = [];
			var bbmNum = [['txtMoney', 10, 0, 1], ['txtTax', 10, 0, 1], ['txtTotal', 10, 0, 1], ['txtTotalus', 10, 2, 1], ['txtWeight', 10, 3, 1], ['txtFloata', 10, 4, 1]];
			var bbsNum = [['txtPrice', 15, 3, 1], ['txtTotal', 10, 0, 1], ['txtWeight', 10, 1, 1], ['txtMount', 10, 0, 1], ['txtTheory', 10, 1, 1], ['txtOmount', 10, 3, 1], ['textSize1', 10, 2, 1], ['textSize2', 10, 1, 1], ['textSize3', 10, 1, 1], ['textSize4', 10, 1, 1], ['textSize5', 10, 1, 1]];
			var bbtNum = [['txtWeight', 10, 3, 1]];
			var bbmMask = [];
			var bbsMask = [];
			var bbtMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'noa';
			q_desc = 1;
			aPop = new Array(
				['txtProductno_', 'btnProduct_', 'ucaucc', 'noa,product', 'txtProductno_', 'ucaucc_b.aspx']
				,['txtProductno1_', 'btnProduct1_', 'bcc', 'noa,product,unit', 'txtProductno1_,txtProduct_,txtUnit_', 'bcc_b.aspx'] 
				, ['txtStyle_', 'btnStyle_', 'style', 'noa,product', 'txtStyle_', 'style_b.aspx']
				,['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'], 
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'], 
				['txtUno_', 'btnUno_', 'view_uccc', 'uno', '0txtUno_', 'uccc_seek_b.aspx?;;;1=0', '95%', '60%'], 
				['txtAddr', '', 'view_road', 'memo,zipcode', '0txtAddr,txtPost', 'road_b.aspx'], 
				['txtAddr2', '', 'view_road', 'memo,zipcode', '0txtAddr2,txtPost2', 'road_b.aspx'], 
				['txtSpec_', '', 'spec', 'noa,product', '0txtSpec_,txtSpec_', 'spec_b.aspx', '95%', '95%'], 
				['txtTggno', 'lblTgg', 'tgg', 'noa,comp,nick,paytype,tel,fax,addr_fact,zip_fact', 'txtTggno,txtTgg,txtNick,txtPaytype,txtTel,txtFax,txtAddr,txtPost', 'tgg_b.aspx']
				,['txtCustno__', 'btnCust__', 'cust', 'noa,nick,comp', 'txtCustno__,txtCust__', 'cust_b.aspx']
			);
			brwCount2 = 11;
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'no2'];
				bbtKey = ['noa', 'noq'];
				q_brwCount();
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
				if (!(q_cur == 1 || q_cur == 2))
					return;
				$('#cmbTaxtype').val((($('#cmbTaxtype').val()) ? $('#cmbTaxtype').val() : '1'));
				$('#txtMoney').attr('readonly', true);
				$('#txtTax').attr('readonly', true);
				$('#txtTotal').attr('readonly', true);
				$('#txtMoney').css('background-color', 'rgb(237,237,238)').css('color', 'green');
				$('#txtTax').css('background-color', 'rgb(237,237,238)').css('color', 'green');
				$('#txtTotal').css('background-color', 'rgb(237,237,238)').css('color', 'green');

				var t_mount = 0, t_price = 0, t_money = 0, t_moneyus = 0, t_weight = 0, t_total = 0, t_tax = 0;
				var t_mounts = 0, t_prices = 0, t_moneys = 0, t_weights = 0;
				var t_unit = '';
				var t_float = q_float('txtFloata');
				var t_kind = (($('#cmbKind').val()) ? $('#cmbKind').val() : '');
				t_kind = t_kind.substr(0, 1);
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
                    if (t_float == 0) {
                        t_moneys = round(t_moneys, 0);
                    } else {
                        t_moneyus = q_add(t_moneyus, round(t_moneys, 2));
                        t_moneys = round(q_mul(t_moneys, t_float), 0);
                    }
                    t_weight = q_add(t_weight, t_weights);
                    t_mount = q_add(t_mount, t_mounts);
                    t_money = q_add(t_money, t_moneys);
                    $('#txtTotal_' + j).val(FormatNumber(t_moneys));
				}
				t_taxrate = parseFloat(q_getPara('sys.taxrate')) / 100;
				switch ($('#cmbTaxtype').val()) {
					case '1':
						// 應稅
						t_tax = round(q_mul(t_money, t_taxrate), 0);
						t_total = q_add(t_money, t_tax);
						break;
					case '2':
						//零稅率
						t_tax = 0;
						t_total = q_add(t_money, t_tax);
						break;
					case '3':
						// 內含
						t_tax = q_sub(t_money, round(q_div(t_money, q_add(1, t_taxrate)), 0));
						t_total = t_money;
						t_money = q_sub(t_total, t_tax);
						break;
					case '4':
						// 免稅
						t_tax = 0;
						t_total = q_add(t_money, t_tax);
						break;
					case '5':
						// 自定
						$('#txtTax').attr('readonly', false);
						$('#txtTax').css('background-color', 'white').css('color', 'black');
						t_tax = round(q_float('txtTax'), 0);
						t_total = q_add(t_money, t_tax);
						break;
					case '6':
						// 作廢-清空資料
						t_money = 0, t_tax = 0, t_total = 0;
						break;
					default:
				}
				t_price = q_float('txtPrice');
				if (t_price != 0) {
					$('#txtTranmoney').val(FormatNumber(round(q_mul(t_weight, t_price), 0)));
				}
				$('#txtWeight').val(FormatNumber(t_weight));

				$('#txtMoney').val(FormatNumber(t_money));
				$('#txtTax').val(FormatNumber(t_tax));
				$('#txtTotal').val(FormatNumber(t_total));
				if (t_float == 0)
					$('#txtTotalus').val(0);
				else
					$('#txtTotalus').val(FormatNumber(t_moneyus));
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtOdate', r_picd]];
				q_mask(bbmMask);
				q_cmbParse("cmbKind2", q_getPara('ordc.kind'));
				//q_cmbParse("cmbCoin", q_getPara('sys.coin'));
				q_cmbParse("combPaytype", q_getPara('rc2.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				q_cmbParse("cmbCoin", t_coin);

				$("#combPaytype").change(function(e) {
					if (q_cur == 1 || q_cur == 2)
						$('#txtPaytype').val($('#combPaytype').find(":selected").text());
				});
				$("#txtPaytype").focus(function(e) {
					var n = $(this).val().match(/[0-9]+/g);
					var input = document.getElementById("txtPaytype");
					if ( typeof (input.selectionStart) != 'undefined' && n != null) {
						input.selectionStart = $(this).val().indexOf(n);
						input.selectionEnd = $(this).val().indexOf(n) + (n + "").length;
					}
				}).click(function(e) {
					var n = $(this).val().match(/[0-9]+/g);
					var input = document.getElementById("txtPaytype");
					if ( typeof (input.selectionStart) != 'undefined' && n != null) {
						input.selectionStart = $(this).val().indexOf(n);
						input.selectionEnd = $(this).val().indexOf(n) + (n + "").length;
					}
				});

				$('#txtFloata').change(function() {
					sum();
				});
				$("#cmbTaxtype").change(function(e) {
					sum();
				});
				$('#txtTotal').change(function() {
					sum();
				});
				//變動尺寸欄位
				$('#txtAddr').change(function() {
					var t_where = "where=^^ noa='" + trim($(this).val()) + "' ^^";
					q_gt('cust', t_where, 0, 0, 0, "", r_accy);
				});
				$('#cmbKind').change(function() {
					size_change();
				});

				$('#lblOrdb').click(function() {
					if (!(q_cur == 1 || q_cur == 2))
						return;
					var t_tggno = trim($('#txtTggno').val());
					var t_ordbno = trim($('#txtOrdbno').val());
					var t_where = "enda=0 and notv >0 ";
					if (t_tggno.length > 0) {
						t_where += (t_tggno.length > 0 ? q_sqlPara2("tggno", t_tggno) : "") + " && kind='" + $('#cmbKind').val() + "'";
					} else {
						alert(q_getMsg('msgTggEmp'));
						return;
					}
					q_box('ordbsst_b.aspx', 'ordbs;' + t_where, "95%", "650px", q_getMsg('popOrdbs'));
				});	
			}

			function distinct(arr1) {
				var uniArray = [];
				for (var i = 0; i < arr1.length; i++) {
					var val = arr1[i];
					if ($.inArray(val, uniArray) === -1) {
						uniArray.push(val);
					}
				}
				return uniArray;
			}

			var ordbsArray = new Array;
			function q_boxClose(s2) {///   q_boxClose 2/4
				var ret;
				switch (b_pop) {
					case 'ordbs':
						if (q_cur > 0 && q_cur < 4) {
							ordbsArray = getb_ret();
							if (!ordbsArray || ordbsArray.length == 0) {
								return;
							} else {
								var distinctArray = new Array;
								var inStr = '';
								for (var i = 0; i < ordbsArray.length; i++) {
									distinctArray.push(ordbsArray[i].noa);
								}
								distinctArray = distinct(distinctArray);
								for (var i = 0; i < distinctArray.length; i++) {
									inStr += "'" + distinctArray[i] + "',";
								}
								inStr = inStr.substring(0, inStr.length - 1);
								var t_where = "where=^^ ordbno in(" + inStr + ") ^^";
								q_gt('ordcs', t_where, 0, 0, 0, '', r_accy);
							}
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						///   q_boxClose 3/4
						break;
				}/// end Switch
				b_pop = '';
			}

			var StyleList = '',t_coin='';
			var t_uccArray = new Array;
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'style' :
						var as = _q_appendData("style", "", true);
						StyleList = new Array();
						StyleList = as;
						q_gt('flors_coin', '', 0, 0, 0, "flors_coin");
						break;
					case 'flors_coin':
						var as = _q_appendData("flors", "", true);
						t_coin='';
						for ( i = 0; i < as.length; i++) {
							t_coin+=','+as[i].coin;
						}
						if(t_coin.length==0) 
							t_coin=' ';
						q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
						break;	
					case 'refreshEnd2':
                        var as = _q_appendData("ordc", "", true);
                        var obj = $('.control_noa');
                        if(as[0]!=undefined){
                            for(var i=0;i<abbm.length;i++){
                                if(abbm[i].noa==as[0].noa){
                                    abbm[i].end2 = as[0].end2;
                                    break;
                                }   
                            }
                            for(var j=0;j<obj.length;j++){
                                if(obj.eq(j).html()==as[0].noa){
                                    $('.control_end2').eq(j).html(as[0].end2);
                                    break;
                                }
                            }
                        }
                        refresh(q_recno);
                        break;
					case 'getAcomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							$('#txtCno').val(as[0].noa);
							$('#txtAcomp').val(as[0].nick);
						}
						Unlock(1);
						$('#chkIsproj').attr('checked', true);
						$('#txtNoa').val('AUTO');
						$('#txtOdate').val(q_date());
						$('#txtOdate').focus();
						size_change();
						break;
					
					case 'flors':
						var as = _q_appendData("flors", "", true);
						if (as[0] != undefined) {
							q_tr('txtFloata',as[0].floata);
							sum();
						}
						break;
					case 'ordcs':
						var as = _q_appendData("ordcs", "", true);
						for (var i = 0; i < as.length; i++) {
							for (var j = 0; j < ordbsArray.length; j++) {
								if (as[i].ordbno == ordbsArray[j].noa && as[i].no3 == ordbsArray[j].no3) {
									ordbsArray[j].mount = dec(ordbsArray[j].mount) - dec(as[i].mount);
									ordbsArray[j].weight = dec(ordbsArray[j].weight) - dec(as[i].weight);
								}
							}
							for (var j = 0; j < ordbsArray.length; j++) {
								if (ordbsArray[j].mount <= 0 || ordbsArray[j].weight <= 0 || ordbsArray[j].noa == '') {
									ordbsArray.splice(j, 1);
									j--;
								}
							}
						}
						if (ordbsArray[0] != undefined) {
							for (var i = 0; i < q_bbsCount; i++) {
								$('#btnMinus_' + i).click();
							}
	
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtDime,txtWidth,txtLengthb,txtRadius,txtOrdbno,txtNo3,txtPrice,txtMount,txtWeight,txtTotal,txtMemo,txtTheory,txtStyle,txtClass,txtUno,txtSize,txtUnit,txtUnit2', ordbsArray.length, ordbsArray, 'productno,product,spec,dime,width,lengthb,radius,noa,no3,price,mount,weight,total,memo,theory,style,class,uno,size,unit,unit2', 'txtProductno,txtProduct,txtSpec');

							var oAMap = ordbsArray.map(function(el) {
								return el['ordbno'];
							});
							for (var i = 0; i < oAMap.length; i++) {
								if ((oAMap.indexOf(oAMap[i]) != oAMap.lastIndexOf(oAMap[i])) || oAMap[i] == '') {
									ordbsArray.splice(i, 1);
									oAMap.splice(i, 1);
									i--;
								} else if (trim(ordbsArray[i].acoin) != '' && dec(ordbsArray[i].afloata) != 0 && dec(ordbsArray[i].afloata).toString() != 'NaN') {
									$('#cmbCoin').val(ordbsArray[i].acoin);
									$('#txtFloata').val(ordbsArray[i].afloata);
								}
							}
							$('#txtMemo').val(distinct(ordbsArray.map(function(el) {
								return el['amemo'];
							})).toString());
							bbsAssign();
							sum();
							size_change();
						}
						ordbsArray = new Array;
						break;
					case 'ordb':
						var ordb = _q_appendData("ordb", "", true);
						if (ordb[0] != undefined) {
							$('#combPaytype').val(ordb[0].paytype);
							$('#txtPaytype').val(ordb[0].pay);
							$('#txtPost').val(ordb[0].post);
							$('#txtAddr').val(ordb[0].addr);
							var ordbs = _q_appendData("ordbs", "", true);
							if (ordbs[0] != undefined) {
								q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtRadius,txtWidth,txtDime,txtLengthb,txtMount,txtWeight,txtPrice,txtTotal,txtTheory,txtMemo,txtOrdbno,txtNo3', ordbs.length, ordbs, 'productno,product,spec,radius,width,dime,lengthb,mount,weight,price,total,theory,memo,noa,no3', '');
							}
						}
						break;
					
					case 'cust' :
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined) {
							var CustAddr = trim(as[0].addr_fact);
							if (CustAddr.length > 0) {
								$('#txtAddr').val(CustAddr);
								$('#txtPost').val(as[0].zip_fact);
							}
						}
						break;
					case q_name:
						t_uccArray = _q_appendData("ucc", "", true);
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
					default:
                    	try{
                    		t_para = JSON.parse(t_name);
                    		if(t_para.action == 'importOrde'){
                    			var as = _q_appendData("view_ordes", "", true);
		                		if (as[0] != undefined) {
		                			$('#txtCustno__'+t_para.n).val(as[0].custno);	
		                			$('#txtCust__'+t_para.n).val(as[0].cust);	
		                			$('#txtWeight__'+t_para.n).val(as[0].weight);	
		                		}else{
		                			alert('找不到訂單【'+t_para.ordeno+'-'+t_para.no2+'】');
		                		}
                    			sum();
                    		}
                    		break;
                    	}catch(e){
                    		
                    	}
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
				}  /// end switch
			}
			
			function coin_chg() {
				var t_where = "where=^^ ('" + $('#txtOdate').val() + "' between bdate and edate) and coin='"+$('#cmbCoin').find("option:selected").text()+"' ^^";
				q_gt('flors', t_where, 0, 0, 0, "");
			}

			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				q_gt('ordc', "where=^^ noa='" + $.trim($('#txtNoa').val()) + "'^^", 0, 0, 0, 'refreshEnd2', r_accy);
				Unlock(1);
			}

			function GetOrdbnoList() {
				var ReturnStr = new Array;
				for (var i = 0; i < q_bbsCount; i++) {
					var thisVal = trim($('#txtOrdbno_' + i).val());
					if (thisVal.length > 0)
						ReturnStr.push(thisVal);
				}
				ReturnStr = distinct(ReturnStr).sort();
				return ReturnStr.toString();
			}

			function btnOk() {
			    Lock(1, {
                    opacity : 0
                });
				//物料品名欄位寫入
				if ($('#cmbKind').val() == '2') {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtProductno_' + j).val($('#txtProductno1_' + j).val());
					}
				}
				$('#txtOrdbno').val(GetOrdbnoList());
				//日期檢查
				if ($('#txtOdate').val().length == 0 || !q_cd($('#txtOdate').val())) {
					alert(q_getMsg('lblOdate') + '錯誤。');
					Unlock(1);
					return;
				}
				/*if ($('#txtOdate').val().substring(0, 3) != r_accy) {
					alert('年度異常錯誤，請切換到【' + $('#txtOdate').val().substring(0, 3) + '】年度再作業。');
					Unlock(1);
					return;
				}*/
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
				sum();
                var t_noa = trim($('#txtNoa').val());
                var t_date = trim($('#txtOdate').val());
                if (t_noa.length == 0 || t_noa == "AUTO")
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_ordc') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(t_noa);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;

				q_box('ordcst_s.aspx', q_name + '_s', "500px", "530px", q_getMsg("popSeek"));
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
					$('#lblNo_' + j).text(j + 1);
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#txtMount_' + j).change(function() {
							sum();
						});
						$('#txtWeight_' + j).change(function() {
							sum();
						});
						$('#txtPrice_' + j).change(function() {
							sum();
						});
						$('#txtTotal_' + j).change(function() {
							sum();
						});
						$('#txtC1_' + j).change(function() {
							sum();
						});
						$('#txtOmount_' + j).change(function() {
                            sum();
                        });
						$('#txtStyle_' + j).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                            $('#btnStyle_'+n).click();
                        });
                        $('#txtProductno_' + j).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                            $('#btnProduct_'+n).click();
                        });
                        $('#txtProductno1_' + j).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                            $('#btnProduct1_'+n).click();
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
                        $('#txtOmount_' + j).change(function() {
                            sum();
                        });
						$('#txtSize_' + j).change(function(e) {
							if ($.trim($(this).val()).length == 0)
								return;
							var n = $(this).attr('id').replace('txtSize_', '');
							var data = tranSize($.trim($(this).val()));
							$(this).val(tranSize($.trim($(this).val()), 'getsize'));
							$('#textSize1_' + n).val('');
							$('#textSize2_' + n).val('');
							$('#textSize3_' + n).val('');
							$('#textSize4_' + n).val('');
							$('#textSize5_' + n).val('');				
							if (!(data.length == 2 || data.length == 3)) {
								alert(q_getPara('transize.error01'));
								return;
							}
							$('#textSize1_' + n).val((data[0] != undefined ? (data[0].toString().length > 0 ? (isNaN(parseFloat(data[0])) ? 0 : parseFloat(data[0])) : 0) : 0));
							$('#textSize2_' + n).val((data[1] != undefined ? (data[1].toString().length > 0 ? (isNaN(parseFloat(data[1])) ? 0 : parseFloat(data[1])) : 0) : 0));
							$('#textSize3_' + n).val((data[2] != undefined ? (data[2].toString().length > 0 ? (isNaN(parseFloat(data[2])) ? 0 : parseFloat(data[2])) : 0) : 0));
							$('#textSize4_' + n).val((data[3] != undefined ? (data[3].toString().length > 0 ? (isNaN(parseFloat(data[3])) ? 0 : parseFloat(data[3])) : 0) : 0));
							$('#textSize5_' + n).val((data[4] != undefined ? (data[4].toString().length > 0 ? (isNaN(parseFloat(data[4])) ? 0 : parseFloat(data[4])) : 0) : 0));
							sum();
						});
						$('#btnOrdcrecord_' + j).click(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							var t_where = "noa='" + $('#txtNoa').val() + "' and no2='" + $('#txtNo2_' + n).val() + "'";
							q_box("z_ordcstp.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, '', "95%", "95%", q_getMsg('popPrint'));
						});
					}
				}
				_bbsAssign();
				size_change();
				genNo2();
			}
			function bbtAssign() {
                for (var i = 0; i < q_bbtCount; i++) {
                    $('#lblNo__' + i).text(i + 1);
                    if (!$('#btnMinut__' + i).hasClass('isAssign')) {
                    	$('#txtOrdeno__'+i).change(function(e){
							var n = $(this).attr('id').replace(/^(.*)__(\d+)$/,'$2');
							n = parseInt(n);
							ImportOrde(n);
						});
						$('#txtNo4__'+i).change(function(e){
							var n = $(this).attr('id').replace(/^(.*)__(\d+)$/,'$2');
							n = parseInt(n);
							ImportOrde(n);
						});
                    	$('#txtCustno__' + i).bind('contextmenu', function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
                            var n = $(this).attr('id').replace('txtCustno__', '');
                            $('#btnCust__'+n).click();
                        });
                    }
                }
                _bbtAssign();
            }
            function ImportOrde(n){
				var t_ordeno = $('#txtOrdeno__'+n).val();
				var t_no2 = $('#txtNo4__'+n).val();
				if(t_ordeno.length>0 && t_no2.length>0){
					var t_where = "where=^^ noa='"+t_ordeno+"' and no2='" + t_no2 + "' ^^";
                	q_gt('view_ordes', t_where, 0, 0, 0, JSON.stringify({action:'importOrde',n:n,ordeno:t_ordeno,no2:t_no2}), r_accy);
				}
			}
			function genNo2(){
				//自動增加NO2
				var maxno2 = 0;
				for(var i=0;i<q_bbsCount;i++){
					maxno2 = q_float('txtNo2_'+i)>maxno2?q_float('txtNo2_'+i):maxno2;
				}
				//console.log(maxno2+"__"+q_bbsCount);
				for(var i=0;i<q_bbsCount;i++){
					
					if($('#txtNo2_'+i).val().length==0){
						maxno2++;
						t_no2 = '000'+maxno2;
						t_no2 = t_no2.substring(t_no2.length-3,t_no2.length);
						//console.log(q_float(t_no2));
						$('#txtNo2_'+i).val(t_no2);
						//$('#txtNo2_'+i).val(maxno2);
					}
				}
			}
			
			function btnIns() {
				_btnIns();
				$('#cmbTaxtype').val(1);
				Lock(1, {
					opacity : 0
				});
				q_gt('acomp', '', 0, 0, 0, 'getAcomp', r_accy);
				genNo2();
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtOdate').focus();
				size_change();
				sum();
			}

			function btnPrint() {
				
				t_where = "noa='" + $('#txtNoa').val() + "'";
				q_box("z_ordcstp.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, '', "95%", "95%", q_getMsg('popPrint'));
					
			}

			function wrServer(key_value) {
				var i;

				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno'] && !as['product'] && !as['spec'] && !as['size'] && !dec(as['total'])) {//不存檔條件
					as[bbsKey[1]] = '';
					/// no2 為空，不存檔
					return;
				}
				q_nowf();
				as['date'] = abbm2['date'];
				as['kind'] = abbm2['kind'];
				as['tggno'] = abbm2['tggno'];
				as['odate'] = abbm2['odate'];
				as['enda'] = abbm2['enda'];
				as['cancel'] = abbm2['cancel'];

				return true;
			}
			function bbtSave(as) {
                if (!as['no2']) {
                    as[bbtKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }
            
			function refresh(recno) {
                _refresh(recno);
                var obj = $('.control_end2');
                for(var i=0;i<obj.length;i++){
                    switch(obj.eq(i).html()){
                        case '':
                            obj.eq(i).parent().children().css('color','blue');
                            break;
                        case '0':
                            obj.eq(i).parent().children().css('color','blue');
                            break;
                        case '1':
                            obj.eq(i).parent().children().css('color','darkred');
                            break;
                        case '2':
                            obj.eq(i).parent().children().css('color','green');
                            break;
                        default:
                            obj.eq(i).parent().children().css('color','pink');
                    }

                }
				size_change();
				//q_popPost('txtProductno_');
				
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
                   		var t_productno = $.trim($('#txtProductno_'+b_seq).val());
	                	var t_style = $.trim($('#txtStyle_'+b_seq).val());
	                	var t_comp = q_getPara('sys.comp');          	
	                	q_gt('getproduct',"where=^^[N'"+t_productno+"',N'"+t_style+"',N'"+t_comp+"')^^", 0, 0, 0, "getproduct_"+b_seq); 
                        $('#txtStyle_'+b_seq).blur();
                        break;
					case 'txtTggno':
						$('#txtSalesno').focus();
						break;
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if(t_para){
					$('#txtDatea').datepicker('destroy');
					$('#txtOdate').datepicker('destroy');
				}else{
					$('#txtDatea').datepicker();
					$('#txtOdate').datepicker();
				}
				
				size_change();
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				size_change();
				if (q_tables == 's')
					bbsAssign();
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
                /*overflow: hidden;*/
                
            }
            .dview {
                float: left;
                width: 320px;
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
                width: 800px;
                /*margin: -1px;
                 border: 1px black solid;*/
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
                width: 10%;
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
                width: 2100px;
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
                width: 800px;
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
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div style="overflow: auto;display:block;">
			<!--#include file="../inc/toolbar.inc"-->
		</div>
		<div style="overflow: auto;display:block;width:1280px;">
			<div class="dview" id="dview"  >
				<table class="tview" id="tview"	>
					<tr>
						<td align="center" style="width:20px; color:black;"><a id="vewChk"> </a></td>
						<td align="center" style="width:80px; color:black;"><a id="vewOdate"> </a></td>
						<td align="center" style="width:100px; color:black;"><a id="vewNoa"> </a></td>
						<td align="center" style="width:80px; color:black;"><a id="vewNick"> </a></td>
						<td align="center" style="width:20px; color:black;display:none;"><a id="vewEnd2"> </a></td>
					</tr>
					<tr>
						<td ><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='odate'>~odate</td>
						<td align="center" class="control_noa" id='noa'>~noa</td>
						<td align="center" id='nick'>~nick</td>
						<td id="end2" class="control_end2" style="text-align: center;display:none;">~end2</td>
					</tr>
				</table>
			</div>
			<div class="dbbm">
				<table class="tbbm"  id="tbbm">
					<tr style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblOdate' class="lbl"> </a></td>
						<td><input id="txtOdate" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td>
							<a id='lblIsproj' class="lbl" style="float:right;"> </a><span> </span>
							<input id="chkIsproj" type="checkbox" style="float:right;"/>
						</td>
						<td style="display:none;"><span> </span><a id='lblKind' class="lbl"> </a></td>
						<td>
							<select id="cmbKind" class="txt c1" style="display:none;"> </select>
							<select id="cmbKind2" class="txt c1" style="display:none;"> </select>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAcomp' class="lbl btn"> </a></td>
						<td colspan="4">
							<input id="txtCno" type="text" style="float:left;width:25%;"/>
							<input id="txtAcomp" type="text" style="float:left;width:75%;"/>
						</td>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td colspan="2"><input id="txtNoa"   type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td ><span> </span><a id="lblTgg" class="lbl btn"> </a></td>
						<td colspan="4">
							<input id="txtTggno" type="text" style="float:left;width:25%;"/>
							<input id="txtTgg"  type="text" style="float:left;width:75%;"/>
							<input id="txtNick"  type="text" style="display:none;"/>
						</td>
						<td><span> </span><a id='lblContract_st' class="lbl"> </a></td>
						<td colspan="2"><input id="txtContract"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td colspan="4"><input id="txtTel"  type="text"  class="txt c1"/></td>
						<td style="display: none"><span> </span><a id='lblOrdb' class="lbl btn"> </a></td>
						<td colspan="2" style="display: none"><input id="txtOrdbno" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblFax' class="lbl"> </a></td>
						<td colspan="4"><input id="txtFax" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblSales" class="lbl btn"> </a></td>
						<td colspan="2">
							<input id="txtSalesno" type="text" style="float:left;width:50%;"/>
							<input id="txtSales" type="text" style="float:left;width:50%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr' class="lbl"> </a></td>
						<td colspan="4" >
							<input id="txtPost"  type="text" style="float:left; width:25%;"/>
							<input id="txtAddr"  type="text" style="float:left; width:75%;"/>
						</td>
						<td><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td colspan="2">
							<input id="txtPaytype" type="text" style="float:left; width:115px;"/>
							<select id="combPaytype" style="float:left; width:25px;"> </select>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td colspan="4" >
							<input id="txtPost2"  type="text" style="float:left; width:25%;"/>
							<input id="txtAddr2"  type="text" style="float:left; width:75%;"/>
						</td>
						<td><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td><select id="cmbTrantype" class="txt" style="float:left; width:100%;"> </select></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTotalus' class="lbl"> </a></td>
						<td><input id="txtTotalus" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblFloata' class="lbl"> </a></td>
						<td><input id="txtFloata" type="text" class="txt num c1" /></td>
						<td>
							<span style="float:left;display:block;width:10px;"> </span>
							<select id="cmbCoin" style="float:left;width:80px;" onchange='coin_chg()' > </select>
						</td>
						<td class="st"><span> </span><a id='lblWeight' class="lbl"> </a></td>
						<td class="st"><input id="txtWeight"  type="text" class="txt num c1"/></td>
						<td>
                            <a id='lblEnd' class="lbl" style="float:right;"> </a><span> </span>
                            <input id="chkEnda" type="checkbox" style="float:right;"/>
                        </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td><input id="txtMoney" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td><input id="txtTax" type="text" class="txt num c1" /></td>
						<td>
							<span style="float:left;display:block;width:10px;"> </span>
							<select id="cmbTaxtype" style="float:left;width:80px;" > </select>
						</td>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal" type="text" class="txt num c1" /></td>
						<td>
                            <a id='lblCancel' class="lbl" style="float:right;"> </a><span> </span>
                            <input id="chkCancel" type="checkbox" style="float:right;"/>
                        </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMemo' class="lbl"> </a></td>
						<td colspan="7"><textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td><input id="txtWorker2"  type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblApv" class="lbl"> </a></td>
						<td><input id="txtApv" type="text"  class="txt c1" disabled="disabled"/></td>
						<td><span> </span><a class="lbl">連絡人</a></td>
						<td><input id="txtPostname"  type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs'>
			<table id="tbbs" class='tbbs' style=' text-align:center'>
				<tr style='color:white; background:#003366;' >
					<td  align="center" style="width:30px;"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:80px;"><a>序</a></td>
					<td align="center" style="width:120px;"><a>品號<BR>品名</a></td>
					<td class="st hide01" align="center" style="width:30px;"><a id='lblStyle_st'> </a></td>
					<td class="st hide01" align="center" style="width:100px;"><a>鋼廠</a><BR><a id='lblSize_ps'>板面</a></td>
					<td align="center" style="width:140px;display:none;" class="pk">規範<BR>國別</td>
					<td class="st hide01" align="center" style="width:350px;" id='Size'>
						<a id='lblSize_help'>厚度 x 寬度/OD x 長度/ID x 寬度2 x 寬度3 </a>
					</td>
					<td align="center" style="width:80px;"><a id='lblMount_st'> </a></td>
					<td align="center" style="width:50px;display:none;" class="pk"><a>數量<br>單位</a></td>
					<td class="st hide01" align="center" style="width:80px;"><a id='lblWeights_st'> </a></td>
					<td align="center" style="width:50px;"><a>計價<br>單位</a></td>
					<td align="center" style="width:80px;"><a id='lblPrices_st'> </a></td>
					<td align="center" style="width:100px;">
						<a id='lblTotal_st'> </a><br>
						<a class="st" id='lblTheory_st'> </a>
					</td>
					<td align="center" style="width:70px;"><a id='lblOmount_ps'>折數</a></td>
					<td align="center" style="width:80px;">
						<a id='lblC1_st'> </a><br>
						<a id='lblNotv_st'> </a>
					</td>
					<td align="center" style="width:150px;"><a id='lblUno_ps'>爐號</a></td>
					<td align="center" style="width:180px;">
                        <a id='lblMemos_st'> </a>
                    </td>
					<td align="center" style="width:30px;"><a id='lblEnda_st'> </a></td>
					<td align="center" style="width:30px;"><a id='lblCancel_st'>取消</a></td>
					<td align="center" style="width:40px;"><a id='lblOrdcrecord'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center"><input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" /></td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td><input id="txtNo2.*" type="text" style="width:95%;"/></td>
					<td>
						<input class="st" id="txtProductno.*" type="text" style="width:95%;" />
						<input class="btn" id="btnProduct.*" type="button" style="display:none;"/>
						<input class="bcc" type="text" id="txtProductno1.*"  style="width:95%;display:none;"/>
						<input class="btn"  id="btnProductno1.*" type="button" style="display:none;"/>
						<input type="text" id="txtProduct.*" style="width:95%;" />
					</td>
					<td class="st hide01">
						<input type="text" id="txtStyle.*" style="width:95%;text-align:center;" />
						<input id="btnStyle.*" type="button" style="display:none;" value="."/>
					</td>
					<td class="st hide01">
						<input id="txtSource.*" type="text" style='width: 95%;'/>
						<input id="txtSpec.*" type="text" style="float:left;width:98%;"/>
					</td>
					<td style="display:none;" class="pk">
                        <input id="txtUcolor.*" type="text" style="width:95%;"/>
                        <input id="txtScolor.*" type="text" style="width:95%;"/>
                    </td>
					<td class="st hide01">
						<input class="txt num" id="textSize1.*" type="text" style="float: left;width:55px;" disabled="disabled"/>
						<div id="x1.*" style="float: left;display:block;width:20px;padding-top: 4px;" >
							x
						</div>
						<input class="txt num" id="textSize2.*" type="text" style="float: left;width:55px;"  disabled="disabled"/>
						<div id="x2.*" style="float: left;display:block;width:20px;padding-top: 4px;">
							x
						</div>
						<input class="txt num" id="textSize3.*" type="text" style="float: left;width:55px;" disabled="disabled"/>
						<div id="x3.*" style="float: left;display:block;width:20px;padding-top: 4px;">
							x
						</div>
						<input class="txt num" id="textSize4.*" type="text"  style="float: left;width:55px;" disabled="disabled"/>
						<div id="x4.*" style="float: left;display:block;width:20px;padding-top: 4px;">
                            x
                        </div>
                        <input class="txt num" id="textSize5.*" type="text"  style="float: left;width:55px;" disabled="disabled"/>
						<!--上為虛擬下為實際-->
						<input id="txtRadius.*" type="text" style="display:none;"/>
						<input id="txtWidth.*" type="text" style="display:none;"/>
						<input id="txtDime.*" type="text" style="display:none;"/>
						<input id="txtLengthb.*" type="text" style="display:none;"/>
						<input id="txtLengthc.*" type="text" style="display:none;"/>
					</td>
					<td><input id="txtMount.*" type="text" class="txt num" style="width:95%;"/></td>
					<td style="display:none;" class="pk"><input id="txtUnit2.*" type="text" style="width:95%;"/></td>
					<td class="st hide01"><input id="txtWeight.*" type="text" class="txt num" style="width:95%;"/></td>
					<td><input id="txtUnit.*" type="text" style="width:95%;"/></td>
					<td><input id="txtPrice.*" type="text"  class="txt num" style="width:95%;"/></td>
					<td>
						<input id="txtTotal.*" type="text" class="txt num" style="width:97%;"/>
						<input id="txtTheory.*" type="text" class="txt num st" style="width:97%;"/>
					</td>
					<td><input id="txtOmount.*" type="text"  class="txt num" style="width:95%;"/></td>
					<td>
						<input id="txtC1.*" type="text" class="txt num" style="width:97%;"/>
						<input id="txtNotv.*" type="text" class="txt num" style="width:97%;"/>
					</td>
					<td>
						<input id="btnUno.*" type="button" value='.' style="float:left;width:1%;"/>
						<input id="txtUno.*" type="text" style="float:left;width:85%;" />
					</td>
					<td >
                        <input id="txtMemo.*" type="text" style="width:97%; float:left;"/>
                        <!--<input id="txtOrdbno.*" type="text"  style="width:70%;float:left;"/>
                        <input id="txtNo3.*" type="text"  style="width:20%;float:left;"/>-->
                    </td>
					<td><input id="chkEnda.*" type="checkbox"/></td>
					<td><input id="chkCancel.*" type="checkbox"/></td>
					<td><input class="btn"  id="btnOrdcrecord.*" type="button" value='.' style=" font-weight: bold;" />	</td>
				</tr>
			</table>
		</div>
		<div id="dbbt" style="display: none;">
            <table id="tbbt" class='tbbt'  border="2"  cellpadding='2' cellspacing='1'>
                <tr style='color:white; background:#003366;' >
                    <td class="td1" align="center" style="width:1%; max-width:20px;">
                    <input class="btn"  id="btnPlut" type="button" value='+' style="font-weight: bold;"  />
                    </td>
                    <td align="center" style="width:20px;"> </td>
                    <td align="center" style="width:80px;"><a>序</a><a style="color:red;">*必填</a></td>
                    <td align="center" style="width:200px;"><a>訂單</a></td>
                    <td align="center" style="width:200px;"><a>客戶</a></td>
                    <td align="center" style="width:100px;"><a>重量</a></td>
                </tr>
                <tr>
                    <td align="center">
                    	<input class="btn"  id="btnMinut..*" type="button" value='-' style="font-weight: bold; "  />
                    	<input class="txt" id="txtNoq..*" type="text" style="display:none;"  />
                    </td>
                    <td><a id="lblNo..*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
                    <td><input class="txt" id="txtNo2..*" type="text" style="width:95%;"/></td>
                    <td>
                    	<input type="text" id="txtOrdeno..*" class="txt" style="width:80%;"  />
                    	<input type="text" id="txtNo4..*" class="txt" style="width:15%;"  />
                    	<input type="button" id="btnOrdeno..*" value="." style="display:none;">
                    </td>
                    <td>
                    	<input type="text" id="txtCustno..*" class="txt" style="width:45%;"  />
                    	<input type="text" id="txtCust..*" class="txt" style="width:50%;"  />
                    	<input type="button" id="btnCust..*" value="." style="display:none;">
                    </td>
                    <td><input class="txt" id="txtWeight..*" type="text" style="width:95%; text-align: right;"/></td>
                </tr>
            </table>
        </div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
