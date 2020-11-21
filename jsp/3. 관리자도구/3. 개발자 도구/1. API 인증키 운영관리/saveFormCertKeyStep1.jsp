<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="lclasSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="mclasSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="sclasSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="hrankSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="lrankSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="senserSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="extrlCdComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="statusComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="dispComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="recptnOrganCdComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="trnsmisYn" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<jsp:useBean id="chargertList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="userList" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>

    <script type="text/javascript">
        var userList = new Array();
        var $tr2 = null;
        //<![CDATA[
        $(function () {
            $("#srvc_hrank_code").change(function () {
                if ($(this).val() == "") {
                    $("#srvc_lrank_code").html('<option value="">서비스 하위분류</option>');
                    $("#srvc_lrank_code").attr("disabled", true);
                } else {
                    fnSetLRankCombo($(this).val(), '');
                }
            });
            <% if(!resultMap.getString("SRVC_HRANK_CODE").equals("")){ %>
            fnSetLRankCombo('<%=resultMap.getString("SRVC_HRANK_CODE")%>', '<%=resultMap.getString("SRVC_LRANK_CODE")%>');
            <% } %>

            /*
            $("#srvc_lclas_code").change(function(){
                if($("#srvc_lclas_code").val() == ""){
                    $("#srvc_mclas_code").html('<option value="">서비스 중분류</option>');
                    $("#srvc_mclas_code").attr("disabled", true);
                    $("#srvc_sclas_code").html('<option value="">서비스 소분류</option>');
                    $("#srvc_sclas_code").attr("disabled", true);
                }else{
                    fnSetMClassCombo($(this).val(), '');
                }
            });

            $("#srvc_mclas_code").change(function(){
                if($(this).val() == ""){
                    $("#srvc_sclas_code").html('<option value="">서비스 소분류</option>');
                    $("#srvc_sclas_code").attr("disabled", true);
                }
                else{
                    fnSetSClassCombo($("#srvc_lclas_code").val(), $(this).val(), '');
                }
            });






            <% if(!resultMap.getString("SRVC_LCLAS_CODE").equals("")){ %>
			fnSetMClassCombo('




            <%=resultMap.getString("SRVC_LCLAS_CODE")%>','




            <%=resultMap.getString("SRVC_MCLAS_CODE")%>');





            <% } %>





            <% if(!resultMap.getString("SRVC_MCLAS_CODE").equals("")){ %>
			fnSetSClassCombo('




            <%=resultMap.getString("SRVC_LCLAS_CODE")%>','




            <%=resultMap.getString("SRVC_MCLAS_CODE")%>','




            <%=resultMap.getString("SRVC_SCLAS_CODE")%>');





            <% } %>
		*/

        });

        // 하위분류 콤보
        function fnSetLRankCombo(code, selValue) {
            var req = {
                "group_id": "R010260"
                , "attrb_1": code
            };
            var html = "";

            if ($("#sch_srvc_hrank_code").val() == "") {
                html += '<option value="">서비스 하위분류</option>';
                $("#sch_srvc_lrank_code").html(html);
                $("#sch_srvc_lrank_code").attr("disabled", true);

                fnSetServiceNmCombo();
            } else {
                jQuery.ajax({
                    type: 'POST',
                    dataType: 'json',
                    url: '/common/selectCodeListAjax.do',
                    data: req,
                    success: function (param) {

                        if (param.resultStats.resultCode == "error") {
                            alert(param.resultStats.resultMsg);
                            return;
                        }

                        var sel = "";
                        html += '<option value="">서비스 하위분류</option>';
                        for (i = 0; i < param.resultStats.resultList.length; i++) {

                            sel = "";
                            if (param.resultStats.resultList[i].CODE == selValue) {
                                sel = 'selected="selected"';
                            }
                            html += '<option value="' + param.resultStats.resultList[i].CODE + '" ' + sel + '>' + param.resultStats.resultList[i].CODE_NM + '</option>';

                        }
                        $("#srvc_lrank_code").html(html);
                        $("#srvc_lrank_code").attr("disabled", false);
                    },
                    error: function (jqXHR, textStatus, thrownError) {
                        ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                    }
                });
            }
        }

        /*
        //중분류 콤보
        function fnSetMClassCombo(code, selValue){
            var req ={
                "group_id" : "R010100"
                ,"attrb_1" : code
            };

            var html = "";

            jQuery.ajax( {
                type : 'POST',
                dataType : 'json',
                url : '/common/selectCodeListAjax.do',
                data : req,
                success : function(param) {

                    if(param.resultStats.resultCode == "error"){
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    var sel = "";
                    html += '<option value="">서비스 중분류</option>';
                    for(i = 0; i < param.resultStats.resultList.length; i++){

                        sel = "";
                        if(param.resultStats.resultList[i].CODE == selValue){
                            sel = 'selected="selected"';
                        }
                        html += '<option value="'+param.resultStats.resultList[i].CODE+'" '+sel+'>'+param.resultStats.resultList[i].CODE_NM+'</option>';

                    }
                    $("#srvc_mclas_code").html(html);
                    $("#srvc_mclas_code").attr("disabled", false);
                },
                error : function(jqXHR, textStatus, thrownError){
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        //소분류 콤보
        function fnSetSClassCombo(code1, code2, selValue){
            var req ={
                "group_id" : "R010110"
                ,"attrb_1" : code1
                ,"attrb_2" : code2
            };

            var html = "";

            jQuery.ajax( {
                type : 'POST',
                dataType : 'json',
                url : '/common/selectCodeListAjax.do',
                data : req,
                success : function(param) {

                    if(param.resultStats.resultCode == "error"){
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    var sel = "";
                    html += '<option value="">서비스 소분류</option>';
                    for(i = 0; i < param.resultStats.resultList.length; i++){

                        sel = "";
                        if(param.resultStats.resultList[i].CODE == selValue){
                            sel = 'selected="selected"';
                        }
                        html += '<option value="'+param.resultStats.resultList[i].CODE+'" '+sel+'>'+param.resultStats.resultList[i].CODE_NM+'</option>';

                    }
                    $("#srvc_sclas_code").html(html);
                    $("#srvc_sclas_code").attr("disabled", false);
                },
                error : function(jqXHR, textStatus, thrownError){
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }
        */
        //목록
        function fnGoList() {
            if ($("#currentPage").val() == null) {
                var hiddenHtml = "";
                hiddenHtml += '<input type="hidden" id="currentPage" name="currentPage" />';
                $('#aform').append(hiddenHtml);
            }

            $("#currentPage").val($("#pageList_currentPage").val());
            $("#sch_srvc_hrank_code").val($("#pageList_sch_srvc_hrank_code").val());
            $("#sch_srvc_lrank_code").val($("#pageList_sch_srvc_lrank_code").val());

            $("#aform").attr({
                action: "/iot/certkey/saveFormCertKeyStep0.do",
                method: 'post'
            }).submit();
        }

        //등록
        function fnGoInsert(f) {

            if (f == 1) { // aform
                if ($("#srvc_nm").val() == "") {
                    alert("서비스 명을 입력해 주세요.");
                    $("#srvc_nm").focus();
                    return false;
                }
                if ($("#srvc_hrank_code").val() == "") {
                    alert("서비스 상위분류를 선택해 주세요.");
                    $("#srvc_hrank_code").focus();
                    return false;
                }

                if ($("#srvc_lrank_code").val() == "") {
                    alert("서비스 하위분류를 선택해 주세요.");
                    $("#srvc_lrank_code").focus();
                    return false;
                }
                /*
                if($("#srvc_lclas_code").val() == ""){
                    alert("서비스 대분류를 선택해 주세요.");
                    $("#srvc_lclas_code").focus();
                    return false;
                }

                if($("#srvc_mclas_code").val() == ""){
                    alert("서비스 중분류를 선택해 주세요.");
                    $("#srvc_mclas_code").focus();
                    return false;
                }

                if($("#srvc_sclas_code").val() == ""){
                    alert("서비스 소분류를 선택해 주세요.");
                    $("#srvc_sclas_code").focus();
                    return false;
                }
                */
                if ($("#modl_nm").val() == "") {
                    alert("모델 명을 입력해 주세요.");
                    $("#modl_nm").focus();
                    return false;
                }

                if ($("#sensor_se_code").val() == "") {
                    alert("센서 구분코드를 선택해 주세요.");
                    $("#sensor_se_code").focus();
                    return false;
                }

                if ($("#colct_intrvl_mnt").val() == "") {
                    alert("센서 수집 간격을 입력해 주세요.");
                    $("#colct_intrvl_mnt").focus();
                    return false;
                }

                if ($("#recptn_intrvl_mnt").val() == "") {
                    alert("수신 간격을 입력해 주세요.");
                    $("#recptn_intrvl_mnt").focus();
                    return false;
                }

                if (confirm("저장하시겠습니까?")) {
                    $("#aform").attr({
                        action: "/iot/certkey/saveCertKeyStep1.do",
                        method: 'post'
                    }).submit();
                }
            } else if (f == 2) { // bform
                if ($("#data_no").val() == "") {
                    alert("서비스를 먼저 저장해 주세요.");
                    $("#srvc_nm").focus();
                    return false;
                }

                var length = $("[name=recptn_organ_code]").length;
                /*
                if(length < 1){
                    alert("저장할 타 기관 전송 URL 정보가 존재하지 않습니다. ");
                    return false;
                }
                */
                for (i = 0; i < length; i++) {
                    if ($("[name=recptn_organ_code]:eq(" + i + ")").val() == "") {
                        alert("기관 명을 선택해 주세요.");
                        $("[name=recptn_organ_code]:eq(" + i + ")").focus();
                        return false;
                    }

                    if ($("[name=trnsmis_url]:eq(" + i + ")").val() == "") {
                        alert("URL을 입력해 주세요.");
                        $("[name=trnsmis_url]:eq(" + i + ")").focus();
                        return false;
                    }

                    if ($("[name=trnsmis_yn]:eq(" + i + ")").val() == "") {
                        alert("전송 여부를 선택해 주세요.");
                        $("[name=trnsmis_yn]:eq(" + i + ")").focus();
                        return false;
                    }
                }

                if (confirm("저장하시겠습니까?")) {
                    $("#bform").attr({
                        action: "/iot/certkey/saveCertKeyStep1_URL.do",
                        method: 'post'
                    }).submit();
                }
            } else if (f == 3) { // cform
                if ($("#data_no").val() == "") {
                    alert("서비스를 먼저 저장해 주세요.");
                    $("#srvc_nm").focus();
                    return false;
                }

                if (confirm("서비스 담당자를 저장하시겠습니까?")) {
                    $("#cform").attr({
                        action: "/iot/charger/saveBsnsCharger.do"
                        , method: 'post'
                    }).submit();
                }
            }
        }

        $(document).ready(function () {
            setRowNo();
            fnSetNumeric();

            $("#all_chkbx").click(function () {
                if ($(this).prop("checked") == true) {
                    $("[name=del_chkbx]").prop("checked", true);
                } else {
                    $("[name=del_chkbx]").prop("checked", false);
                }
            });

        });

        //행추가
        function fnAddRow() {

            var html = '<tr>';
            html += '<td class="text-center"><input type="checkbox" name="del_chkbx" /></td>';
            html += "<td><select name='recptn_organ_code' class='form-control input-sm'><%=CommboUtil.getComboStr(recptnOrganCdComboStr, "CODE", "CODE_NM", param.getString(""), "기관 명")%></select></td>"
            html += '	<td><div class="outBox1">';
            html += '	<input type="text" name="trnsmis_url" class="form-control" value="" />';
            html += '	</div></td>';
            html += "<td><select name='trnsmis_yn' class='form-control input-sm'><%=CommboUtil.getComboStr(trnsmisYn, "CODE", "CODE_NM", param.getString(""), "전송여부")%></select></td>"
            html += '</tr>';

            $('#tbody1').append(html);

            setRowNo();
            fnSetNumeric();
        }

        //행삭제
        function fnDeleteRow() {
            var delChkbx = f_getList("del_chkbx");
            var chkFag = false;

            for (i = 0; i < delChkbx.length; i++) {
                if (delChkbx[i].checked == true) {
                    chkFag = true;
                    break;
                }
            }

            if (chkFag == false) {
                alert("삭제할 수신자 정보를 선택해 주세요.");
                return false;
            }

            if (confirm("선택된 행을 삭제하시겠습니까?")) {
                $('[name=del_chkbx]:checked').each(function () {
                    $(this).closest('tr').remove();
                });
                setRowNo();
            }
        }

        //No 번호 매기기
        function setRowNo() {

            var setNo = 1;
            $('#aform tbody .row_no').each(function () {
                $(this).text(setNo++);
            });

        }

        //]]>
    </script>
