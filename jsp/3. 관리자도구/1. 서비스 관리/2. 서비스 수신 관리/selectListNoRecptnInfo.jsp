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
<jsp:useBean id="unUseResultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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
            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page_3").change(function () {
                fnSearch();
            });
        });

        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/iot/srvcRecptn/selectListNoRecptnInfo.do", method: 'post'}).submit();
        }

        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/iot/srvcRecptn/selectListNoRecptnInfo.do", method: 'post'}).submit();
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

        // 사용중지
        function fnUnUse() {
            var unUseList = f_getList("check_modl_serial");
            var chkFag = false;

            for (i = 0; i < unUseList.length; i++) {
                if (unUseList[i].checked == true) {
                    chkFag = true;
                    break;
                }
            }

            if (chkFag == false) {
                alert("사용중지할 관리번호를 선택해 주세요.");
                return;
            }

            var trnsmit_server_no = $("#trnsmit_server_no").val();
            var data_no = $("#data_no").val();
            var req = {
                "trnsmit_server_no": trnsmit_server_no
                , "data_no": data_no
            };

            if (confirm("사용중지하시겠습니까?")) {
                $("#aform").attr({action: "/iot/srvcRecptn/saveNoRecptnInfoUnUse.do", method: 'post'}).submit();
            }
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
                        <input type="hidden" id="sch_start_ymd" name="sch_start_ymd"/>
                        <input type="hidden" id="sch_end_ymd" name="sch_end_ymd"/>
                        <input type="hidden" id="sch_row_per_page" name="sch_row_per_page"/>

                        <%@ include file="/common/inc/srvcRecptnTap.jspf" %>
                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <div class="form-group">
                                        <!--초과 시간 검색-->
                                        <input type="text" class="form-control numeric" id="sch_overhour"
                                               name="sch_overhour" style="width:50px;"
                                               value="<%=param.getString("sch_overhour")%>"/> 시간
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
                                        <col width="*">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center"></th>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">관리번호</th>
                                        <th class="text-center">최근수신일시</th>
                                        <th class="text-center">수신 상태</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        DataMap DataMap = null;
                                        int dataNo = pageNavigationVo.getCurrDataNo();
                                        String att = "";
                                        for (int i = 0; i < resultList.size(); i++) {
                                            DataMap = (DataMap) resultList.get(i);

                                            if (DataMap.getString("FLG").equals("수신")) {
                                                att = "disabled";
                                            } else {
                                                att = "";
                                            }

                                    %>
                                    <tr>
                                        <td class="text-center"><input type="checkbox" <%=att%> name="check_modl_serial"
                                                                       value="<%=DataMap.getString("MODL_SERIAL")%>"/>
                                        </td>
                                        <td class="text-center"><%=dataNo - i%>
                                        </td>
                                        <td class="text-center"><%=DataMap.getString("MODL_SERIAL") %>
                                        </td>
                                        <td class="text-center"><%=DataMap.getString("REGIST_DT") %>
                                        </td>
                                        <td class="text-center"><%=DataMap.getString("FLG") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
                                <div class="pull-left form-inline">
                                    Row Per Page
                                    <select id="sch_row_per_page_3" name="sch_row_per_page_3"
                                            class="form-control input-sm">
                                        <%=CommboUtil.getComboStr(rowPerPageComboStr, "CODE", "CODE_NM", param.getString("sch_row_per_page_3"), "")%>
                                    </select>
                                </div>
                                ${navigationBar}
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnUnUse(); return false;"><i
                                            class="fa fa-pencil"></i>관리번호 사용중지
                                    </button>
                                </div>
                            </div>
                        </div><!-- /.box -->

                        <!-- 미사용 센서리스트  -->
                        <div class="box box-primary">
                            <div class="box-header">
                                <h3 class="box-title">
                                    <i class="fa fa-fw fa-info-circle"></i> 사용 중지된 모델 정보
                                </h3>
                            </div><!-- /.box-header -->
                            <div class="box-body table-responsive no-padding">
                                <table id="unUseTable" class="table table-bordered">
                                    <colgroup>
                                        <col width="40">
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
                                        <th class="text-center">번호</th>
                                        <th class="text-center">모델 시리얼</th>
                                        <th class="text-center">우편번호</th>
                                        <th class="text-center">주소</th>
                                        <th class="text-center">주소 상세</th>
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
                                    <%
                                        DataMap unUseDataMap = null;
                                        for (int i = 0; i < unUseResultList.size(); i++) {
                                            unUseDataMap = (DataMap) unUseResultList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center row_no"><%=i + 1%>
                                        </td>
                                        <td><%=unUseDataMap.getString("MODL_SERIAL") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("POST_NO") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("ADRES") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("ADRES_DETAIL") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("CODE_NM") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("LA") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("LO") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("ANTCTY") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("BULD_NM") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("INSTL_FLOOR") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("INSTL_HO_NO") %>
                                        </td>
                                        <td><%=unUseDataMap.getString("RM") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    <%
                                        if (unUseResultList.size() == 0) {
                                    %>
                                    <tr>
                                        <td class="text-center" colspan="14"><spring:message
                                                code="msg.data.empty"/></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                    </tbody>
                                </table>
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
