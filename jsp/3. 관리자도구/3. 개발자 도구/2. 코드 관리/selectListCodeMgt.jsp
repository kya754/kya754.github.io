<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
        function f_GoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/admin/code/selectPageListCodeMgt.do", method: 'post'}).submit();
        }

        // 		function f_ChngFistPage(firstPage){
        // 			$("#firstPage").val(firstPage);
        // 			$("#currentPage").val(firstPage);
        // 			$("#aform").attr({action:"/admin/code/selectCodePageList.do", method:'post'}).submit();
        // 		}
        $(function () {
            //f_divView('main_0', 'main_0');	//메뉴구조 유지
        });

        function fnRemoveLine(removeId) {
            $("#" + removeId).remove();
        }

        //입력폼 보기
        var removeNo = 0;

        function fnInsertForm() {
            var comboStr = "<select class=\"form-control\" name=\"use_yn\">";
            <c:forEach var="ynCode" items="${ynCodeList}">
            comboStr += "<option value=\"${ynCode.CODE }\" >${ynCode.CODE_NM }</option>";
            </c:forEach>
            comboStr += "</select>";

            var nextSrtOrd = 0;	//next 정렬순서
            var newSrtOrdList = f_getList("sort_ordr");
            for (i = 0; i < newSrtOrdList.length; i++) {

                if (Number(nextSrtOrd) < Number(newSrtOrdList[i].value)) {
                    nextSrtOrd = Number(newSrtOrdList[i].value);
                }
            }
            if (newSrtOrdList.length == 0) {
                nextSrtOrd = Number($("#new_srt_ord_val").val()) + 10;
            } else {
                nextSrtOrd = Number(nextSrtOrd) + 10;
            }

            removeNo++;

            var table = $("#codeTable");
            var htmlStr = "<tr id=\"id_new_code_" + removeNo + "\">";
            htmlStr += "	<td><input type=\"text\" class=\"form-control\" name=\"code\" onkeyup=\"cfLengthCheck('코드는', this, 10);\"/></td>";
            htmlStr += "	<td><input type=\"text\" class=\"form-control\" name=\"code_nm\" onkeyup=\"cfLengthCheck('코드명은', this, 100);\" /></td>";
            htmlStr += "	<td><input type=\"text\" class=\"form-control\" name=\"code_nm_eng\" onkeyup=\"cfLengthCheck('코드영문명은', this, 100);\" /></td>";
            htmlStr += "	<td><input type=\"text\" class=\"form-control\" name=\"attrb_1\" onkeyup=\"cfLengthCheck('속성1은', this, 100);\" /></td>";
            htmlStr += "	<td><input type=\"text\" class=\"form-control\" name=\"attrb_2\" onkeyup=\"cfLengthCheck('속성2는', this, 100);\" /></td>";
            htmlStr += "	<td><input type=\"text\" class=\"form-control\" name=\"attrb_3\" onkeyup=\"cfLengthCheck('속성3은', this, 100);\" /></td>";
            htmlStr += "	<td><input type=\"text\" class=\"form-control\" name=\"sort_ordr\"  value=\"" + nextSrtOrd + "\"/></td>";
            htmlStr += "	<td>" + comboStr + "</td>";
            htmlStr += "	<td class=\"text-center\"><button type=\"button\" class=\"btn btn-warning\" onclick=\"fnRemoveLine('id_new_code_" + removeNo + "');\">삭제</button></td>";
            htmlStr += "</tr>";

            table.append(htmlStr);
        }

        function fnList() {
// 			document.location.href="/admin/code/selectGroupCodePageList.do";
            $("#aform").attr({action: "/admin/code/selectPageListGroupCodeMgt.do", method: 'post'}).submit();
        }

        function fnUpdate() {

            if ($("#group_nm").val() == "") {
                alert("그룹코드명을 입력해 주세요.");
                $("#group_nm").focus();
                return;
            }

            var codeList = f_getList("code");
            var codeNmList = f_getList("code_nm");
            var sortOrdrList = f_getList("sort_ordr");

            var codeDupYn = false;
            var codeDupCnt = 0;

            for (i = 0; i < codeList.length; i++) {

                if (codeList[i].value == "") {
                    alert("코드를 입력해 주세요.");
                    codeList[i].focus();
                    return;
                }

                if (codeNmList[i].value == "") {
                    alert("코드명을 입력해 주세요.");
                    codeNmList[i].focus();
                    return;
                }
                if (sortOrdrList[i].value == "") {
                    alert("순서를 입력해 주세요.");
                    sortOrdrList[i].focus();
                    return;
                }

                codeDupCnt = 0;
                for (k = 0; k < codeList.length; k++) {

                    if (codeList[i].value == codeList[k].value) {
                        codeDupCnt++;

                        if (codeDupCnt > 1) {
                            codeDupYn = true;
                            break;
                        }
                    }
                }
            }

            if (codeDupYn) {
                alert("중복된 코드가 존재합니다.");
                return;
            }

            if (confirm("수정하시겠습니까?")) {
                $("#aform").attr({action: "/admin/code/updateCodeMgt.do", method: 'post'}).submit();
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
            <h1>코드관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" action="/admin/code/selectPageListCodeMgt.do">
                        <div class="box box-primary">
                            <input type="hidden" name="group_id" id="group_id" value="${param.group_id }"/>
                            <input type="hidden" name="new_srt_ord_val" id="new_srt_ord_val"
                                   value="${param.LOW_SORT_ORDR}"/>
                            <!--페이징조건-->
                            <input type="hidden" name="currentPage" value="${param.currentPage }"/>
                            <input type="hidden" name="sch_row_per_page" value="${param.sch_row_per_page }"/>

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
                                        <th class="required_field">그룹ID</th>
                                        <td colspan="3">
                                            <div class="outBox1">
                                                ${resultMap.GROUP_ID}
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">그룹코드명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="group_nm" name="group_nm"
                                                       placeholder="그룹코드명" value="${resultMap.GROUP_NM }"
                                                       onkeyup="cfLengthCheck('그룹코드명은', this, 50);">
                                            </div>
                                        </td>
                                        <th>영문그룹코드명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="group_nm_eng"
                                                       name="group_nm_eng" placeholder="영문그룹코드명"
                                                       value="${resultMap.GROUP_NM_ENG }"
                                                       onkeyup="cfLengthCheck('영문그룹코드명은', this, 50);">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>비고</th>
                                        <td colspan="3">
                                            <div class="outBox1">
                                                <textarea class="form-control" rows="3" name="rm" placeholder="비고"
                                                          onkeyup="cfLengthCheck('비고는', this, 100);">${resultMap.RM }</textarea>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>

                            </div><!-- /.box-body -->
                        </div><!-- /.box -->

                        <div class="box box-primary">
                            <div class="box-body table-responsive no-padding">
                                <table id="codeTable" class="table table-bordered">
                                    <colgroup>
                                        <col width="100">
                                        <col width="*">
                                        <col width="15%">
                                        <col width="15%">
                                        <col width="15%">
                                        <col width="15%">
                                        <col width="80">
                                        <col width="80">
                                        <col width="80">
                                    </colgroup>
                                    <tr>
                                        <th class="text-center required_field">코드</th>
                                        <th class="text-center required_field">코드 명</th>
                                        <th class="text-center">영문명</th>
                                        <th class="text-center">속성1</th>
                                        <th class="text-center">속성2</th>
                                        <th class="text-center">속성3</th>
                                        <th class="text-center">순서</th>
                                        <th class="text-center">사용여부</th>
                                        <th class="text-center">삭제</th>
                                    </tr>
                                    <c:forEach var="code" items="${resultList}" varStatus="status">
                                        <tr id="id_code_${status.count }">
                                            <td><input type="text" name="code" class="form-control"
                                                       value="${code.CODE }" onkeyup="cfLengthCheck('코드는', this, 10);"/>
                                            </td>
                                            <td><input type="text" name="code_nm" class="form-control"
                                                       value="${code.CODE_NM }"
                                                       onkeyup="cfLengthCheck('코드명은', this, 100);"/></td>
                                            <td><input type="text" name="code_nm_eng" class="form-control"
                                                       value="${code.CODE_NM_ENG }"
                                                       onkeyup="cfLengthCheck('코드영문명은', this, 100);"/></td>
                                            <td><input type="text" name="attrb_1" class="form-control"
                                                       value="${code.ATTRB_1 }"
                                                       onkeyup="cfLengthCheck('속성1은', this, 100);"/></td>
                                            <td><input type="text" name="attrb_2" class="form-control"
                                                       value="${code.ATTRB_2 }"
                                                       onkeyup="cfLengthCheck('속성2는', this, 100);"/></td>
                                            <td><input type="text" name="attrb_3" class="form-control"
                                                       value="${code.ATTRB_3 }"
                                                       onkeyup="cfLengthCheck('속성3은', this, 100);"/></td>
                                            <td><input type="text" name="sort_ordr" class="form-control"
                                                       value="${code.SORT_ORDR }"/></td>
                                            <td>
                                                <select class="form-control" name="use_yn">
                                                    <c:forEach var="ynCode" items="${ynCodeList}">
                                                        <option value="${ynCode.CODE }"
                                                                <c:if test="${code.USE_YN == ynCode.CODE }">selected</c:if>>${ynCode.CODE_NM }</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="btn btn-warning"
                                                        onclick="fnRemoveLine('id_code_${status.count }');">삭제
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </table>
                            </div>
                            <div class="box-footer">
                                <button type="button" class="btn btn-default" onclick="fnList(); return false;"><i
                                        class="fa fa-reply"></i> 목록
                                </button>
                                <div class="pull-right">
                                    <button type="button" class="btn btn-primary"
                                            onclick="fnInsertForm(); return false;"><i class="fa fa-plus"></i> 신규등록
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnUpdate(); return false;"><i
                                            class="fa fa-pencil"></i> 저장
                                    </button>
                                </div>
                            </div>
                        </div><!-- /.box -->
                    </form>
                </div><!-- col-xs-12 -->
            </div><!-- row -->
        </section><!-- content -->
    </div><!-- content-wrapper -->
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!-- //fooer -->
</div>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