</head>
<body class="hold-transition <%=cssSkin%> layout-top-nav">
<div class="wrapper">

    <!-- 헤더  -->
    <c:import url="/common/inc/header.do" charEncoding="utf-8"/>


    <script type="text/javascript">
        $(function () {
            $(".content-header h1").append("(<%=param.getString("p_srvc_nm")%>)");
        });
    </script>

    <!-- content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>인증키 관리 - 발급</h1>
        </section>
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post">
                        <input type="hidden" id="trnsmit_server_no" name="trnsmit_server_no"
                               value="${param.trnsmit_server_no}"/>
                        <input type="hidden" id="data_no" name="data_no" value="${param.data_no}"/>
                        <input type="hidden" id="packet_mastr_seq" name="packet_mastr_seq"
                               value="${resultMap.PACKET_MASTR_SEQ}"/>
                        <input type="hidden" id="p_srvc_nm" name="p_srvc_nm" value="${param.p_srvc_nm}"/>
                        <%-- pageList --%>
                        <input type="hidden" id="pageList_currentPage" name="pageList_currentPage"
                               value="${param.pageList_currentPage}"/>
                        <input type="hidden" id="sch_organ_code" name="sch_organ_code" value="${param.sch_organ_code}"/>
                        <input type="hidden" id="pageList_sch_srvc_hrank_code" name="pageList_sch_srvc_hrank_code"
                               value="${param.pageList_sch_srvc_hrank_code}"/>
                        <input type="hidden" id="pageList_sch_srvc_lrank_code" name="pageList_sch_srvc_lrank_code"
                               value="${param.pageList_sch_srvc_lrank_code}"/>
                        <input type="hidden" id="sch_srvc_nm" name="sch_srvc_nm" value="${param.sch_srvc_nm}"/>
                        <input type="hidden" id="sch_srvc_nm2" name="sch_srvc_nm2" value="${param.sch_srvc_nm2}"/>
                        <input type="hidden" id="sch_row_per_page" name="sch_row_per_page"
                               value="${param.sch_row_per_page}"/>

                        <%@ include file="/common/inc/modelTap.jspf" %>
                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width: 20%;">
                                        <col style="width: 80%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="required_field">서비스 명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="srvc_nm" name="srvc_nm"
                                                       placeholder="서비스 명" maxlength="50" value="${resultMap.SRVC_NM}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>서비스 상태</th>
                                        <td>
                                            <div class="outBox1">
                                                <select id="srvc_status" name="srvc_status"
                                                        class="form-control input-sm">
                                                    <%=CommboUtil.getComboStr(statusComboStr, "CODE", "CODE_NM", resultMap.getString("SRVC_STATUS"), "")%>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>전시여부 상태</th>
                                        <td>
                                            <div class="outBox1">
                                                <select id="srvc_disp" name="srvc_disp" class="form-control input-sm">
                                                    <%=CommboUtil.getComboStr(dispComboStr, "CODE", "CODE_NM", resultMap.getString("DISP_YN"), "")%>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">서비스 분류 코드</th>
                                        <td>
                                            <div class="outBox1">
                                                <select id="srvc_hrank_code" name="srvc_hrank_code"
                                                        class="form-control input-sm"
                                                        style="display:inline-block;width:49%;">
                                                    <%=CommboUtil.getComboStr(hrankSeComboStr, "CODE", "CODE_NM", resultMap.getString("SRVC_HRANK_CODE"), "서비스 상위분류")%>
                                                </select>
                                                <select id="srvc_lrank_code" name="srvc_lrank_code"
                                                        class="form-control input-sm" disabled
                                                        style="display:inline-block;width:50%;">
                                                    <option value="">서비스 하위분류</option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <%--
                                    <tr>
                                        <th class="required_field">서비스 분류 코드</th>
                                        <td>
                                            <div class="outBox1">
                                                <select id="srvc_lclas_code" name="srvc_lclas_code" class="form-control input-sm" style="display:inline-block;width:33%;">
                                                    <%=CommboUtil.getComboStr(lclasSeComboStr, "CODE", "CODE_NM", resultMap.getString("SRVC_LCLAS_CODE"), "서비스 대분류")%>
                                                </select>
                                                <select id="srvc_mclas_code" name="srvc_mclas_code" class="form-control input-sm" disabled style="display:inline-block;width:33%;">
                                                    <option value="">서비스 중분류</option>
                                                </select>
                                                <select id="srvc_sclas_code" name="srvc_sclas_code" class="form-control input-sm" disabled style="display:inline-block;width:33%;">
                                                    <option value="">서비스 소분류</option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                     --%>
                                    <tr>
                                        <th class="required_field">협치시스템 분류 코드</th>
                                        <td>
                                            <div class="outBox1">
                                                <select id="extrl_srvc_code" name="extrl_srvc_code"
                                                        class="form-control input-sm">
                                                    <%=CommboUtil.getComboStr(extrlCdComboStr, "CODE", "CODE_NM", resultMap.getString("EXTRL_SRVC_CODE"), "협치시스템 분류 코드")%>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">모델 명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="modl_nm" name="modl_nm"
                                                       placeholder="모델 명" maxlength="50" value="${resultMap.MODL_NM}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">센서 구분 코드</th>
                                        <td>
                                            <div class="outBox1">
                                                <select id="sensor_se_code" name="sensor_se_code"
                                                        class="form-control input-sm">
                                                    <%=CommboUtil.getComboStr(senserSeComboStr, "CODE", "CODE_NM", resultMap.getString("SENSOR_SE_CODE"), "센서 구분")%>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">센서 수집 간격(분)</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control numeric" id="colct_intrvl_mnt"
                                                       name="colct_intrvl_mnt" placeholder="센서 수집 간격(분)" maxlength="10"
                                                       value="${resultMap.COLCT_INTRVL_MNT}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                    <tr>
                                        <th class="required_field">수신 간격(분)</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control numeric" id="recptn_intrvl_mnt"
                                                       name="recptn_intrvl_mnt" placeholder="수신 간격(분)" maxlength="10"
                                                       value="${resultMap.RECPTN_INTRVL_MNT}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>측정 항목</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="mesure_iem"
                                                       name="mesure_iem" placeholder="측정항목" maxlength="50"
                                                       value="${resultMap.MESURE_IEM}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>서비스 내용</th>
                                        <td>
                                            <div class="outBox1">
                                                <textarea class="form-control" id="srvc_cn" name="srvc_cn" rows="5"
                                                          placeholder="서비스 내용"
                                                          onkeyup="cfLengthCheck('서비스 내용은', this, 4000);">${resultMap.SRVC_CN}</textarea>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnGoList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnGoInsert(1); return false;">
                                        <i class="fa fa-pencil"></i> 저장
                                    </button>
                                </div>
                            </div><!-- /.box-footer -->
                        </div><!-- /.box -->
                    </form>

                    <form role="form" id="cform" method="post">
                        <input type="hidden" name="trnsmit_server_no" value="${param.trnsmit_server_no}"/>
                        <input type="hidden" name="data_no" value="${param.data_no}"/>
                        <input type="hidden" name="organ_code" value="${param.organ_code}"/>
                        <input type="hidden" name="redirectUrl" value="/iot/certkey/saveFormCertKeyStep1.do"/>

                        <div class="box box-primary">
                            <div class="box-header">
                                <h3 class="box-title">※ 서비스 담당자 지정</h3>
                            </div>
                            <div style="overflow: hidden; margin-bottom:10px;">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info update" data-toggle="modal"
                                            data-target="#assignMgrModal" id="selectConf">
                                        <i class="fa fa-user-plus"></i> 서비스 담당자 지정
                                    </button>
                                </div>
                            </div>
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width:80px;">
                                        <col style="width:15%;">
                                        <col style="width:*;">
                                        <col style="width:25%;">
                                        <col style="width:20%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">순번</th>
                                        <th class="text-center">담당자 ID</th>
                                        <th class="text-center">담당자 성명</th>
                                        <th class="text-center">담당자 구분</th>
                                        <th class="text-center">등록 일</th>
                                    </tr>
                                    </thead>
                                    <tbody class="user_wrap_p">
                                    <c:forEach var="data" items="${chargertList}" varStatus="status">
                                        <tr>
                                            <td class="text-center">
                                                <c:out value="${status.index+1}"/>
                                            </td>
                                            <td class="text-center">${data.USER_ID}</td>
                                            <td class="text-center">${data.USER_NM}</td>
                                            <td class="text-center">${data.USER_SE_NM}</td>
                                            <td class="text-center">${data.REGIST_YMD}</td>
                                            <input type="hidden" name="user_no" value="${data.USER_NO}">
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${fn:length(chargertList) == 0}">
                                        <tr>
                                            <td class="text-center" colspan="5"><spring:message
                                                    code="msg.data.empty"/></td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info" onclick="fnGoInsert(3); return false;"><i
                                            class="fa fa-pencil"></i> 저장
                                    </button>
                                </div>
                            </div><!-- /.box-footer -->
                        </div><!-- /.box -->
                    </form>

                    <form role="form" id="bform" method="post">
                        <input type="hidden" name="trnsmit_server_no" value="${param.trnsmit_server_no}"/>
                        <input type="hidden" name="data_no" value="${param.data_no}"/>
                        <div class="box box-primary">
                            <div class="box-header">
                                <h3 class="box-title">※ 타 기관 전송 URL 등록</h3>
                            </div>
                            <div class="box-body no-pad-top table-responsive">
                                <table id="codeTable" class="table table-bordered">
                                    <colgroup>
                                        <col width="5%">
                                        <col width="15%">
                                        <col width="*">
                                        <col width="10%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center"><input type="checkbox" id="all_chkbx"/></th>
                                        <th class="text-center">기관 명</th>
                                        <th class="text-center">URL</th>
                                        <th class="text-center">전송여부</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tbody1">
                                    <%
                                        DataMap dataMap = null;
                                        for (int i = 0; i < resultList.size(); i++) {
                                            dataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><input type="checkbox" name="del_chkbx"/></td>
                                        <td>
                                            <select name="recptn_organ_code" class="form-control input-sm">
                                                <%=CommboUtil.getComboStr(recptnOrganCdComboStr, "CODE", "CODE_NM", dataMap.getString("RECPTN_ORGAN_CODE"), "기관 명")%>
                                            </select>
                                        </td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" name="trnsmis_url" class="form-control"
                                                       value="<%=dataMap.getString("TRNSMIS_URL") %>"/>
                                            </div>
                                        </td>
                                        <td>
                                            <select name="trnsmis_yn" class="form-control input-sm">
                                                <%=CommboUtil.getComboStr(trnsmisYn, "CODE", "CODE_NM", dataMap.getString("TRNSMIS_YN"), "전송 여부")%>
                                            </select>
                                        </td>
                                    </tr>
                                    <% }%>
                                    </tbody>
                                </table>

                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <button type="button" class="btn btn-primary" onclick="fnAddRow(); return false;"><i
                                        class="fa fa-plus"></i> 행추가
                                </button>
                                <button type="button" class="btn btn-warning" onclick="fnDeleteRow(); return false;"><i
                                        class="fa fa-trash"></i> 행 삭제
                                </button>
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info" onclick="fnGoInsert(2); return false;"><i
                                            class="fa fa-pencil"></i> 저장
                                    </button>
                                </div>
                            </div>
                        </div><!-- /.box -->
                    </form>
                </div>
                <!--  /.col-xs-12 -->
            </div>
            <!-- ./row -->
        </section>
        <!-- /.content -->
    </div>
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!-- //fooer -->
</div>
<%@ include file="/common/inc/chargerAssign.jspf" %>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
