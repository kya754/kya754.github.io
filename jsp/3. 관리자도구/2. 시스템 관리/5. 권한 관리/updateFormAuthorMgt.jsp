<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="organComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="organNm" type="java.util.List" class="java.util.ArrayList" scope="request"/>


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

        function fnGoUpdate() {
            if ($("#author_nm").val() == "") {
                alert("권한명을 입력해 주세요.");
                $("#author_nm").focus();
                return;
            }

            if (confirm("수정하시겠습니까?")) {
                $("#aform").attr({action: "/admin/author/updateAuthorMgt.do", method: 'post'}).submit();
            }
        }

        function fnGoList() {
            $("#aform").attr({action: "/admin/author/selectPageListAuthorMgt.do", method: 'post'}).submit();
        }

        function fnGoDelete() {
            if (confirm("삭제하시겠습니까?")) {
                $("#aform").attr({action: "/admin/author/deleteAuthorMgt.do", method: 'post'}).submit();
            }
        }

        //]]>
    </script>
</head>
<body class="hold-transition <%=cssSkin%> layout-top-nav">
<div class="wrapper">

    <!-- 헤더  -->
    <c:import url="/common/inc/header.do" charEncoding="utf-8"/>

    <!-- content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>권한관리</h1>
        </section>

        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box box-primary">
                        <!-- form start -->
                        <form role="form" id="aform" method="post" action="/admin/author/insertAuthorMgt.do">
                            <!--검색조건-->
                            <input type="hidden" name="author_id" value="${param.author_id }"/>
                            <input type="hidden" name="sch_auth_nm" value="${param.sch_auth_nm }"/>
                            <!--페이징조건-->
                            <input type="hidden" name="currentPage" value="${param.currentPage }"/>
                            <%-- pageList --%>
                            <input type="hidden" id="sch_organ_code" name="sch_organ_code"
                                   value="${param.sch_organ_code}"/>
                            <input type="hidden" id="sch_row_per_page" name="sch_row_per_page"
                                   value="${param.sch_row_per_page}"/>

                            <div class="box-body">
                                <table class="table table-bordered">
                                    <caption></caption>
                                    <colgroup>
                                        <col style="width:20%;">
                                        <col style="width:30%;">
                                        <col style="width:20%;">
                                        <col style="width:30%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>권한ID</th>
                                        <td>
                                            <div class="outBox1">
                                                ${resultMap.AUTHOR_ID }
                                            </div>
                                        </td>
                                        <th class="required_field">권한명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="author_nm" name="author_nm"
                                                       value="${resultMap.AUTHOR_NM }" placeholder="권한명"
                                                       onkeyup="cfLengthCheck('권한명은', this, 100);">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>기관명</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${adminYn eq 'Y' }">

                                                    <select class="form-control" id="organ_code" name="organ_code">
                                                        <%=CommboUtil.getComboStr(organComboStr, "CODE", "CODE_NM", resultMap.getString("ORGAN_CODE"), "C")%>
                                                    </select>
                                                </c:when>
                                                <c:otherwise>
                                                    <%
                                                        DataMap dataMapOrgan = new DataMap();
                                                        int organSize = organNm.size();
                                                        for (int x = 0; x < organSize; x++) {
                                                            dataMapOrgan = (DataMap) organNm.get(x);
                                                    %>
                                                    <input type="hidden" name="organ_code"
                                                           value="${resultMap.ORGAN_CODE }"/>
                                                    <%= dataMapOrgan.getString("ORGAN_NM") %>

                                                    <% } %>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>내용</th>
                                        <td colspan="3">
                                            <div class="outBox1">
                                                <textarea class="form-control" rows="3" name="rm" placeholder="내용..."
                                                          onkeyup="cfLengthCheck('내용은', this, 100);">${resultMap.RM }</textarea>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>

                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <button type="button" class="btn btn-default" onclick="fnGoList(); return false;"><i
                                        class="fa fa-reply"></i> 목록
                                </button>
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info" onclick="fnGoUpdate(); return false;"><i
                                            class="fa fa-pencil"></i> 수정
                                    </button>
                                    <button type="button" class="btn btn-warning" onclick="fnGoDelete(); return false;">
                                        <i class="fa fa-trash"></i> 삭제
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div><!-- box -->
                </div><!-- col-xs-12 -->
            </div><!-- row -->
        </section><!-- //content -->
    </div>
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!-- //fooer -->
</div>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
