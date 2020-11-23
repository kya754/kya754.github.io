<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="authList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="bsnsList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>

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
        // 목록
        function fnGoList() {
            $("#aform").attr({action: "/admin/user/selectPageListUserMgt.do", method: 'post'}).submit();
        }

        // 사용자수정폼 이동
        function fnGoUpdateForm(user_no) {
            $("#aform").action = "/admin/user/updateFormUserMgt.do";
            $("#aform").submit();
        }

        // 사용자삭제
        function fnGoDelete(user_no) {
            if (confirm("삭제하시겠습니까?")) {
                $("#aform").attr({action: "/admin/user/deleteUserMgt.do", method: 'post'}).submit();
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
            <h1>사용자관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">

                    <div class="box box-primary">
                        <form role="form" id="aform" method="post" action="/admin/user/updateFormUserMgt.do">
                            <input type="hidden" id="user_no" name="user_no"
                                   value="<%=resultMap.getString("USER_NO") %>"/>
                            <%-- pageList --%>
                            <input type="hidden" name="sch_organ_code" value="<%=param.getString("sch_organ_code")%>"/>
                            <input type="hidden" name="sch_user_se_code"
                                   value="<%=param.getString("sch_user_se_code")%>"/>
                            <input type="hidden" name="sch_user_sttus_code"
                                   value="<%=param.getString("sch_user_sttus_code")%>"/>
                            <input type="hidden" name="sch_type" value="<%=param.getString("sch_type")%>"/>
                            <input type="hidden" name="sch_text" value="<%=param.getString("sch_text")%>"/>
                            <input type="hidden" name="currentPage" value="<%=param.getString("currentPage")%>"/>
                            <input type="hidden" name="sch_row_per_page"
                                   value="<%=param.getString("sch_row_per_page")%>"/>

                            <div class="box-header with-border">
                                <h3 class="box-title"><i class="fa fa-fw fa-info-circle"></i>기본 정보</h3>
                            </div>
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width:15%;">
                                        <col style="width:35%;">
                                        <col style="width:15%;">
                                        <col style="width:35%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>사용자ID</th>
                                        <td>
                                            <%=resultMap.getString("USER_ID") %>
                                        </td>
                                        <th>이름</th>
                                        <td>
                                            <%=resultMap.getString("USER_NM") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>기관</th>
                                        <td>
                                            <%=resultMap.getString("ORGAN_NM") %>
                                        </td>
                                        <th>사용자 권한</th>
                                        <td>
                                            <%
                                                if (authList != null) {
                                                    for (int i = 0; i < authList.size(); i++) {
                                                        DataMap dataMap = (DataMap) authList.get(i);

                                                        out.print(dataMap.getString("AUTHOR_NM"));
                                                        if (i != authList.size() - 1) {
                                                            out.print(", ");
                                                        }
                                                    }
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>사용자 상태</th>
                                        <td>
                                            <%=resultMap.getString("USER_STTUS_NM") %>
                                        </td>
                                        <th>신청권한</th>
                                        <td>
                                            <%=resultMap.getString("USER_SE_NM") %>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                    </div>

                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-fw fa-info-circle"></i>추가 정보</h3>
                        </div>
                        <div class="box-body no-padding">
                            <table class="table table-bordered">
                                <colgroup>
                                    <col style="width:15%;">
                                    <col style="width:85%;">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>부서명</th>
                                    <td>
                                        <%=resultMap.getString("USER_DEPT_NM") %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>이용업무</th>
                                    <td>
                                        <pre style="margin:3px 3px 3px 3px;"><%=resultMap.getString("USER_ROLE_DESC") %></pre>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div><!-- /.box-body -->
                    </div><!-- /.box -->

                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-fw fa-info-circle"></i>부가 정보</h3>
                        </div>
                        <div class="box-body no-padding">
                            <table class="table table-bordered">
                                <colgroup>
                                    <col style="width:15%;">
                                    <col style="width:35%;">
                                    <col style="width:15%;">
                                    <col style="width:35%;">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>연락처</th>
                                    <td>
                                        <%if (!resultMap.getString("CTTPC").equals("")) {%>
                                        [<%=resultMap.getString("CTTPC_SE_NM") %>] <%=resultMap.getString("CTTPC") %>
                                        <%}%>
                                    </td>
                                    <th>이메일</th>
                                    <td>
                                        <%=resultMap.getString("EMAIL") %>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div><!-- /.box-body -->
                        <div class="box-footer">
                            <div class="pull-right">
                                <button type="button" class="btn btn-default" onclick="fnGoList(); return false;"><i
                                        class="fa fa-reply"></i> 목록
                                </button>
                                <button type="button" class="btn btn-info" onclick="fnGoUpdateForm(); return false;"><i
                                        class="fa fa-pencil"></i> 수정
                                </button>
                                <button type="button" class="btn btn-warning" onclick="fnGoDelete(); return false;"><i
                                        class="fa fa-trash"></i> 삭제
                                </button>
                            </div>
                        </div>
                        </form>
                    </div><!-- /.box -->

                    <%if (param.getString("author_se_yn").equals("Y")) {%>
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-fw fa-info-circle"></i>담당 서비스 정보</h3>
                        </div>
                        <div class="box-body no-padding">
                            <table class="table table-bordered">
                                <colgroup>
                                    <col style="width:5%">
                                    <col style="*">
                                    <col style="width:15%;">
                                    <col style="width:15%;">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th class="text-center">번호</th>
                                    <th class="text-center">서비스 명</th>
                                    <th class="text-center">서비스 상태</th>
                                    <th class="text-center">담당자 등록일</th>
                                </tr>

                                <c:forEach var="data" items="${bsnsList}" varStatus="status">
                                    <tr>
                                        <td class="text-center txt_overflow">${status.index+1}</td>
                                        <td>${data.SRVC_NM}</td>
                                        <td class="text-center txt_overflow">${data.SRVC_STATUS}</td>
                                        <td class="text-center txt_overflow">${data.REGIST_YMD}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${fn:length(bsnsList) == 0}">
                                    <tr>
                                        <td class="text-center" colspan="5"><spring:message code="msg.data.empty"/></td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div><!-- /.box-body -->
                        </form>
                    </div><!-- /.box -->
                    <%}%>

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
