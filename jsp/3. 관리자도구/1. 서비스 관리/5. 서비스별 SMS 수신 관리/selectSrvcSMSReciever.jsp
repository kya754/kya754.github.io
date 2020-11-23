<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="resultList1" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="resultList2" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="recptnYn" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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
                $("#aform").attr({action: "/iot/sms/selectSrvcSMSReciever.do", method: 'post'}).submit();
            });
        });

        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/iot/sms/selectSrvcSMSReciever.do", method: 'post'}).submit();
        }

        var row_num = 1;
        $(document).ready(function () {
            setRowNo();
            fnSetNumeric();

            $("#all_chkbx").click(function () {
                if ($(this).prop("checked") == true) {
                    $("[name=del_chkbx]").prop("checked", true);
                } else {
                    $("[name=del_chkbx]").prop("checked", false);
                }
            });

        });

        //행추가
        function fnAddRow() {

            var html = '<tr>';
            html += '<td class="text-center"><input type="checkbox" name="del_chkbx" /></td>';
            html += '	<td class="text-center row_no"></td>';
            html += '	<td><input type="text" name="rcver_nm" class="form-control" value="" maxlength="10"/></td>';
            html += '	<td><div class="form-inline">';
            html += '	<input type="text" name="mobile1" class="form-control numeric" value="" maxlength="3" style="width:80px;"/>';
            html += '	<span style="margin:5px">-</span>';
            html += '	<input type="text" name="mobile2" class="form-control numeric" value="" maxlength="4" style="width:80px;"/>';
            html += '	<span style="margin:5px">-</span>';
            html += '	<input type="text" name="mobile3" class="form-control numeric" value="" maxlength="4" style="width:80px;"/>';
            html += '	</div></td>';
            html += '	<td><div class="form-inline">';
            html += '	<input type="text" name="recptn_cycle_mnt" class="form-control numeric" value="" maxlength="10" style="width:60px;"/>';
            html += '	<span style="margin:10px">분 (※실시간은 0입력)</span>';
            html += '	</div></td>';
            html += "<td><select name='recptn_yn' class='form-control input-sm'><%=CommboUtil.getComboStr(recptnYn, "CODE", "CODE_NM", param.getString(""), "")%></select></td>"
            html += '</tr>';

            $('#tbody1').append(html);

            setRowNo();
            fnSetNumeric();
        }

        //행삭제
        function fnDeleteRow() {
            var delChkbx = f_getList("del_chkbx");
            var chkFag = false;

            for (i = 0; i < delChkbx.length; i++) {
                if (delChkbx[i].checked == true) {
                    chkFag = true;
                    break;
                }
            }

            if (chkFag == false) {
                alert("삭제할 수신자 정보를 선택해 주세요.");
                return false;
            }

            if (confirm("선택된 행을 삭제하시겠습니까?")) {
                $('[name=del_chkbx]:checked').each(function () {
                    $(this).closest('tr').remove();
                });
                setRowNo();
            }
        }

        //No 번호 매기기
        function setRowNo() {

            var setNo = 1;
            $('#aform tbody .row_no').each(function () {
                $(this).text(setNo++);
            });

        }

        //저장
        function fnSave() {
            var length = $("[name=rcver_nm]").length;
            /*
            if(length < 1){
                alert("저장할 수신자 정보가 존재하지 않습니다. ");
                return false;
            }
            */
            for (i = 0; i < length; i++) {
                if ($("[name=rcver_nm]:eq(" + i + ")").val() == "") {
                    alert("수신자 명을 입력해 주세요.");
                    $("[name=rcver_nm]:eq(" + i + ")").focus();
                    return false;
                }

                if ($("[name=mobile1]:eq(" + i + ")").val() == "") {
                    alert("번호1을 입력해 주세요.");
                    $("[name=mobile1]:eq(" + i + ")").focus();
                    return false;
                }

                if ($("[name=mobile2]:eq(" + i + ")").val() == "") {
                    alert("번호2를 입력해 주세요.");
                    $("[name=mobile2]:eq(" + i + ")").focus();
                    return false;
                }

                if ($("[name=mobile3]:eq(" + i + ")").val() == "") {
                    alert("번호3을 입력해 주세요.");
                    $("[name=mobile3]:eq(" + i + ")").focus();
                    return false;
                }
                if ($("[name=recptn_cycle_mnt]:eq(" + i + ")").val() == "") {
                    alert("수신주기를 입력해 주세요.");
                    $("[name=recptn_cycle_mnt]:eq(" + i + ")").focus();
                    return false;
                }
            }

            if (confirm("저장하시겠습니까?")) {
                $("#aform").attr({
                    action: "/iot/sms/saveSrvcSMSReciever.do",
                    method: 'post'
                }).submit();
            }
        }

        //목록
        function fnGoList() {
            if ($("#currentPage").val() == null) {
                var hiddenHtml = "";
                hiddenHtml += '<input type="hidden" id="currentPage" name="currentPage" />';
                $('#aform').append(hiddenHtml);
            }

            $("#currentPage").val($("#pageList_currentPage").val());
            $("#sch_row_per_page").val($("#pageList_sch_row_per_page").val());
            $("#aform").attr({
                action: "/iot/sms/selectPageListSrvcSMSReciever.do",
                method: 'post'
            }).submit();
        }

        //]]>
    </script>
