<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="snsComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

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

            $('[name=sch_start_de]').datetimepicker({
                locale: 'ko', 	// 화면에 출력될 언어를 한국어로 설정한다.
                format: 'YYYY.MM.DD',
                useCurrent: false, 	//Important! See issue #1075
                sideBySide: true,
            });


            $('[name=sch_end_de]').datetimepicker({
                locale: 'ko', 	// 화면에 출력될 언어를 한국어로 설정한다.
                format: 'YYYY.MM.DD',
                useCurrent: false, 	//Important! See issue #1075
                sideBySide: true,
            });

            //sns 셀렉트 박스 변경시 조회
            $('[name=sch_sns_code]').on({
                'change': function () {
                    fnSearch();
                }
            });

        });

        // 페이지 이동
        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/admin/stats/selectPageListSnsTrace.do", method: 'post'}).submit();
        }

        // 검색
        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/admin/stats/selectPageListSnsTrace.do", method: 'get'}).submit();
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
            <h1>SNS 추적</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" action="/admin/stats/selectPageListSnsTrace.do">
                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <div class="form-group">
                                        <select name="sch_sns_code" class="form-control input-sm">
                                            <%= CommboUtil.getComboStr(snsComboStr, "CODE", "CODE_NM", param.getString("sch_sns_code"), "SNS") %>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <input type="text" class="form-control input-sm" name="sch_start_de"
                                               value="<%=param.getString("sch_start_de")%>" placeholder="이벤트 시작일"/>
                                        -
                                    </div>
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <input type="text" class="form-control input-sm" name="sch_end_de"
                                                   value="<%=param.getString("sch_end_de")%>" placeholder="이벤트 종료일"/>
                                            <div class="input-group-btn">
                                                <button type="button" class="btn btn-sm btn-default"
                                                        onclick="fnSearch(); return false;"><i class="fa fa-search"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div><!-- /.box-header -->
                            <div class="box-body no-pad-top table-responsive">
                                <table class="table table-hover table-bordered table_fixed">
                                    <colgroup>
                                        <col width="80"/>
                                        <col width="13%"/>
                                        <col width="13%"/>
                                        <col width="*"/>
                                        <col width="12%"/>
                                        <col width="20%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">No</th>
                                        <th class="text-center">메뉴명</th>
                                        <th class="text-center">SNS</th>
                                        <th class="text-center">URL</th>
                                        <th class="text-center">IP</th>
                                        <th class="text-center">이벤트 일시</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        String naviBar = (String) request.getAttribute("navigationBar");
                                        int dataNo = pageNavigationVo.getCurrDataNo();
                                        for (int i = 0; i < resultList.size(); i++) {
                                            DataMap dataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><%=dataNo - i %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("CODE_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("MENU_NM") %>
                                        </td>
                                        <td class="text-left txt_overflow"><%=dataMap.getString("REFRN_URL") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("IP") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("DISPLAY_EVENT_DT") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    <% if (resultList.size() == 0) { %>
                                    <tr>
                                        <td class="text-center" colspan="5"><spring:message code="msg.data.empty"/></td>
                                    </tr>
                                    <%}%>

                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
                                <%=naviBar %>
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">

                                </div>
                            </div>
                        </div><!-- /.box -->
                    </form>
                </div><!--  /.col-xs-12 -->
            </div><!-- ./row -->
        </section><!-- /.content -->
    </div><!-- /.content-wrapper -->

    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!-- //fooer -->

</div><!-- ./wrapper -->
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>