<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="organSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="packetStatusSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>

    <script type="text/javascript">
        //<![CDATA[
        //이메일 도메인 select setting
        $(document).ready(function () {

            $('[name=begin_valid_de]').datetimepicker({
                locale: 'ko', 	// 화면에 출력될 언어를 한국어로 설정한다.
                format: 'YYYY.MM.DD',
                useCurrent: false, 	//Important! See issue #1075
                sideBySide: true,
            });

            $('[name=end_valid_de]').datetimepicker({
                locale: 'ko', 	// 화면에 출력될 언어를 한국어로 설정한다.
                format: 'YYYY.MM.DD',
                useCurrent: false, 	//Important! See issue #1075
                sideBySide: true,
            });


            $('[name=del_modl_no]').change(function () {
                if ($(this).is(":checked")) {
                    $(this).next().prop("checked", true);
                } else {
                    $(this).next().prop("checked", false);
                }
            });

            // 엑셀 파일 업로드 check
            $("#excelfile").on("change", function () {

                if ($("#excelfile").val() != '') {

                    var formData = new FormData(document.getElementById("excelUploadForm"));

                    $.ajax({
                        url: "/iot/certkey/uploadExcelAjax.do",
                        type: "POST",
                        data: formData,
                        dataType: "json",
                        contentType: false,
                        processData: false,
                        success: function (data) {
                            var resultMap = data.resultMap;

                            // 에러 결과 메세지
                            var errorMessageList = resultMap.errorMessageList;

                            if (errorMessageList.length > 0) {
                                var errorStr = "";

                                for (var i = 0; i < errorMessageList.length; i++) {
                                    errorStr += errorMessageList[i] + "\n";
                                }

                                $("#upload_result_msg").html(errorStr);
                                $("#excelfile").val("");

                            } else {

                                alert("엑셀 업로드가 완료되었습니다.");

                                $("[name = trnsmit_server_no]").val(resultMap.trnsmit_server_no);
                                $("#aform").attr({
                                    action: "/iot/certkey/saveFormCertKeyStep0.do",
                                    method: 'post'
                                }).submit();
                            }
                        },
                        error: function (result) {
                            alert("파일 업로드중 에러가 발생했습니다.");
                            $("#excelfile").val("");
                        }
                    })
                }

            });
            // end : 엔셀 파일 업로드 check
        });

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
                action: "/iot/certkey/selectPageListCertKey.do",
                method: 'post'
            }).submit();

        }

        //모델 마스터 추가 페이지 이동
        function fnGoModelInsert() {

            if ($("#aform [name=trnsmit_server_no]").val() == "") {
                alert("먼저 송신 서버 정보를 저장하시기 바랍니다. ");
                return false;
            }

            $("#aform").attr({
                action: "/iot/certkey/saveFormCertKeyStep1.do",
                method: 'post'
            }).submit();
        }

        //등록
        function fnGoInsert(f) {
            if (f == 1) {

                if ($("#organ_code").val() == "") {
                    alert("관리기관을 선택해 주세요.");
                    $("#organ_code").focus();
                    return false;
                }

                if ($("#chrg_dept_nm").val() == "") {
                    alert("관리기관 부서명을 입력해 주세요.");
                    $("#chrg_dept_nm").focus();
                    return false;
                }

                if ($("#charger_nm").val() == "") {
                    alert("관리기관 담당자명을 입력해 주세요.");
                    $("#charger_nm").focus();
                    return false;
                }

                if ($("#charger_cttpc").val() == "") {
                    alert("관리기관 연락처를 입력해 주세요.");
                    $("#charger_cttpc").focus();
                    return false;
                }

                if ($("#server_ip").val() == "") {
                    alert("송신IP(공인IP)를 입력해 주세요.");
                    $("#server_ip").focus();
                    return false;
                }

                if ($("#server_nm").val() == "") {
                    alert("서버 명을 입력해 주세요.");
                    $("#server_nm").focus();
                    return false;
                }

                $("#aform").attr({action: "/iot/certkey/saveCertKeyStep0.do", method: 'post'}).submit();

            } else {

                if ($("#certkey_form [name=trnsmit_server_no]").val() == "") {
                    alert("먼저 송신 서버 정보를 저장하시기 바랍니다. ");
                    return false;
                }

                $("#certkey_form").attr({action: "/iot/certkey/saveCertKeyStep0.do", method: 'post'}).submit();
            }
        }

        function fnModelDetail(data_no, srvc_nm) {
            $("#data_no").val(data_no);
            $("#p_srvc_nm").val(srvc_nm);

            $("#aform").attr({
                action: "/iot/certkey/saveFormCertKeyStep1.do",
                method: 'post'
            }).submit();
        }

        //인증키 발급
        function fnCertkeyApply() {

            if ($("#aform [name=trnsmit_server_no]").val() == "") {
                alert("먼저 송신 서버 정보를 저장하시기 바랍니다. ");
                return false;
            }

            if ($("#certkey").val() != "") {
                alert("이미 인증키를 발급받으셨습니다. ");
                return false;
            }

            if (confirm("인증키를 발급하시겠습니까?")) {
                $("#aform").attr({
                    action: "/iot/certkey/createCertKey.do",
                    method: 'post'
                }).submit();
            }
        }

        //삭제
        function fnDelete() {
            var delDataNoList = f_getList("del_modl_no");
            var chkFag = false;

            for (i = 0; i < delDataNoList.length; i++) {
                if (delDataNoList[i].checked == true) {
                    chkFag = true;
                    break;
                }
            }

            if (chkFag == false) {
                alert("삭제할 모델 정보를 선택해 주세요.");
                return;
            }
            if (confirm("삭제하시겠습니까?")) {
                $("#delete_form").attr({action: "/iot/certkey/deleteModel.do", method: 'post'}).submit();
            }
        }

        function fnExcelUpload() {
            document.getElementById('excelfile').click();
        }

        function fnEditAble() {
            $("#certkey").prop("readonly", false);
        }

        // 엑셀 다운로드
        function fnExceldownload() {
            var downDataNoList = f_getList("del_modl_no");
            var downDataNoListLen = $("input:checkbox[name=del_modl_no]:checked").length;
            var chkFag = false;

            for (i = 0; i < downDataNoList.length; i++) {
                if (downDataNoList[i].checked == true) {
                    chkFag = true;
                    break;
                }
            }

            if (chkFag == false) {
                alert("서비스를 선택해 주세요.");
                return;
            }

            if (downDataNoListLen > 1) {
                alert("서비스를 1개 만 선택해 주세요.");
                return;
            }

            $("#delete_form").attr({action: "/iot/certkey/exceldownloadCertkey.do", method: 'post'}).submit();
        }

        //]]>
    </script>
