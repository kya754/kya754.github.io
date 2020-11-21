<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="packetDetailList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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

            $(".ui-datepicker-month").css({'color': '#222 !important'});

            $('span[name=toggle-control]').click(function () {
                $("#packet_info").toggle();
                $('span[name=toggle-control]').toggle();
            });

            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page_4").change(function () {
                fnSearch();
            })

        });

        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/data/service/selectPage4.do", method: 'post'}).submit();
        }

        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/data/service/selectPage4.do", method: 'post'}).submit();
        }

        function fnList() {
            if ($("#currentPage").val() == null) {
                var hiddenHtml = "";
                hiddenHtml += '<input type="hidden" id="currentPage" name="currentPage" />';
                $('#aform').append(hiddenHtml);
            }

            $("#currentPage").val($("#pageList_currentPage").val());
            $("#sch_row_per_page").val($("#pageList_sch_row_per_page").val());

            $("#aform").attr({action: "/data/service/selectPageListDataSrvc.do", method: 'post'}).submit();
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
            <h1>서비스 열람</h1>
        </section>
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form id="aform" method="post" action="data/dataservice/selecPage4.do">
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
                        <input type="hidden" id="sch_senser_code" name="sch_senser_code"
                               value="${param.sch_senser_code}"/>
                        <input type="hidden" id="sch_srvc_status" name="sch_srvc_status"
                               value="${param.sch_srvc_status}"/>
                        <input type="hidden" id="sch_srvc_nm2" name="sch_srvc_nm2" value="${param.sch_srvc_nm2}"/>
                        <input type="hidden" id="sch_row_per_page" name="sch_row_per_page"/>


                        <%@ include file="/common/inc/dataSrvcTap.jspf" %>
                        <div class="box box-primary toggle-wrap">
                            <div class="box-body">
                                <span name="toggle-control"> <a>패킷 정보 펼치기 </a> </span>
                                <span name="toggle-control" style="display:none;"> <a>패킷 정보 접기 </a> </span>
                            </div>
                            <div class="box-body table-responsive no-padding" id="packet_info" style="display:none;">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col width="40">
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
                                        <th class="text-center">번호</th>
                                        <th class="text-center">구분</th>
                                        <th class="text-center">명칭</th>
                                        <th class="text-center">길이</th>
                                        <th class="text-center">단위</th>
                                        <th class="text-center">범주</th>
                                        <th class="text-center">설명</th>
                                        <th class="text-center">공개 구분</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        DataMap packetInfoMap = null;
                                        for (int i = 0; i < packetDetailList.size(); i++) {
                                            packetInfoMap = (DataMap) packetDetailList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><%=i + 1%>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PACKET_SE_NM") %>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PACKET_NM") %>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PACKET_BYTE") %>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PACKET_UNIT") %>
                                        </td>
                                        <td><%=packetInfoMap.getString("PACKET_CTGRY") %>
                                        </td>
                                        <td><%=packetInfoMap.getString("DC") %>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PUBLIC_YN_NM") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                        </div><!-- /.box -->

                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <div class="form-group">
                                        <b>전일 기준 최근 1000개의 데이터가 제공 됩니다.</b>
                                        <div class="date-wrap">
                                            <span class="date">최종 수신 일시:
                                                <em>2020-10-20 16:25</em>
                                            </span>
                                            <button type="button" class="refresh-btn">
                                                <span class="hidden-txt">새로고침</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div><!-- /.box-header -->

                            <div class="box-body no-pad-top table-responsive">
                                <table class="table table-bordered table-hover" style="width: 2700px;">
                                    <colgroup>
                                        <col width="50">
                                        <%for (int i = 0; i < packetDetailList.size(); i++) {%>
                                        <col width="*">
                                        <%}%>
                                        <col width="150">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">번호</th>
                                        <%
                                            for (int i = 0; i < packetDetailList.size(); i++) {
                                                packetInfoMap = (DataMap) packetDetailList.get(i);
                                        %>
                                        <th class="text-center"><%=packetInfoMap.getString("PACKET_NM")%>
                                        </th>
                                        <%
                                            }
                                        %>
                                        <th class="text-center">등록 일시</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        DataMap dataMap = null;
                                        String naviBar = (String) request.getAttribute("navigationBar");
                                        int dataNo = pageNavigationVo.getCurrDataNo();
                                        for (int i = 0; i < resultList.size(); i++) {
                                            dataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><%=dataNo - i%>
                                        </td>
                                        <%
                                            for (int k = 0; k < packetDetailList.size(); k++) {
                                                packetInfoMap = (DataMap) packetDetailList.get(k);
                                        %>
                                        <td class="text-center"><%=dataMap.getString("COLUMN" + k)%>
                                            <%
                                                if (!packetInfoMap.getString("PACKET_UNIT").equals("")) {
                                            %>
                                            <%=packetInfoMap.getString("PACKET_UNIT")%>
                                            <%
                                                }
                                            %>
                                        </td>
                                        <%
                                            }
                                        %>
                                        <td class="text-center"><%=dataMap.getString("REGIST_DT")%>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                    <%
                                        if (resultList.size() == 0) {%>
                                    <tr>
                                        <td class="text-center" colspan="<%=packetDetailList.size()+2%>"><spring:message
                                                code="msg.data.empty"/></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
                                <div class="pull-left form-inline">
                                    <select id="sch_row_per_page_4" name="sch_row_per_page_4"
                                            class="form-control input-sm">
                                        <%=CommboUtil.getComboStr(rowPerPageComboStr, "CODE", "CODE_NM", param.getString("sch_row_per_page_4"), "")%>
                                    </select>
                                </div>
                                <%=naviBar%>
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" style="float:right" class="btn btn-default" onclick="fnList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
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
</html>
<%@ include file="/common/inc/msg.jspf" %>
