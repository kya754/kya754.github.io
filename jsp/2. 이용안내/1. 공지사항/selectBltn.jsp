<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.file.vo.NtsysFileVO" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@page import="egovframework.framework.common.util.DateUtil" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="fileList" class="java.util.ArrayList" type="java.util.List" scope="request"/>
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
        // 목록
        function fnGoList() {
            $('#aform').attr({action: '/iot/bltn/selectPageListBltn.do', method: 'get'}).submit();
        }

        // 수정폼 이동
        function fnGoUpdateForm() {
            $('#aform').attr({action: '/iot/bltn/updateFormBltn.do', method: 'get'}).submit();
        }

        // 삭제
        function fnGoDelete() {
            if (confirm('삭제하시겠습니까?')) {
                $('#aform').attr({action: '/iot/bltn/deleteBltn.do', method: 'post'}).submit();
            }
        }

        // 첨부파일 다운로드
        function fnDownload(file_id) {
            $('[name=file_id]').val(file_id);
            $('#aform').attr({'action': '/common/file/FileDown.do'}).submit();
        }


        function setFileIcon(obj) {
            obj.src = "/common/images/file_ext_ico/attach_etc.gif";
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
            <h1></h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box box-primary">
                        <form role="form" id="aform" method="post" action="/iot/bltn/selectBltn.do">
                            <input type="hidden" id="bbs_seq" name="bbs_seq"
                                   value="<%=resultMap.getString("BBS_SEQ") %>"/>
                            <input type="hidden" id="bbs_atchmnfl_id" name="bbs_atchmnfl_id"
                                   value="<%=resultMap.getString("BBS_ATCHMNFL_ID") %>"/>

                            <!-- 검색관련 -->
                            <input type="hidden" name="sch_organ_code" value="<%=param.getString("sch_organ_code")%>"/>
                            <input type="hidden" name="sch_type" value="<%=param.getString("sch_type")%>"/>
                            <input type="hidden" name="sch_text" value="<%=param.getString("sch_text")%>"/>
                            <input type="hidden" name="currentPage" value="<%=param.getString("currentPage")%>"/>
                            <input type="hidden" name="sch_row_per_page"
                                   value="<%=param.getString("sch_row_per_page")%>"/>

                            <input type="hidden" name="file_id"/>

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
                                        <th>제목</th>
                                        <td colspan="3"><%=resultMap.getString("BBS_SJ") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>작성자</th>
                                        <td><%=resultMap.getString("REGISTER_NM") %>
                                        </td>
                                        <th>등록일시</th>
                                        <td><%=resultMap.getString("REGIST_DT") %>
                                        </td>
                                    </tr>
                                    </tr>
                                    <th>첨부파일</th>
                                    <td colspan="3">
                                        <%
                                            int fileListSize = fileList.size();
                                            if (fileListSize > 0) {
                                                for (int i = 0; i < fileListSize; i++) {
                                                    NtsysFileVO fvo = (NtsysFileVO) fileList.get(i);
                                        %>
                                        <a href="#" onclick="fnDownload('<%=fvo.getFile_id()%>'); return false;">
                                            <img src="/common/images/file_ext_ico/attach_<%=fvo.getFile_ext_nm().toLowerCase()%>.gif"
                                                 width="16" height="16" class="attach_file"
                                                 onerror="setFileIcon(this)"/>
                                            <%=fvo.getFile_nm()%> (<%=fvo.getFile_size() / 1000.0%>) KB <br/>
                                        </a>
                                        <%
                                                }
                                            }
                                        %>
                                    </td>
                                    </tr>
                                    <% if (param.getString("adminYn").equals("Y")) { %>
                                    <tr>
                                        <th>전체 알림 여부</th>
                                        <td colspan="2">
                                            <%= resultMap.getString("NOTICE_UPEND_FIXING").toString()%>
                                        </td>
                                    </tr>
                                    <% } %>
                                    <tr>
                                        <th>조회수</th>
                                        <td colspan="3" class="text_area"><%=resultMap.getHtml("VIEW_CNT") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>내용</th>
                                        <td colspan="3" class="text_area"><%=resultMap.getHtml("BBS_CN") %>
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
                                    <% if (resultMap.getString("REGISTER_NO").equals(ssUserNo)) { %>
                                    <button type="button" class="btn btn-info"
                                            onclick="fnGoUpdateForm(); return false;"><i class="fa fa-pencil"></i> 수정
                                    </button>
                                    <% } %>
                                    <% if (param.getString("adminYn").equals("Y") || resultMap.getString("REGISTER_NO").equals(ssUserNo)) { %>
                                    <button type="button" class="btn btn-warning" onclick="fnGoDelete(); return false;">
                                        <i class="fa fa-trash"></i> 삭제
                                    </button>
                                    <% } %>
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