</head>
<body class="hold-transition <%=cssSkin%> layout-top-nav">
<div class="wrapper">

    <!-- 헤더  -->
    <c:import url="/common/inc/header.do" charEncoding="utf-8"/>

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
                        <input type="hidden" name="trnsmit_server_no" value="${param.trnsmit_server_no}"/>
                        <input type="hidden" id="data_no" name="data_no"/>
                        <input type="hidden" id="p_srvc_nm" name="p_srvc_nm"/>
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

                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width: 15%;">
                                        <col style="width: 10%;">
                                        <col style="width: 25%;">
                                        <col style="width: 15%;">
                                        <col style="width: 10%;">
                                        <col style="width: 25%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th rowspan="4" class="required_field">관리기관(자치구)</th>
                                        <td>기관명</td>
                                        <td>
                                            <select id="organ_code" name="organ_code"
                                                    class="form-control input-sm input-sm">
                                                <%=CommboUtil.getComboStr(organSeComboStr, "CODE", "CODE_NM", resultMap.getString("ORGAN_CODE"), "기관")%>
                                            </select>
                                        </td>
                                        <th rowspan="4">송신 서버</th>
                                        <th class="required_field">송신 IP(공인 IP)</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="server_ip" name="server_ip"
                                                       placeholder="송신 IP(공인 IP)" maxlength="19"
                                                       value="${resultMap.SERVER_IP}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>부서명</td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm input-sm "
                                                       id="chrg_dept_nm" name="chrg_dept_nm" placeholder="부서 명"
                                                       maxlength="50" value="${resultMap.CHRG_DEPT_NM}">
                                            </div>
                                        </td>
                                        <th class="required_field">서버 명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="server_nm" name="server_nm"
                                                       placeholder="서버 명" maxlength="50" value="${resultMap.SERVER_NM}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>담당자 명</td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm input-sm"
                                                       id="charger_nm" name="charger_nm" placeholder="담당자 명"
                                                       maxlength="50" value="${resultMap.CHARGER_NM}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>연락처</td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm input-sm numeric"
                                                       id="charger_cttpc" name="charger_cttpc" placeholder="연락처"
                                                       maxlength="50" value="${resultMap.CHARGER_CTTPC}">
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- 업체명 -->
                                    <tr>
                                        <th rowspan="3">제작(설치)업체</th>
                                        <td>업체 명</td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm input-sm"
                                                       id="instl_entrps_nm" name="instl_entrps_nm" placeholder="업체 명"
                                                       maxlength="50" value="${resultMap.INSTL_ENTRPS_NM}">
                                            </div>
                                        </td>
                                        <th rowspan="3">유지보수업체</th>
                                        <td>업체 명</td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm input-sm"
                                                       id="mntnce_entrpsnm" name="mntnce_entrpsnm" placeholder="업체 명"
                                                       maxlength="50" value="${resultMap.MNTNCE_ENTRPSNM}">
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- 담당자 명 -->
                                    <tr>
                                        <td>담당자 명</td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm input-sm"
                                                       id="instl_entrps_charger_nm" name="instl_entrps_charger_nm"
                                                       placeholder="담당자 명" maxlength="50"
                                                       value="${resultMap.INSTL_ENTRPS_CHARGER_NM}">
                                            </div>
                                        </td>
                                        <td>담당자 명</td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm input-sm"
                                                       id="mntnce_entrps_charger_nm" name="mntnce_entrps_charger_nm"
                                                       placeholder="담당자 명" maxlength="50"
                                                       value="${resultMap.MNTNCE_ENTRPS_CHARGER_NM}">
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- 연락처 -->
                                    <tr>
                                        <td>연락처</td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm input-sm numeric"
                                                       id="instl_entrps_cttpc" name="instl_entrps_cttpc"
                                                       placeholder="연락처" maxlength="50"
                                                       value="${resultMap.INSTL_ENTRPS_CTTPC}">
                                            </div>
                                        </td>
                                        <td>연락처</td>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm input-sm numeric"
                                                       id="mntnce_entrps_cttpc" name="mntnce_entrps_cttpc"
                                                       placeholder="연락처" maxlength="50"
                                                       value="${resultMap.MNTNCE_ENTRPS_CTTPC}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>비고(특이사항 기재)</th>
                                        <td colspan="5">
                                            <div class="outBox1">
                                                <textarea class="form-control" rows="6" id="rm" name="rm"
                                                          placeholder="비고(특이사항 기재)"
                                                          maxlength="2000">${resultMap.RM}</textarea>
                                            </div>
                                        </td>
                                    </tr>

                                    <!--
											<tr>
												<th class="required_field">송신 IP(공인 IP)</th>
												<td>
													<div class="outBox1">
														<input type="text" class="form-control input-sm input-sm" id="server_ip" name="server_ip" placeholder="송신 IP(공인 IP)" maxlength="19" value="${resultMap.SERVER_IP}">
													</div>
												</td>
												<th class="required_field">서버 명</th>
												<td>
													<div class="outBox1">
														<input type="text" class="form-control input-sm input-sm" id="server_nm" name="server_nm" placeholder="서버 명" maxlength="50" value="${resultMap.SERVER_NM}">
													</div>
												</td>
											</tr>
											<tr>
												<th colspan="2">비고(특이사항 기재)</th>
												<td colspan="2">
													<div class="outBox1">
														<textarea class="form-control input-sm input-sm" rows="3" id="rm" name="rm" placeholder="비고(특이사항 기재)" maxlength="2000" >${resultMap.RM}</textarea>
													</div>
												</td>
											</tr>
											 -->
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info" onclick="fnGoInsert(1); return false;"><i
                                            class="fa fa-pencil"></i> 저장
                                    </button>
                                </div>
                            </div><!-- /.box-footer -->
                        </div><!-- /.box -->
                    </form>

                    <form role="form" id="certkey_form" method="post">
                        <input type="hidden" name="trnsmit_server_no" value="${param.trnsmit_server_no}"/>
                        <input type="hidden" id="certkey_seq" name="certkey_seq" value="${resultMap.CERTKEY_SEQ}"/>
                        <input type="hidden" name="certkey_form" value="Y"/>
                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width: 10%;">
                                        <col style="width: 40%;">
                                        <col style="width: 10%;">
                                        <col style="width: 40%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>인증키</th>
                                        <td>
                                            <div class="input-group input-group-sm">
                                                <input type="text" class="form-control input-sm input-sm" id="certkey"
                                                       name="certkey" maxlength="20" value="${resultMap.CRTFC_KEY}"
                                                       readonly>
                                                <div class="input-group-btn">
                                                    <button type="button" class="btn btn-sm btn-default"
                                                            onclick="fnEditAble(); return false;">수정
                                                    </button>
                                                </div>
                                            </div>
                                        </td>
                                        <th>유효 기간</th>
                                        <td>
                                            <input type="text" class="form-control input-sm input-sm"
                                                   name="begin_valid_de" placeholder="시작 유효 기간" maxlength="40"
                                                   style="display: inline-block; width: 150px"
                                                   value="${resultMap.BEGIN_VALID_DE}" autocomplete="off"/> <span
                                                style="margin: 5px"> - </span> <input type="text"
                                                                                      class="form-control input-sm input-sm"
                                                                                      name="end_valid_de"
                                                                                      placeholder="종료 유효 기간"
                                                                                      maxlength="40"
                                                                                      style="display: inline-block; width: 150px"
                                                                                      value="${resultMap.END_VALID_DE}"
                                                                                      autocomplete="off"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>발급 상태</th>
                                        <td>
                                            <select id="sttus_code" name="sttus_code"
                                                    class="form-control input-sm input-sm">
                                                <%=CommboUtil.getComboStr(packetStatusSeComboStr, "CODE", "CODE_NM", resultMap.getString("STTUS_CODE"), "")%>
                                            </select>
                                        </td>
                                        <th>상태 수정일자</th>
                                        <td>
                                            ${resultMap.CERTKEY_UPDT_DT}
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default"
                                            onclick="fnCertkeyApply(); return false;"><i class="fa fa-fw fa-key"></i>
                                        인증키 발급
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnGoInsert(2); return false;"><i
                                            class="fa fa-pencil"></i> 저장
                                    </button>
                                </div>
                            </div><!-- /.box-footer -->
                        </div><!-- /.box -->
                    </form>

                    <div class="box box-primary">
                        <div class="box-body no-padding">
                            <table class="table table-bordered">
                                <colgroup>
                                    <col style="width: 10%;">
                                    <col style="width: 40%;">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>업로드 결과 메시지</th>
                                    <td>
                                        <div class="outBox1">
                                            <textarea class="form-control input-sm" rows="3" id="upload_result_msg"
                                                      name="upload_result_msg" readonly="readonly"></textarea>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div><!-- /.box-body -->

                        <form id="excelUploadForm" enctype="multipart/form-data" method="post">
                            <input type="hidden" id="excel_trnsmit_server_no" name="excel_trnsmit_server_no"
                                   value="<%=param.getString("trnsmit_server_no")%>">
                            <div class="box-footer">
                                <div class="pull-right">
                                    <input type="file" id="excelfile" name="excelfile" style="display:none"/>
                                    <button type="button" class="btn btn-info" onclick="fnExcelUpload(); return false;">
                                        <i class="fa fa-fw fa-level-up"></i> 인증키 발급 양식 업로드
                                    </button>
                                </div>
                            </div><!-- /.box-footer -->
                        </form>

                    </div><!-- /.box -->
                    <div class="box box-primary">
                        <div class="box-body no-padding">
                            <form role="form" id="delete_form" method="post">
                                <input type="hidden" name="trnsmit_server_no" value="${param.trnsmit_server_no}"/>
                                <table class="table table-hover table-bordered table_fixed">
                                    <colgroup>
                                        <col width="50"/>
                                        <col width="80"/>
                                        <col width="20%"/>
                                        <col width="*"/>
                                        <col width="10%"/>
                                        <col width="15%"/>
                                        <col width="15%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center"></th>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">서비스 분류</th>
                                        <th class="text-center">서비스 명</th>
                                        <th class="text-center">모델 명</th>
                                        <th class="text-center">센서 구분</th>
                                        <th class="text-center">설치 수</th>
                                        <th class="text-center">등록 일자</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:set value="${pageNavigationVo.getCurrDataNo()}" var="dataNo"></c:set>
                                    <c:choose>
                                        <c:when test="${resultList.size() == 0}">
                                            <td class="text-center" colspan="8"><spring:message
                                                    code="msg.data.empty"/></td>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="resultSet" items="${resultList}" varStatus="status">
                                                <tr style="cursor: pointer; cursor: hand;">
                                                    <td class="text-center txt_overflow">
                                                        <input type="checkbox" name="del_modl_no"
                                                               value="${resultSet.DATA_NO}"/>
                                                        <input type="checkbox" name="del_packet_mstr_no"
                                                               value="${resultSet.PACKET_MASTR_SEQ}"
                                                               style="display:none;"/></td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnModelDetail('${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.DATA_NO}</td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnModelDetail('${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.SRVC_LRANK_NM}</td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnModelDetail('${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.SRVC_NM}</td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnModelDetail('${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.MODL_NM }</td>
                                                    <td class="title txt_overflow"
                                                        onclick="fnModelDetail('${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.SENSOR_SE_NM}</td>
                                                    <td class="title txt_overflow"
                                                        onclick="fnModelDetail('${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.MODL_INSTL_CNT}</td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnModelDetail('${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.REGIST_DT}</td>
                                                </tr>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                        <!-- /.box-body -->
                        <div class="box-footer">
                            <div class="pull-left">
                                <button type="button" class="btn btn-info" onclick="fnExceldownload(); return false;"><i
                                        class="fa fa-file-excel-o"></i> 인증키 발급 문서 다운로드
                                </button>
                            </div>
                            <div class="pull-right">
                                <button type="button" class="btn btn-default" onclick="fnGoList(); return false;"><i
                                        class="fa fa-reply"></i> 목록
                                </button>
                                <button type="button" class="btn btn-default" onclick="fnDelete(); return false;">
                                    <i class="fa fa-fw fa-close"></i> 삭제
                                </button>
                                <button type="button" class="btn btn-info" onclick="fnGoModelInsert(); return false;">
                                    <i class="fa fa-fw fa-plus"></i> 추가
                                </button>
                            </div>
                        </div>
                        <!-- /.box-footer -->
                    </div>
                    <!-- /.box -->
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
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
