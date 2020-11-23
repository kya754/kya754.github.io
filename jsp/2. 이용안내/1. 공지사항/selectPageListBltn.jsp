<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="fixResultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="navigationBar" class="java.lang.String" scope="request"/>
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
            //기관 셀렉트 박스 변경시 조회
            $("#sch_organ_code").change(function () {
                fnSearch();
            });
            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page").change(function () {
                fnSearch();
            });
        });

        // 페이지 이동
        function fnGoPage(currentPage) {
            $('#currentPage').val(currentPage);
            $('#aform').attr({action: '/iot/bltn/selectPageListBltn.do', method: 'get'}).submit();
        }

        // 등록폼 이동
        function fnInsertForm() {
            $('#aform').attr({action: '/iot/bltn/insertFormBltn.do', method: 'post'}).submit();
        }

        // 상세조회
        function fnSelect(bbs_seq) {
            $('#bbs_seq').val(bbs_seq);
            $('#aform').attr({action: '/iot/bltn/selectBltn.do', method: 'get'}).submit();
        }

        // 검색
        function fnSearch() {
            $('#currentPage').val('1');
            $('#aform').attr({action: '/iot/bltn/selectPageListBltn.do', method: 'get'}).submit();
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
            <h1></h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" action="/iot/bltn/selectPageListBltn.do">
                        <input type="hidden" id="bbs_seq" name="bbs_seq"/>

                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <div class="form-group">
                                        <c:if test="${adminYn eq 'Y' }">
                                            <!-- 관리자일 경우 검색조건 추가 -->
                                            <select id="sch_organ_code" name="sch_organ_code"
                                                    class="form-control input-sm">
                                                <%=CommboUtil.getComboStr(organSeComboStr, "CODE", "CODE_NM", param.getString("sch_organ_code"), "기관 명")%>
                                            </select>
                                        </c:if>
                                        <select id="search_list_st" name="sch_type" class="form-control input-sm">
                                            <option value="title"
                                                    <%if(param.getString("sch_type").equals("bbs_sj")){%>selected="selected"<%}%>>
                                                제목
                                            </option>
                                            <option value="cn"
                                                    <%if(param.getString("sch_type").equals("bbs_cn")){%>selected="selected"<%}%>>
                                                내용
                                            </option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <input type="text" class="form-control" name="sch_text"
                                                   placeholder="검색어를 입력하세요." title="검색어를 입력하세요."
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
                                        <col style="width:5%;">
                                        <col style="">
                                        <col style="width:10%;">
                                        <col style="width:10%;">
                                        <col style="width:10%;">
                                        <col style="width:10%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">제목</th>
                                        <th class="text-center">조회수</th>
                                        <th class="text-center">작성기관</th>
                                        <th class="text-center">작성자</th>
                                        <th class="text-center">등록일</th>
                                    </tr>
                                    </thead>
                                    <tbody>

                                    <%
                                        //상단고정 공지
                                        DataMap dataMapfix = new DataMap();
                                        int fixResultListSize = fixResultList.size();
                                        for (int y = 0; y < fixResultListSize; y++) {
                                            dataMapfix = (DataMap) fixResultList.get(y);
                                    %>
                                    <tr style="cursor:pointer;cursor:hand;"
                                        onclick="fnSelect('<%=dataMapfix.getString("BBS_SEQ")%>')">
                                        <td class="text-center">공지</td>
                                        <td>
                                            <%=dataMapfix.getString("BBS_SJ") %>
                                        </td>
                                        <td class="text-center"><%=dataMapfix.getString("VIEW_CNT") %>
                                        </td>
                                        <td class="text-center"><%=dataMapfix.getString("ORGAN_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMapfix.getString("REGISTER_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMapfix.getString("REGIST_DT") %>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        int dataNo = pageNavigationVo.getCurrDataNo();
                                        DataMap dataMap = new DataMap();
                                        int resultListSize = resultList.size();
                                        for (int i = 0; i < resultListSize; i++) {
                                            dataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr style="cursor:pointer;cursor:hand;"
                                        onclick="fnSelect('<%=dataMap.getString("BBS_SEQ")%>')">
                                        <td class="text-center">
                                            <%=dataNo - i %>
                                        </td>
                                        <td>
                                            <%=dataMap.getString("BBS_SJ") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("VIEW_CNT") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("ORGAN_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("REGISTER_NM") %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("REGIST_DT") %>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        if (resultListSize == 0 && fixResultListSize == 0) {
                                    %>
                                    <tr>
                                        <td class="text-center" colspan="5"><spring:message code="msg.data.empty"/></td>
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
                                <%=navigationBar %>
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <c:if test="${insertYn eq 'Y' }">
                                    <div class="pull-right">
                                        <button type="button" class="btn btn-info"
                                                onclick="fnInsertForm(); return false;"><i class="fa fa-pencil"></i> 등록
                                        </button>
                                    </div>
                                </c:if>
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

