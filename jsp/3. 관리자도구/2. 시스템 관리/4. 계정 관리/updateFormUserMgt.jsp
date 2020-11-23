<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="authList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="userAuthList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="userSttusComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="userSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="cttpcSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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

            // 사용자 권한 체크
            <%	for(int i=0; i<userAuthList.size(); i++){
                    DataMap dataMap = (DataMap)userAuthList.get(i);
                    String author_id = dataMap.getString("AUTHOR_ID");
            %>
            $("[value=<%=author_id%>]").eq(0).attr("checked", "true");
            <%	} %>

            $('[name=organ_code]').change(function (e) {
                fnGetAuthor();
            });

            // 비밀번호 수정 checkBox 이벤트
            $("#change_password_YN").change(function () {
                if ($("#change_password_YN").is(":checked")) {
                    $("[name = password]").show();
                    $("[name = check_password]").show();
                } else {
                    $("[name = password]").hide();
                    $("[name = check_password]").hide();
                    $("[name = password]").val("");
                    $("[name = check_password]").val("");
                }
            });

            // 데이터 셋팅
            $('input[name=organ_code]').val('${resultMap.ORGAN_CODE}');
            var cttpc = '${resultMap.CTTPC}'.split('-');
            $('input[name=cttpc1]').val(cttpc[0]);
            $('input[name=cttpc2]').val(cttpc[1]);
            $('input[name=cttpc3]').val(cttpc[2]);
            var email = '${resultMap.EMAIL}'.split('@');
            $('input[name=email1]').val(email[0]);
            $('input[name=email2]').val(email[1]);

            var emailList = ["직접입력", "naver.com", "hanmail.net", "gmail.com", , "nate.com", "hotmail.com"];
            var str = "";
            for (var i in emailList) {
                str += '<option value="' + emailList[i] + '">' + emailList[i] + '</option>';
            }
            $(".emailSelect").html(str);
        });

        function fnEmailSelect_b(v) {
            if (v == '직접입력') $('[name=email2]').val("");
            else $('[name=email2]').val(v);
        }

        // 선택 기관 권한
        function fnGetAuthor() {
            var param = {'organ_code': $('[name=organ_code]').val()};

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

        // 상세
        function fnDetail() {
            $("#aform").attr({action: "/admin/user/selectUserMgt.do", method: 'post'}).submit();
        }

        // 수정
        function fnGoUpdate() {
            if ($("[name=cttpc1]").val() != "" && $("[name=cttpc2]").val() != "" && $("[name=cttpc3]").val() != "") {
                var cttpc = $("[name=cttpc1]").val() + "-" + $("[name=cttpc2]").val() + "-" + $("[name=cttpc3]").val();
                $("[name=cttpc]").val(cttpc);
            }

            if ($("[name=email1]").val() != "" && $("[name=email2]").val() != "") {
                $("[name=email]").val($("[name=email1]").val() + "@" + $("[name=email2]").val());
            }

            if ($("[name=user_nm]").val() == "") {
                alert("이름을 입력해 주세요.");
                $("[name=user_nm]").focus();
                return;
            }

            if ($("[name=password]").val() == "" && ($("#change_password_YN").is(":checked"))) {
                alert("비밀번호를 입력해 주세요.");
                $("[name=password]").focus();
                return;
            }

            if ($("input:radio[name='author_id']").is(":checked") == false) {
                alert("사용자 권한을 체크해 주세요");
                return;
            }

            if ($("[name=user_se_code]").val() == "") {
                alert("신청권한을 선택해 주세요.");
                $("[name=user_se_code]").focus();
                return;
            }

            if ($("#change_password_YN").is(":checked")) {
                if ($("[name=password]").val() != $("[name=check_password]").val()) {
                    alert("비밀번호가 일치하지 않습니다.");
                    $("[name=password]").focus();
                    return;
                }
            }

            if (confirm("수정하시겠습니까?")) {
                $("#aform").attr({action: "/admin/user/updateUserMgt.do", method: 'post'}).submit();
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

                    <form role="form" id="aform" method="post" action="/admin/user/updateUserMgt.do">
                        <input type="hidden" id="user_no" name="user_no" value="<%=resultMap.getString("USER_NO") %>"/>
                        <input type="hidden" id="cttpc" name="cttpc"/>
                        <input type="hidden" id="email" name="email"/>

                        <%-- pageList --%>
                        <input type="hidden" name="sch_organ_code" value="<%=param.getString("sch_organ_code")%>"/>
                        <input type="hidden" name="sch_user_se_code" value="<%=param.getString("sch_user_se_code")%>"/>
                        <input type="hidden" name="sch_user_sttus_code"
                               value="<%=param.getString("sch_user_sttus_code")%>"/>
                        <input type="hidden" name="sch_type" value="<%=param.getString("sch_type")%>"/>
                        <input type="hidden" name="sch_text" value="<%=param.getString("sch_text")%>"/>
                        <input type="hidden" name="currentPage" value="<%=param.getString("currentPage")%>"/>
                        <input type="hidden" name="sch_row_per_page" value="<%=param.getString("sch_row_per_page")%>"/>

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
                                                <%=CommboUtil.getComboStr(organComboStr, "CODE", "CODE_NM", resultMap.getString("ORGAN_CODE"), "")%>
                                            </select>
                                            <%}%>
                                            <%if (!param.getString("author_se_yn").equals("Y")) {%>
                                            <%=CommboUtil.getComboName(organComboStr, "CODE", "CODE_NM", resultMap.getString("ORGAN_CODE"))%>
                                            <input type="hidden" name="organ_code"
                                                   value="<%=resultMap.getString("ORGAN_CODE")%>"/>
                                            <%}%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">사용자 권한</th>
                                        <td id="organAuthor" colspan="3">
                                            <%
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
                                        <col style="width:35%;">
                                        <col style="width:15%;">
                                        <col style="width:35%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="required_field">사용자ID</th>
                                        <td>
                                            <input type="text" class="form-control" id="user_id" name="user_id"
                                                   placeholder="사용자ID" onkeyup="cfLengthCheck('사용자ID는', this, 100);"
                                                   value="<%=resultMap.getString("USER_ID") %>" readonly="readonly"/>
                                        </td>
                                        <th class="required_field">이름</th>
                                        <td>
                                            <input type="text" class="form-control" id="user_nm" name="user_nm"
                                                   placeholder="이름" onkeyup="cfLengthCheck('이름은', this, 250);"
                                                   value="<%=resultMap.getString("USER_NM") %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>비밀번호</th>
                                        <td>
                                            <label>
                                                <input type="checkbox" id="change_password_YN"
                                                       name="change_password_YN"/>
                                                수정
                                            </label>
                                            <input type="password" class="form-control" name="password"
                                                   placeholder="변경 비밀번호" onkeyup="cfLengthCheck('비밀번호는', this, 100);"
                                                   style="display:none;"/>
                                            <input type="password" class="form-control" name="check_password"
                                                   onkeyup="cfLengthCheck('비밀번호는', this, 100);"
                                                   style="display:none;margin-top:10px;" placeholder="변경 비밀번호 확인"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">사용자 상태</th>
                                        <td>
                                            <select class="form-control" id="user_sttus_code" name="user_sttus_code">
                                                <%=CommboUtil.getComboStr(userSttusComboStr, "CODE", "CODE_NM", resultMap.getString("USER_STTUS_CODE"), "")%>
                                            </select>
                                        </td>
                                        <th class="required_field">신청권한</th>
                                        <td>
                                            <select class="form-control" id="user_se_code" name="user_se_code">
                                                <%=CommboUtil.getComboStr(userSeComboStr, "CODE", "CODE_NM", resultMap.getString("USER_SE_CODE"), "")%>
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
                                        <th>부서명</th>
                                        <td>
                                            <input type="text" class="form-control" id="user_dept_nm"
                                                   name="user_dept_nm" placeholder="부서명"
                                                   onkeyup="cfLengthCheck('부서명은', this, 50);"
                                                   value="<%=resultMap.getString("USER_DEPT_NM") %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>이용업무</th>
                                        <td>
                                            <textarea class="form-control" rows="3" name="user_role_desc"
                                                      placeholder="업무 내용을 작성해주십시오."
                                                      onkeyup="cfLengthCheck('업무내용은', this, 250);"><%=resultMap.getString("USER_ROLE_DESC") %></textarea>
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
                                                    <%=CommboUtil.getComboStr(cttpcSeComboStr, "CODE", "CODE_NM", resultMap.getString("CTTPC_SE_CODE"), "")%>
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
                                                        onChange="fnEmailSelect_b(this.value)"
                                                        style="display:inline-block; width:150px; margin-left:5px; background:#f9f9f9;"></select>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnDetail(); return false;"><i
                                            class="fa fa-reply"></i> 취소
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnGoUpdate(); return false;"><i
                                            class="fa fa-pencil"></i> 확인
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
