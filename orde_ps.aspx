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
            qBoxNo3id = -1;
            q_desc = 1;
            q_tables = 't';
            var q_name = "orde";
            var q_readonly = ['txtApv','txtWorker','txtWorker2','txtComp','txtAcomp','txtMoney','txtTax','txtTotal','txtWeight','txtSales','txtPaytype'];
            var q_readonlys = ['txtTotal','txtTheory','txtNo2'];
            var bbmNum = [['txtMoney', 10, 0, 1], ['txtTax', 10, 0, 1], ['txtTotal', 10, 0, 1], ['txtWeight', 10, 2, 1], ['txtFloata', 10, 4, 1]];
            // 允許 key 小數
            var bbsNum = [['txtPrice', 15, 3, 1],['txtSprice', 15, 3, 1], ['txtTotal', 12, 2, 1, 1], ['txtWeight', 10, 2, 1], ['txtMount', 10, 2, 1],['txtTheory',10,1,1],['textSize1', 10, 3, 1], ['textSize2', 10, 2, 1], ['textSize3', 10, 3, 1], ['textSize4', 10, 2, 1]];
            var bbtNum = [['txtMount', 10, 2, 1], ['txtWeight', 10, 3, 1],['textSize1', 10, 3, 1], ['textSize2', 10, 2, 1], ['textSize3', 10, 3, 1], ['textSize4', 10, 2, 1]];
            var bbmMask = [];
            var bbsMask = [['txtStyle', 'A']];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'noa';
            aPop = new Array(
					['txtProductno_', 'btnProduct_', 'ucaucc', 'noa,product', 'txtProductno_', 'ucaucc_b.aspx'],
            		['txtStyle_', 'btnStyle_', 'style', 'noa,product', 'txtStyle_', 'style_b.aspx'],
            		['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
            		['txtAddr', '', 'view_road', 'memo,zipcode', '0txtAddr,txtPost', 'road_b.aspx'],
            		['txtAddr2', '', 'view_road', 'memo,zipcode', '0txtAddr2,txtPost2', 'road_b.aspx'],
            		['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
            		['txtSpec_', '', 'spec', 'noa,product', '0txtSpec_,txtSpec_', 'spec_b.aspx', '95%', '95%'],
            		['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,paytype,trantype,tel,fax,zip_comp,addr_comp', 'txtCustno,txtComp,txtNick,txtPaytype,cmbTrantype,txtTel,txtFax,txtPost,txtAddr', 'cust_b.aspx'],
					['txtProductno__', 'btnProductno__', 'assignproduct', 'noa,product', 'txtProductno__,txtProduct__', 'ucc_b.aspx']);
            brwCount2 = 12;
            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'no2'];
                bbtKey = ['noa', 'no2'];
				
                q_brwCount();
                // 計算 合適  brwCount
                q_gt('style', '', 0, 0, 0, '');
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
                // q_sqlCount=最前面 top=筆數， q_init 為載入 q_sys.xml 與 q_LIST
                $('#txtOdate').focus();
                OrdenoAndNo2On_Change();
                
                q_gt('flors_coin', '', 0, 0, 0, "flors_coin");
            });
            function main() {
                if (dataErr){// 載入資料錯誤
                    dataErr = false;
                    return;
                }
                mainForm(1);
                // 1=最後一筆  0=第一筆
                OrdenoAndNo2On_Change();
            }
            function sum() {
                if (!(q_cur == 1 || q_cur == 2))
                    return;
                $('#cmbTaxtype').val((($('#cmbTaxtype').val())?$('#cmbTaxtype').val():'1'));
                $('#txtMoney').attr('readonly', true);
                $('#txtTax').attr('readonly', true);
                $('#txtTotal').attr('readonly', true);
                $('#txtMoney').css('background-color', 'rgb(237,237,238)').css('color', 'green');
                $('#txtTax').css('background-color', 'rgb(237,237,238)').css('color', 'green');
                $('#txtTotal').css('background-color', 'rgb(237,237,238)').css('color', 'green');
                var t_mount = 0, t_price = 0, t_money = 0, t_moneyus=0, t_weight = 0, t_total = 0, t_tax = 0;
                var t_mounts = 0, t_prices = 0, t_moneys = 0, t_weights = 0;
                var t_unit = '';
                var t_float = q_float('txtFloata');
                var t_kind = (($('#cmbKind').val())?$('#cmbKind').val():'');
                t_kind = t_kind.substr(0, 1);
                for (var j = 0; j < q_bbsCount; j++) {
                    t_unit = $.trim($('#txtUnit_' + j).val()).toUpperCase();
                    t_product = $.trim($('#txtProduct_' + j).val());
                    if(t_unit.length==0 && t_product.length>0){
                        if(t_product.indexOf('管')>0)
                            t_unit = '支';
                        else
                            t_unit = 'KG';
                        $('#txtUnit_' + j).val(t_unit);
                    }
                    //---------------------------------------
                    if (t_kind == 'A') {
                        q_tr('txtDime_' + j, q_float('textSize1_' + j));
                        q_tr('txtWidth_' + j, q_float('textSize2_' + j));
                        q_tr('txtLengthb_' + j, q_float('textSize3_' + j));
                        q_tr('txtRadius_' + j, q_float('textSize4_' + j));
                    } else if (t_kind == 'B') {
                        q_tr('txtRadius_' + j, q_float('textSize1_' + j));
                        q_tr('txtWidth_' + j, q_float('textSize2_' + j));
                        q_tr('txtDime_' + j, q_float('textSize3_' + j));
                        q_tr('txtLengthb_' + j, q_float('textSize4_' + j));
                    } else {//鋼筋、胚
                        q_tr('txtLengthb_' + j, q_float('textSize3_' + j));
                    }
                    getTheory(j);
                    //---------------------------------------
                    t_weights = q_float('txtWeight_' + j);                    
                    t_mounts = q_float('txtMount_' + j);
                    t_prices = q_float('txtPrice_' + j);
                    if(t_unit.length==0 ||t_unit=='KG' || t_unit=='M2' || t_unit=='M' || t_unit=='批' || t_unit=='公斤' || t_unit=='噸' || t_unit=='頓'){
                        t_moneys = round(q_mul(t_weights,t_prices),0);              
                    }else{
                        t_moneys = round(q_mul(t_mounts,t_prices),0);
                    }
                    if(t_float==0){
                        t_moneys = round(t_moneys,0);
                    }else{
                        t_moneyus = q_add(t_moneyus,round(t_moneys,2));
                        t_moneys = round(q_mul(t_moneys,t_float),0);
                    }
                    t_weight = q_add(t_weight,t_weights);
                    t_mount = q_add(t_mount,t_mounts);
                    t_money = q_add(t_money,t_moneys);
                    $('#txtTotal_' + j).val(FormatNumber(t_moneys));
                }
                for (var j = 0; j < q_bbtCount; j++) {
                    if ($('#cmbKind').val().substr(0, 1) == 'A') {
                        q_tr('txtDime__' + j, q_float('textSize1__' + j));
                        q_tr('txtWidth__' + j, q_float('textSize2__' + j));
                        q_tr('txtLengthb__' + j, q_float('textSize3__' + j));
                        q_tr('txtRadius__' + j, q_float('textSize4__' + j));
                    } else if ($('#cmbKind').val().substr(0, 1) == 'B') {
                        q_tr('txtRadius__' + j, q_float('textSize1__' + j));
                        q_tr('txtWidth__' + j, q_float('textSize2__' + j));
                        q_tr('txtDime__' + j, q_float('textSize3__' + j));
                        q_tr('txtLengthb__' + j, q_float('textSize4__' + j));
                    } else {//鋼筋、胚
                        q_tr('txtLengthb__' + j, q_float('textSize3__' + j));
                    }
                }
                t_taxrate = parseFloat(q_getPara('sys.taxrate')) / 100;
                switch ($('#cmbTaxtype').val()) {
                    case '1': // 應稅
                        t_tax = round(q_mul(t_money,t_taxrate), 0);
                        t_total = q_add(t_money,t_tax);
                        break;
                    case '2': //零稅率
                        t_tax = 0;
                        t_total = q_add(t_money,t_tax);
                        break;
                    case '3': // 內含
                        t_tax = q_sub(t_money,round(q_div(t_money, q_add(1, t_taxrate)), 0));
                        t_total = t_money;
                        t_money = q_sub(t_total,t_tax);
                        break;
                    case '4': // 免稅
                        t_tax = 0;
                        t_total = q_add(t_money,t_tax);
                        break;
                    case '5': // 自定
                        $('#txtTax').attr('readonly', false);
                        $('#txtTax').css('background-color', 'white').css('color', 'black');
                        t_tax = round(q_float('txtTax'), 0);
                        t_total = q_add(t_money,t_tax);
                        break;
                    case '6': // 作廢-清空資料
                        t_money = 0, t_tax = 0, t_total = 0;
                        break;
                    default:
                }
                t_price = q_float('txtPrice');
                if (t_price != 0) {
                    $('#txtTranmoney').val(FormatNumber(round(q_mul(t_weight,t_price),0)));
                }
                $('#txtWeight').val(FormatNumber(t_weight));
                $('#txtMoney').val(FormatNumber(t_money));
                $('#txtTax').val(FormatNumber(t_tax));
                $('#txtTotal').val(FormatNumber(t_total));
                OrdenoAndNo2On_Change();
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
            var t_spec;  //儲存spec陣列
            function mainPost() {// 載入資料完，未 refresh 前
                q_getFormat();
                bbmMask = [['txtDatea', r_picd], ['txtOdate', r_picd]];
                bbsMask = [['txtDatea', r_picd],['txtStyle','A']];
                q_mask(bbmMask);
                q_cmbParse("cmbKind", q_getPara('sys.stktype'));
                q_cmbParse("cmbStype", q_getPara('orde.stype'));
                q_cmbParse("combPaytype", q_getPara('vcc.paytype')); 
				// comb 未連結資料庫
                q_cmbParse("cmbTrantype",q_getPara('sys.tran'));
                q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
                
                q_gt('spec', '', 0, 0, 0, "", r_accy);
                $('#cmbKind').change(function() {
                    size_change();
                    sum();
                });
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
                
                $('#txtTax').change(function() {
                    sum();
                });
                $('#txtAddr').change(function() {
                    var t_custno = trim($(this).val());
                    if (!emp(t_custno)) {
                        focus_addr = $(this).attr('id');
                        var t_where = "where=^^ noa='" + t_custno + "' ^^";
                        q_gt('cust', t_where, 0, 0, 0, "");
                    }
                });
                $('#txtAddr2').change(function() {
                    var t_custno = trim($(this).val());
                    if (!emp(t_custno)) {
                        focus_addr = $(this).attr('id');
                        var t_where = "where=^^ noa='" + t_custno + "' ^^";
                        q_gt('cust', t_where, 0, 0, 0, "");
                    }
                });
                $('#btnCredit').click(function(){
                    if(!emp($('#txtCustno').val())){
                        q_box("z_credit.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";custno='" + $('#txtCustno').val() + "';"+r_accy+";" + q_cur, 'ordei', "95%", "95%", q_getMsg('btnCredit'));
                    }
                });
                $('#btnApv').click(function(e){
                    Lock(1, {
                        opacity : 0
                    });
                    q_func('qtxt.query.apv', 'orde.txt,apv,'+ encodeURI(r_userno) + ';' + encodeURI($('#txtNoa').val()));
                });
                OrdenoAndNo2On_Change();
            }

            function q_boxClose(s2) {///   q_boxClose 2/4 /// 查詢視窗、客戶視窗、訂單視窗  關閉時執行
                var ret;
                switch (b_pop) {/// 重要：不可以直接 return ，最後需執行 originalClose();
                    case 'quats':
                        if (q_cur > 0 && q_cur < 4) {
                            b_ret = getb_ret();
                            if (!b_ret || b_ret.length == 0){
                                b_pop = '';
                                return;
                            }
                            var i, j = 0;
                            for(var i=0;i<q_bbsCount;i++){$('#btnMinus_'+i).click();}
                            for(var k=0;k<b_ret.length;k++){
                                var t_notv = dec(b_ret[k].notv);
                                var t_mount = dec(b_ret[k].mount);
                                var t_weight = dec(b_ret[k].weight);
                                var t_kind = trim(b_ret[k].kind).toUpperCase().substring(0,1);
                                if(t_kind=='B'){
                                    if(t_notv != t_mount)
                                        t_weight = round(q_mul(q_div(t_weight,t_mount),t_notv),0);
                                    t_mount = t_notv;
                                }else{
                                    if(t_notv != t_weight)
                                        t_mount = round(q_mul(q_div(t_mount,t_weight),t_notv),0);
                                    t_weight = t_notv;
                                }
                                b_ret[k].mount = t_mount;
                                b_ret[k].weight = t_weight;
                            }
                            var t_where = "where=^^ noa='"+b_ret[0].noa+"'";
                            //q_gt('quat', t_where, 0, 0, 0, "",r_accy);
                            ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtSpec,txtSize,txtRadius,txtDime,txtWidth,txtLengthb,txtUnit,txtPrice,txtMount,txtWeight,txtClass,txtTheory,txtStyle', b_ret.length, b_ret, 'productno,product,spec,size,radius,dime,width,lengthb,unit,noa,price,notv,weight,class,theory,style', 'txtProductno,txtProduct,txtSpec');
                            /// 最後 aEmpField 不可以有【數字欄位】
                            bbsAssign();
                            sum();
                        }
                        break;
                    case 'uccc':
                        if (q_cur > 0 && q_cur < 4) {
                            b_ret = getb_ret();
                            if (!b_ret || b_ret.length == 0){
                                b_pop = '';
                                return;
                            }
                            for (var j = 0; j < b_ret.length; j++) {
                                for (var i = 0; i < q_bbtCount; i++) {
                                    var t_uno = $('#txtUno__' + i).val();
                                    if (b_ret[j] && b_ret[j].uno == t_uno) {
                                        b_ret.splice(j, 1);
                                    }
                                }
                            }
                            if (b_ret && b_ret[0] != undefined) {
                                ret = q_gridAddRow(bbtHtm, 'tbbt','txtProduct,txtProductno,txtRadius,txtDime,txtWidth,txtLengthb,txtMount,txtWeight,txtSource', b_ret.length, b_ret, 'uno,product,productno,radius,dime,width,lengthb,mount,weight,source', 'txtProduct,txtProductno', '__');
                                /// 最後 aEmpField 不可以有【數字欄位】
                                /*if (qBoxNo3id != -1) {
                                    for (var i = 0; i < ret.length; i++) {
                                        $('#txtNo3__' + ret[i]).val(padL($('#lblNo_' + qBoxNo3id).text(), '0', 3));
                                    }
                                }*/
                                qBoxNo3id = -1;
                            }
                            bbsAssign();
                            sum();
                        }
                        break;
                    case q_name + '_s':
                        q_boxClose2(s2);
                        ///   q_boxClose 3/4
                        break;
                }/// end Switch
                size_change();
                b_pop = '';
                OrdenoAndNo2On_Change();
            }
            var focus_addr = '';
            var StyleList = '';
            var t_uccArray = new Array;
            function q_gtPost(t_name) {/// 資料下載後 ...
                switch (t_name) {
                	case 'flors_coin':
						var as = _q_appendData("flors", "", true);
						var z_coin='';
						for ( i = 0; i < as.length; i++) {
							z_coin+=','+as[i].coin;
						}
						if(z_coin.length==0) z_coin=' ';
						
						q_cmbParse("cmbCoin", z_coin);
						if(abbm[q_recno])
							$('#cmbCoin').val(abbm[q_recno].coin);
						
						break;
					case 'flors':
						var as = _q_appendData("flors", "", true);
						if (as[0] != undefined) {
							q_tr('txtFloata',as[0].floata);
							sum();
						}
						break;
                    case 'refreshEnd2':
                        var as = _q_appendData("orde", "", true);
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
                        if(as[0]!=undefined){
                            $('#txtCno').val(as[0].noa);
                            $('#txtAcomp').val(as[0].nick);
                        }
                        Unlock(1);
                        $('#chkIsproj').attr('checked',true);
                        $('#txtNoa').val('AUTO');
                        $('#cmbKind').val(q_getPara('vcc.kind'));
                        size_change();
                        $('#txtOdate').val(q_date());
                        OrdenoAndNo2On_Change();
                        $('#txtCno').focus();
                        break;
                    case 'spec':
                        t_spec = _q_appendData("spec", "", true);
                        break;
                    case 'style' :
                        var as = _q_appendData("style", "", true);
                        StyleList = new Array();
                        StyleList = as;
                        break;
                    case 'cust':
                        var as = _q_appendData("cust", "", true);
                        if (as[0] != undefined && focus_addr != '') {
                            $('#' + focus_addr).val(as[0].addr_fact);
                            focus_addr = '';
                        }
                        break;
                    /*case 'quat':
                        var as = _q_appendData("quat", "", true);
                        if (as[0] != undefined) {
                            (trim($('#txtTel').val())==''?$('#txtTel').val(as[0].tel):'');
                            (trim($('#txtFax').val())==''?$('#txtFax').val(as[0].fax):'');
                            (trim($('#txtPost').val())==''?$('#txtPost').val(as[0].post):'');
                            (trim($('#txtAddr').val())==''?$('#txtAddr').val(as[0].addr):'');
                            (trim($('#txtPost2').val())==''?$('#txtPost2').val(as[0].post2):'');
                            (trim($('#txtAddr2').val())==''?$('#txtAddr2').val(as[0].addr2):'');
                            (trim($('#txtSalesno').val())==''?$('#txtSalesno').val(as[0].salesno):'');
                            (trim($('#txtSales').val())==''?$('#txtSales').val(as[0].sales):'');
                            (trim($('#txtPaytype').val())==''?$('#txtPaytype').val(as[0].paytype):'');
                            $('#cmbTrantype').val(as[0].trantype);
                            (trim($('#txtFloata').val())==''?$('#txtFloata').val(as[0].floata):'');
                            $('#cmbCoin').val(as[0].coin);
                        }*/                       
                    case q_name:
                        t_uccArray = _q_appendData("ucc", "", true);
                        if (q_cur == 4)// 查詢
                            q_Seek_gtPost();
                        break;
                    default:
                        if (t_name.substring(0, 15) == 'checkUccbMount_') {
                            var t_seq = parseInt(t_name.split('_')[1]);
                            var as = _q_appendData("view_uccb", "", true);
                            if (as[0] != undefined) {
                                var t_weight = q_div(dec(as[0].weight),dec(dec(as[0].mount)));
                                if(isNaN(t_weight) || t_weight==Infinity ){
                                    return;
                                }else{
                                    var t_mount = dec($('#txtMount__'+t_seq).val());
                                    $('#txtWeight__'+t_seq).val(q_mul(t_weight,t_mount));
                                }
                            }
                        }
                    
                        break;
                }  /// end switch
                OrdenoAndNo2On_Change();
            }
            function distinct(arr1){
                var uniArray = [];
                for(var i=0;i<arr1.length;i++){
                    var val = arr1[i];
                    if($.inArray(val, uniArray)===-1){
                        uniArray.push(val);
                    }
                }
                return uniArray;
            }
            /*function btnQuat() {
                var t_custno = trim($('#txtCustno').val());
                var t_where = '1=1 ';
                if (t_custno.length > 0) {
                    t_where += (t_custno.length > 0 ? q_sqlPara2("custno", t_custno) : "");
                    ////  sql AND 語法，請用 &&
                    t_where = t_where;
                } else {
                    alert(q_getMsg('msgCustEmp'));
                    return;
                }
                var distinctArray = new Array;
                var inStr = '';
                var t_noa = $('#txtNoa').val();
                for(var i=0;i<abbs.length;i++){
                    if(abbs[i].noa == t_noa)
                        distinctArray.push(abbs[i].quatno+abbs[i].no3);
                }
                distinctArray = distinct(distinctArray);
                for(var i=0;i<distinctArray.length;i++){
                    if(trim(distinctArray[i]) != '')
                        inStr += "'"+distinctArray[i]+"',";
                }
                inStr = inStr.substring(0,inStr.length-1);
                if (q_getPara('sys.project').toUpperCase()=="RS"){//祥興報價重量數量會為0
                	t_where += " and kind='" +$('#cmbKind').val()+ "' and (((enda='0') and (notv > 0 or notv = 0))"+(trim(inStr).length>0?" or noa+no3 in("+inStr+") ":'')+")";
                }else{
                	t_where += " and kind='" +$('#cmbKind').val()+ "' and (((enda='0') and (notv > 0))"+(trim(inStr).length>0?" or noa+no3 in("+inStr+") ":'')+")";
                }
                q_box("quatst_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where + ";" + r_accy, 'quats', "95%", "95%", q_getMsg('popQuats'));
            }*/
            
            function coin_chg() {
				var t_where = "where=^^ ('" + $('#txtDatea').val() + "' between bdate and edate) and coin='"+$('#cmbCoin').find("option:selected").text()+"' ^^";
				q_gt('flors', t_where, 0, 0, 0, "");
			}
            function btnOk() {
                OrdenoAndNo2On_Change();
                Lock(1, {
                    opacity : 0
                });
                if ($('#txtOdate').val().length == 0 || !q_cd($('#txtOdate').val())) {
                    alert(q_getMsg('lblOdate') + '錯誤。');
                    Unlock(1);
                    return;
                }
                /*for(var i=0;i<q_bbsCount;i++){
                    if(q_float('txtMount_'+i)!=0 && !$('#chkSale_'+i).prop('checked') && !$('#chkIscut_'+i).prop('checked')){
                        $('#chkCut_'+i).prop('checked',true);
                    }
                    getTheory(i);
                }*/
                var t_chk;
                /*for(var i=0;i<q_bbtCount;i++){
                    if($.trim($('#txtUno__'+i).val()).length>0){
                        if($.trim($('#txtNo3__'+i).val()).length==0){
                            alert('請輸入訂序');
                            Unlock(1);
                            return;
                        }else{
                            t_chk = false;
                            for(var j=0;j<q_bbsCount;j++){
                                if($.trim($('#txtNo3__'+i).val())==$.trim($('#txtNo2_'+j).val())){
                                    t_chk = true;
                                    break;
                                }
                            }
                            if(!t_chk){
                                alert('【'+$.trim($('#txtNo3__'+i).val())+'】訂序異常');
                                Unlock(1);
                                return;
                            }
                        }
                    }
                }*/
                if (q_cur == 1)
                    $('#txtWorker').val(r_name);
                else
                    $('#txtWorker2').val(r_name);
                sum();
                if($('#txtCustno').val().length==0){
                    alert('請輸入'+q_getMsg('lblCust'));
                    Unlock(1);
                    return;
                }
                q_func('qtxt.query.orde', 'credit.txt,orde,'+ encodeURI($('#txtCustno').val()) + ';' + encodeURI($('#txtNoa').val()));
            }
            function save(){
                var s1 = $('#txtNoa').val();
                if (s1.length == 0 || s1 == "AUTO")/// 自動產生編號
                	if(q_getPara('sys.comp').indexOf('傑期')>-1){
                		q_gtnoa(q_name, $('#txtOdate').val().substring(0,3),r_accy,4);
                	}else{
                		q_gtnoa(q_name, replaceAll(q_getPara('sys.key_orde') + $('#txtOdate').val(), '/', ''));
                	}
                    
                else
                    wrServer(s1);
            }
            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                q_gt('orde',"where=^^ noa='"+$.trim($('#txtNoa').val())+"'^^", 0, 0, 0, 'refreshEnd2', r_accy);
                Unlock(1);
                OrdenoAndNo2On_Change();
            }
            function q_funcPost(t_func, result) {
                switch(t_func) {
                    case 'qtxt.query.conform':
                        var as = _q_appendData("tmp0", "", true, true);
                        if(as[0]!=undefined){
                            var err = as[0].err;
                            var msg = as[0].msg;
                            var ordeno = as[0].ordeno;  
                            var userno = as[0].userno;  
                            var namea = '*';//as[0].namea;
                            if(err=='1'){
                                for(var i=0;i<abbm.length;i++){
                                    if(abbm[i].noa==ordeno){
                                        abbm[i].conform=namea;
                                        break;
                                    }
                                }
                                var obj = $('#tview').find('#noa');
                                for(var i=0;i<obj.length;i++){
                                    if(obj.eq(i).html()==ordeno){
                                        $('#tview').find('#conform').eq(i).html(namea);
                                        break;                                      
                                    }
                                }
                            }else{
                                alert(msg); 
                            }
                        }
                        Unlock(1);
                        break;
                    case 'qtxt.query.apv':
                        var as = _q_appendData("tmp0", "", true, true);
                        if(as[0]!=undefined){
                            var err = as[0].err;
                            var msg = as[0].msg;
                            var ordeno = as[0].ordeno;  
                            var userno = as[0].userno;  
                            var namea = as[0].namea;
                            if(err=='1'){
                                $('#txtApv').val(namea);
                                for(var i=0;i<abbm.length;i++){
                                    if(abbm[i].noa==ordeno){
                                        abbm[i].apv=namea;
                                        break;
                                    }
                                }
                                var obj = $('#tview').find('#noa');
                                for(var i=0;i<obj.length;i++){
                                    if(obj.eq(i).html()==ordeno){
                                        $('#tview').find('#apv').eq(i).html(namea);
                                        break;                                      
                                    }
                                }
                            }else{
                                alert(msg); 
                            }
                        }
                        Unlock(1);
                        break;
                    case 'qtxt.query.orde':
                        var as = _q_appendData("tmp0", "", true, true);                     
                        if(as[0]!=undefined){
                            var total = parseFloat(as[0].total.length==0?"0":as[0].total);
                            var credit = parseFloat(as[0].credit.length==0?"0":as[0].credit);
                            var gqb = parseFloat(as[0].gqbMoney.length==0?"0":as[0].gqbMoney);
                            var vcc = parseFloat(as[0].vccMoney.length==0?"0":as[0].vccMoney);
                            var orde = parseFloat(as[0].ordeMoney.length==0?"0":as[0].ordeMoney);
                            var umm = parseFloat(as[0].ummMoney.length==0?"0":as[0].ummMoney);
                            var curorde = 0;
                            var curtotal = 0;
                            
                            for(var i=0;i<q_bbsCount;i++){
                                curorde = q_add(curorde,q_float('txtTotal_'+i));                     
                            }
                            curtotal = credit - gqb - vcc -orde - umm - curorde;
                            if(curtotal<0){
                                var t_space = '          ';
                                var msg = as[0].custno+'-'+as[0].cust+'\n'
                                +' 基本額度：'+(t_space+q_trv(credit)).replace(/^.*(.{10})$/,'$1')+'\n'
                                +'-應收票據：'+(t_space+q_trv(gqb)).replace(/^.*(.{10})$/,'$1')+'\n'
                                +'-應收帳款：'+(t_space+q_trv(vcc)).replace(/^.*(.{10})$/,'$1')+'\n'
                                +'-未出訂單：'+(t_space+q_trv(orde)).replace(/^.*(.{10})$/,'$1')+'\n'
                                +'-預收貨款：'+(t_space+q_trv(umm)).replace(/^.*(.{10})$/,'$1')+'\n'
                                +'-本張訂單：'+(t_space+q_trv(curorde)).replace(/^.*(.{10})$/,'$1')+'\n'
                                +'----------------------------'+'\n'
                                +'額度餘額：'+(t_space+q_trv(curtotal)).replace(/^.*(.{10})$/,'$1');
                                alert(msg);
                                Unlock(1);
                                return;
                            }                 
                        }
                        save();
                        break;
                }
            }
            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;
                q_box('ordest_s.aspx', q_name + '_s', "550px", "700px", q_getMsg("popSeek"));
            }
            function bbtAssign() {
                for (var j = 0; j < q_bbtCount; j++) {
                    $('#lblNo__' + j).text(j + 1);
                    $('#textSize1__' + j).change(function() {
                        sum();
                    });
                    $('#textSize2__' + j).change(function() {
                        sum();
                    });
                    $('#textSize3__' + j).change(function() {
                        sum();
                    });
                    $('#textSize4__' + j).change(function() {
                        sum();
                    });
                    $('#txtMount__'+j).change(function(){
                        var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
                        q_gt('view_uccb',"where=^^ uno='"+$.trim($('#txtUno__'+n).val())+"'^^", 0, 0, 0, 'checkUccbMount_'+n, r_accy);
                    });
                }
                _bbtAssign();
                OrdenoAndNo2On_Change();
            }
            function getTheory(b_seq) {
                t_Radius = dec($('#txtRadius_' + b_seq).val());
                t_Width = dec($('#txtWidth_' + b_seq).val());
                t_Dime = dec($('#txtDime_' + b_seq).val());
                t_Lengthb = dec($('#txtLengthb_' + b_seq).val());
                t_Mount = dec($('#txtMount_' + b_seq).val());
                t_Style = $('#txtStyle_' + b_seq).val();
                t_Stype = ($('#cmbStype').find("option:selected").text() == '外銷' ? 1 : 0);
                t_Productno = $('#txtProductno_' + b_seq).val();
                var theory_setting={
                    calc:StyleList,
                    ucc:t_uccArray,
                    radius:t_Radius,
                    width:t_Width,
                    dime:t_Dime,
                    lengthb:t_Lengthb,
                    mount:t_Mount,
                    style:t_Style,
                    stype:t_Stype,
                    productno:t_Productno,
                    round:1
                };
                if ($('#cmbKind').val().substr(1, 1) == '4') {//鋼胚
                    q_tr('txtTheory_' + b_seq, round(t_Mount * theory_bi(t_spec, $('#txtSpec_' + b_seq).val(), t_Dime, t_Width, t_Lengthb), 0));
                } else {
                    q_tr('txtTheory_' + b_seq, theory_st(theory_setting));
                }
                var t_Product = $('#txtProduct_' + b_seq).val();
                if(dec($('#txtWeight_' + b_seq).val()) == 0){
                    $('#txtWeight_' + b_seq).val($('#txtTheory_' + b_seq).val());
                }
            }
            function bbsAssign() {/// 表身運算式
                /*$('input[id*="btnOrdet_"]').each(function(){
                    $(this).val($('#lblOrdet_st').text());
                });*/
                var maxNo2 = 0;
                var tmpNo2 = 0;
                try{
                    for (var j = 0; j < q_bbsCount; j++) {
                        tmpNo2 = parseInt($.trim($('#txtNo2_'+j).val()).length==0 ?"0":$.trim($('#txtNo2_'+j).val()));
                        maxNo2 = tmpNo2>maxNo2?tmpNo2:maxNo2;
                    }
                }catch(e){
                    alert('訂序異常。');
                }
                for (var j = 0; j < q_bbsCount; j++) {
                    $('#lblNo_' + j).text(j + 1); 
					
                    if($('#txtNo2_'+j).val().length==0){
                        maxNo2++;
                        tmpNo2 = ('00'+maxNo2).substring(('00'+maxNo2).length-3,('00'+maxNo2).length);
                        $('#txtNo2_'+j).val(tmpNo2);
                    }
                    if (!$('#btnMinus_' + j).hasClass('isAssign')) {
					
						$('#txtProductno_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnProduct_'+n).click();
						});
						
						$('#txtStyle_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnStyle_'+n).click();
						});
						
                        $('#txtUnit_' + j).focusout(function() {
                            sum();
                        });
                        $('#txtWeight_' + j).focusout(function() {
                            sum();
                        });
                        $('#txtPrice_' + j).focusout(function() {
                        	if(!(q_cur==1 || q_cur==2))
                        		return;
                            var n = $(this).attr('id').replace('txtPrice_','');
                            t_unit = $.trim($('#txtUnit_' + n).val()).toUpperCase();
                            t_product = $.trim($('#txtProduct_' + n).val());
                            t_weights = q_float('txtWeight_' + n);                    
                            t_mounts = q_float('txtMount_' + n);
                            if(t_unit.length==0 && t_product.length>0){
                                if(t_product.indexOf('管')>0)
                                    t_unit = '支';
                                else
                                    t_unit = 'KG';
                                $('#txtUnit_' + n).val(t_unit);
                            }                 
                            t_prices = q_float('txtPrice_' + n);    
                            if(t_unit.length==0 ||t_unit=='KG' || t_unit=='M2' || t_unit=='M' || t_unit=='批' || t_unit=='公斤' || t_unit=='噸' || t_unit=='頓'){
                                t_moneys = q_mul(t_prices,t_weights);
                            }else{
                                t_moneys = q_mul(t_prices,t_mounts);
                            }
                            t_sprices = t_weights==0?0: round(q_div(t_moneys,t_weights),3);
                            $('#txtSprice_'+n).val(t_sprices);
                            sum();
                        });
                        $('#txtSprice_' + j).focusout(function() {
                        	if(!(q_cur==1 || q_cur==2))
                        		return;
                            var n = $(this).attr('id').replace('txtSprice_','');
                            t_unit = $.trim($('#txtUnit_' + n).val()).toUpperCase();
                            t_product = $.trim($('#txtProduct_' + n).val());
                            t_weights = q_float('txtWeight_' + n);                    
                            t_mounts = q_float('txtMount_' + n);
                            if(t_unit.length==0 && t_product.length>0){
                                if(t_product.indexOf('管')>0)
                                    t_unit = '支';
                                else
                                    t_unit = 'KG';
                                $('#txtUnit_' + n).val(t_unit);
                            }                 
                            t_sprices = q_float('txtSprice_' + n);   
                            if(t_unit.length==0 ||t_unit=='KG' || t_unit=='M2' || t_unit=='M' || t_unit=='批' || t_unit=='公斤' || t_unit=='噸' || t_unit=='頓'){
                                t_moneys = round(q_mul(t_weights,t_sprices),3);
                                t_prices = t_weights==0?0: round(q_div(t_moneys,t_weights),3);                
                            }else{
                                t_moneys = round(q_mul(t_weights,t_sprices),3);
                                t_prices = t_mounts==0?0: round(q_div(t_moneys,t_mounts),3);
                            }
                            $('#txtPrice_'+n).val(t_prices);
                            sum();
                        });
                        $('#txtMount_' + j).focusout(function() {
                        	if(!(q_cur==1 || q_cur==2))
                        		return;
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							sum();
							$('#txtWeight_'+n).val($('#txtTheory_'+n).val());
                        });
                        $('#txtStyle_' + j).blur(function() {
                            $('input[id*="txtProduct_"]').each(function() {
                                thisId = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
                                $(this).attr('OldValue',$('#txtProductno_'+thisId).val());
                            });
                            var n = $(this).attr('id').replace('txtStyle_', '');
                            ProductAddStyle(n);
                        });
						
                        //計算理論重
                        $('#textSize1_' + j).change(function() {sum();});
                        $('#textSize2_' + j).change(function() {sum();});
                        $('#textSize3_' + j).change(function() {sum();});
                        $('#textSize4_' + j).change(function() {sum();});
                        $('#txtSize_'+j).change(function(e){
                            if ($.trim($(this).val()).length == 0)
                                return;
                            var n = $(this).attr('id').replace('txtSize_','');          
                            var data = tranSize($.trim($(this).val()));
                            $(this).val(tranSize($.trim($(this).val()),'getsize'));
                            $('#textSize1_'+n).val('');
                            $('#textSize2_'+n).val('');
                            $('#textSize3_'+n).val('');
                            $('#textSize4_'+n).val('');
                            if($('#cmbKind').val()=='A1'){//鋼捲鋼板
                                if(!(data.length==2 || data.length==3)){
                                    alert(q_getPara('transize.error01'));
                                    return;
                                }
                                $('#textSize1_'+n).val((data[0]!=undefined?(data[0].toString().length>0?(isNaN(parseFloat(data[0]))?0:parseFloat(data[0])):0):0));
                                $('#textSize2_'+n).val((data[1]!=undefined?(data[1].toString().length>0?(isNaN(parseFloat(data[1]))?0:parseFloat(data[1])):0):0));
                                $('#textSize3_'+n).val((data[2]!=undefined?(data[2].toString().length>0?(isNaN(parseFloat(data[2]))?0:parseFloat(data[2])):0):0));
                                sum();
                            }else if($('#cmbKind').val()=='A4'){//鋼胚
                                if(!(data.length==2 || data.length==3)){
                                    alert(q_getPara('transize.error04'));
                                    return;
                                }
                                $('#textSize1_'+n).val((data[0]!=undefined?(data[0].toString().length>0?(isNaN(parseFloat(data[0]))?0:parseFloat(data[0])):0):0));
                                $('#textSize2_'+n).val((data[1]!=undefined?(data[1].toString().length>0?(isNaN(parseFloat(data[1]))?0:parseFloat(data[1])):0):0));
                                $('#textSize3_'+n).val((data[2]!=undefined?(data[2].toString().length>0?(isNaN(parseFloat(data[2]))?0:parseFloat(data[2])):0):0));
                            }else if($('#cmbKind').val()=='B2'){//鋼管
                                if(!(data.length==3 || data.length==4)){
                                    alert(q_getPara('transize.error02'));
                                    return;
                                }
                                if(data.length==3){
                                    $('#textSize1_'+n).val((data[0]!=undefined?(data[0].toString().length>0?(isNaN(parseFloat(data[0]))?0:parseFloat(data[0])):0):0));
                                    $('#textSize3_'+n).val((data[1]!=undefined?(data[1].toString().length>0?(isNaN(parseFloat(data[1]))?0:parseFloat(data[1])):0):0));
                                    $('#textSize4_'+n).val((data[2]!=undefined?(data[2].toString().length>0?(isNaN(parseFloat(data[2]))?0:parseFloat(data[2])):0):0));
                                }else{
                                    $('#textSize1_'+n).val((data[0]!=undefined?(data[0].toString().length>0?(isNaN(parseFloat(data[0]))?0:parseFloat(data[0])):0):0));
                                    $('#textSize2_'+n).val((data[1]!=undefined?(data[1].toString().length>0?(isNaN(parseFloat(data[1]))?0:parseFloat(data[1])):0):0));
                                    $('#textSize3_'+n).val((data[2]!=undefined?(data[2].toString().length>0?(isNaN(parseFloat(data[2]))?0:parseFloat(data[2])):0):0));
                                    $('#textSize4_'+n).val((data[3]!=undefined?(data[3].toString().length>0?(isNaN(parseFloat(data[3]))?0:parseFloat(data[3])):0):0));
                                }
                            }else if($('#cmbKind').val()=='C3'){//鋼筋
                                if(data.length!=1){
                                    alert(q_getPara('transize.error03'));
                                    return;
                                }
                                $('#textSize1_'+n).val((data[0]!=undefined?(data[0].toString().length>0?(isNaN(parseFloat(data[0]))?0:parseFloat(data[0])):0):0));
                            }else{
                                //nothing
                            }
                            sum();
                        });
                        $('#txtSpec_' + j).change(function() {
                            sum();
                        });
                    }
                }
				
				
                _bbsAssign();
                size_change();
                OrdenoAndNo2On_Change();
            }
            function btnIns() {
                _btnIns();
                $('#cmbTaxtype').val(1);
                Lock(1, {
                    opacity : 0
                });
                q_gt('acomp', '', 0, 0, 0, 'getAcomp', r_accy);
            }
            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                size_change();
                $('#txtApv').val('');
                $('#txtOdate').focus();
                sum();
                OrdenoAndNo2On_Change();
            }
            function btnPrint() {
                t_where = "noa='" + $('#txtNoa').val() + "'";
                q_box("z_ordep_ps.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, '', "95%", "95%", q_getMsg('popPrint'));
            }
            function wrServer(key_value) {
                var i;
                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                xmlSql = '';
                if (q_cur == 2)/// popSave
                    xmlSql = q_preXml();
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
                OrdenoAndNo2On_Change();
            }
            function bbtSave(as) {
                if (!as['uno']) {
                    as[bbtKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }
            function bbsSave(as) {/// 表身 寫入資料庫前，寫入需要欄位
                if (!as['productno'] && !as['product'] && !as['spec'] && !dec(as['total'])) {//不存檔條件
                    as[bbsKey[1]] = '';
                    /// no2 為空，不存檔
                    return;
                }
                q_nowf();
                as['type'] = abbm2['type'];
                as['mon'] = abbm2['mon'];
                as['noa'] = abbm2['noa'];
                as['odate'] = abbm2['odate'];
                if (!emp(abbm2['datea']))/// 預交日
                    as['datea'] = abbm2['datea'];
                as['custno'] = abbm2['custno'];
                if (!as['enda'])
                    as['enda'] = '0';
                t_err = '';
                if (as['price'] != null && (dec(as['price']) > 99999999 || dec(as['price']) < -99999999))
                    t_err = q_getMsg('msgPriceErr') + as['price'] + '\n';
                if (as['total'] != null && (dec(as['total']) > 999999999 || dec(as['total']) < -99999999))
                    t_err = q_getMsg('msgMoneyErr') + as['total'] + '\n';
                if (t_err) {
                    alert(t_err);
                    return false;
                }
                return true;
            }
            
            function OrdenoAndNo2On_Change(){
            	var thissyle = trim($('#cmbKind').val());
                for(var idno=0;idno<q_bbsCount;idno++){
                    //var thisNo3 = trim($('#txtNo3_'+idno).val());
                    /*if(thisNo3.length > 0){
                        $('#textSize1_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                        $('#textSize2_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                        if (q_getPara('sys.project').toUpperCase()!="RS" || thissyle=='B2'){
                       		$('#textSize3_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                       	}
                       	if (q_getPara('sys.project').toUpperCase()!="RS"){
                       		$('#textSize4_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                       	}
                        $('#txtRadius_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                        $('#textWidth_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                        $('#textDime_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                        $('#textLengthb_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                        $('#txtProduct_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                        $('#txtSize_'+idno).attr('readonly', true).css('background-color', 'rgb(237,237,238)').css('color', 'green');
                    }else*/{
                        if(q_cur==1 || q_cur ==2){
                            $('#textSize1_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                            $('#textSize2_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                            $('#textSize3_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                            $('#textSize4_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                            $('#txtRadius_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                            $('#textWidth_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                            $('#textDime_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                            $('#textLengthb_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                            $('#txtProduct_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                            $('#txtSize_'+idno).attr('readonly', false).css('background-color', 'white').css('color', 'black');
                        }
                    }
                }
            }
            
            ///////////////////////////////////////////////////  以下提供事件程式，有需要時修改
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
                
				$('input[id*="txtProduct_"]').each(function() {
					thisId = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
					$(this).attr('OldValue',$('#txtProductno_'+thisId).val());
				});
                OrdenoAndNo2On_Change();
            }
            function q_popPost(s1) {
                var ret;
                switch (s1) {
                    case 'txtUno_':
                        ret = getb_ret();
                        if (!ret || ret.length == 0)
                            return;
                        if (ret.length > 0 && ret[0] != undefined) {
                            if (emp($('#txtRadius_' + b_seq).val()) || $('#txtRadius_' + b_seq).val() == 0)
                                $('#txtRadius_' + b_seq).val(ret[0].radius);
                            if (emp($('#txtWidth_' + b_seq).val()) || $('#txtWidth_' + b_seq).val() == 0)
                                $('#txtWidth_' + b_seq).val(ret[0].width);
                            if (emp($('#txtLengthb_' + b_seq).val()) || $('#txtLengthb_' + b_seq).val() == 0)
                                $('#txtLengthb_' + b_seq).val(ret[0].lengthb);
                            if (emp($('#txtDime_' + b_seq).val()) || $('#txtDime_' + b_seq).val() == 0)
                                $('#txtDime_' + b_seq).val(ret[0].dime);
                            size_change();
                            $('#textSize1_' + b_seq).change();
                        }
                        break;
                    case 'txtProductno_':
                        $('input[id*="txtProduct_"]').each(function() {
                            thisId = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
                            $(this).attr('OldValue',$('#txtProductno_'+thisId).val());
                        });
                        if(trim($('#txtStyle_' + b_seq).val()).length != 0)
                            ProductAddStyle(b_seq);
                        $('#txtStyle_' + b_seq).focus();
                        break;
                    case 'txtCustno':
                        $('#txtPost2').val($('#txtPost').val());
                        $('#txtAddr2').val($('#txtAddr').val());
                        $('#txtContract').focus();
                        break;
                    case 'txtAddr':
                        $('#txtPost2').focus();
                        break;
                    case 'txtAddr2':
                        $('#txtPaytype').focus();
                        break;
                    case 'txtStyle_':
                        $('#txtStyle_'+b_seq).blur();
                        break;
                }
                OrdenoAndNo2On_Change();
            }
            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                size_change();
                if(q_cur==1 || q_cur=='2')
                    $('#btnApv').attr('disabled', 'disabled');
                else
                    $('#btnApv').removeAttr('disabled');
                OrdenoAndNo2On_Change();
            }
            function btnMinus(id) {
                _btnMinus(id);
                sum();
                OrdenoAndNo2On_Change();
            }
            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
                size_change();
                OrdenoAndNo2On_Change();
            }
            function btnPlut2(org_htm, dest_tag, afield) {
                size_change();
                OrdenoAndNo2On_Change();
            }
            function q_appendData(t_Table) {
                return _q_appendData(t_Table);
                OrdenoAndNo2On_Change();
            }
            function btnSeek() {
                _btnSeek();
                OrdenoAndNo2On_Change();
            }
            function btnTop() {
                _btnTop();
                OrdenoAndNo2On_Change();
            }
            function btnPrev() {
                _btnPrev();
                OrdenoAndNo2On_Change();
            }
            function btnPrevPage() {
                _btnPrevPage();
                OrdenoAndNo2On_Change();
            }
            function btnNext() {
                _btnNext();
                OrdenoAndNo2On_Change();
            }
            function btnNextPage() {
                _btnNextPage();
                OrdenoAndNo2On_Change();
            }
            function btnBott() {
                _btnBott();
                OrdenoAndNo2On_Change();
            }
            function q_brwAssign(s1) {
                _q_brwAssign(s1);
                OrdenoAndNo2On_Change();
            }
            function btnDele() {
                _btnDele();
                OrdenoAndNo2On_Change();
            }
            function btnCancel() {
                _btnCancel();
                OrdenoAndNo2On_Change();
            }
            function size_change() {
                if (q_cur == 1 || q_cur == 2) {
                    $('input[id*="textSize"]').removeAttr('disabled');
                } else {
                    $('input[id*="textSize"]').attr('disabled', 'disabled');
                }
                var t_kind = (($('#cmbKind').val())?$('#cmbKind').val():'');
                t_kind = t_kind.substr(0, 1);               
                if (t_kind == 'A') {
                    $('*[id="lblSize_help"]').text(q_getPara('sys.lblSizea'));
                    for (var j = 0; j < q_bbsCount; j++) {
                        $('#textSize1_' + j).show();
                        $('#textSize2_' + j).show();
                        $('#textSize3_' + j).show();
                        $('#textSize4_' + j).hide();
                        $('#x1_' + j).show();
                        $('#x2_' + j).show();
                        $('#x3_' + j).hide();
                        $('*[id="Size"]').css('width', '220px');
                        $('#txtSpec_' + j).css('width', '220px');
                        $('#textSize1_' + j).val($('#txtDime_' + j).val());
                        $('#textSize2_' + j).val($('#txtWidth_' + j).val());
                        $('#textSize3_' + j).val($('#txtLengthb_' + j).val());
                        $('#textSize4_' + j).val(0);
                        $('#txtRadius_' + j).val(0);
                    }
                } else if (t_kind == 'B') {
                    $('*[id="lblSize_help"]').text(q_getPara('sys.lblSizeb'));
                    for (var j = 0; j < q_bbsCount; j++) {
                        $('#textSize1_' + j).show();
                        $('#textSize2_' + j).show();
                        $('#textSize3_' + j).show();
                        $('#textSize4_' + j).show();
                        $('#x1_' + j).show();
                        $('#x2_' + j).show();
                        $('#x3_' + j).show();
                        $('*[id="Size"]').css('width', '300px');
                        $('#txtSpec_' + j).css('width', '300px');
                        $('#textSize1_' + j).val($('#txtRadius_' + j).val());
                        $('#textSize2_' + j).val($('#txtWidth_' + j).val());
                        $('#textSize3_' + j).val($('#txtDime_' + j).val());
                        $('#textSize4_' + j).val($('#txtLengthb_' + j).val());
                    }
                } else {//鋼筋和鋼胚
                    $('*[id="lblSize_help"]').text(q_getPara('sys.lblSizec'));
                    for (var j = 0; j < q_bbsCount; j++) {
                        $('#textSize1_' + j).hide();
                        $('#textSize2_' + j).hide();
                        $('#textSize3_' + j).show();
                        $('#textSize4_' + j).hide();
                        $('#x1_' + j).hide();
                        $('#x2_' + j).hide();
                        $('#x3_' + j).hide();
                        $('*[id="Size"]').css('width', '55px');
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
            }
        </script>
        <style type="text/css">
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
		  ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
        <div style="overflow: auto;display:block;width:1050px;">
            <!--#include file="../inc/toolbar.inc"-->
        </div>
        <div style="overflow: auto;display:block;width:1280px;"><!---上--->
            <div id="dview" style="float:left;width:400px;border-width:0px;"><!---左--->
                <table class="tview" id="tview">
                    <tr>
                        <td align="center" style="width:20px; color:black;"><a id="vewChk"> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id="vewOdate"> </a></td>
                        <td align="center" style="width:100px; color:black;"><a id="vewNoa"> </a></td>
                        <td align="center" style="width:100px; color:black;"><a id="vewNick"> </a></td>
                        <td align="center" style="width:100px; color:black;"><a id="vewApv"> </a></td>
                    </tr>
                    <tr>
                        <td><input id="chkBrow.*" type="checkbox"/></td>
                        <td id="odate" style="text-align: center;">~odate</td>
                        <td id="noa" class="control_noa" style="text-align: center;">~noa</td>
                        <td id="nick" style="text-align: center;">~nick</td>
                        <td id="apv" style="text-align: center;">~apv</td>
                    </tr>
                </table>
            </div>
            <div style="float:left;width:800px;border-radius:5px;"><!---右--->
                <table class="tbbm" id="tbbm">
                    <tr style="height:1px;">
                        <td colspan="8" class="tdZ"></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblOdate' class="lbl"> </a></td>
                        <td><input id="txtOdate" type="text" class="txt c1"/></td>
                        <td align="center" ><select id="cmbStype" class="txt c1"></select></td>
                        <td><span> </span><a id='lblKind' class="lbl"> </a></td>
                        <td><select id="cmbKind" class="txt c1"></select></td>
                        <td><span> </span><a id='lblNoa' class="lbl"> </a></td>
                        <td colspan="2"><input id="txtNoa"   type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblAcomp' class="lbl btn"> </a></td>
                        <td colspan="4">
							<input id="txtCno" type="text" style="float:left;width:25%;"/>
							<input id="txtAcomp" type="text" style="float:left;width:75%;"/>
                        </td>
                        <td><span> </span><a id='lblContract' class="lbl"> </a></td>
                        <td colspan="2"><input id="txtContract"  type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblCust' class="lbl btn"> </a></td>
                        <td colspan="4">
							<input id="txtCustno" type="text" style="float:left;width:25%;"/>
							<input id="txtComp" type="text" style="float:left;width:75%;"/>
							<input id="txtNick" type="text" style="display:none;"/>
                        </td>
                        <td><span> </span><a id="lblSales" class="lbl btn"> </a></td>
                        <td colspan="2">
							<input id="txtSalesno" type="text" style="float:left;width:50%;"/>
							<input id="txtSales" type="text" style="float:left;width:50%;"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblTel' class="lbl"> </a></td>
                        <td colspan='4'><input id="txtTel" type="text" class="txt c1"/></td>
                        <td><span> </span><a id='lblTrantype' class="lbl"> </a></td>
                        <td colspan="2"><select id="cmbTrantype" class="txt c1" name="D1" ></select></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblFax' class="lbl"> </a></td>
                        <td colspan="4"><input id="txtFax" type="text" class="txt c1" /></td>
                        <td colspan="3"></td>
                    </tr>
                    <tr>
						<td><span> </span><a id='lblAddr' class="lbl"> </a></td>
                        <td colspan="6">
                            <input id="txtPost"  type="text" style="float:left;width:15%;"/>
                            <input id="txtAddr"  type="text" style="float:left;width:75%;" />
                        </td>
						<td></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblAddr2' class="lbl"> </a></td>
                        <td colspan="6">
                            <input id="txtPost2"  type="text" style="float:left;width:15%;"/>
                            <input id="txtAddr2"  type="text" style="float:left;width:75%;" />
                        </td>
						<td></td>
                    </tr>
                    <tr>
						<td><span> </span><a id='lblPaytype' class="lbl"> </a></td>
                        <td colspan="2">
							<input id="txtPaytype" type="text" style="float:left; width:60%;"/>
							<select id="combPaytype" style="float:left; width:20px;"></select>
						</td>
						<td colspan="2">
							<a id='lblFloata' style="float:left;color:black;font-size:medium;"></a> 
							<input id="txtFloata" type="text" style="float:left; width:60%;"/>
							<select id="cmbCoin" style="float:left;width:20px;" onchange='coin_chg()'> </select>
						</td>
						<td><span> </span><a id='lblWeight' class="lbl"> </a></td>
						<td><input id="txtWeight"  type="text" class="txt num c1"/></td>
						<td></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblMoney' class="lbl"> </a></td>
                        <td><input id="txtMoney" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td colspan="2">
							<input id="txtTax" type="text" style="float:left; width:60%;"/>
							<select id="cmbTaxtype" style="float:left;width:80px;" > </select>
						</td>
                        <td><span> </span><a id='lblTotal' class="lbl"> </a></td>
                        <td><input id="txtTotal" type="text" class="txt num c1"/></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblMemo' class="lbl"> </a></td>
                        <td colspan="6"><textarea id="txtMemo" cols="10" rows="5" style="height: 50px;" class="txt c1"></textarea></td>
                        <td align="center"><input id="btnCredit" type="button" value='' /></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblWorker' class="lbl"> </a></td>
                        <td><input id="txtWorker"  type="text" class="txt c1"/></td>
                        <td><span> </span><a id='lblWorker2' class="lbl"> </a></td>
                        <td><input id="txtWorker2"  type="text" class="txt c1"/></td>
                        <td><input id="btnApv" type="button" style="width:50%;float:right;" value="核准"/></td>
                        <td><input id="txtApv" type="text" class="txt c1" disabled="disabled"/></td>
                        <td align="center">
							<span></span><a id='lblEnd' class="lbl"></a>
							<input id="chkEnda" type="checkbox"/>
						</td>
                        <td align="center">
                            <span></span><a id='lblIsproj' class="lbl"></a>
							<input id="chkIsproj" type="checkbox"/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div style="width: 1800px;"><!---下--->
            <table id="tbbs" class='tbbs' style=' text-align:center'>
                <tr style='color:white; background:#003366;'>
                    <td  align="center" style="width:30px;"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"/></td>
                    <td align="center" style="width:30px;"><a id='lblNo2' style="text-align:center;"> </a></td>
                    <td align="center" style="width:90px;"><a id='lblProductno'></a><br><a id='lblStyle_st'></a>｜<a id='lblClasss'></a></td>
                    <td align="center" style="width:120px;"><a id='lblProduct_s'> </a></td>
                    <td align="center" id='Size'><a id='lblSize_help'> </a><BR><a id='lblSize_st'> </a></td>
					<td align="center" style="width:50px;"><a id='lblWidth_t'></a>2</td>
					<td align="center" style="width:50px;"><a>寬度3</a></td>
                    <td align="center" style="width:120px;"><a id='lblSizea_st'> </a></td>
                    <td align="center" style="width:50px;"><a id='lblUnit'> </a></td>
                    <td align="center" style="width:120px;"><a id='lblMount'> </a></td>
                    <td align="center" style="width:120px;"><a id='lblWeights'> </a><br><a id='lblTheorys'> </a></td>
                    <td align="center" style="width:120px;"><a id='lblPrices'> </a><br><a id='lblTotals'> </a></td>
                    <td align="center" style="width:120px;"><a id='lblDateas'> </a></td>
                    <td align="center" style="width:40px;"><a id='lblEnda_st'> </a></td>
                    <td align="center" style="width:250px;"><a id='lblMemo_s'></a><br>爐號</td>
                </tr>
                <tr style='background:#cad3ff;'>
                    <td align="center"><input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;"/></td>
                    <td><input class="txt" id="txtNo2.*" type="text" style="width:95%;"/></td>
                    <td>
						<input type="button" id="btnProduct.*" style="display:none;"/>
						<input type="text" id="txtProductno.*"  style="width:95%;"/><br>
						<input type="button" id="btnStyle.*" style="display:none;"/>
                        <input id="txtStyle.*" type="text" style="width:30px;text-align:center;"/> |
						<input id="txtClass.*" type="text" style="width:45px;text-align:center;"/>
                    </td>
                    <td>
                        <span style="width:20px;height:1px;display:none;float:left;"> </span>
                        <input id="txtProduct.*" type="text" style="float:left;width:93%;"/>
                    </td>
                    <td>
						<input class="txt num" id="textSize1.*" type="text" style="float: left;width:55px;" disabled="disabled"/>
						<div id="x1.*" style="float: left;display:block;width:20px;padding-top: 4px;" >x</div>
						<input class="txt num" id="textSize2.*" type="text" style="float: left;width:55px;"  disabled="disabled"/>
						<div id="x2.*" style="float: left;display:block;width:20px;padding-top: 4px;">x</div>
						<input class="txt num" id="textSize3.*" type="text" style="float: left;width:55px;" disabled="disabled"/>
						<div id="x3.*" style="float: left;display:block;width:20px;padding-top: 4px;">x</div>
						<input class="txt num" id="textSize4.*" type="text"  style="float: left;width:55px;" disabled="disabled"/>
                    <!---上為虛擬下為實際--->
						<input id="txtRadius.*" type="text" style="display:none;"/>
                    	<input id="txtWidth.*" type="text" style="display:none;"/>
                    	<input id="txtDime.*" type="text" style="display:none;"/>
                    	<input id="txtLengthb.*" type="text" style="display:none;"/>
                    	<input id="txtSpec.*" type="text" style="float:left;"/>
                    </td>
					<td><input class="txt " id="txtWidth2.*" type="text" style="width:95%;"/></td>
					<td><input class="txt " id="txtWidth3.*" type="text" style="width:95%;"/></td>
                    <td><input class="txt " id="txtSize.*" type="text" style="width:95%;"/></td>
                    <td><input id="txtUnit.*" type="text" style="width:90%;"/></td>
                    <td><input id="txtMount.*" type="text" class="txt num" style="width:95%;"/></td>
                    <td>
						<input id="txtWeight.*" type="text" class="txt num" style="width:95%;"/>
						<input id="txtTheory.*" type="text" class="txt num" style="width:95%;"/>
					</td>
                    <td>
						<input id="txtPrice.*" type="text"  class="txt num" style="width:95%;"/>
						<input id="txtTotal.*" type="text" class="txt num" style="width:95%;"/>
					</td>
                    <td><input class="txt " id="txtDatea.*" type="text" style="width:95%;"/></td>
                    <td align="center"><input id="chkEnda.*" type="checkbox"/></td>
                    <td>
						<input type="text" id="txtMemo.*" style="width:95%;float:left;"/>
						<input class="txt " id="txtUno2.*" type="text" style="width:95%;float:left;"/>
					</td>
                </tr>
            </table>
        </div>
        <input id="q_sys" type="hidden" />
    </body>
</html>