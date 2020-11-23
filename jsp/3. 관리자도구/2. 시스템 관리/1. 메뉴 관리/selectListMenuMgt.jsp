<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>

<%@ page import="egovframework.framework.common.object.DataMap" %>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="menuTypeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="dispYnComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="useYnComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="urlTyComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="parentMenuIdComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>

    <link rel="stylesheet" href="<%=jsRoot%>jsTree_new/themes/default/style.min.css"/>
    <script src="<%=jsRoot%>jsTree_new/jstree.min.js"></script>

    <script type="text/javascript">
        //<![CDATA[

        $(function () {
            $('#jstree').jstree({
                "core": {
                    "themes": {
                        "icons": false,
                    }
                },
                "plugins": [
                    "state", "wholerow"
                ]
            });

            //url 유형 코드 select 이벤트
            $('#url_ty_code').on('change', function () {
                $(this).closest('table').find('th.name').text('');
                $(this).closest('table').find('td.code').text('');

                if ($(this).val() == "10") {
                    fnSelectBbsCode("", $(this), "");
                    return false;
                }
                if ($(this).val() == "20") {
                    fnSelectCntntsId($(this), "");
                    return false;
                }
                if ($(this).val() == "30") {
                    $('#defaultTb .ty_info').html("");
                    return false;
                }
            });


            $("#id_resize").css("height", $(window).height() - 200);
            $(window).resize(function () {
                $("#id_resize").css("height", $(window).height() - 200);
            });

        });

        //]]>
    </script>

    <script type="text/javascript">
        function checkNum(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;

            return true;
        }

        //메뉴정보 조회
        function fnSelectMenuInfo(menu_id, menu_nm, menu_lv) {
            var req = {
                "menu_id": menu_id
                , "menu_nm": menu_nm
                , "menu_lv": menu_lv
            };

            jQuery.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/admin/menu/selectMenuMgtAjax.do',
                data: req,
                success: function (param) {

                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    $("#menu_id").val(param.resultMap.MENU_ID);
                    $("#up_menu_id").val(param.resultMap.UP_MENU_ID);
                    $("#up_menu_nm").val(param.resultMap.UP_MENU_NM);
                    $("#menu_type_code").val(param.resultMap.MENU_TY_CODE);
                    $("#menu_lv").val(param.resultMap.MENU_LEVEL);
                    $("#menu_nm").val(param.resultMap.MENU_NM);
                    $("#fnct_nm").val(param.resultMap.FNCT_NM);
                    $("#menu_nm_cn").val(param.resultMap.MENU_NM_CN);
                    $("#url").val(param.resultMap.URL);
                    $("#rm").val(param.resultMap.RM);
                    $("#srt_ord").val(param.resultMap.SORT_ORDR);
                    $("#use_yn").val(param.resultMap.USE_YN);
                    $("#disp_yn").val(param.resultMap.DISP_YN);

                    var urlTyCode = param.resultMap.URL_TY_CODE;
                    $("#url_ty_code").val(urlTyCode);

                    $('#defaultTb tr.ty_info').html("");
                    $('#defaultTb th.name').text("");
                    $('#defaultTb td.code').text("");
                    if (urlTyCode == "10") {
                        var str = "<th>기관</th>";
                        str += "<td>";
                        str += "  <select name=\"bbs_organ_code\" id=\"bbs_organ_code\" class=\"form-control\">";
                        str += param.bbsMap.bbsOrganComboStrText;
                        str += "	</select>";
                        str += "	<input type='hidden' name='subpath' value='" + param.bbsMap.subpath + "'/>";
                        str += "</td>"
                        str += "<th>게시판 명</th>";
                        str += "<td>";
                        str += "  <select name=\"bbs_code\" id=\"bbs_code\" class=\"form-control\">";
                        str += param.bbsMap.bbsCodeComboStrText;
                        str += "	</select>";
                        str += "</td>"
                        $('#defaultTb tr.ty_info').html(str);
                        $('#defaultTb th.name').text('게시판 코드');
                        $('#defaultTb td.code').text($('#bbs_code').val());
                        fnSetBbsCode("");
                    } else if (urlTyCode == "20") {
                        var str = "<th>[기관]콘텐츠 제목</th>";
                        str += "<td colspan=\"2\" class=\"cntnts_nm\">[" + param.cntntsMap.ORGAN_NM + "] " + param.cntntsMap.SJ + "</td>";
                        str += "<td>";
                        str += "  <span class='btnR'><button type=\"button\" id='btnCntnts' onclick=\"fnSearchCntnts('', this)\" class=\"btn btn-primary\">콘텐츠 검색</button></span>";
                        str += "  <input type=\"hidden\" name=\"cntnts_id\" value='" + param.cntntsMap.CNTNTS_ID + "'>";
                        str += "</td>";
                        $('#defaultTb tr.ty_info').html(str);
                        $('#defaultTb th.name').text('컨텐츠ID');
                        $('#defaultTb td.code').text(param.cntntsMap.CNTNTS_ID);
                    }

                    $("#new_menu_id_val").val(param.resultMap.LOW_MENU_ID);
                    $("#new_srt_ord_val").val(param.resultMap.MAX_SORT_ORDR);

                    if (param.resultMap.LOW_MENU_ID == null) {
                        $("#new_menu_id_val").val('900');
                    }

                    $("#sort_ordr_1").val(param.resultMap.SORT_ORDR_1);
                    $("#sort_ordr_2").val(param.resultMap.SORT_ORDR_2);
                    $("#sort_ordr_3").val(param.resultMap.SORT_ORDR_3);
                    $("#sort_ordr_4").val(param.resultMap.SORT_ORDR_4);
                    $("#sort_ordr_5").val(param.resultMap.SORT_ORDR_5);
                    $("#sort_ordr_6").val(param.resultMap.SORT_ORDR_6);

                    $("#insertArea").html("");
                    $("#insertBtn").hide();
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });

        } //메뉴정보 조회 끝

        var oldValue = "";

        function fnSetOldValue(obj, idx) {
            oldValue = obj.value;
        }

        function fnCompNewValue(obj, idx) {
            if (oldValue != obj.value) {
                $("#dup_chk_yn_" + idx).val("N");
            }
        }

        //코드정보 조회
        function fnSelectMenuExistYnAjax(idx) {

            if ($("#new_menu_id" + idx).val() == "") {
                alert("코드ID를 입력해 주세요.");
                return;
            }

            if ($("#new_menu_id" + idx).val() == "") {
                alert("신규 메뉴코드 ID를입력해 주세요.");
                return;
            }

            var req = {
                "new_menu_id": $("#menu_id").val() + $("#new_menu_id").val()
            };

            jQuery.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/admin/menu/selectExistYnMenuMgtAjax.do',
                data: req,
                success: function (param) {

                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    if (param.resultMap.EXIST_YN == "Y") {
                        alert("메뉴ID가 존재합니다.");
                    } else {
                        alert("사용가능한 메뉴ID입니다.");
                        $("#dup_chk_yn_" + idx).val("Y");
                    }

                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });

        } //코드정보 조회 끝


        //입력폼 보기
        var removeNo = 0;

        function fnInsertForm() {

            if ($("#menu_id").val() == "") {
                alert("메뉴를 선택해 주세요.");
                return;
            }

            var sortDepth = $("#menu_id").val().length / 4 + 1;
            if (sortDepth > 7) {
                alert(" 7 Depth 이상으로는 메뉴를 생성할 수 없습니다.");
                return;
            }

            var nextSrtOrd = 0;	//next 정렬순서
            var newSrtOrdList = f_getList("new_srt_ord");
            for (i = 0; i < newSrtOrdList.length; i++) {

                if (Number(nextSrtOrd) < Number(newSrtOrdList[i].value)) {
                    nextSrtOrd = Number(newSrtOrdList[i].value);
                }
            }
            if (newSrtOrdList.length == 0) {
                nextSrtOrd = Number($("#new_srt_ord_val").val()) + 10;
            } else {
                nextSrtOrd = Number(nextSrtOrd) + 10;
            }

            var next_new_menu_id = 0;	//next 하위 메뉴 아이디
            var newMenuIdList = f_getList("new_menu_id");
            for (i = 0; i < newMenuIdList.length; i++) {

                if (Number(next_new_menu_id) < Number(newMenuIdList[i].value)) {
                    next_new_menu_id = Number(newMenuIdList[i].value);
                }
            }
            if (newMenuIdList.length == 0) {
                next_new_menu_id = Number($("#new_menu_id_val").val()) + 100;
            } else {
                next_new_menu_id = Number(next_new_menu_id) + 100;
            }


            var menuTypeComboStr = "<select name=\"new_menu_type_code\" id=\"new_menu_type_code\" class=\"form-control\">";
            menuTypeComboStr += "	<%=CommboUtil.getComboStr(menuTypeComboStr, "CODE", "CODE_NM", "", "C")%>";
            menuTypeComboStr += "</select>";

            var useYnComboStr = "<select name=\"new_use_yn\" id=\"new_use_yn\" class=\"form-control\" >";
            useYnComboStr += "	<%=CommboUtil.getComboStr(useYnComboStr, "CODE", "CODE_NM", "", "")%>";
            useYnComboStr += "</select>";

            var dispYnComboStr = "<select name=\"new_disp_yn\" id=\"new_disp_yn\" class=\"form-control\" >";
            dispYnComboStr += "	<%=CommboUtil.getComboStr(dispYnComboStr, "CODE", "CODE_NM", "", "")%>";
            dispYnComboStr += "</select>";

            var urlTyComboStr = "<select name=\"new_url_ty_code\" id=\"new_url_ty_code\" class=\"form-control\" >";
            urlTyComboStr += "	<%=CommboUtil.getComboStr(urlTyComboStr, "CODE", "CODE_NM", "30", "")%>";
            urlTyComboStr += "</select>";

            removeNo++;

            var layer = "";
            layer += "<table id='removeNo_" + removeNo + "' class=\"table table-bordered\">";
            layer += "<caption>하위메뉴생성</caption>";
            layer += "	<colgroup>";
            layer += "		<col style=\"width:20%;\" />";
            layer += "		<col style=\"width:25%;\" />";
            layer += "		<col style=\"width:20%;\" />";
            layer += "		<col style=\"width:25%;\" />";
            layer += "		<col class=\"td5\" />";
            layer += "	</colgroup>	";

            layer += "	<tr>";
            layer += "		<th class=\"required_field\">상위메뉴 ID</th>";
            layer += "		<td colspan=\"3\">";
            layer += "			<div class=\"row\">";
            layer += "				<div class=\"col-xs-4\">";
            layer += "					<input type=\"text\" class=\"form-control\" name=\"\" value=\"" + $("#menu_id").val() + "\" readonly />";
            layer += "					<input type=\"hidden\" name=\"new_url_ty_code\"    value=\"30\"  />";
            layer += "					<input type=\"hidden\" name=\"dup_chk_yn\" id=\"dup_chk_yn_" + removeNo + "\"   value=\"Y\"  />";
            layer += "				</div>";
            layer += "				<div class=\"col-xs-8\">";
            layer += "						<div class=\"input-group\">";
            layer += "							<input type=\"text\" class=\"form-control\" name=\"new_menu_id\" id=\"new_menu_id\" onkeypress=\"return checkNum(event);\" value=\"" + next_new_menu_id + "\"/>";
            layer += "						<div class=\"input-group-btn\">";
            layer += "								<button type=\"button\" class=\"btn btn-primary\" onclick=\"fnSelectMenuExistYnAjax('" + removeNo + "')\">중복확인</button>";
            layer += "						</div>";
            layer += "				</div>";
            layer += "			</div>";
            layer += "		</td>";
            layer += "		<td rowspan=\"7\" class=\"bor_L\"><button type=\"button\" class=\"btn btn-warning\" onclick=\"fnRemove('removeNo_" + removeNo + "');\">삭제</button></td>";
            layer += "	</tr>";
            layer += "	<tr>";
            layer += "		<th class=\"required_field\">메뉴명</th>";
            layer += "		<td><div class=\"outBox1\"><input type=\"text\" class=\"form-control\" name=\"new_menu_nm\" id=\"new_menu_nm\"  maxlength=\"100\" onkeyup=\"cfLengthCheck('메뉴명은', this, 100);\"></div></td>";
            layer += "		<th>상세기능명</th>";
            layer += "		<td><div class=\"outBox1\"><input type=\"text\" class=\"form-control\" name=\"new_fnct_nm\" id=\"new_fnct_nm\"  maxlength=\"100\" onkeyup=\"cfLengthCheck('상세기능명은', this, 100);\"></div></td>";
            layer += "	</tr>";
            layer += "	<tr>";
            layer += "		<th class=\"required_field\">메뉴유형</th>";
            layer += "		<td><div class=\"outBox1\">" + menuTypeComboStr + "</div></td>";
            layer += "		<th>정렬순서</th>";
            layer += "		<td><div class=\"outBox1\"><input type=\"text\" class=\"form-control\" name=\"new_srt_ord\" id=\"new_srt_ord\" maxlength=\"4\" onkeypress=\"return checkNum(event);\" value=\"" + nextSrtOrd + "\"></div></td>";
            layer += "	</tr>";
            layer += "	<tr>";
            layer += "		<th>사용여부</th>";
            layer += "		<td><div class=\"outBox1\">" + useYnComboStr + "</div></td>";
            layer += "		<th>전시여부</th>";
            layer += "		<td><div class=\"outBox1\">" + dispYnComboStr + "</div></td>";
            layer += "	</tr>";
            layer += "	<tr class=\"new_ty_info\"></tr>";
            layer += "	<tr>";
            layer += "		<th class=\"bor_last\">URL</th>";
            layer += "		<td colspan=\"3\"><div class=\"outBox1\"><input type=\"text\" class=\"form-control\" name=\"new_url\" id=\"new_url\" maxlength=\"100\" onkeyup=\"cfLengthCheck('URL은', this, 100);\"></div></td>";
            layer += "	</tr>";
            layer += "	<tr>";
            layer += "		<th class=\"bor_last\">비고</th>";
            layer += "		<td colspan=\"3\" class=\"bor_last\"><div class=\"outBox1\"><input type=\"text\" class=\"form-control\" name=\"new_rm\" id=\"new_rm\" maxlength=\"500\" onkeyup=\"cfLengthCheck('비고는', this, 500);\"></div></td>";
            layer += "	</tr>";
            layer += "</table>";

            $("#insertArea").append(layer);
            $("#insertBtn").show();

            fnSetNumeric();
            fnSetUrlTyCode();
        } //입력폼 보기 끝

        //신규등록 url 유형 코드 이벤트
        function fnSetUrlTyCode() {
            $('[name=new_url_ty_code]').on('change', function () {
                $(this).closest('table').find('th.new_name').text('');
                $(this).closest('table').find('td.new_code').text('');

                if ($(this).val() == "10") {
                    fnSelectBbsCode("", $(this), "new_");
                    return false;
                }
                if ($(this).val() == "20") {
                    fnSelectCntntsId($(this), "new_");
                    return false;
                }
                if ($(this).val() == "30") {
                    $(this).closest('tr').next('tr').html("");
                    return false;
                }
            });

        }

        //입력폼 삭제
        function fnRemove(removeId) {
            $("#" + removeId).remove();

            if ($("#insertArea").html().length == 0) {
                $("#insertBtn").hide();
            }
        }

        //메뉴정보 수정
        function fnUpdate() {

            if ($("#menu_id").val() == "") {
                alert("메뉴를 선택해 주세요.");
                return;
            } else {

                if ($("#menu_nm").val() == "") {
                    alert("메뉴명을 입력해 주세요.");
                    $("#menu_nm").focus();
                    return;
                }

                if ($("#menu_type_code").val() == "") {
                    alert("메뉴유형을 입력해 주세요.");
                    $("#menu_nm").focus();
                    return;
                }

                if ($('#url_ty_code').val() == "10" && ($('[name=bbs_organ_code]').val() == "" || $('[name=bbs_code]').val() == "")) {
                    alert("게시판을 선택해 주세요.");
                    $("#bbs_organ_code").focus();
                    return;
                } else if ($('#url_ty_code').val() == "20" && $('[name=cntnts_id]').val() == "") {
                    alert("컨텐츠를 선택해 주세요.");
                    $("#btnCntnts").focus();
                    return;
                }

                fnUpdateCheck();
            }
        } //메뉴정보 수정 끝

        //수정한 정보 체크
        function fnUpdateCheck() {
            var req = {
                "up_menu_id": $("#up_menu_id").val()
                , "menu_id": $("#menu_id").val()
                , "srt_ord": $("#srt_ord").val()
            };

            jQuery.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/admin/menu/selectExistSortMenuMgtAjax.do',
                data: req,
                success: function (param) {
                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }
                    if (param.resultMap.EXIST_SORT_YN == "Y") {
                        alert("중복된 정렬 순서가 존재합니다.\n다른 정렬 순서번호를 이용하시기바랍니다.");
                    } else {
                        if (confirm("수정하시겠습니까?")) {
                            $("#aform").attr({action: "/admin/menu/updateMenuMgt.do", method: 'post'}).submit();
                        }
                    }
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        } //수정한 정보 체크

        //메뉴 신규 등록
        function fnInsert() {
            var newMenuIdList = f_getList("new_menu_id");
            var newMenuNmList = f_getList("new_menu_nm");
            var newMenuTypeCodeList = f_getList("new_menu_type_code");
            var newUseYnList = f_getList("new_use_yn");
            var newDispYnList = f_getList("new_disp_yn");

            var newStrOrdList = f_getList("new_srt_ord");

            var dupChkYnList = f_getList("dup_chk_yn");
            var newUrlList = f_getList("new_url");

            var menuIdDupYn = false;

            if (newMenuIdList.length == 0) {

                alert("신규메뉴정보를 입력해 주세요.");
                return;
            } else {

                for (i = 0; i < newMenuIdList.length; i++) {

                    if (newMenuIdList[i].value == "") {
                        alert("신규 메뉴ID를 입력해 주세요.");
                        newMenuIdList[i].focus();
                        return;
                    }
                    if (/^[0-9]{4}$/.test(newMenuIdList[i].value) == false) {
                        alert("신규 메뉴ID를 4자리수를 입력해 주세요.");
                        newMenuIdList[i].focus();
                        return;
                    }

                    if (dupChkYnList[i].value == "N") {
                        alert($("#menu_id").val() + "" + newMenuIdList[i].value + " 메뉴ID의 중복검사가 필요합니다.");
                        return;
                    }

                    if (newMenuNmList[i].value == "") {
                        alert("신규 메뉴명을 입력해 주세요.");
                        newMenuNmList[i].focus();
                        return;
                    }

                    if (newMenuTypeCodeList[i].value == "") {
                        alert("신규 메뉴유형을 입력해 주세요.");
                        newMenuTypeCodeList[i].focus();
                        return;
                    }
                }

                //메뉴 아이디 중복 검사
                var dupCnt = 0;
                for (i = 0; i < newMenuIdList.length; i++) {

                    dupCnt = 0;

                    for (k = 0; k < newMenuIdList.length; k++) {

                        if (newMenuIdList[i].value == newMenuIdList[k].value) {
                            dupCnt++;
                            //alert(newMenuIdList[i]+":"+newMenuIdList[k]+":"+dupCnt);
                            if (dupCnt > 1) {
                                menuIdDupYn = true;
                                break;
                            }
                        }
                    }
                }

                if (menuIdDupYn) {
                    alert("메뉴ID가 중복입력 되었습니다.");
                    return;
                }

                if ($('#new_url_ty_code').val() == "10" && ($('[name=new_bbs_organ_code]').val() == "" || $('[name=new_bbs_code]').val() == "")) {
                    alert("게시판을 선택해 주세요.");
                    $("#new_bbs_code").focus();
                    return;
                } else if ($('#new_url_ty_code').val() == "20" && $('[name=new_cntnts_id]').val() == "") {
                    alert("컨텐츠를 선택해 주세요.");
                    $("#new_btnCntnts").focus();
                    return;
                }

                if (confirm("등록하시겠습니까?")) {
                    $("#aform").attr({action: "/admin/menu/insertMenuMgt.do", method: 'post'}).submit();
                }
            }

        } //매뉴 신규 등록 끝

        //메뉴 삭제
        function fnDelete() {

            if ($("#menu_id").val() == "") {
                alert("메뉴를 선택해 주세요.");
                return;
            }
            if ($("#up_menu_id").val() == "") {
                alert("Root는 삭제할 수 없습니다.");
                return;
            }

            if (confirm("\nWARNNING!!!!\n\n하위 메뉴 포함하여 삭제됩니다. \n\n삭제하시겠습니까?\n")) {
                $("#aform").attr({action: "/admin/menu/deleteMenuMgt.do", method: 'post'}).submit();
            }
        }

        //게시판 코드 리스트 조회
        function fnSelectBbsCode(organCode, urlTyCodeObj, prefix) {
            var req = {
                organ_code: organCode
            };

            jQuery.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/admin/menu/selectListBbsCodeAjax.do',
                data: req,
                success: function (param) {
                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    if (organCode == "") {
                        var str = "<th>기관</th>";
                        str += "<td>";
                        str += "  <select name=\"" + prefix + "bbs_organ_code\" class=\"form-control\">";
                        str += param.organComboStrText;
                        str += "	</select>";
                        str += "	<input type='hidden' name='subpath' />";
                        str += "</td>";
                        str += "<th>게시판 명</th>";
                        str += "<td>";
                        str += "  <select name=\"" + prefix + "bbs_code\" disabled=\"disabled\" class=\"form-control\">";
                        str += "		<option>게시판</option>";
                        str += "	</select>";
                        str += "</td>";
                        $(urlTyCodeObj).closest('tr').next().html(str);
                        fnSetBbsCode(prefix);
                        return;

                    } else {
                        if (param.bbsListLength == 0) {
                            $(urlTyCodeObj).closest('table').find("[name=" + prefix + "bbs_code]").html('<option value="">게시판</option>');
                            $(urlTyCodeObj).closest('table').find("[name=" + prefix + "bbs_code]").prop('disabled', true);
                            return;
                        } else {
                            $(urlTyCodeObj).closest('table').find("[name=" + prefix + "bbs_code]").html(param.bbsCodeComboStrText);
                            $(urlTyCodeObj).closest('table').find("[name=" + prefix + "bbs_code]").prop('disabled', false);
                            $(urlTyCodeObj).closest('table').find("[name=subpath]").val("/" + param.subpath);
                            return;
                        }
                    }
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        //게시판 코드 select 이벤트
        function fnSetBbsCode(prefix) {
            $('[name=' + prefix + 'bbs_organ_code]').on('change', function () {
                fnSelectBbsCode($(this).val(), $(this), prefix);
            });

            $('[name=' + prefix + 'bbs_code]').on('change', function () {
                $(this).closest('table').find('th.name').text('게시판 코드');
                $(this).closest('table').find('td.code').text($(this).val());

                if ($(this).closest('table').find('[name=' + prefix + 'menu_nm]').val().indexOf("상세") == -1) {
                    var subpath = $(this).closest('table').find('[name=subpath]').val();
                    $(this).closest('table').find('[name=' + prefix + 'url]').val(subpath + '<%=param.getString("selectPageListBbsUrl")%>' + $(this).val());
                }
            });
        }

        //콘텐츠 조회
        function fnSelectCntntsId(urlTyCodeObj, prefix) {
            var str = "<th>[기관]콘텐츠 제목</th>";
            str += "<td colspan=\"2\" class=\"cntnts_nm\"></td>";
            str += "<td>";
            str += "  <span class='btnR'><button type=\"button\" id='" + prefix + "btnCntnts' onclick=\"fnSearchCntnts('" + prefix + "', this)\" class=\"btn btn-primary\">콘텐츠 검색</button></span>";
            str += "  <input type=\"hidden\" name=\"" + prefix + "cntnts_id\">";
            str += "</td>";
            $(urlTyCodeObj).closest('tr').next('tr').html(str);
        }

        //콘텐츠 조회 window popup
        function fnSearchCntnts(prefix, obj) {
            var popupX = (window.screen.width / 2) - (800 / 2); // 만들 팝업창 좌우 크기의 1/2 만큼 보정값으로 빼주었음
            var popupY = (window.screen.height / 2) - (1000 / 2); // 만들 팝업창 상하 크기의 1/2 만큼 보정값으로 빼주었음

            var tbId = $(obj).closest('table').attr('id');
            window.open('/admin/menu/selectPageListCntnts.do?prefix=' + prefix + '&tbId=' + tbId, 'popup', 'width=1000, height=800, left=' + popupX + ', top=' + popupY + ', screenX=' + popupX + ', screenY= ' + popupY);
            document.aform.target = 'popup';
        }

        function fnChageParentMenuId(obj) {
            document.location.href = "/admin/menu/selectListMenuMgt.do?sch_parent_menu_id=" + obj.value;
        }
    </script>
</head>
<body class="hold-transition <%=cssSkin%> layout-top-nav">
<div class="wrapper">

    <!-- 헤더  -->
    <c:import url="/common/inc/header.do" charEncoding="utf-8"/>


    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>메뉴관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <form id="aform" method="post" action="/admin/menu/selectListMenuMgt.do">
                    <div class="col-lg-5">
                        <div id="id_resize" class="box box-primary" style="overflow-y: auto;">
                            <div class="box-body">
                                <div class="row">
                                    <div class="col-xs-6">
                                        <select name="sch_parent_menu_id" id="sch_parent_menu_id" class="form-control"
                                                onchange="fnChageParentMenuId(this);">
                                            <%=CommboUtil.getComboStr(parentMenuIdComboStr, "MENU_ID", "MENU_NM", param.getString("sch_parent_menu_id"), "")%>
                                        </select>
                                    </div>
                                    <div class="col-xs-6">
                                        <button type="button" class="btn btn-success pull-right"
                                                onclick="$('#jstree').jstree('close_all');"><i class="fa fa-minus"></i>
                                            접기
                                        </button>
                                        <button type="button" class="btn btn-primary pull-right"
                                                style="margin-right: 5px;" onclick="$('#jstree').jstree('open_all');"><i
                                                class="fa fa-plus"></i> 펼치기
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <!-- 접기, 펼치기 -->

                            <!-- 좌측 메뉴 트리 -->
                            <div class="left_list" id="jstree">
                                <ul>
                                    <li>
                                        <%
                                            int dataCnt = resultList.size();
                                            int tagSumCnt = 0;
                                            int lvDept = 0;

                                            DataMap resutMap = new DataMap();
                                            DataMap oldResutMap = new DataMap();

                                            for (int i = 0; i < dataCnt; i++) {

                                                resutMap = (DataMap) resultList.get(i);

                                                if (i == 0) {
                                                    out.println(
                                                            "<a class=\"pointer\" onclick=\"fnSelectMenuInfo('"
                                                                    + resutMap.getString("MENU_ID")
                                                                    + "', '"
                                                                    + resutMap.getString("MENU_NM")
                                                                    + "', '"
                                                                    + resutMap.getString("MENU_LEVEL")
                                                                    + "');return false;\">"
                                                                    + resutMap.getString("MENU_NM") + "</a>");
                                                } else {

                                                    oldResutMap = (DataMap) resultList.get(i - 1);

                                                    if (oldResutMap.getInt("MENU_LEVEL") < resutMap.getInt("MENU_LEVEL")) {
                                                        //하위레벨일경우
                                                        out.print("<ul><li>");
                                                        tagSumCnt++;
                                                    }

                                                    if (oldResutMap.getInt("MENU_LEVEL") == resutMap.getInt("MENU_LEVEL")) {
                                                        //동레벨일경우
                                                        out.print("</li><li>");
                                                    }

                                                    if (oldResutMap.getInt("MENU_LEVEL") > resutMap.getInt("MENU_LEVEL")) {
                                                        //상위레벨일경우
                                                        lvDept = oldResutMap.getInt("MENU_LEVEL") - resutMap.getInt("MENU_LEVEL");

                                                        for (int k = 0; k < lvDept; k++) {

                                                            out.println("</li></ul>");
                                                            tagSumCnt--;
                                                        }

                                                        out.println("<li>");
                                                    }

                                                    out.println(
                                                            "<a href=\"#\" onclick=\"fnSelectMenuInfo('"
                                                                    + resutMap.getString("MENU_ID")
                                                                    + "', '"
                                                                    + resutMap.getString("MENU_NM")
                                                                    + "', '"
                                                                    + resutMap.getString("MENU_LEVEL")
                                                                    + "');return false;\">"
                                                                    + resutMap.getString("MENU_NM") + "</a>");
                                                }
                                            }

                                            for (int i = 0; i < tagSumCnt; i++) {
                                                out.println("</li></ul>");
                                                tagSumCnt--;
                                            }
                                        %>
                                    </li>
                                </ul>
                            </div>    <!-- 좌측 메뉴 트리 끝 -->
                        </div>
                    </div>
                    <!-- 우측 메뉴 정보 -->
                    <div class="col-lg-7">
                        <div class="box box-primary">
                            <div class="box-body no-pad-top">
                                <input type="hidden" name="sort_ordr_1" id="sort_ordr_1"/>
                                <input type="hidden" name="sort_ordr_2" id="sort_ordr_2"/>
                                <input type="hidden" name="sort_ordr_3" id="sort_ordr_3"/>
                                <input type="hidden" name="sort_ordr_4" id="sort_ordr_4"/>
                                <input type="hidden" name="sort_ordr_5" id="sort_ordr_5"/>
                                <input type="hidden" name="sort_ordr_6" id="sort_ordr_6"/>
                                <input type="hidden" name="new_menu_id_val" id="new_menu_id_val"/>
                                <input type="hidden" name="new_srt_ord_val" id="new_srt_ord_val"/>
                                <input type="hidden" name="url_ty_code" value="30"/>

                                <table class="table table-bordered" id="defaultTb">
                                    <caption><%=PAGE_TITLE%>
                                    </caption>
                                    <colgroup>
                                        <col style="width: 20%;"/>
                                        <col style="width: 30%;"/>
                                        <col style="width: 20%;"/>
                                        <col style="width: 30%;"/>
                                    </colgroup>
                                    <tr>
                                        <th>상위메뉴 ID</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" name="up_menu_id"
                                                       id="up_menu_id" readonly>
                                            </div>
                                        </td>
                                        <th>상위메뉴명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" name="up_menu_nm"
                                                       id="up_menu_nm" readonly>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>메뉴 ID</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" name="menu_id" id="menu_id"
                                                       readonly>
                                            </div>
                                        </td>
                                        <th>메뉴레벨</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" name="menu_lv" id="menu_lv"
                                                       readonly>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">메뉴명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" name="menu_nm" id="menu_nm"
                                                       onkeyup="cfLengthCheck('메뉴명은', this, 100);">
                                            </div>
                                        </td>
                                        <th>상세기능명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" name="fnct_nm" id="fnct_nm"
                                                       onkeyup="cfLengthCheck('상세기능명은', this, 100);">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">메뉴유형</th>
                                        <td>
                                            <div class="outBox1">
                                                <select name="menu_type_code" id="menu_type_code" class="form-control">
                                                    <%=CommboUtil.getComboStr(menuTypeComboStr, "CODE", "CODE_NM", "", "C")%>
                                                </select>
                                            </div>
                                        </td>
                                        <th>정렬순서</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" name="srt_ord" id="srt_ord"
                                                       onkeypress="return checkNum(event);" maxlength="4">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>사용여부</th>
                                        <td>
                                            <select name="use_yn" id="use_yn" class="form-control">
                                                <%=CommboUtil.getComboStr(useYnComboStr, "CODE", "CODE_NM", "", "")%>
                                            </select>
                                        </td>
                                        <th>전시여부</th>
                                        <td>
                                            <select name="disp_yn" id="disp_yn" class="form-control">
                                                <%=CommboUtil.getComboStr(dispYnComboStr, "CODE", "CODE_NM", "", "")%>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr class="ty_info"></tr>
                                    <tr>
                                        <th>URL</th>
                                        <td colspan="3"><input type="text" class="form-control" name="url" id="url"
                                                               onkeyup="cfLengthCheck('URL은', this, 100);"></td>
                                    </tr>
                                    <tr>
                                        <th class="bor_last">비고</th>
                                        <td class="bor_last" colspan="3"><input type="text" class="form-control"
                                                                                name="rm" id="rm"
                                                                                onkeyup="cfLengthCheck('비고는', this, 500);">
                                        </td>
                                    </tr>
                                </table>

                                <br/>
                                <div class="row">
                                    <div class="col-xs-6">
                                        <button type="button" class="btn btn btn-primary"
                                                onclick="fnUpdate(); return false;">수정
                                        </button>
                                        <button type="button" class="btn btn-warning"
                                                onclick="fnDelete(); return false;">
                                            <i class="fa fa-trash"></i> 삭제
                                        </button>
                                    </div>

                                    <div class="col-xs-6" style="text-align: right;">
											<span class="btnR">
												<button type="button" class="btn btn-info"
                                                        onclick="fnInsertForm(); return false;">
													<i class="fa fa-plus"></i> 신규등록
												</button>
											</span>
                                    </div>
                                </div>
                            </div>    <!-- 우측 메뉴 정보 끝 -->

                            <!-- 하위 메뉴 생성 -->
                            <div class="box-body no-pad-top">
                                <span id="insertArea"></span>
                                <div class="show_btn mT10" id="insertBtn" style="display: none;">
                                    <button type="button" class="btn btn-info" onclick="fnInsert(); return false;">등록
                                    </button>
                                </div>
                            </div>
                        </div>    <!-- box-primary -->
                    </div>    <!-- col-xs-7 -->
                </form>    <!-- aform -->
            </div>    <!-- row -->
        </section>    <!-- content -->
    </div>    <!-- content-wrapper -->

    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!--//footer -->
</div>    <!-- wrapper -->
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>