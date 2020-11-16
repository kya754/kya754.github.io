<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="crdntSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="rowPerPageComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

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
        $(function () {
            $("#currentPage").val("1");
            // datepick 한글 셋팅 common.js
            settingdatepickerko();

            $('[name=sch_start_ymd_2]').datepicker({
                dateFormat: 'yy.mm.dd',
                changeYear: true,
                changeMonth: true
            });

            $('[name=sch_end_ymd_2]').datepicker({
                dateFormat: 'yy.mm.dd',
                changeYear: true,
                changeMonth: true
            });

            $(".ui-datepicker-month").css({'color': '#222 !important'});

            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page_2").change(function () {
                fnSearch();
            });
        });

        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/iot/srvcRecptn/selectListModelSerialInfo.do", method: 'post'}).submit();
        }

        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/iot/srvcRecptn/selectListModelSerialInfo.do", method: 'post'}).submit();
        }

        // 목록으로 이동
        function fnList() {
            if ($("#currentPage").val() == null) {
                var hiddenHtml = "";
                hiddenHtml += '<input type="hidden" id="currentPage" name="currentPage" />';
                $('#aform').append(hiddenHtml);
            }

            $("#currentPage").val($("#pageList_currentPage").val());
            $("#sch_row_per_page").val($("#pageList_sch_row_per_page").val());
            $("#aform").attr({action: "/iot/srvcRecptn/selectPageListServiceRecptn.do", method: 'post'}).submit();
        }

        // 기기 등록
        function fnAdd() {
            var checkModlSerial = f_getList("check_modl_serial");
            var checkMoelSerialLen = $("input:checkbox[name=check_modl_serial]:checked").length;
            var hiddenHtml = null;
            var html = null;

            if (checkMoelSerialLen == 0) {
                alert("등록할 기기를 선택해주세요.");
                return;
            }

            $("#modlSerialAddModal").modal();
            $('#codeTable tbody>tr').remove();

            console.log($("#trnsmit_server_no").val());

            hiddenHtml = ' <input type="hidden" id="trnsmit_server_no" name="trnsmit_server_no" value="' + $("#trnsmit_server_no").val() + '" />';
            hiddenHtml += '<input type="hidden" id="data_no" name="data_no" value="' + $("#data_no").val() + '" />';
            $('#modalform').append(hiddenHtml);
            var row_no = null;
            for (var i = 0; i < checkMoelSerialLen; i++) {
                row_no = i + 1;
                html = '<tr>';
                html += '	<td class="text-center row_no">' + row_no + '</td>';
                html += '	<td><input type="text" name="modl_serial" class="form-control" readonly="readonly" value="' + checkModlSerial[i].value + '" maxlength="20"/></td>';
                html += '	<td><input type="text" name="post_no" class="form-control numeric" value="" maxlength="5"/></td>';
                html += '	<td><input type="text" name="adres" class="form-control" value="" maxlength="100"/></td>';
                html += '	<td><input type="text" name="adres_detail" class="form-control" value="" maxlength="100"/></td>';
                html += "	<td><select name='crdnt_code' class='form-control input-sm'> <%=CommboUtil.getComboStr(crdntSeComboStr, "CODE", "CODE_NM", param.getString(""), "")%> </select></td>";
                html += '	<td><input type="text" name="la" class="form-control" value="" maxlength="50"/></td>';
                html += '	<td><input type="text" name="lo" class="form-control" value="" maxlength="50"/></td>';
                html += '	<td><input type="text" name="antcty" class="form-control numeric" value="" maxlength="11"/></td>';
                html += '	<td><input type="text" name="buld_nm" class="form-control" value="" maxlength="50"/></td>';
                html += '	<td><input type="text" name="instl_floor" class="form-control" value="" maxlength="11"/></td>';
                html += '	<td><input type="text" name="instl_ho_no" class="form-control numeric" value="" maxlength="11"/></td>';
                html += '	<td><input type="text" name="rm" class="form-control" value="" maxlength="100"/></td>';
                html += '</tr>';
                $('#codeTable  tbody').append(html);
            }
        }


        // 모달 확인 -> 등록
        function fnGoaddModal() {
            $('#modalform').attr("trnsmit_server_no", "${param.data_no}");
            $("#modalform").submit();

            if (confirm("수정하시겠습니까?")) {
                $.ajax({
                    url: '/iot/srvcRecptn/saveModlSerialAjax.do',
                    data: $('#modalform').serialize(),
                    type: 'post',
                    dataType: 'json',
                    success: function (response) {
                        if (response.resultStats.resultCode == "error") {
                            alert(response.resultStats.resultMsg);
                            return;
                        }

                        alert('수정 하였습니다.');
                        location.reload();
                    }
                });
            }
        }

        // 엑셀 다운로드
        function fnExceldownload() {
            $("#aform").attr({action: "/iot/srvcRecptn/exceldownload.do", method: 'post'}).submit();
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
            $(".content-header h1").append("(<%=param.getString("srvc_nm")%>)");
        });
    </script>

    <!-- content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>서비스 수신 관리</h1>
        </section>
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form id="aform" method="post" action="iot/srvcRecptn/selectListRecptnIntrvlOverInfo.do">
                        <input type="hidden" id="trnsmit_server_no" name="trnsmit_server_no"
                               value="${param.trnsmit_server_no}"/>
                        <input type="hidden" id="data_no" name="data_no" value="${param.data_no}"/>
                        <input type="hidden" id="srvc_nm" name="srvc_nm" value="${param.srvc_nm}"/>
                        <%-- pageList --%>
                        <input type="hidden" id="pageList_currentPage" name="pageList_currentPage"
                               value="${param.pageList_currentPage}"/>
                        <input type="hidden" id="pageList_sch_row_per_page" name="pageList_sch_row_per_page"
                               value="${param.pageList_sch_row_per_page}"/>
                        <input type="hidden" id="sch_organ_code" name="sch_organ_code" value="${param.sch_organ_code}"/>
                        <input type="hidden" id="sch_srvc_hrank_code" name="sch_srvc_hrank_code"
                               value="${param.sch_srvc_hrank_code}"/>
                        <input type="hidden" id="sch_srvc_lrank_code" name="sch_srvc_lrank_code"
                               value="${param.sch_srvc_lrank_code}"/>
                        <input type="hidden" id="sch_srvc_nm" name="sch_srvc_nm" value="${param.sch_srvc_nm}"/>
                        <input type="hidden" id="sch_srvc_status" name="sch_srvc_status"
                               value="${param.sch_srvc_status}"/>
                        <input type="hidden" id="sch_srvc_nm2" name="sch_srvc_nm2" value="${param.sch_srvc_nm2}"/>
                        <input type="hidden" id="sch_start_ymd" name="sch_start_ymd" value="${param.sch_start_ymd}"/>
                        <input type="hidden" id="sch_end_ymd" name="sch_end_ymd" value="${param.sch_end_ymd}"/>
                        <input type="hidden" id="sch_row_per_page" name="sch_row_per_page"/>

                        <%@ include file="/common/inc/srvcRecptnTap.jspf" %>
                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <div class="form-group">
                                        <!--날자 검색-->
                                        <input type="text" class="form-control input-sm" id="sch_start_ymd_2"
                                               name="sch_start_ymd_2" placeholder="수신 시작일"
                                               value="<%=param.getString("sch_start_ymd_2")%>"/> -
                                        <input type="text" class="form-control input-sm" id="sch_end_ymd_2"
                                               name="sch_end_ymd_2" placeholder="수신 종료일"
                                               value="<%=param.getString("sch_end_ymd_2")%>"/>
                                    </div>
                                    <div class="form-group">
                                        <button type="button" class="btn btn-block btn-default btn-sm"
                                                onclick="fnSearch();">검색
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="box-body table-responsive no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col width="40">
                                        <col width="40">
                                        <col width="*">
                                        <col width="*">
                                        <col width="10%">
                                        <col width="10%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center"></th>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">관리번호</th>
                                        <%-- 모델 시리얼 --%>
                                        <th class="text-center">패킷</th>
                                        <th class="text-center">수집 데이터 건수</th>
                                        <th class="text-center">수집일시</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        DataMap DataMap = null;
                                        int dataNo = pageNavigationVo.getCurrDataNo();
                                        for (int i = 0; i < resultList.size(); i++) {
                                            DataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><input type="checkbox" name="check_modl_serial"
                                                                       value="<%=DataMap.getString("MODL_SERIAL")%>"/>
                                        </td>
                                        <td class="text-center"><%=dataNo - i%>
                                        </td>
                                        <td class="text-left"><%=DataMap.getString("MODL_SERIAL")%>
                                        </td>
                                        <td class="text-left"><%=DataMap.getString("PACKET")%>
                                        </td>
                                        <td class="text-center"><%=DataMap.getString("CNT")%>
                                        </td>
                                        <td class="text-center"><%=DataMap.getString("REGIST_DT")%>
                                        </td>
                                    </tr>
                                    <% }%>
                                    <%
                                        if (resultList.size() == 0) {
                                    %>
                                    <tr>
                                        <td class="text-center" colspan="6"><spring:message code="msg.data.empty"/></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
                                <div class="pull-left form-inline">
                                    Row Per Page
                                    <select id="sch_row_per_page_2" name="sch_row_per_page_2"
                                            class="form-control input-sm">
                                        <%=CommboUtil.getComboStr(rowPerPageComboStr, "CODE", "CODE_NM", param.getString("sch_row_per_page_2"), "")%>
                                    </select>
                                </div>
                                ${navigationBar}
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" class="btn btn-info update" onclick="fnAdd(); return false;"
                                            id="selectConf"><i class="fa fa-user-plus"></i>기기 등록
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
</body>

<div class="modal fade" id="modlSerialAddModal" tabindex="-1" role="dialog" aria-labelledby="modalLabel">
    <div class="modal-dialog" role="document" style="width:95%">
        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="modalLabel">기기 등록</h4>
            </div>

            <div class="modal-body">
                <form id="modalform" action="/iot/srvcRecptn/saveModlSerialAjax.do" method="post">

                    <table id="codeTable" class="table table-bordered">
                        <colgroup>
                            <col width="40">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                        </colgroup>
                        <thead>
                        <tr>
                            <th class="text-center">No</th>
                            <th class="text-center required_field">모델 시리얼</th>
                            <th class="text-center ">우편번호</th>
                            <th class="text-center ">주소</th>
                            <th class="text-center ">주소 상세</th>
                            <th class="text-center">좌표 구분</th>
                            <th class="text-center">위도</th>
                            <th class="text-center">경도</th>
                            <th class="text-center">고도(미터)</th>
                            <th class="text-center">건물 명</th>
                            <th class="text-center">설치 층</th>
                            <th class="text-center">설치 호</th>
                            <th class="text-center">비고</th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
            </div>
            </form>
            <div class="modal-footer">
                <button type="button" class="btn btn-info" onclick="fnGoaddModal(); return false;"><i
                        class="fa fa-pencil"></i>확인
                </button>
                <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-reply"></i>취소
                </button>
            </div>
        </div>
    </div>
</div>
</html>
<%@ include file="/common/inc/msg.jspf" %>
