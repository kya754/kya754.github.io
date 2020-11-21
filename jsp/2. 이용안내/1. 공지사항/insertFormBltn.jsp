<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.util.SysUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="ynComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>
    <script type="text/javascript" src="/common/ckeditor/ckeditor.js"></script>

    <script type="text/javascript">
        //<![CDATA[
        $(function () {
            fnComboStrFile('.fileBoxWrap', 0, 5);

            var url = document.referrer;
            $("#before_url").val();
            url = url.replace(/^.*\/\/[^\/]+/, '');
            $("#before_url").val(url);
        });

        // 목록
        function fnGoList() {
            $('#aform').attr({action: '/iot/bltn/selectPageListBltn.do', method: 'post'}).submit();
        }

        // 등록
        function fnGoInsert() {
            if ($('#notice_sj').val() == '') {
                alert('제목을 입력해 주세요.');
                $('#notice_sj').focus();
                return;
            }

            if (!aform.notice_cn.value.replace(/(^\s*)|(\s*$)/gi, "")) {
                alert("내용을 입력해 주세요.");
                aform.notice_cn.focus();
                return;
            }

            if (confirm('등록하시겠습니까?')) {
                $('#aform').attr({action: '/iot/bltn/insertBltn.do', method: 'post'}).submit();
            }
        }

        //]]>
    </script>
</head>
<body class="hold-transition <%= cssSkin %> layout-top-nav">
<div class="wrapper">

    <!-- 헤더  -->
    <c:import url="/common/inc/header.do" charEncoding="utf-8"/>

    <!-- content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1></h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" name="aform" method="post" action="/iot/bltn/insertBltn.do"
                          enctype="multipart/form-data">
                        <input type="hidden" name="url" id="before_url">
                        <!-- 내용 DOC ID -->

                        <!-- 검색관련 -->
                        <input type="hidden" name="sch_organ_code" value="<%=param.getString("sch_organ_code")%>"/>
                        <input type="hidden" name="sch_type" value="<%=param.getString("sch_type")%>"/>
                        <input type="hidden" name="sch_text" value="<%=param.getString("sch_text")%>"/>
                        <input type="hidden" name="currentPage" value="<%=param.getString("currentPage")%>"/>

                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width:15%;">
                                        <col style="width:85%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="required_field">제목</th>
                                        <td colspan="2">
                                            <input type="text" class="form-control" id="notice_sj" name="notice_sj"
                                                   placeholder="제목" value="<%=param.getString("bbs_sj") %>"
                                                   onkeyup="cfLengthCheck('제목은', this, 200);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>첨부파일</th>
                                        <td colspan="2">
                                            <div class="outBox1 fileBoxWrap">
                                            </div>
                                        </td>
                                    </tr>
                                    <% if (param.getString("adminYn").equals("Y")) { %>
                                    <tr>
                                        <th>전체 알림 여부</th>
                                        <td colspan="2">
                                            <select class="form-control" id="notice_upend_fixing"
                                                    name="notice_upend_fixing">
                                                <%=CommboUtil.getComboStr(ynComboStr, "CODE", "CODE_NM", "", "")%>
                                            </select>
                                        </td>
                                    </tr>
                                    <% } %>
                                    <tr>
                                        <th class="required_field">내용</th>
                                        <td colspan="2">
                                            <textarea class="form-control" rows="10" id="notice_cn" name="notice_cn"
                                                      onkeyup="cfLengthCheck('내용은', this, 4000);"><%=param.getString("bbs_cn") %></textarea>
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