</head>
<body class="hold-transition <%=cssSkin%> layout-top-nav">
<div class="wrapper">

    <!-- 헤더  -->
    <c:import url="/common/inc/header.do" charEncoding="utf-8"/>


    <script type="text/javascript">
        $(function () {
            $(".content-header h1").append("(<%=param.getString("srvc_nm")%>)");
        });
    </script>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>서비스별 SMS 수신자 정보</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <!-- content 영역 -->
                    <form id="aform" method="post" action="iot/sms/selectSrvcSMSReciever.do">
                        <input type="hidden" name="trnsmit_server_no" value="${param.trnsmit_server_no}"/>
                        <input type="hidden" name="data_no" value="${param.data_no}"/>
                        <input type="hidden" name="organ_code" value="${param.organ_code}"/>
                        <%-- pageList --%>
                        <input type="hidden" id="pageList_currentPage" name="pageList_currentPage"
                               value="${param.pageList_currentPage}"/>
                        <input type="hidden" id="pageList_sch_row_per_page" name="pageList_sch_row_per_page"
                               value="${param.pageList_sch_row_per_page}"/>
                        <input type="hidden" id="sch_organ_code" name="sch_organ_code" value="${param.sch_organ_code}"/>
                        <input type="hidden" id="sch_srvc_hrank_code" name="sch_srvc_hrank_code"
                               value="${param.sch_srvc_hrank_code}"/>
                        <input type="hidden" id="sch_srvc_lrank_code" name="sch_srvc_lrank_code"
                               value="${param.sch_srvc_lrank_code}"/>
                        <input type="hidden" id="sch_srvc_nm" name="sch_srvc_nm" value="${param.sch_srvc_nm}"/>
                        <input type="hidden" id="sch_srvc_status" name="sch_srvc_status"
                               value="${param.sch_srvc_status}"/>
                        <input type="hidden" id="sch_srvc_nm2" name="sch_srvc_nm2" value="${param.sch_srvc_nm2}"/>

                        <div class="box box-primary">
                            <div class="box-body no-pad-top table-responsive">
                                <table id="codeTable" class="table table-bordered">
                                    <colgroup>
                                        <col width="5%">
                                        <col width="5%">
                                        <col width="10%">
                                        <col width="20%">
                                        <col width="15%">
                                        <col width="10%">
                                        <col width="*">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center"><input type="checkbox" id="all_chkbx"/></th>
                                        <th class="text-center">번호</th>
                                        <th class="text-center required_field">수신자 명</th>
                                        <th class="text-center required_field">번호</th>
                                        <th class="text-center required_field">수신자 수신주기(분)</th>
                                        <th class="text-center required_field">수신여부</th>
                                        <th class="text-center"></th>
                                    </tr>
                                    </thead>
                                    <tbody id="tbody1">
                                    <%
                                        DataMap dataMap1 = null;
                                        for (int i = 0; i < resultList1.size(); i++) {
                                            dataMap1 = (DataMap) resultList1.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><input type="checkbox" name="del_chkbx"/></td>
                                        <td class="text-center row_no">1</td>
                                        <td><input type="text" name="rcver_nm" class="form-control"
                                                   value="<%=dataMap1.getString("RCVER_NM") %>" maxlength="10"/></td>
                                        <td>
                                            <div class="form-inline">
                                                <input type="text" name="mobile1" class="form-control numeric"
                                                       value="<%=dataMap1.getString("MOBILE1") %>" maxlength="3"
                                                       style="width:80px;"/>
                                                <span style="margin:5px">-</span>
                                                <input type="text" name="mobile2" class="form-control numeric"
                                                       value="<%=dataMap1.getString("MOBILE2") %>" maxlength="4"
                                                       style="width:80px;"/>
                                                <span style="margin:5px">-</span>
                                                <input type="text" name="mobile3" class="form-control numeric"
                                                       value="<%=dataMap1.getString("MOBILE3") %>" maxlength="4"
                                                       style="width:80px;"/>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-inline">
                                                <input type="text" name="recptn_cycle_mnt" class="form-control numeric"
                                                       value="<%=dataMap1.getString("RECPTN_CYCLE_MNT") %>"
                                                       maxlength="10" style="width:60px;"/>
                                                <span style="margin:10px">분 (※실시간은 0입력)</span>
                                            </div>
                                        </td>
                                        <td>
                                            <select name="recptn_yn" class="form-control input-sm">
                                                <%=CommboUtil.getComboStr(recptnYn, "CODE", "CODE_NM", dataMap1.getString("RECPTN_YN"), "")%>
                                            </select>
                                        </td>
                                    </tr>
                                    <% }%>
                                    </tbody>
                                </table>

                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <button type="button" class="btn btn-primary" onclick="fnAddRow(); return false;"><i
                                        class="fa fa-plus"></i> 행추가
                                </button>
                                <button type="button" class="btn btn-warning" onclick="fnDeleteRow(); return false;"><i
                                        class="fa fa-trash"></i> 행 삭제
                                </button>
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnGoList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnSave(); return false;"><i
                                            class="fa fa-pencil"></i> 저장
                                    </button>
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
                                        <tbody id="tbody2">
                                        <%
                                            String naviBar = (String) request.getAttribute("navigationBar");
                                            int dataNo = pageNavigationVo.getCurrDataNo();
                                            DataMap dataMap2 = null;
                                            for (int i = 0; i < resultList2.size(); i++) {
                                                dataMap2 = (DataMap) resultList2.get(i);
                                        %>
                                        <tr>
                                            <td class="text-center">
                                                <%=dataNo - i %>
                                            </td>
                                            <td class="text-center"><%=dataMap2.getString("RCVER_NM")%>
                                            </td>
                                            <td class="text-center"><%=dataMap2.getString("MOBILE")%>
                                            </td>
                                            <td class="text-left"><%=dataMap2.getString("MSSAGE")%>
                                            </td>
                                            <td class="text-center"><%=dataMap2.getString("RECPTN_DT")%>
                                            </td>
                                            <td class="text-center"><%=dataMap2.getString("SEND_YN")%>
                                            </td>
                                            <td class="text-left"><%=dataMap2.getString("SEND_RST_STR")%>
                                            </td>
                                        </tr>
                                        <% }%>
                                        <% if (resultList2.size() == 0) { %>
                                        <tr>
                                            <td class="text-center" colspan="7"><spring:message
                                                    code="msg.data.empty"/></td>
                                        </tr>
                                        <%}%>
                                        </tbody>
                                    </table>
                                </div><!-- /.box-body -->
                                <div class="box-footer clearfix text-center">
                                    <div class="pull-left form-inline">
                                        Row Per Page
                                        <select id="sch_row_per_page" name="sch_row_per_page"
                                                class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(rowPerPageComboStr, "CODE", "CODE_NM", param.getString("sch_row_per_page"), "")%>
                                        </select>
                                    </div>
                                    <%=naviBar %>
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
