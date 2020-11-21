<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="serviceInfo" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="chargertList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="userList" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>
    <script type="text/javascript">
        var userList = new Array();
        var $tr2 = null;
        //<![CDATA[
        $(function () {

        });

        // 목록
        function fnGoList() {
            $("#aform").attr({action: "/iot/charger/selectPageListBsnsCharger.do", method: 'post'}).submit();
        }

        // 등록
        function fnGoInsert() {
            if (confirm("서비스 담당자를 저장하시겠습니까?")) {
                $("#aform").attr({action: "/iot/charger/saveBsnsCharger.do", method: 'post'}).submit();
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
            <h1>사업 담당자</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <!-- content 영역 -->
                    <form id="aform" method="post" action="iot/stats/selectPageListServiceRcptStatus.do">
                        <input type="hidden" name="trnsmit_server_no" value="${param.trnsmit_server_no}"/>
                        <input type="hidden" name="data_no" value="${param.data_no}"/>
                        <input type="hidden" name="organ_code" value="${param.organ_code}"/>
                        <input type="hidden" name="redirectUrl" value="/iot/charger/saveFormBsnsCharger.do"/>
                        <%-- pageList --%>
                        <input type="hidden" id="sch_organ_code" name="sch_organ_code" value="${param.sch_organ_code}"/>
                        <input type="hidden" id="sch_srvc_hrank_code" name="sch_srvc_hrank_code"
                               value="${param.sch_srvc_hrank_code}"/>
                        <input type="hidden" id="sch_srvc_lrank_code" name="sch_srvc_lrank_code"
                               value="${param.sch_srvc_lrank_code}"/>
                        <input type="hidden" id="sch_srvc_nm" name="sch_srvc_nm" value="${param.sch_srvc_nm}"/>
                        <input type="hidden" id="sch_srvc_status" name="sch_srvc_status"
                               value="${param.sch_srvc_status}"/>
                        <input type="hidden" id="sch_srvc_nm2" name="sch_srvc_nm2" value="${param.sch_srvc_nm2}"/>
                        <input type="hidden" id="sch_row_per_page" name="sch_row_per_page"
                               value="${param.sch_row_per_page}"/>

                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width: 20%;">
                                        <col style="width: 80%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>기관 명</th>
                                        <td>
                                            <%=serviceInfo.getString("ORGAN_NM")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>서버 명</th>
                                        <td>
                                            <%=serviceInfo.getString("SERVER_NM")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>서비스 명</th>
                                        <td>
                                            <%=serviceInfo.getString("SRVC_NM")%>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                        </div><!-- /.box -->


                        <div class="box box-primary">
                            <div style="overflow: hidden; margin-bottom:10px;">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info update" data-toggle="modal"
                                            data-target="#assignMgrModal" id="selectConf">
                                        <i class="fa fa-user-plus"></i> 서비스 담당자 지정
                                    </button>
                                </div>
                            </div>
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width:80px;">
                                        <col style="width:15%;">
                                        <col style="width:*;">
                                        <col style="width:25%;">
                                        <col style="width:20%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">순번</th>
                                        <th class="text-center">담당자 ID</th>
                                        <th class="text-center">담당자 성명</th>
                                        <th class="text-center">담당자 구분</th>
                                        <th class="text-center">등록 일</th>
                                    </tr>
                                    </thead>
                                    <tbody class="user_wrap_p">
                                    <c:forEach var="data" items="${chargertList}" varStatus="status">
                                        <tr>
                                            <td class="text-center">
                                                <c:out value="${status.index+1}"/>
                                            </td>
                                            <td class="text-center">${data.USER_ID}</td>
                                            <td class="text-center">${data.USER_NM}</td>
                                            <td class="text-center">${data.USER_SE_NM}</td>
                                            <td class="text-center">${data.REGIST_YMD}</td>
                                            <input type="hidden" name="user_no" value="${data.USER_NO}">
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${fn:length(chargertList) == 0}">
                                        <tr>
                                            <td class="text-center" colspan="5"><spring:message
                                                    code="msg.data.empty"/></td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnGoList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnGoInsert(); return false;"><i
                                            class="fa fa-pencil"></i> 저장
                                    </button>
                                </div>
                            </div><!-- /.box-footer -->
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
<%@ include file="/common/inc/chargerAssign.jspf" %>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
