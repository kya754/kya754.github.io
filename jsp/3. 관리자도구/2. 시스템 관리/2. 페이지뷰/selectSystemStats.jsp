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

<jsp:useBean id="menuNmComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>

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
            $('.sub_fix_wrap').css('max-height', windowHeight * 0.6);
            sum();
        });

        $(function () {
            // datepick 한글 셋팅 common.js
            settingdatepickerko();
            // 메뉴 셀렉트 박스 변경시 조회
            $("#sch_menu_nm").change(function () {
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
            // 총 합계 column = 2
            for (var i = 1; i < 3; i++) {
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

        function fnSearch() {
            $("#aform").attr({action: "/iot/statsservice/selectSystemStats.do", method: 'post'}).submit();
        }

        // 시스템 통계 엑셀 다운로드
        function fnExceldownload() {
            $("#aform").attr({action: "/iot/statsservice/exceldownloadSystemStats.do", method: 'post'}).submit();
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
            <h1>유통 통계</h1>
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
                                    <!-- 메뉴 검색 -->
                                    <div class="form-group">
                                        <select id="sch_menu_nm" name="sch_menu_nm" class="form-control input-sm" width>
                                            <%=CommboUtil.getComboStr(menuNmComboStr, "CODE", "CODE_NM", param.getString("sch_menu_nm"), "메뉴")%>
                                        </select>
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
                            </div>
                            <!-- /.box-header -->
                            <div class="sub_tbl_scroll_box">
                                <div class="sub_fix_th_bg"></div>
                                <div class="sub_fix_wrap">
                                    <div class="box-body no-pad-top table-responsive" style="border: 0px;">
                                        <table class="table table-bordered table-striped dataTable">
                                            <colgroup>
                                                <col style="width: 10%;">
                                                <col style="width: 15%;">
                                                <col style="width: 15%;">
                                                <col style="width: 15%;">
                                                <col style="width: 22.5%;">
                                                <col style="width: 22.5%;">
                                            </colgroup>
                                            <thead>
                                            <tr>
                                                <th scope="col" style="width: 10%;">
                                                    <div class="sub_fix_th">번호</div>
                                                </th>
                                                <th colspan="3" scope="col" style="width: 45%;">
                                                    <div class="sub_fix_th">메뉴명</div>
                                                </th>
                                                <th scope="col" style="width: 22.5%;">
                                                    <div class="sub_fix_th">기간별 누적 조회수</div>
                                                </th>
                                                <th scope="col" style="width: 22.5%;">
                                                    <div class="sub_fix_th">전체 누적 조회수</div>
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
                                                            <c:choose>
                                                                <c:when test="${data.MENU_NM_4 eq null}">
                                                                    <td colspan=3
                                                                        class="text-left"> ${data.MENU_NM_3} </td>
                                                                </c:when>
                                                                <c:when test="${data.MENU_NM_5 eq null}">
                                                                    <td class="text-left"> ${data.MENU_NM_3} </td>
                                                                    <td colspan=2
                                                                        class="text-left"> ${data.MENU_NM_4} </td>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <td class="text-left"> ${data.MENU_NM_3} </td>
                                                                    <td class="text-left"> ${data.MENU_NM_4} </td>
                                                                    <td class="text-left"> ${data.MENU_NM_5} </td>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <td class="text-right" name="col_1">
                                                                <fmt:formatNumber type="number" maxFractionDigits="3"
                                                                                  value="${data.CNT}"/>
                                                            </td>
                                                            <td class="text-right" name="col_2">
                                                                <fmt:formatNumber type="number" maxFractionDigits="3"
                                                                                  value="${data.TOT_CNT}"/>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                            </tbody>
                                            <tfoot>
                                            <tr>
                                                <th class="text-right disabled_th" colspan="4">합계</th>
                                                <th class="text-right disabled_th" id="result_1" name="result_1"></th>
                                                <th class="text-right disabled_th" id="result_2" name="result_2"></th>
                                            </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer clearfix">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info"
                                            onclick="fnExceldownload(); return false;"><i
                                            class="fa fa-file-excel-o"></i> 통계 결과 엑셀 다운로드
                                    </button>
                                </div>
                            </div>
                        </div>
                        <!-- /.box -->
                    </form>
                    <!-- content 영역 -->
                </div>
                <!-- /.col-xs-12 -->
            </div>
            <!-- /.row -->
        </section>
        <!-- /.content -->
    </div>
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!--//footer -->
</div>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
