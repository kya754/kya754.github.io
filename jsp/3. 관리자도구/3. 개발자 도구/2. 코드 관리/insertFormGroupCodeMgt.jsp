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
        $(function () {
            //f_divView('main_0', 'main_0');	//메뉴구조 유지

            //group_id 자동 채번
            var newGroupId = Number($("#new_group_id").val()) + 10;
            var temp = newGroupId.toString();
            var newGroupId_length = temp.length;
            if ($("#new_group_id").val() == null)	//초기상태
                $("#group_id").val("R010010");
            if (newGroupId_length == 5)
                $("#group_id").val("R0" + newGroupId);
            if (newGroupId_length > 5)
                $("#group_id").val("R" + newGroupId);
        });

        function fnGoInsert() {

            if ($("#group_id").val() == "") {
                alert("그룹ID를 입력해 주세요.");
                $("#group_id").focus();
                return;
            }

            if ($("[name=group_id]").attr("duplicate") != "Y") {
                alert("그룹ID 중복검사를 해주세요.");
                $("[name=group_id]").focus();
                return;
            }

            if ($("[name=group_id]").attr("duplicate") == "Y" && $("[name=group_id]").val() != $("[name=group_id]").attr("compareVal")) {
                alert("중복검사한 그룹ID가 아닙니다.");
                $("[name=group_id]").focus();
                return;
            }

            if ($("#group_nm").val() == "") {
                alert("그룹코드명을 입력해 주세요.");
                $("#group_nm").focus();
                return;
            }

            if (confirm("등록하시겠습니까?")) {
                $("#aform").attr({action: "/admin/code/insertGroupCodeMgt.do", method: 'post'}).submit();
            }
        }

        function fnGoList() {
            document.location.href = "/admin/code/selectPageListGroupCodeMgt.do";
        }

        //그룹ID 중복 체크
        function fnGroupIdCheck() {

            if ($("#group_id").val() == "") {
                alert("그룹ID를 입력해 주세요.");
                return;
            }

            var req = {
                group_id: $("#group_id").val()
            };

            jQuery.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/admin/code/selectExistYnGroupIdAjax.do',
                data: req,
                success: function (param) {

                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    if (param.resultMap.EXIST_YN == "Y") {
                        alert("그룹ID가 존재합니다.");
                        $("#bbs_code").attr("duplicate", "N");
                    } else {
                        alert("사용가능한 그룹ID 입니다.");
                        $("#group_id").attr("duplicate", "Y");
                        $("#group_id").attr("compareVal", req["group_id"]);
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
            <h1>코드관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box box-primary">
                        <input type="hidden" name="new_group_id" id="new_group_id" value="${resultMap.MAX_GROUP_ID}"/>
                        <form role="form" id="aform" method="post" action="/admin/code/selectPageListCodeMgt.do">
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
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="group_id" name="group_id"
                                                       placeholder="그룹ID" onkeyup="cfLengthCheck('그룹ID는', this, 10);">
                                                <div class="input-group-btn">
                                                    <button type="button" class="btn btn-primary"
                                                            onclick="fnGroupIdCheck(); return false;">중복확인
                                                    </button>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">그룹코드명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="group_nm" name="group_nm"
                                                       placeholder="그룹코드명" onkeyup="cfLengthCheck('그룹코드명은', this, 50);">
                                            </div>
                                        </td>
                                        <th>영문그룹코드명</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control" id="group_nm_eng"
                                                       name="group_nm_eng" placeholder="영문그룹코드명"
                                                       onkeyup="cfLengthCheck('영문그룹코드명은', this, 50);">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>비고</th>
                                        <td colspan="3">
                                            <div class="outBox1">
                                                <textarea class="form-control" rows="3" name="rm" placeholder="비고"
                                                          onkeyup="cfLengthCheck('비고는', this, 100);"></textarea>
                                            </div>
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
                                    <button type="button" class="btn btn-info" onclick="fnGoInsert(); return false;"><i
                                            class="fa fa-pencil"></i> 등록
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div><!-- /.box -->
                </div><!-- /.col-xs-12 -->
            </div><!-- /.row -->
        </section><!-- /.content -->
    </div>
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!-- //fooer -->
</div>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
