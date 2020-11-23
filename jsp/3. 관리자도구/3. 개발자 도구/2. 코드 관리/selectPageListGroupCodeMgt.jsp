<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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
            //f_divView('main_0', 'main_0');	//메뉴구조 유지
            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page").change(function () {
                fnSearch();
            });
        });

        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/admin/code/selectPageListGroupCodeMgt.do", method: 'post'}).submit();
        }

        function fnInsertForm() {
            document.location.href = "/admin/code/insertFormGroupCodeMgt.do";
        }

        function fnSelectCodeList(groupId) {
            $("#group_id").val(groupId);
            $("#aform").attr({action: "/admin/code/selectListCodeMgt.do", method: 'post'}).submit();
        }

        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/admin/code/selectPageListGroupCodeMgt.do", method: 'post'}).submit();
        }

        function fnDelete() {
            var delGrpCodeList = f_getList("del_grp_code");
            var chkFag = false;

            for (i = 0; i < delGrpCodeList.length; i++) {
                if (delGrpCodeList[i].checked == true) {
                    chkFag = true;
                    break;
                }
            }

            if (chkFag == false) {
                alert("삭제할 그룹코드를 선택해 주세요.");
                return;
            }

            if (confirm("삭제하시겠습니까?")) {
                $("#aform").attr({action: "/admin/code/deleteGroupCodeMgt.do", method: 'post'}).submit();
            }
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
            <h1>코드관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <!-- content 영역 -->
                    <form id="aform" method="post">
                        <input type="hidden" name="group_id" id="group_id"/>

                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <input type="text" id="sch_grp_code_nm" name="sch_grp_code_nm"
                                                   value="${param.sch_grp_code_nm }" class="form-control"
                                                   placeholder="그룹코드명을 입력하세요. ">
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
                                <table class="table table-bordered table-hover">
                                    <colgroup>
                                        <col width="50">
                                        <col width="80">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="150">
                                        <col width="150">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center"></th>
                                        <th class="text-center">No</th>
                                        <th class="text-center">그룹코드</th>
                                        <th class="text-center">그룹코드 명</th>
                                        <th class="text-center">영문그룹코드 명</th>
                                        <th class="text-center">등록자</th>
                                        <th class="text-center">등록일</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="group" items="${resultList}" varStatus="status">
                                        <tr style="cursor:pointer;cursor:hand;">
                                            <td class="text-center"><input type="checkbox" name="del_grp_code"
                                                                           value="${group.GROUP_ID }"/></td>
                                            <td class="text-center" onclick="fnSelectCodeList('${group.GROUP_ID}')">
                                                <c:out value="${pageNavigationVo.totalCount - (pageNavigationVo.currentPage-1) * pageNavigationVo.rowPerPage - status.index}"/>
                                            </td>
                                            <td onclick="fnSelectCodeList('${group.GROUP_ID}')">${group.GROUP_ID }</td>
                                            <td onclick="fnSelectCodeList('${group.GROUP_ID}')">${group.GROUP_NM }</td>
                                            <td onclick="fnSelectCodeList('${group.GROUP_ID}')">${group.GROUP_NM_ENG}</td>
                                            <td onclick="fnSelectCodeList('${group.GROUP_ID}')"
                                                class="text-center">${group.REGISTER_NM}</td>
                                            <td onclick="fnSelectCodeList('${group.GROUP_ID}')"
                                                class="text-center">${group.REGIST_YMD}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${fn:length(resultList) == 0}">
                                        <tr>
                                            <td class="text-center" colspan="7"><spring:message
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
                                ${navigationBar}
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-warning" onclick="fnDelete(); return false;"><i
                                            class="fa fa-trash"></i> 삭제
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnInsertForm(); return false;">
                                        <i class="fa fa-pencil"></i> 등록
                                    </button>
                                </div>
                            </div>
                        </div><!-- /.box -->
                    </form>
                    <!-- content 영역 -->
                </div><!-- /.col-xs-12 -->
            </div><!-- /.row -->
        </section><!-- /.content -->
    </div>
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!--//footer -->
</div>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
