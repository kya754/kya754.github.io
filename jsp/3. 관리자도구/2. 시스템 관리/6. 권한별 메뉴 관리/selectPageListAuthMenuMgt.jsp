<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="organComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="rowPerPageComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>
    <script type="text/javascript">
        //<![CDATA[
        $(function () {
            //활동을 기본으로 검색
            $('[name=sch_organ_code], [name=sch_row_per_page]').change(function (e) {
                fnSearch();
            });
        });

        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/admin/authmenu/selectPageListAuthMenuMgt.do", method: 'post'}).submit();
        }

        function fnAuthMenuList(auth_id) {
            $("#author_id").val(auth_id);
            $("#aform").attr({action: "/admin/authmenu/selectListAuthMenuMgt.do", method: 'post'}).submit();
        }

        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/admin/authmenu/selectPageListAuthMenuMgt.do", method: 'post'}).submit();
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
            <h1>권한별 메뉴관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" action="/admin/authmenu/selectPageListAuthMenuMgt.do">
                        <input type="hidden" id="author_id" name="author_id"/>
                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <!--  기관 -->
                                    <div class="form-group">
                                        <c:if test="${comboYn eq 'Y'}">
                                            <select class="form-control input-sm" id="sch_organ_code"
                                                    name="sch_organ_code">
                                                <%=CommboUtil.getComboStr(organComboStr, "CODE", "CODE_NM", param.getString("sch_organ_code"), "기관")%>
                                            </select>
                                        </c:if>
                                    </div>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="text" name="sch_auth_nm" value="${param.sch_auth_nm }"
                                                   class="form-control input-sm pull-right" placeholder="권한명을 입력하세요.">
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
                                        <col width="10%"/>
                                        <col width="20%"/>
                                        <col width="*"/>
                                        <col width="10%"/>
                                        <col width="10%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">기관명</th>
                                        <th class="text-center">권한 ID</th>
                                        <th class="text-center">권한 명</th>
                                        <th class="text-center">등록자</th>
                                        <th class="text-center">등록일</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="author" items="${resultList}" varStatus="status">
                                        <tr style="cursor:pointer;cursor:hand;"
                                            onclick="fnAuthMenuList('${author.AUTHOR_ID}')">
                                            <td class="text-center"><c:out
                                                    value="${pageNavigationVo.totalCount - (pageNavigationVo.currentPage-1) * pageNavigationVo.rowPerPage - status.index}"/></td>
                                            <td class="text-center">${author.ORGAN_NM }</td>
                                            <td class="text-center">${author.AUTHOR_ID }</td>
                                            <td>${author.AUTHOR_NM }</td>
                                            <td class="text-center">${author.USER_NM }</td>
                                            <td class="text-center">${author.RGST_YMD }</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${fn:length(resultList) == 0}">
                                        <tr>
                                            <td class="text-center" colspan="4"><spring:message
                                                    code="msg.data.empty"/></td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
                                <div class="pull-left form-inline">
                                    Row Per Page
                                    <select id="sch_row_per_page" name="sch_row_per_page" class="form-control input-sm">
                                        <%=CommboUtil.getComboStr(rowPerPageComboStr, "CODE", "CODE_NM", param.getString("sch_row_per_page"), "")%>
                                    </select>
                                </div>
                                ${navigationBar }
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
