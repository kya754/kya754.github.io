<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
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

            $('[name=sch_start_ymd_1]').datepicker({
                dateFormat: 'yy.mm.dd',
                changeYear: true,
                changeMonth: true
            });

            $('[name=sch_end_ymd_1]').datepicker({
                dateFormat: 'yy.mm.dd',
                changeYear: true,
                changeMonth: true
            });

            $(".ui-datepicker-month").css({'color': '#222 !important'});

            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page_1").change(function () {
                fnSearch();
            });
        });

        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/iot/srvcRecptn/selectListRecptnIntrvlOverInfo.do", method: 'post'}).submit();
        }

        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/iot/srvcRecptn/selectListRecptnIntrvlOverInfo.do", method: 'post'}).submit();
        }

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
                    <form id="aform" method="post" action="iot/srvcRecptn/saveNoRecptnInfoUnUse.do">
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
                                        <input type="text" class="form-control input-sm" id="sch_start_ymd_1"
                                               name="sch_start_ymd_1" placeholder="수신 시작일"
                                               value="<%=param.getString("sch_start_ymd_1")%>"/> -
                                        <input type="text" class="form-control input-sm" id="sch_end_ymd_1"
                                               name="sch_end_ymd_1" placeholder="수신 종료일"
                                               value="<%=param.getString("sch_end_ymd_1")%>"/>
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
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">관리번호</th>
                                        <th class="text-center">메세지</th>
                                        <th class="text-center">패킷</th>
                                        <th class="text-center">수신일시</th>
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
                                        <td class="text-center"><%=dataNo - i%>
                                        </td>
                                        <td class="text-center"><%=DataMap.getString("MODL_SERIAL") %>
                                        </td>
                                        <td><%=DataMap.getString("ERROR_MSSAGE") %>
                                        </td>
                                        <td><%=DataMap.getString("PACKET") %>
                                        </td>
                                        <td class="text-center"><%=DataMap.getString("REGIST_DT") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    <%
                                        if (resultList.size() == 0) {
                                    %>
                                    <tr>
                                        <td class="text-center" colspan="5"><spring:message code="msg.data.empty"/></td>
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
                                    <select id="sch_row_per_page_1" name="sch_row_per_page_1"
                                            class="form-control input-sm">
                                        <%=CommboUtil.getComboStr(rowPerPageComboStr, "CODE", "CODE_NM", param.getString("sch_row_per_page_1"), "")%>
                                    </select>
                                </div>
                                ${navigationBar}
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                </div>
                            </div>
                        </div><!-- /.box -->
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
