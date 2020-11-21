<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.util.file.vo.NtsysFileVO" %>
<%@ page import="egovframework.framework.common.util.SysUtil" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="fileList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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
            fnComboStrFile('.fileBoxWrap', <%=fileList.size()%>, 5);
        });

        // 상세
        function fnDetail() {
            $('#aform').attr({action: '/iot/bltn/selectBltn.do', method: 'get'}).submit();
        }

        // 수정
        function fnGoUpdate() {

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

            if (confirm('수정하시겠습니까?')) {
                $('#aform').attr({action: '/iot/bltn/updateBltn.do', method: 'post'}).submit();
            }
        }

        //파일 다운로드
        function fnDownload(file_id) {
            $('[name=file_id]').val(file_id);
            $('#aform').attr({'action': '/common/file/FileDown.do'}).submit();
        }

        //서버에 있는 파일 삭제
        function fnFileDel(obj, file_id) {

            if (confirm('삭제하시겠습니까?')) {

                var param = {'file_id': file_id};

                jQuery.ajax({
                    type: 'POST',
                    dataType: 'json',
                    url: '/common/file/deleteFileInfAjax.do',
                    data: param,
                    success: function (param) {

                        if (param.resultStats.resultCode == 'error') {
                            alert(param.resultStats.resultMsg);
                            return;
                        } else {
                            alert(param.resultStats.resultMsg);
                            // 첨부파일 삭제
                            $(obj).parent().remove();

                            // 첨부파일 select 박스 다시 그림
                            var n = $('.attach_file').length;
                            fnComboStrFile('.fileBoxWrap', n, 5);
                        }
                    },
                    error: function (jqXHR, textStatus, thrownError) {
                        ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                    }
                });
            }
        }

        //]]>
    </script>
</head>
<body class="hold-transition <%=cssSkin %> layout-top-nav">
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

                    <form role="form" id="aform" method="post" action="/iot/bltn/updateBltn.do"
                          enctype="multipart/form-data">
                        <input type="hidden" id="bbs_seq" name="bbs_seq" value="<%=resultMap.getString("BBS_SEQ") %>"/>
                        <input type="hidden" id="bbs_atchmnfl_id" name="bbs_atchmnfl_id"
                               value="<%=resultMap.getString("BBS_ATCHMNFL_ID") %>"/>

                        <!-- 검색조건 -->
                        <input type="hidden" name="sch_type" value="<%=param.getString("sch_type")%>"/>
                        <input type="hidden" name="sch_text" value="<%=param.getString("sch_text")%>"/>
                        <input type="hidden" name="currentPage" value="<%=param.getString("currentPage")%>"/>

                        <input type="hidden" name="file_id"/>

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
                                                   placeholder="제목"
                                                   value="<%=param.getString("BBS_SJ", resultMap.getString("BBS_SJ")) %>"
                                                   onkeyup="cfLengthCheck('제목은', this, 100);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>첨부파일</th>
                                        <td colspan="2">
                                            <div class="outBox1 fileBoxWrap">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>첨부파일 목록</th>
                                        <td colspan="2">
                                            <div class="outBox1">
                                                <%
                                                    int fileListSize = fileList.size();
                                                    for (int i = 0; i < fileListSize; i++) {
                                                        NtsysFileVO fvo = (NtsysFileVO) fileList.get(i);
                                                %>
                                                <div>
                                                    <a href="#"
                                                       onclick="fnDownload('<%=fvo.getFile_id()%>'); return false;">
                                                        <img src="/common/images/file_ext_ico/attach_<%=fvo.getFile_ext_nm().toLowerCase()%>.gif"
                                                             width="16" height="16" class="attach_file"/>
                                                        <%=fvo.getFile_nm()%> (<%=fvo.getFile_size() / 1000.0%>) KB
                                                    </a>
                                                    <a href="#"
                                                       onclick="fnFileDel(this, '<%=fvo.getFile_id() %>'); return false;">[삭제]</a><br/>
                                                </div>
                                                <%
                                                    }
                                                %>
                                            </div>
                                        </td>
                                    </tr>
                                    <% if (param.getString("adminYn").equals("Y")) { %>
                                    <tr>
                                        <th>전체 알림 여부</th>
                                        <td colspan="2">
                                            <select class="form-control" id="notice_upend_fixing"
                                                    name="notice_upend_fixing">
                                                <%=CommboUtil.getComboStr(ynComboStr, "CODE", "CODE_NM", resultMap.getString("NOTICE_UPEND_FIXING").toString(), "")%>
                                            </select>
                                        </td>
                                    </tr>
                                    <%} %>
                                    <tr>
                                        <th class="required_field">내용</th>
                                        <td colspan="2">
                                            <textarea class="form-control" rows="10" id="notice_cn" name="notice_cn"
                                                      onkeyup="cfLengthCheck('내용은', this, 4000);"><%=param.getString("BBS_CN", resultMap.getString("BBS_CN")) %></textarea>
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
