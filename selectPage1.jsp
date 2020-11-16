<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="basisInfo" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="serverInfo" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="packetDetailList" type="java.util.List" class="java.util.ArrayList" scope="request"/>

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

        });

        //기본 정보 엑셀 다운로드
        function fnExceldownload() {
            $("#aform").attr({action: "/data/service/exceldownloadPage1.do", method: 'post'}).submit();
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
            3
            $(".content-header h1").append("(<%=param.getString("srvc_nm")%>)");
            <c:choose>
            <c:when test="${param.trnsmit_server_no eq '30' || param.trnsmit_server_no eq '31' || param.trnsmit_server_no eq '47'  }">
            $("#content-header-sub").css("display", "block");
            $("#content-header-sub").append("<font size='3' color='#ff0000'>(본 데이터를 이용하시려면 시스템 관리자에게 연락주시기 바랍니다.)</font>");
            </c:when>
            </c:choose>

        });
    </script>

    <!-- content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>서비스 열람</h1>
            <div id="content-header-sub" style="display:none;"></div>
        </section>
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post">
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
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title"><i class="fa fa-fw fa-info-circle"></i>서비스 정보</h3>
                            </div>
                            <%-- 송수신 서버 정보 --%>
                            <div class="box-body no-padding text-left">
                                <table class="table table-bordered type02">
                                    <colgroup>
                                        <col style="width: 10%;">
                                        <col style="width: 10%;">
                                        <col style="width: 10%;">
                                        <col style="width: 10%;">
                                        <col style="width: 10%;">
                                        <col style="width: 10%;">
                                        <col style="width: 10%;">
                                        <col style="width: 10%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>서비스</th>
                                        <td colspan="7"><%=serverInfo.getString("SRVC_NM")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>서비스 상태</th>
                                        <td><%=serverInfo.getString("SRVC_STATUS_NM")%>
                                        </td>
                                        <th>연계 일자</th>
                                        <td><%=serverInfo.getString("REGIST_DT")%>
                                        </td>
                                        <th>누적 데이터 수</th>
                                        <td class="text-right">
                                            <fmt:formatNumber type="number" maxFractionDigits="3"
                                                              value='<%=serverInfo.getString("DATA_CNT")%>'/>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <th>서비스 분류</th>
                                    <td colspan="3"><%=serverInfo.getString("SRVC_HRANK_NM")%>
                                        -<%=serverInfo.getString("SRVC_LRANK_NM")%>
                                    </td>
                                    <th>센서개수</th>
                                    <td class="text-right">
                                        <fmt:formatNumber type="number" maxFractionDigits="3"
                                                          value='<%=serverInfo.getString("MODL_SERIAL_CNT")%>'/>
                                    </td>
                                    <th>수신간격(분)</th>
                                    <td class="text-right"><%=serverInfo.getString("RECPTN_INTRVL_MNT")%>
                                    </td>
                                    </tr>
                                    <tr>
                                        <th>관리기관</th>
                                        <td colspan="3"><%=serverInfo.getString("ORGAN_NM")%>
                                            -<%=serverInfo.getString("CHRG_DEPT_NM")%>
                                        </td>
                                        <th>담당자</th>
                                        <td><%=serverInfo.getString("CHARGER_NM")%>
                                        </td>
                                        <th>연락처</th>
                                        <td><%=serverInfo.getString("CHARGER_CTTPC")%>
                                        </td>
                                    </tr>
                                    <tr height="100">
                                        <th>서비스내용</th>
                                        <td colspan="7"><%=serverInfo.getHtml("SRVC_CN")%>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-header with-border">
                                <h3 class="box-title"><i class="fa fa-fw fa-info-circle"></i>정보 속성</h3>
                            </div>
                            <%-- 메타정보 --%>
                            <div class="box-body table-responsive no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width: 10%;">
                                        <col style="width: 10%;">
                                        <col style="width: 10%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">전체 길이</th>
                                        <th class="text-center">필수 길이</th>
                                        <th class="text-center">데이터 길이</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td class="text-center"><%=basisInfo.getString("PACKET_SIZE")%>
                                        </td>
                                        <td class="text-center"><%=basisInfo.getString("HDER_SIZE")%>
                                        </td>
                                        <td class="text-center"><%=basisInfo.getString("DATA_SIZE")%>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-body table-responsive no-padding">
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
                                        <th class="text-center">공개구분</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        DataMap dataMap = null;
                                        for (int i = 0; i < packetDetailList.size(); i++) {
                                            dataMap = (DataMap) packetDetailList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><%=i + 1%>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("PACKET_SE_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("PACKET_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("PACKET_BYTE") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("PACKET_UNIT") %>
                                        </td>
                                        <td><%=dataMap.getString("PACKET_CTGRY") %>
                                        </td>
                                        <td><%=dataMap.getString("DC") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("PUBLIC_YN_NM") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" class="btn btn-info"
                                            onclick="fnExceldownload(); return false;"><i
                                            class="fa fa-file-excel-o"></i> 기본 정보 엑셀 다운로드
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
