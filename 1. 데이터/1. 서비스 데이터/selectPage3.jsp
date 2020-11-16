<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="dumpList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="publicYnComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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

            $("input:checkbox[name=dis_agre_chkbx]").prop("checked", true);
            $("button:button[name=btn_dwnload]").prop("disabled", true);

            // 공개 볌위 변경시 조회
            $("#sch_public_yn").change(function () {
                fnSearch();
            });
            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page").change(function () {
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

            $("input:checkbox[name=agre_chkbx]").change(function () {
                if ($("input:checkbox[name=agre_chkbx]").is(":checked")) {
                    $("input:checkbox[name=dis_agre_chkbx]").prop("checked", false);
                    $("button:button[name=btn_dwnload]").prop("disabled", false);
                } else {
                    $("input:checkbox[name=agre_chkbx]").prop("checked", false);
                    $("input:checkbox[name=dis_agre_chkbx]").prop("checked", true);
                    $("button:button[name=btn_dwnload]").prop("disabled", true);
                }
            });
            $("input:checkbox[name=dis_agre_chkbx]").change(function () {
                if ($("input:checkbox[name=dis_agre_chkbx]").is(":checked")) {
                    $("input:checkbox[name=agre_chkbx]").prop("checked", false);
                    $("button:button[name=btn_dwnload]").prop("disabled", true);
                } else {
                    $("input:checkbox[name=dis_agre_chkbx]").prop("checked", false);
                    $("input:checkbox[name=agre_chkbx]").prop("checked", true);
                    $("button:button[name=btn_dwnload]").prop("disabled", false);
                }
            });
        });


        // 페이지 이동
        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/data/service/selectPage3.do", method: 'post'}).submit();
        }

        // 검색
        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/data/service/selectPage3.do", method: 'post'}).submit();
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

        // 파일 다운로드
        function fnDownload() {
            if (confirm("파일을 다운로드하시겠습니까?")) {
                $('#aform').attr({'action': '/common/file/DumpFileDown.do'}).submit();
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
            <h1>서비스 열람</h1>
        </section>
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" action="data//dataservice/selectPage3.do">
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

                        <%@ include file="/common/inc/dataSrvcTap.jspf" %>
                        <div class="box box-primary download-search">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <!--날자 검색-->
                                    <div class="form-group">
                                        <input type="text" class="form-control input-sm" id="sch_start_ymd"
                                               name="sch_start_ymd" placeholder="검색 시작일"
                                               value="<%=param.getString("sch_start_ymd")%>"/> -
                                        <input type="text" class="form-control input-sm" id="sch_end_ymd"
                                               name="sch_end_ymd" placeholder="검색 종료일"
                                               value="<%=param.getString("sch_end_ymd")%>"/>
                                    </div>
                                    <%if (!param.getString("author_se_yn").equals("N")) {%>
                                    <!--공개 범위-->
                                    <div class="form-group">
                                        <select id="sch_public_yn" name="sch_public_yn" class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(publicYnComboStr, "CODE", "ATTRB_2", param.getString("sch_public_yn"), "공개 범위")%>
                                        </select>
                                    </div>
                                    <%}%>
                                    <!--파일 명 검색-->
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <input type="text" class="form-control input-sm" id="sch_file_nm"
                                                   name="sch_file_nm" placeholder="파일 명 직접 입력"
                                                   onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                                   value="<%=param.getString("sch_file_nm")%>"/>
                                            <div class="input-group-btn">
                                                <button type="button" class="btn btn-sm btn-default"
                                                        onclick="fnSearch(); return false;"><i class="fa fa-search"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div><!-- /.box-header -->
                            <div class="box-body table-responsive no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width:5%;">
                                        <col style="width:*;">
                                        <col style="width:10%;">
                                        <col style="width:10%;">
                                        <col style="width:10%;">
                                        <col style="width:15%;">
                                        <col style="width:140px;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">파일 명</th>
                                        <th class="text-center">파일 크기</th>
                                        <th class="text-center">데이터 기준일</th>
                                        <th class="text-center">파일 공개 범위</th>
                                        <th class="text-center">생성 일시</th>
                                        <th class="text-center">활용하기</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:set value="${pageNavigationVo.getCurrDataNo()}" var="dataNo"></c:set>
                                    <c:choose>
                                        <c:when test="${dumpList.size() == 0}">
                                            <td class="text-center" colspan="7"><spring:message
                                                    code="msg.data.empty"/></td>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="resultSet" items="${dumpList}" varStatus="status">
                                                <tr>
                                                    <td class="text-center txt_overflow">${dataNo - status.index} </td>
                                                    <td> ${resultSet.FILE_NM} </td>
                                                    <td> ${resultSet.FILE_SIZE} Byte</td>
                                                    <td class="text-center">${resultSet.DUMP_YMD}</td>
                                                    <td class="text-center">${resultSet.PUBLIC_NM}</td>
                                                    <td class="text-center">${resultSet.REGIST_DT}</td>
                                                    <td class="text-center">
                                                        <button type="button" class="data-btn download">
                                                            <span class="hidden-txt">다운로드</span>
                                                        </button>
                                                        <button type="button" class="data-btn bookmark">
                                                            <span class="hidden-txt">북마크</span>
                                                        </button>
                                                        <button type="button" class="data-btn graph">
                                                            <span class="hidden-txt">그래프</span>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
                                <div class="pull-left form-inline">
                                    <select id="sch_row_per_page" name="sch_row_per_page" class="form-control input-sm">
                                        <%=CommboUtil.getComboStr(rowPerPageComboStr, "CODE", "CODE_NM", param.getString("sch_row_per_page"), "")%>
                                    </select>
                                </div>
                                ${navigationBar}
                            </div>
                            <div class="box-footer box-agree clearfix text-right">
                                <div class="pull-right">
                                    ※ 제공되는 데이터는 내부업무의 연구, 분석 용도로만 활용 가능하며, 목적 달성 후 즉시 파기해 주시고
                                    <br>또한, 본인의 부주의로 인해 외부 등에 공개되어 발생하는 민·형사상 책임은 본인에게 있습니다.
                                    <br>
                                    <input type="checkbox" id="agre_chkbx" name="agre_chkbx"/>
                                    <label for="agre_chkbx">동의합니다</label>
                                </div>
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" name="btn_dwnload" class="btn btn-info"
                                            onclick="fnDownload(); return false;"><i class="fa fa-file-excel-o"></i> 파일
                                        다운로드
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
