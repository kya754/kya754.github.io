<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="rowPerPageComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>
    <script type="text/javascript">
        //<![CDATA[
        $(function () {
            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page").change(function () {
                $("#currentPage").val("1");
                $("#aform").attr({action: "/iot/sms/selectSMSReciever.do", method: 'post'}).submit();
            });
        });

        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/iot/sms/selectSMSReciever.do", method: 'post'}).submit();
        }

        function fnInsert() {

            if ($("#rcver_nm").val() == "") {
                alert("수신자 명을 입력해 주세요.");
                $("#rcver_nm").focus();
                return false;
            }

            if ($("#mobile1").val() == "") {
                alert("수신자 번호를 선택해 주세요.");
                $("#mobile1").focus();
                return false;
            }

            if ($("#mobile2").val() == "") {
                alert("수신자 번호를 선택해 주세요.");
                $("#mobile2").focus();
                return false;
            }

            if ($("#mobile3").val() == "") {
                alert("수신자 번호를 선택해 주세요.");
                $("#mobile3").focus();
                return false;
            }

            if ($("#recptn_cycle_mnt").val() == "") {
                alert("수신자 수신주기를 선택해 주세요.");
                $("#recptn_cycle_mnt").focus();
                return false;
            }


            if (confirm("저장하시겠습니까?")) {
                $("#aform").attr({action: "/iot/sms/saveSMSReciever.do", method: 'post'}).submit();
            }
        }

        function fnDelete() {
            if (confirm("삭제하시겠습니까?")) {
                $("#aform").attr({action: "/iot/sms/deleteSMSReciever.do", method: 'post'}).submit();
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
            <h1>통합 SMS 수신자</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <!-- content 영역 -->
                    <form id="aform" method="post" action="iot/sms/selectSMSReciever.do">
                        <div class="box box-primary">
                            <div class="box-header">
                                <h3 class="box-title">통합 SMS 수신자 정보</h3>
                            </div>
                            <div class="box-body no-pad-top table-responsive">

                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width:15%">
                                        <col style="width:30%">
                                        <col style="width:15%">
                                        <col style="width:40%">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="required_field">수신자 명</th>
                                        <td>
                                            <div class="input-group">
                                                <input type="hidden" name="sms_seq"
                                                       value="<%=resultMap.getString("SMS_SEQ")%>">
                                                <input type="text" class="form-control input-sm" id="rcver_nm"
                                                       name="rcver_nm" maxlength="10"
                                                       style="display: inline-block; width: 120px"
                                                       value="<%=resultMap.getString("RCVER_NM")%>">
                                            </div>
                                        </td>
                                        <th class="required_field">수신자 번호</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm numeric" id="mobile1"
                                                       name="mobile1" maxlength="4"
                                                       style="display: inline-block; width: 80px"
                                                       value="<%=resultMap.getString("MOBILE1")%>">
                                                <span style="margin: 5px"> - </span>
                                                <input type="text" class="form-control input-sm numeric" id="mobile2"
                                                       name="mobile2" maxlength="4"
                                                       style="display: inline-block; width: 80px"
                                                       value="<%=resultMap.getString("MOBILE2")%>">
                                                <span style="margin: 5px"> - </span>
                                                <input type="text" class="form-control input-sm numeric" id="mobile3"
                                                       name="mobile3" maxlength="4"
                                                       style="display: inline-block; width: 80px"
                                                       value="<%=resultMap.getString("MOBILE3")%>">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">수신자 수신주기(분)</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control input-sm numeric"
                                                       id="recptn_cycle_mnt" name="recptn_cycle_mnt" maxlength="4"
                                                       style="display: inline-block; width: 120px"
                                                       value="<%=resultMap.getString("RECPTN_CYCLE_MNT")%>">
                                                <span style="margin: 5px"> 분 (※실시간은 0입력)</span>
                                            </div>
                                        </td>
                                        <th class="required_field">수신 여부</th>
                                        <td>
                                            <div class="outBox1">
                                                <select class="form-control input-sm" name="recptn_yn"
                                                        style="display: inline-block; width: 80px">
                                                    <option value="Y"
                                                            <%if(resultMap.getString("RECPTN_YN").equals("Y")){%>selected="selected"<%}%>>
                                                        예
                                                    </option>
                                                    <option value="N"
                                                            <%if(resultMap.getString("RECPTN_YN").equals("N")){%>selected="selected"<%}%>>
                                                        아니오
                                                    </option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>

                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-warning" onclick="fnDelete();"><i
                                            class="fa fa-trash"></i>삭제
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnInsert(); return false;"><i
                                            class="fa fa-pencil"></i> 저장
                                    </button>
                                </div>
                            </div>
                        </div><!-- /.box -->
                        <div class="box box-primary">

                            <div class="box-header">
                                <h3 class="box-title">SMS 수신 이력</h3>
                            </div>

                            <div class="box-body no-pad-top table-responsive">
                                <table class="table table-bordered table-hover">
                                    <colgroup>
                                        <col width="80">
                                        <col width="100">
                                        <col width="100">
                                        <col width="*">
                                        <col width="140">
                                        <col width="80">
                                        <col width="15%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">수신자 명</th>
                                        <th class="text-center">모바일</th>
                                        <th class="text-center">메시지</th>
                                        <th class="text-center">수신 일시</th>
                                        <th class="text-center">성공 여부</th>
                                        <th class="text-center">발신 결과 메시지</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        String naviBar = (String) request.getAttribute("navigationBar");
                                        int dataNo = pageNavigationVo.getCurrDataNo();
                                        DataMap dataMap = null;
                                        for (int i = 0; i < resultList.size(); i++) {
                                            dataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center">
                                            <%=dataNo - i %>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("RCVER_NM")%>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("MOBILE")%>
                                        </td>
                                        <td class="text-left"><%=dataMap.getString("MSSAGE")%>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("RECPTN_DT")%>
                                        </td>
                                        <td class="text-center"><%=dataMap.getString("SEND_YN")%>
                                        </td>
                                        <td class="text-left"><%=dataMap.getString("SEND_RST_STR")%>
                                        </td>
                                    </tr>
                                    <% }%>
                                    <% if (resultList.size() == 0) { %>
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
                                <%=naviBar%>
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
