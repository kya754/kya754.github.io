<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="organSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="lclasSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="mclasSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="sclasSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>
    <script type="text/javascript">
        //<![CDATA[
        $(document).ready(function () {	//스크롤 높이 창 크기에 따라 조정
            var windowHeight = $(window).height();
            $('.sub_fix_wrap').css('max-height', windowHeight * 0.55);
            sum();
        });

        $(function () {
            // datepick 한글 셋팅 common.js
            settingdatepickerko();
            //콤보 생성
            // 상, 하위 분류 콤보 생성
            fnSetHRankCombo();

            // 기관 셀렉트 박스 변경시 조회
            $("#sch_organ_code").change(function () {
                fnSearch();
            });
            // 서비스 명 셀렉트 박스 변경시 조회
            $("#sch_srvc_nm").change(function () {
                fnSearch();
            });

            $('[name=sch_start_ymd]').datepicker({
                dateFormat: 'yy.mm.dd',
                changeYear: true,
                changeMonth: true
            });
            $('[name=sch_end_ymd]').datepicker({
                dateFormat: 'yy.mm.dd',
                changeYear: true,
                changeMonth: true
            });
        });

        function sum() {
            var hiddenHtml = "";
            // 총 합계 column = 4
            for (var i = 1; i < 5; i++) {
                var sum = 0;
                var col = "col_" + i;
                col = $('[name=col_' + i + ']');

                for (var j = 0; j < col.length; j++) {
                    sum += Number(unComma(col[j].innerText));
                }
                $('[name=result_' + i + ']').text(comma(sum));
                hiddenHtml += '<input type="hidden" id="result_' + i + '" name="result_' + i + '" value=' + sum + ' />';
            }
            $('#aform').append(hiddenHtml);
        }

        function comma(num) {
            num = String(num);
            return num.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
        }

        function unComma(num) {
            num = String(num);
            return num.replace(/,/gi, "");
        }

        // 검색
        function fnSearch() {
            $("#aform").attr({action: "/iot/statsservice/selectRecptnDataStats.do", method: 'post'}).submit();
        }

        // 시스템 통계 엑셀 다운로드
        function fnExceldownload() {
            for (var i = 1; i < 5; i++) {

            }
            $("#aform").attr({action: "/iot/statsservice/exceldownloadRecptnDataStats.do", method: 'post'}).submit();
        }

        // 상위분류 콤보
        function fnSetHRankCombo() {
            var req = {
                "group_id": "R010250"
            };

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

                    var html = '<option value="">서비스 상위분류</option>';
                    var sel = "";
                    if (param.resultStats.resultList.length > 0) {

                        for (i = 0; i < param.resultStats.resultList.length; i++) {
                            sel = "";
                            if (param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_hrank_code")%>") {
                                sel = 'selected="selected"';
                            }
                            html += '<option value="' + param.resultStats.resultList[i].CODE + '" ' + sel + '>' + param.resultStats.resultList[i].CODE_NM + '</option>';

                        }
                    }

                    $("#sch_srvc_hrank_code").html(html);

                    fnSetLRankCombo();
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        // 하위분류 콤보
        function fnSetLRankCombo() {
            var req = {
                "group_id": "R010260"
                , "attrb_1": $("#sch_srvc_hrank_code").val()
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
                        if (param.resultStats.resultList.length > 0) {

                            for (i = 0; i < param.resultStats.resultList.length; i++) {

                                sel = "";
                                if (param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_lrank_code")%>") {
                                    sel = 'selected="selected"';
                                }
                                html += '<option value="' + param.resultStats.resultList[i].CODE + '" ' + sel + '>' + param.resultStats.resultList[i].CODE_NM + '</option>';

                            }
                        }
                        $("#sch_srvc_lrank_code").html(html);
                        $("#sch_srvc_lrank_code").attr("disabled", false);

                        fnSetServiceNmCombo();
                    },
                    error: function (jqXHR, textStatus, thrownError) {
                        ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                    }
                });
            }
        }

        //서비스명 콤보
        function fnSetServiceNmCombo() {
            var req = {
                "sch_srvc_hrank_code": $("#sch_srvc_hrank_code").val()
                , "sch_srvc_lrank_code": $("#sch_srvc_lrank_code").val()
                , "organ_code": $("#sch_organ_code").val()
            };

            var html = "";

            jQuery.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/common/selectListServiceNmAjax.do',
                data: req,
                success: function (param) {

                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    var sel = "";
                    html += '<option value="">서비스 명</option>';
                    if (param.resultStats.resultList.length > 0) {

                        for (i = 0; i < param.resultStats.resultList.length; i++) {

                            sel = "";
                            if (param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_nm")%>") {
                                sel = 'selected="selected"';
                            }
                            html += '<option value="' + param.resultStats.resultList[i].CODE + '" ' + sel + '>' + param.resultStats.resultList[i].CODE_NM + '</option>';
                        }
                    }
                    $("#sch_srvc_nm").html(html);
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        //]]>
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
            <h1>데이터 수집 현황</h1>
            <small>서비스별 데이터 정상 수집 여부를 기간별로 확인할 수 있습니다.</small>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <!-- content 영역 -->
                    <form id="aform" method="post">
                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <!--  기관 구분 -->
                                    <div class="form-group">
                                        <select id="sch_organ_code" name="sch_organ_code" class="form-control input-sm"
                                                width>
                                            <%=CommboUtil.getComboStr(organSeComboStr, "CODE", "CODE_NM", param.getString("sch_organ_code"), "기관")%>
                                        </select>
                                    </div>
                                    <%-- 서비스 상위분류 --%>
                                    <div class="form-group">
                                        <select id="sch_srvc_hrank_code" name="sch_srvc_hrank_code"
                                                class="form-control input-sm" onchange="fnSetLRankCombo();"></select>
                                    </div>
                                    <%-- 서비스 하위분류 --%>
                                    <div class="form-group">
                                        <select id="sch_srvc_lrank_code" name="sch_srvc_lrank_code"
                                                class="form-control input-sm"
                                                onchange="fnSetServiceNmCombo();"></select>
                                    </div>
                                    <div class="form-group">
                                        <!--서비스 명콤보 -->
                                        <select id="sch_srvc_nm" name="sch_srvc_nm"
                                                class="form-control input-sm"></select>
                                    </div>
                                    <!--날자 검색-->
                                    <div class="form-group">
                                        <input type="text" class="form-control input-sm" id="sch_start_ymd"
                                               name="sch_start_ymd" placeholder="검색 시작일"
                                               value="<%=param.getString("sch_start_ymd")%>"/> -
                                        <input type="text" class="form-control input-sm" id="sch_end_ymd"
                                               name="sch_end_ymd" placeholder="검색 종료일"
                                               value="<%=param.getString("sch_end_ymd")%>"/>
                                        <button type="button" class="btn btn-sm btn-default"
                                                onclick="fnSearch(); return false;"><i class="fa fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </div><!-- /.box-header -->
                            <div class="box-body no-pad-top table-responsive" style="border: 0px;">
                                <div class="sub_tbl_scroll_box_2h">
                                    <div class="sub_fix_th_bg_2h"></div>
                                    <div class="sub_fix_wrap">
                                        <table class="table table-bordered table-striped dataTable">
                                            <colgroup>
                                                <col style="width: 5%;">
                                                <col style="width: 6%;">
                                                <col style="width: 8%;">
                                                <col style="width: 22%;">
                                                <col style="width: 7.5%;">
                                                <col style="width: 7.5%;">
                                                <col style="width: 8%;">
                                                <col style="width: 8.5%;">
                                                <col style="width: 8.5%;">
                                                <col style="width: 8.5%;">
                                                <col style="width: 8.5%;">
                                            </colgroup>
                                            <thead>
                                            <tr>
                                                <th rowspan="2" scope="col" style="width: 5%;">
                                                    <div class="sub_fix_th_2h">번호
                                                </th>
                                                <th rowspan="2" scope="col" style="width: 6%;">
                                                    <div class="sub_fix_th_2h">구축년도
                                                </th>
                                                <th rowspan="2" scope="col" style="width: 8%;">
                                                    <div class="sub_fix_th_2h">기관 명
                                                </th>
                                                <th rowspan="2" scope="col" style="width: 22%;">
                                                    <div class="sub_fix_th_2h">서비스 명
                                                </th>
                                                <th rowspan="2" colspan="2" scope="col" style="width: 15%;">
                                                    <div class="sub_fix_th_2h">서비스 분류 체계
                                                </th>
                                                <th rowspan="2" scope="col" style="width: 8%;">
                                                    <div class="sub_fix_th_2h">연계 일자
                                                </th>
                                                <th colspan="2" scope="col" style="width: 17%;">
                                                    <div class="sub_fix_th">정상 수집 건수
                                                </th>
                                                <th colspan="2" scope="col" style="width: 17%;">
                                                    <div class="sub_fix_th">오류 수집 건수
                                                </th>
                                            </tr>
                                            <tr>
                                                <th scope="col" style="width: 8.5%;">
                                                    <div class="sub_fix_th_2h">기간</div>
                                                </th>
                                                <th scope="col" style="width: 8.5%;">
                                                    <div class="sub_fix_th_2h">전체</div>
                                                </th>
                                                <th scope="col" style="width: 8.5%;">
                                                    <div class="sub_fix_th_2h">기간</div>
                                                </th>
                                                <th scope="col" style="width: 8.5%;">
                                                    <div class="sub_fix_th_2h">전체</div>
                                                </th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:choose>
                                                <c:when test="${resultList.size() == 0}">
                                                    <td class="text-center" colspan="8"><spring:message
                                                            code="msg.data.empty"/></td>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="data" items="${resultList}" varStatus="status">
                                                        <tr>
                                                            <td class="text-center">
                                                                <c:out value="${fn:length(resultList) - status.index}"/>
                                                            </td>
                                                            <td class="text-center">${data.SRVC_YEAR}</td>
                                                            <td class="text-center">${data.ORGAN_NM}</td>
                                                            <td class="text-left">${data.SRVC_NM}</td>
                                                            <td class="text-center">${data.HRANK_NM}</td>
                                                            <td class="text-center">${data.LRANK_NM}</td>
                                                            <td class="text-center">${data.REGIST_DT}</td>
                                                            <td class="text-right" name="col_1">
                                                                <fmt:formatNumber type="number" maxFractionDigits="3"
                                                                                  value="${data.S_CNT}"/>
                                                            </td>
                                                            <td class="text-right" name="col_2">
                                                                <fmt:formatNumber type="number" maxFractionDigits="3"
                                                                                  value="${data.S_TOT_CNT}"/>
                                                            </td>
                                                            <td class="text-right" name="col_3">
                                                                <fmt:formatNumber type="number" maxFractionDigits="3"
                                                                                  value="${data.E_CNT}"/>
                                                            </td>
                                                            <td class="text-right" name="col_4">
                                                                <fmt:formatNumber type="number" maxFractionDigits="3"
                                                                                  value="${data.E_TOT_CNT}"/>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                            </tbody>
                                            <tfoot>
                                            <th class="text-right disabled_th" colspan="7">합계</th>
                                            <th class="text-right disabled_th" name="result_1"></th>
                                            <th class="text-right disabled_th" name="result_2"></th>
                                            <th class="text-right disabled_th" name="result_3"></th>
                                            <th class="text-right disabled_th" name="result_4"></th>
                                            </tfoot>
                                        </table>
                                    </div>
                                </div>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info"
                                            onclick="fnExceldownload(); return false;"><i
                                            class="fa fa-file-excel-o"></i> 통계 결과 엑셀 다운로드
                                    </button>
                                </div>
                            </div>
                        </div><!-- /.box -->
                    </form>
                    <!-- content 영역 -->
                </div><!-- /.col-xs-12 -->
            </div><!-- /.row -->
        </section><!-- /.content -->
    </div>
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!--//footer -->
</div>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
