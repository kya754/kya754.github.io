<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
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
            //f_divView('main_2', 'main_2');	//메뉴구조 유지
        });

        function f_GoList() {
            document.location.href = "/admin/author/selectPageListAuthorMgt.do";
        }

        function f_GoInsert() {

            if ($("#author_nm").val() == "") {
                alert("권한명을 입력해 주세요.");
                $("#author_nm").focus();
                return;
            } else if ($("#author_id").val() == "") {
                alert("권한ID를 입력해 주세요.");
                $("#author_id").focus();
                return;
            }

            var param = {'author_id': $('#author_id').val()};
            $.ajax({
                url: '/admin/author/selectExistYnAuthorMgtAjax.do',
                data: param,
                dataType: 'json',
                type: 'post',
                success: function (response) {
                    if (response.resultStats.resultCode == 'success') {
                        if (response.resultStats.resultMsg.existYn == 'N') {
                            if (confirm("등록하시겠습니까?")) {
                                $("#aform").attr({action: "/admin/author/insertAuthorMgt.do", method: 'post'}).submit();
                            }
                        } else {
                            alert('이미 등록된 권한 ID 입니다.');
                            $("#auth_id").focus();
                            return;
                        }
                    }
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });

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

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box box-primary">
                        <!-- form start -->
                        <form role="form" id="aform" method="post" action="/admin/author/insertAuthorMgt.do">
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
                                        <th class="required_field">권한ID</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="author_id" name="author_id"
                                                       placeholder="권한ID" onkeyup="cfLengthCheck('권한ID는', this, 15);">
                                            </div>
                                        </td>
                                        <th class="required_field">권한명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="author_nm" name="author_nm"
                                                       placeholder="권한명" onkeyup="cfLengthCheck('권한명은', this, 100);">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>기관명</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${adminYn eq 'Y' }">
                                                    <select class="form-control" id="organ_code" name="organ_code">
                                                        <%=CommboUtil.getComboStr(organComboStr, "CODE", "CODE_NM", request.getAttribute("user_organ_code").toString(), "기관")%>
                                                    </select>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="organ_code"
                                                           value="<%=request.getAttribute("user_organ_code").toString() %>"/>
                                                    <%
                                                        DataMap dataMapOrgan = new DataMap();
                                                        int organSize = organNm.size();
                                                        for (int x = 0; x < organSize; x++) {
                                                            dataMapOrgan = (DataMap) organNm.get(x);
                                                    %>
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
                                                          onkeyup="cfLengthCheck('내용은', this, 100);"></textarea>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>

                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="f_GoList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="f_GoInsert(); return false;"><i
                                            class="fa fa-pencil"></i> 등록
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div><!-- /.box -->
                </div><!--  /.col-xs-12 -->
            </div><!-- ./row -->
        </section><!-- /.content -->
    </div>
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!-- //fooer -->
</div>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>