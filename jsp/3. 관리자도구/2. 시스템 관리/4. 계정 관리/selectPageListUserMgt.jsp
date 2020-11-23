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
<jsp:useBean id="userSttusComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="userSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="organSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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
            $('[name=sch_organ_code], [name=sch_user_se_code], [name=sch_user_sttus_code], [name=sch_row_per_page]').change(function (e) {
                fnSearch();
            });
        });

        // 페이지 이동
        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/admin/user/selectPageListUserMgt.do", method: 'post'}).submit();
        }

        // 사용자등록폼 이동
        function fnInsertForm() {
            document.location.href = "/admin/user/insertFormUserMgt.do";
        }

        // 상세조회
        function fnSelect(user_no) {
            $("#user_no").val(user_no);
            $("#aform").attr({action: "/admin/user/selectUserMgt.do", method: 'post'}).submit();
        }

        // 검색
        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/admin/user/selectPageListUserMgt.do", method: 'get'}).submit();
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
                    <form role="form" id="aform" method="post" action="/admin/user/selectPageListUserMgt.do">
                        <input type="hidden" id="user_no" name="user_no"/>
                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <%if (param.getString("author_se_yn").equals("Y")) {%>
                                    <!--  기관 구분 -->
                                    <div class="form-group">
                                        <select id="sch_organ_code" name="sch_organ_code" class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(organSeComboStr, "CODE", "CODE_NM", param.getString("sch_organ_code"), "기관")%>
                                        </select>
                                    </div>
                                    <%}%>

                                    <!--  사용자구분 -->
                                    <div class="form-group">
                                        <select id="sch_user_se_code" name="sch_user_se_code"
                                                class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(userSeComboStr, "CODE", "CODE_NM", param.getString("sch_user_se_code"), "사용자 구분")%>
                                        </select>
                                    </div>

                                    <!--  사용자상태 -->
                                    <div class="form-group">
                                        <select id="sch_user_sttus_code" name="sch_user_sttus_code"
                                                class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(userSttusComboStr, "CODE", "CODE_NM", param.getString("sch_user_sttus_code"), "사용자 상태")%>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <select id="search_list_st" name="sch_type" class="form-control input-sm">
                                            <option value="user_nm"
                                                    <%if(param.getString("sch_type").equals("user_nm")){%>selected="selected"<%}%>>
                                                이름
                                            </option>
                                            <option value="user_id"
                                                    <%if(param.getString("sch_type").equals("user_id")){%>selected="selected"<%}%>>
                                                사용자ID
                                            </option>
                                        </select>
                                        <div class="input-group input-group-sm">
                                            <input type="text" class="form-control" id="sch_text" name="sch_text"
                                                   placeholder="검색어를 입력하세요."
                                                   onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                                   value="<%=param.getString("sch_text")%>"/>
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
                                        <col width="10%"/>
                                        <col width="10%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">기관 명</th>
                                        <th class="text-center">사용자 ID</th>
                                        <th class="text-center txt_overflow">이름</th>
                                        <th class="text-center">사용자 구분</th>
                                        <th class="text-center">사용자 상태</th>
                                        <th class="text-center txt_overflow">등록자 명</th>
                                        <th class="text-center">등록일</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        String naviBar = (String) request.getAttribute("navigationBar");
                                        int dataNo = pageNavigationVo.getCurrDataNo();
                                        for (int i = 0; i < resultList.size(); i++) {
                                            DataMap dataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr style="cursor:pointer;cursor:hand;"
                                        onclick="fnSelect('<%=dataMap.getString("USER_NO")%>')">
                                        <td class="text-center"><%=dataNo - i %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("ORGAN_CODE") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("USER_ID") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("USER_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("USER_SE_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("USER_STTUS_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("REGISTER_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("REGIST_YMD") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    <% if (resultList.size() == 0) { %>
                                    <tr>
                                        <td class="text-center" colspan="10"><spring:message
                                                code="msg.data.empty"/></td>
                                    </tr>
                                    <%}%>

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
                                <%=naviBar%>
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info" onclick="fnInsertForm(); return false;">
                                        <i class="fa fa-pencil"></i> 등록
                                    </button>
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
