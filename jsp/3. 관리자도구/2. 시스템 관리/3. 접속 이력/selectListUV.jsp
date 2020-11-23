<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="organComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

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

            // 지점검색 이벤트
            $('[name=sch_text]').on({
                'keyup': function (e) {
                    if (e.which == 13) {
                        fnSearch();
                    }
                }
            });

        });

        // 페이지 이동
        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/admin/stats/selectListUV.do", method: 'post'}).submit();
        }

        // 검색
        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/admin/stats/selectListUV.do", method: 'get'}).submit();
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
            <h1>사용자관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" action="/admin/stats/selectListUV.do">
                        <input type="hidden" id="user_no" name="user_no"/>
                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">

                                    <div class="form-group">
                                        <select name="sch_organ_code" class="form-control input-sm"
                                                onchange="fnSearch();">
                                            <%= CommboUtil.getComboStr(organComboStr, "CODE", "CODE_NM", param.getString("sch_organ_code"), "기관") %>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <input type="text" class="form-control input-sm" name="sch_start_de"
                                               value="<%=param.getString("sch_start_de")%>" placehoder="시작일"/>
                                        -
                                        <input type="text" class="form-control input-sm" name="sch_end_de"
                                               value="<%=param.getString("sch_end_de")%>" placehoder="종료일"/>
                                    </div>
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <input type="text" class="form-control" name="sch_text"
                                                   placeholder="메뉴명을 입력하세요." value="<%=param.getString("sch_text")%>"/>
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
                                <table class="table table-hover table-bordered">
                                    <colgroup>
                                        <col width="80"/>
                                        <col width="30%"/>
                                        <col width="*"/>
                                        <col width="20%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">No</th>
                                        <th class="text-center">기관</th>
                                        <th class="text-center">메뉴</th>
                                        <th class="text-center">카운트</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        int dataNo = resultList.size();
                                        for (int i = 0; i < resultList.size(); i++) {
                                            DataMap dataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><%=dataNo - i %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("ORGAN_NM") %>
                                        </td>
                                        <td class="text-left"><%=dataMap.getString("MENU_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("ACCES_CNT") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    <% if (resultList.size() == 0) { %>
                                    <tr>
                                        <td class="text-center" colspan="4"><spring:message code="msg.data.empty"/></td>
                                    </tr>
                                    <%}%>

                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
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