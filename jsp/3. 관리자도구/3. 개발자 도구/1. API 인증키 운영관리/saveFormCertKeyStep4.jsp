<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="packetSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="publicYn" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="graphYn" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>

    <script type="text/javascript">
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
            var last_packet_code = $("[name=packet_se_code]:eq(" + ($("[name=packet_se_code]").length - 1) + ")").val();
            if (last_packet_code == null || last_packet_code == "") {
                last_packet_code = "H";
            }

            var html = '<tr>';
            html += '<td class="text-center"><input type="checkbox" name="del_chkbx" /></td>';
            html += '	<td class="text-center row_no"></td>';
            html += "<td><select name='packet_se_code' class='form-control input-sm'><%=CommboUtil.getComboStr(packetSeComboStr, "CODE", "CODE_NM", param.getString(""), "")%></select></td>"
            html += '	<td><input type="text" name="packet_nm" class="form-control" value="" maxlength="50"/></td>';
            html += '	<td><input type="text" name="packet_byte" class="form-control numeric" value="" maxlength="10"/></td>';
            html += '	<td><input type="text" name="packet_unit" class="form-control" value="" maxlength="50"/></td>';
            html += '	<td><input type="text" name="packet_ctgry" class="form-control" value="" maxlength="100"/></td>';
            html += '	<td><input type="text" name="dc" class="form-control" value="" maxlength="100"/></td>';
            html += '	<td><input type="text" name="limit_value" class="form-control" value="" maxlength="50"/></td>';
            html += '	<td><input type="text" name="ceck_pttrn" class="form-control" value="" maxlength="100"/></td>';
            html += "<td><select name='public_yn' class='form-control input-sm'><%=CommboUtil.getComboStr(publicYn, "CODE", "CODE_NM", param.getString(""), "")%></select></td>"
            html += "<td><select name='graph_yn' class='form-control input-sm'><%=CommboUtil.getComboStr(graphYn, "CODE", "CODE_NM", param.getString(""), "")%></select></td>"
            html += '	<td><input type="text" name="sort_ordr" class="form-control numeric" value="" maxlength="10"/></td>';
            html += '</tr>';

            $('#aform tbody').append(html);

            $("[name=packet_se_code]:eq(" + ($("[name=packet_se_code]").length - 1) + ")").val(last_packet_code);
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
                alert("삭제할 패킷 상세 정보를 선택해 주세요.");
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
            /*
                    var totCnt = Number($('#aform tbody tr').length);
                    $('#aform tbody .row_no').each(function(){
                        $(this).text(totCnt--);
                    });
             */
            var setNo = 1;
            $('#aform tbody .row_no').each(function () {
                $(this).text(setNo++);
            });

        }

        //저장
        function fnSave() {
            var length = $("[name=packet_se_code]").length;

            if (length < 1) {
                alert("저장할 패킷 상세 정보가 존재하지 않습니다. ");
                return false;
            }

            for (i = 0; i < length; i++) {
                if ($("[name=packet_se_code]:eq(" + i + ")").val() == "") {
                    alert("패킷 구분을 선택해 주세요.");
                    $("[name=packet_se_code]:eq(" + i + ")").focus();
                    return false;
                }

                if ($("[name=packet_nm]:eq(" + i + ")").val() == "") {
                    alert("패킷 명을 입력해 주세요.");
                    $("[name=packet_nm]:eq(" + i + ")").focus();
                    return false;
                }

                if ($("[name=packet_byte]:eq(" + i + ")").val() == "") {
                    alert("패킷 바이트를 입력해 주세요.");
                    $("[name=packet_byte]:eq(" + i + ")").focus();
                    return false;
                }

                if ($("[name=sort_ordr]:eq(" + i + ")").val() == "") {
                    alert("정렬 순서를 입력해 주세요.");
                    $("[name=sort_ordr]:eq(" + i + ")").focus();
                    return false;
                }
            }

            var totHder = 0;
            var totTail = 0;
            $("[name=packet_se_code]").each(function (i) {
                if ($(this).val() == 'H') {
                    totHder += Number($("[name=packet_byte]:eq(" + i + ")").val());
                } else {
                    totTail += Number($("[name=packet_byte]:eq(" + i + ")").val());
                }
            });
            if (totHder > Number('${resultMap.HDER_SIZE}')) {
                if (!confirm("헤더 패킷 바이트의 합이 헤더사이즈보다 큽니다. 저장하시겠습니까? \n(헤더사이즈 : ${resultMap.HDER_SIZE} / 데이터사이즈 : ${resultMap.DATA_SIZE})")) {
                    return false;
                }
            }
            if (totTail > Number('${resultMap.DATA_SIZE}')) {
                if (!confirm("테일 패킷 바이트의 합이 데이터사이즈보다 큽니다. 저장하시겠습니까? \n(헤더사이즈 : ${resultMap.HDER_SIZE} / 데이터사이즈 : ${resultMap.DATA_SIZE})")) {
                    return false;
                }
            }


            if (confirm("저장하시겠습니까?")) {
                $("#aform").attr({
                    action: "/iot/certkey/saveCertKeyStep4.do",
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
            $("#sch_srvc_hrank_code").val($("#pageList_sch_srvc_hrank_code").val());
            $("#sch_srvc_lrank_code").val($("#pageList_sch_srvc_lrank_code").val());

            $("#aform").attr({
                action: "/iot/certkey/saveFormCertKeyStep0.do",
                method: 'post'
            }).submit();
        }
    </script>
</head>
<body class="hold-transition <%=cssSkin%> layout-top-nav">
<div class="wrapper">

    <!-- 헤더  -->
    <c:import url="/common/inc/header.do" charEncoding="utf-8"/>


    <script type="text/javascript">
        $(function () {
            $(".content-header h1").append("(<%=param.getString("p_srvc_nm")%>)");
        });
    </script>

    <!-- content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>인증키 관리-발급</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <%@ include file="/common/inc/modelTap.jspf" %>
                    <form role="form" id="aform" method="post">
                        <input type="hidden" id="trnsmit_server_no" name="trnsmit_server_no"
                               value="${param.trnsmit_server_no}"/>
                        <input type="hidden" id="data_no" name="data_no" value="${param.data_no}"/>
                        <input type="hidden" id="packet_mastr_seq" name="packet_mastr_seq"
                               value="${param.packet_mastr_seq}"/>
                        <input type="hidden" id="packet_detail_cnt" name="packet_detail_cnt"
                               value="<%= param.getString("packet_detail_cnt") %>"/>
                        <input type="hidden" id="p_srvc_nm" name="p_srvc_nm" value="${param.p_srvc_nm}"/>
                        <%-- pageList --%>
                        <input type="hidden" id="pageList_currentPage" name="pageList_currentPage"
                               value="${param.pageList_currentPage}"/>
                        <input type="hidden" id="sch_organ_code" name="sch_organ_code" value="${param.sch_organ_code}"/>
                        <input type="hidden" id="pageList_sch_srvc_hrank_code" name="pageList_sch_srvc_hrank_code"
                               value="${param.pageList_sch_srvc_hrank_code}"/>
                        <input type="hidden" id="pageList_sch_srvc_lrank_code" name="pageList_sch_srvc_lrank_code"
                               value="${param.pageList_sch_srvc_lrank_code}"/>
                        <input type="hidden" id="sch_srvc_nm" name="sch_srvc_nm" value="${param.sch_srvc_nm}"/>
                        <input type="hidden" id="sch_srvc_nm2" name="sch_srvc_nm2" value="${param.sch_srvc_nm2}"/>
                        <input type="hidden" id="sch_row_per_page" name="sch_row_per_page"
                               value="${param.sch_row_per_page}"/>

                        <div class="box box-primary">
                            <div class="box-body table-responsive no-padding">
                                <table id="codeTable" class="table table-bordered">
                                    <colgroup>
                                        <col width="40">
                                        <col width="40">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="100">
                                        <col width="100">
                                        <col width="*">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center"><input type="checkbox" id="all_chkbx"/></th>
                                        <th class="text-center">No</th>
                                        <th class="text-center required_field">패킷 구분</th>
                                        <th class="text-center required_field">패킷 명</th>
                                        <th class="text-center required_field">패킷 길이</th>
                                        <th class="text-center">패킷 단위</th>
                                        <th class="text-center">패킷 범주</th>
                                        <th class="text-center">패킷 설명</th>
                                        <th class="text-center">임계치</th>
                                        <th class="text-center">체크 패턴</th>
                                        <th class="text-center">공개 여부</th>
                                        <th class="text-center">차트 설정</th>
                                        <th class="text-center required_field">정렬 순서</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        DataMap dataMap = null;
                                        for (int i = 0; i < resultList.size(); i++) {
                                            dataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><input type="checkbox" name="del_chkbx"/></td>
                                        <td class="text-center row_no">1</td>
                                        <td>
                                            <select name="packet_se_code" class="form-control input-sm">
                                                <%=CommboUtil.getComboStr(packetSeComboStr, "CODE", "CODE_NM", dataMap.getString("PACKET_SE_CODE"), "")%>
                                            </select>
                                        </td>
                                        <td><input type="text" name="packet_nm" class="form-control"
                                                   value="<%=dataMap.getString("PACKET_NM") %>" maxlength="50"/></td>
                                        <td><input type="text" name="packet_byte" class="form-control numeric"
                                                   value="<%=dataMap.getString("PACKET_BYTE") %>" maxlength="10"/></td>
                                        <td><input type="text" name="packet_unit" class="form-control"
                                                   value="<%=dataMap.getString("PACKET_UNIT") %>" maxlength="50"/></td>
                                        <td><input type="text" name="packet_ctgry" class="form-control"
                                                   value="<%=dataMap.getString("PACKET_CTGRY") %>" maxlength="100"/>
                                        </td>
                                        <td><input type="text" name="dc" class="form-control"
                                                   value="<%=dataMap.getString("DC") %>" maxlength="100"/></td>
                                        <td><input type="text" name="limit_value" class="form-control"
                                                   value="<%=dataMap.getString("LIMIT_VALUE") %>" maxlength="50"/></td>
                                        <td><input type="text" name="ceck_pttrn" class="form-control"
                                                   value="<%=dataMap.getString("CECK_PTTRN") %>" maxlength="100"/></td>
                                        <td>
                                            <select name="public_yn" class="form-control input-sm">
                                                <%=CommboUtil.getComboStr(publicYn, "CODE", "CODE_NM", dataMap.getString("PUBLIC_YN"), "")%>
                                            </select>
                                        </td>
                                        <td>
                                            <select name="graph_yn" class="form-control input-sm">
                                                <%=CommboUtil.getComboStr(graphYn, "CODE", "CODE_NM", dataMap.getString("GRAPH_YN"), "")%>
                                            </select>
                                        </td>
                                        <td><input type="text" name="sort_ordr" class="form-control numeric"
                                                   value="<%=dataMap.getString("SORT_ORDR") %>" maxlength="10"/></td>
                                    </tr>
                                    <% }%>
                                    </tbody>
                                </table>
                            </div>
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
                            </div>
                        </div><!-- /.box -->
                    </form>
                </div><!-- col-xs-12 -->
            </div><!-- row -->
        </section><!-- content -->
    </div><!-- content-wrapper -->
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!-- //fooer -->
</div>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
