<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="authList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="userSttusComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="userSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="cttpcSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="organComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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
        //이메일 도메인 select setting
        $(function () {
            var emailList = ["직접입력", "naver.com", "hanmail.net", "gmail.com", , "nate.com", "hotmail.com"];
            var str = "";
            for (var i in emailList) {
                str += '<option value="' + emailList[i] + '">' + emailList[i] + '</option>';
            }
            $(".emailSelect").html(str);

            $('[name=organ_code]').change(function (e) {
                fnGetAuthor();
            });
        });

        function fnEmailSelect_b(v) {
            if (v == '직접입력') {
                $('[name=email2]').val("");
            } else {
                $('[name=email2]').val(v);
            }
        }

        //목록
        function fnGoList() {
            document.location.href = "/admin/user/selectPageListUserMgt.do";
        }

        //등록
        function fnGoInsert() {

            if ($("[name=organ_code]").val() == "") {
                alert("기관을 선택해 주세요");
                return;
            }

            if (!$('input:radio[name=author_id]').is(':checked')) {
                alert("사용자권한을 선택해 주세요.");
                $("[name=author_id]").focus();
                return;
            }

            if ($("[name=user_id]").val() == "") {
                alert("사용자ID를 입력해 주세요.");
                $("[name=user_id]").focus();
                return;
            }

            if ($("[name=user_id]").attr("duplicate") != "Y") {
                alert("사용자ID 중복검사를 해주세요.");
                $("[name=user_id]").focus();
                return;
            }

            if ($("[name=user_id]").attr("duplicate") == "Y" && $("[name=user_id]").val() != $("[name=user_id]").attr("compareVal")) {
                alert("중복검사한 사용자ID가 아닙니다.");
                $("[name=user_id]").focus();
                return;
            }

            fnIdCheck('insert');

            if ($("[name=user_nm]").val() == "") {
                alert("이름을 입력해 주세요.");
                $("[name=user_nm]").focus();
                return;
            }

            if ($("[name=password]").val() == "") {
                alert("비밀번호를 입력해 주세요.");
                $("[name=password]").focus();
                return;
            }

            if ($("[name=password]").val() != $("[name=check_password]").val()) {
                alert("비밀번호가 일치하지 않습니다.");
                $("[name=password]").focus();
                return;
            }

            if ($("[name=user_se_code]").val() == "") {
                alert("신청권한을 선택해 주세요.");
                $("[name=user_se_code]").focus();
                return;
            }

            if ($("input:radio[name='author_id']").is(":checked") == false) {
                alert("사용자 권한을 체크해 주세요");
                return;
            }

            if ($("[name=cttpc1]").val() != "" && $("[name=cttpc2]").val() != "" && $("[name=cttpc3]").val() != "") {
                var cttpc = $("[name=cttpc1]").val() + "-" + $("[name=cttpc2]").val() + "-" + $("[name=cttpc3]").val();
                $("[name=cttpc]").val(cttpc);
            }

            if ($("[name=email1]").val() != "" && $("[name=email2]").val() != "") {
                $("[name=email]").val($("[name=email1]").val() + "@" + $("[name=email2]").val());
            }

            if (confirm("등록하시겠습니까?")) {
                $("#aform").attr({action: "/admin/user/insertUserMgt.do", method: 'post'}).submit();
            }
        }

        // 아이디 중복 체크
        function fnIdCheck(flag) {
            var user_id = $("[name=user_id]").val();

            if (user_id.trim() == null || user_id.trim() == "") {
                alert("사용자ID를 입력해 주세요.");
                $("[name=user_id]").focus();
                return;
            }

            var param = {'modal_user_id': user_id};
            $.ajax({
                url: '/admin/user/selectIdExistYnAjax.do',
                type: 'post',
                dataType: 'json',
                data: param,
                async: false,
                success: function (response) {
                    if (response.resultStats.resultCode == 'success') {
                        if (response.resultMap == 'Y') {
                            $("#user_id").attr("duplicate", "N");
                            alert(response.resultStats.resultMsg);
                            return;
                        } else {
                            if (flag == 'btn') alert(response.resultStats.resultMsg);

                            $("#user_id").attr("duplicate", "Y");
                            $("#user_id").attr("compareVal", param["modal_user_id"]);
                        }
                    } else {
                        ajaxErrorMsg(response)
                    }
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        // 선택 기관 권한
        function fnGetAuthor() {
            var param = {'organ_code': $('[name=organ_code]').val()};

            if ($("[name=organ_code]").val() == "") {
                param = {'organ_code': 'null'};
            }

            $.ajax({
                url: '/admin/user/selectOrganAuthorAjax.do',
                type: 'post',
                dataType: 'json',
                data: param,
                async: false,
                success: function (param) {
                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }
                    $("#organAuthor").children().remove();

                    var html = "";
                    for (var i = 0; i < param.resultMap.length; i++) {
                        var item = param.resultMap[i];

                        var authorId = item.AUTHOR_ID;
                        var authorNm = item.AUTHOR_NM;
                        var author = "author" + i;

                        html += '<div class="checkbox">';
                        html += '		<label for="' + author + '">';
                        html += '		<input type="radio" name="author_id" id="' + author + '" value="' + authorId + '"/>' + authorNm;
                        html += ' 	</label>';
                        html += ' </div>';
                    }
                    $("#organAuthor").append(html);
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
            <h1>사용자관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" action="/admin/user/insertUserMgt.do">
                        <input type="hidden" id="cttpc" name="cttpc"/>
                        <input type="hidden" id="email" name="email"/>
                        <div class="box box-primary">
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
                                        <th class="required_field">기관</th>
                                        <td colspan="3">
                                            <%if (param.getString("author_se_yn").equals("Y")) {%>
                                            <select class="form-control" id="organ_code" name="organ_code">
                                                <%=CommboUtil.getComboStr(organComboStr, "CODE", "CODE_NM", "", "C")%>
                                            </select>
                                            <%}%>
                                            <%if (!param.getString("author_se_yn").equals("Y")) {%>
                                            <%=CommboUtil.getComboName(organComboStr, "CODE", "CODE_NM", param.getString("ss_organ_code"))%>
                                            <input type="hidden" name="organ_code"
                                                   value="<%=param.getString("ss_organ_code")%>"/>
                                            <%}%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">사용자 권한</th>
                                        <td id="organAuthor" colspan="3">
                                            <%
                                                if (!param.getString("author_se_yn").equals("Y")) {
                                                    for (int i = 0; i < authList.size(); i++) {
                                                        DataMap authMap = (DataMap) authList.get(i);
                                                        String authorName = "author" + i;
                                            %>
                                            <div class="checkbox">
                                                <label for="<%=authorName%>">
                                                    <input type="radio" name="author_id" id="<%=authorName%>"
                                                           value="<%=authMap.getString("AUTHOR_ID") %>"/>
                                                    <%=authMap.getString("AUTHOR_NM") %>
                                                </label>
                                            </div>
                                            <%
                                                    }
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                        </div><!-- /.box -->

                        <div class="box box-primary">
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
                                            <input type="text" class="form-control" id="user_dept_nm"
                                                   name="user_dept_nm" placeholder="부서명"
                                                   onkeyup="cfLengthCheck('부서명은', this, 50);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>이용업무</th>
                                        <td>
                                            <textarea class="form-control" rows="3" name="user_role_desc"
                                                      placeholder="업무 내용을 작성해주십시오."
                                                      onkeyup="cfLengthCheck('업무내용은', this, 250);"></textarea>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                        </div><!-- /.box -->


                        <div class="box box-primary">
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
                                        <th rowspan="2" class="required_field">사용자ID</th>
                                        <td rowspan="2">
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="user_id" name="user_id"
                                                       placeholder="사용자ID"
                                                       onkeyup="cfLengthCheck('사용자ID는', this, 100);"/>
                                                <div class="input-group-btn">
                                                    <button type="button" class="btn btn-primary"
                                                            onclick="fnIdCheck('btn'); return false;">사용자ID 중복체크
                                                    </button>
                                                </div>
                                            </div>
                                        </td>
                                        <th class="required_field">비밀번호</th>
                                        <td>
                                            <input type="password" class="form-control" id="password" name="password"
                                                   placeholder="비밀번호" onkeyup="cfLengthCheck('비밀번호는', this, 100);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">비밀번호 확인</th>
                                        <td>
                                            <input type="password" class="form-control" id="check_password"
                                                   name="check_password" placeholder="비밀번호 확인"
                                                   onkeyup="cfLengthCheck('비밀번호는', this, 100);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th rowspan="2" class="required_field">이름</th>
                                        <td rowspan="2">
                                            <input type="text" class="form-control" id="user_nm" name="user_nm"
                                                   placeholder="이름" onkeyup="cfLengthCheck('이름은', this, 250);"/>
                                        </td>
                                        <th class="required_field">신청권한</th>
                                        <td>
                                            <select class="form-control" id="user_se_code" name="user_se_code">
                                                <%=CommboUtil.getComboStr(userSeComboStr, "CODE", "CODE_NM", "", "C")%>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">사용자 상태</th>
                                        <td>
                                            <select class="form-control" id="user_sttus_code" name="user_sttus_code">
                                                <%=CommboUtil.getComboStr(userSttusComboStr, "CODE", "CODE_NM", "", "C")%>
                                            </select>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                        </div><!-- /.box -->

                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width:15%;">
                                        <col style="width:85%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>연락처</th>
                                        <td class="cttpc">
                                            <div class="form-inline">
                                                <select class="form-control" name="cttpc_se_code"
                                                        style="width:80px; background:#f9f9f9; margin-right:15px;">
                                                    <%=CommboUtil.getComboStr(cttpcSeComboStr, "CODE", "CODE_NM", "20", "")%>
                                                </select>
                                                <div class="form-group" style="text-align:left;">
                                                    <input type="text" name="cttpc1" class="form-control numeric"
                                                           maxlength="4" title="전화번호 첫번째 입력칸입니다" style="width:80px;"/>
                                                    <span style="margin:5px">-</span>
                                                    <input type="text" name="cttpc2" class="form-control numeric"
                                                           maxlength="4" title="전화번호 두번째 입력칸입니다" style="width:80px;"/>
                                                    <span style="margin:5px">-</span>
                                                    <input type="text" name="cttpc3" class="form-control numeric"
                                                           maxlength="4" title="전화번호 세번째 입력칸입니다" style="width:80px;"/>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>이메일</th>
                                        <td>
                                            <div class="form-group" style="text-align:left">
                                                <input type="text" class="form-control" name="email1" placeholder="이메일"
                                                       maxlength="40" style="display:inline-block; width:150px"/>
                                                <span style="margin:5px">@</span>
                                                <input type="text" class="form-control" name="email2" placeholder="도메인"
                                                       maxlength="40" style="display:inline-block; width:150px"/>
                                                <select class="emailSelect form-control"
                                                        onchange="fnEmailSelect_b(this.value)"
                                                        style="display:inline-block; width:150px; margin-left:5px; background:#f9f9f9;"></select>
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
                            </div><!-- /.box-footer -->
                        </div><!-- /.box -->
                    </form>
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
