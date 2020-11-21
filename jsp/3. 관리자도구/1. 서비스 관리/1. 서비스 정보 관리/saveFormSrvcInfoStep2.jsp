<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="crdntSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="useYNComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="unUseResultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>

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

            $("#all_chkbx1").click(function () {
                if ($(this).prop("checked") == true) {
                    $("[name=del_chkbx]").prop("checked", true);
                } else {
                    $("[name=del_chkbx]").prop("checked", false);
                }
            });

            $("#all_chkbx2").click(function () {
                if ($(this).prop("checked") == true) {
                    $("[name=reUse_chkbx]").prop("checked", true);
                } else {
                    $("[name=reUse_chkbx]").prop("checked", false);
                }
            });

        });

        //행추가
        function fnAddRow() {
            var html = '<tr>';
            html += '<input type="hidden" id="use_yn" name="use_yn" value="Y" />'
            html += '<td class="text-center"><input type="checkbox" name="del_chkbx" /></td>';
            html += '	<td class="text-center row_no"></td>';
            html += '	<td><input type="text" name="modl_serial" class="form-control" value="" maxlength="20"/></td>';
            html += '	<td><input type="text" name="post_no" class="form-control numeric" value="" maxlength="5"/></td>';
            html += '	<td><input type="text" name="adres" class="form-control" value="" maxlength="100"/></td>';
            html += '	<td><input type="text" name="adres_detail" class="form-control" value="" maxlength="100"/></td>';
            html += "	<td><select name='crdnt_code' class='form-control input-sm'> <%=CommboUtil.getComboStr(crdntSeComboStr, "CODE", "CODE_NM", param.getString(""), "")%> </select></td>";
            html += '	<td><input type="text" name="la" class="form-control" value="" maxlength="50"/></td>';
            html += '	<td><input type="text" name="lo" class="form-control" value="" maxlength="50"/></td>';
            html += '	<td><input type="text" name="antcty" class="form-control numeric" value="" maxlength="11"/></td>';
            html += '	<td><input type="text" name="buld_nm" class="form-control" value="" maxlength="50"/></td>';
            html += '	<td><input type="text" name="instl_floor" class="form-control" value="" maxlength="11"/></td>';
            html += '	<td><input type="text" name="instl_ho_no" class="form-control numeric" value="" maxlength="11"/></td>';
            html += '	<td><input type="text" name="rm" class="form-control" value="" maxlength="100"/></td>';
            html += '</tr>';

            $('#codeTable tbody').append(html);
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
                alert("삭제할 모델 설치 정보를 선택해 주세요.");
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
            $('#codeTable tbody .row_no').each(function () {
                $(this).text(setNo++);
            });

        }

        // 사용중지
        function fnUnUse() {
            var unUseList = f_getList("del_chkbx");
            var chkFag = false;

            for (i = 0; i < unUseList.length; i++) {
                if (unUseList[i].checked == true) {
                    chkFag = true;
                    break;
                }
            }

            if (chkFag == false) {
                alert("사용중지할 모델을 선택해 주세요.");
                return;
            }

            var trnsmit_server_no = $("#trnsmit_server_no").val();
            var data_no = $("#data_no").val();
            var req = {
                "trnsmit_server_no": trnsmit_server_no
                , "data_no": data_no
            };

            if (confirm("사용중지하시겠습니까?")) {
                $("#aform").attr({action: "/iot/srvcInfo/saveSrvcInfoStep2UnUse.do", method: 'post'}).submit();
            }
        }

        // 사용 재시작
        function fnReUse() {
            var reUseList = f_getList("reUse_chkbx");
            var chkFag = false;

            for (i = 0; i < reUseList.length; i++) {
                if (reUseList[i].checked == true) {
                    chkFag = true;
                    break;
                }
            }

            if (chkFag == false) {
                alert("재사용할 모델을 선택해 주세요.");
                return;
            }

            var trnsmit_server_no = $("#trnsmit_server_no").val();
            var data_no = $("#data_no").val();
            var req = {
                "trnsmit_server_no": trnsmit_server_no
                , "data_no": data_no
            };

            if (confirm("재사용하시겠습니까?")) {
                $("#aform").attr({action: "/iot/srvcInfo/saveSrvcInfoStep2ReUse.do", method: 'post'}).submit();
            }
        }

        //저장
        function fnSave() {
            var length = $("[name=post_no]").length;

            if (length < 1) {
                alert("저장할 모델 설치 정보가 존재하지 않습니다. ");
                return false;
            }

            for (i = 0; i < length; i++) {
                if ($("[name=modl_serial]:eq(" + i + ")").val() == "") {
                    alert("모델 시리얼을 입력해주세요. ");
                    $("[name=modl_serial]:eq(" + i + ")").focus();
                    return false;
                }
                /*
                            if($("[name=post_no]:eq("+i+")").val() == ""){
                                alert("우편번호를 입력해 주세요.");
                                $("[name=post_no]:eq("+i+")").focus();
                                return false;
                            }

                            if($("[name=adres]:eq("+i+")").val() == ""){
                                alert("주소를 입력해 주세요.");
                                $("[name=adres]:eq("+i+")").focus();
                                return false;
                            }

                            if($("[name=adres_detail]:eq("+i+")").val() == ""){
                                alert("상세 주소를 입력해 주세요.");
                                $("[name=adres_detail]:eq("+i+")").focus();
                                return false;
                            }
                         */
                ///고도값이 비었을 경우 0 처리
                if ($("[name=antcty]:eq(" + i + ")").val() == "") {
                    $("[name=antcty]:eq(" + i + ")").val('0');
                }

                ///건물 층이 비었을 경우 0 처리
                if ($("[name=instl_floor]:eq(" + i + ")").val() == "") {
                    $("[name=instl_floor]:eq(" + i + ")").val('0');
                }
                ///설치 호가 비었을 경우 0 처리
                if ($("[name=instl_ho_no]:eq(" + i + ")").val() == "") {
                    $("[name=instl_ho_no]:eq(" + i + ")").val('0');
                }
            } //for문 끝

            var size = $("input[name='modl_serial']").length;
            var old_modl_size = $("input[name='old_modl_serial']").length;
            var modl_nm_string = "";
            var trnsmit_server_no = $("#trnsmit_server_no").val();
            var data_no = $("#data_no").val();
            var firstchk = true;
            var oldChk = true;
            var doubleChk = "";

            for (var i = 0; i < size; i++) {
                for (var j = i + 1; j < size; j++) {
                    if ($("input[name='modl_serial']")[i].value == $("input[name='modl_serial']")[j].value) {
                        alert("같은 이름의 모델 시리얼은 사용할 수 없습니다. [" + $("input[name='modl_serial']")[j].value + "]");
                        return false;
                    }
                }

                oldChk = true;
                for (var j = 0; j < old_modl_size; j++) {
                    if ($("input[name='modl_serial']")[i].value == $("input[name='old_modl_serial']")[j].value) {
                        oldChk = false;
                    }
                }


                if (oldChk) {
                    if (firstchk) {
                        modl_nm_string = modl_nm_string + $("input[name='modl_serial']")[i].value
                        firstchk = false;
                    } else {
                        modl_nm_string = modl_nm_string + ", " + $("input[name='modl_serial']")[i].value
                    }
                }
            }

            var req = {
                "modl_nm_string": modl_nm_string
                , "trnsmit_server_no": trnsmit_server_no
                , "data_no": data_no
            };

            jQuery.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/iot/srvcInfo/chkSrvcInfoModlSerialAjax.do',
                data: req,
                success: function (param) {

                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    if (!param.resultStats.resultChkBool) {
                        alert("해당 모델 시리얼은 현재 사용 중입니다. [" + param.resultStats.resultErrorNm + "]");
                        return false;
                    }


                    if (confirm("저장하시겠습니까?")) {
                        $("#aform").attr({
                            action: "/iot/srvcInfo/saveSrvcInfoStep2.do",
                            method: 'post'
                        }).submit();
                    }

                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        //목록
        function fnGoList() {
            if ($("#currentPage").val() == null) {
                var hiddenHtml = "";
                hiddenHtml += '<input type="hidden" id="currentPage" name="currentPage" />';
                $('#aform').append(hiddenHtml);
            }

            $("#currentPage").val($("#pageList_currentPage").val());
            $("#aform").attr({
                action: "/iot/srvcInfo/selectPageListSrvcInfo.do",
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
                    <form role="form" id="aform" method="post">
                        <input type="hidden" id="trnsmit_server_no" name="trnsmit_server_no"
                               value="${param.trnsmit_server_no}"/>
                        <input type="hidden" id="data_no" name="data_no" value="${param.data_no}"/>
                        <input type="hidden" id="packet_mastr_seq" name="packet_mastr_seq"
                               value="${param.packet_mastr_seq}"/>
                        <input type="hidden" id="modl_inst_cnt" name="modl_inst_cnt"
                               value="<%= param.getString("modl_inst_cnt") %>"/>
                        <input type="hidden" id="p_srvc_nm" name="p_srvc_nm" value="${param.p_srvc_nm}"/>
                        <%-- pageList --%>
                        <input type="hidden" id="pageList_currentPage" name="pageList_currentPage"
                               value="${param.pageList_currentPage}"/>
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

                        <%@ include file="/common/inc/srvcInfoTab.jspf" %>
                        <div class="box box-primary">
                            <div class="box-body table-responsive no-padding">
                                <table id="codeTable" class="table table-bordered">
                                    <colgroup>
                                        <col width="40">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">번호</th>
                                        <th class="text-center ">모델 시리얼</th>
                                        <th class="text-center ">우편번호</th>
                                        <th class="text-center ">주소</th>
                                        <th class="text-center ">주소 상세</th>
                                        <th class="text-center">좌표 구분</th>
                                        <th class="text-center">위도</th>
                                        <th class="text-center">경도</th>
                                        <th class="text-center">고도(미터)</th>
                                        <th class="text-center">건물 명</th>
                                        <th class="text-center">설치 층</th>
                                        <th class="text-center">설치 호</th>
                                        <th class="text-center">비고</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        DataMap dataMap = null;
                                        for (int i = 0; i < resultList.size(); i++) {
                                            dataMap = (DataMap) resultList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center row_no"><%=i + 1%>
                                        </td>
                                        <td><%=dataMap.getString("MODL_SERIAL") %>
                                        </td>
                                        <td><%=dataMap.getString("POST_NO") %>
                                        </td>
                                        <td><%=dataMap.getString("ADRES") %>
                                        </td>
                                        <td><%=dataMap.getString("ADRES_DETAIL") %>
                                        </td>
                                        <td><%=CommboUtil.getComboName(crdntSeComboStr, "CODE", "CODE_NM", dataMap.getString("CRDNT_CODE"))%>
                                        </td>
                                        <td><%=dataMap.getString("LA") %>
                                        </td>
                                        <td><%=dataMap.getString("LO") %>
                                        </td>
                                        <td><%=dataMap.getString("ANTCTY") %>
                                        </td>
                                        <td><%=dataMap.getString("BULD_NM") %>
                                        </td>
                                        <td><%=dataMap.getString("INSTL_FLOOR") %>
                                        </td>
                                        <td><%=dataMap.getString("INSTL_HO_NO") %>
                                        </td>
                                        <td><%=dataMap.getString("RM") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    </tbody>
                                </table>
                            </div>

                            <div class="box-footer">
                                <%-- <button type="button" class="btn btn-primary" onclick="fnAddRow(); return false;"><i class="fa fa-plus"></i> 행추가</button>
                                <button type="button" class="btn btn-warning" onclick="fnDeleteRow(); return false;"><i class="fa fa-trash"></i> 행 삭제</button> --%>
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnGoList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <%-- <button type="button" class="btn btn-info" onclick="fnUnUse(); return false;"><i class="fa fa-pencil"></i> 사용중지</button>
                                    <button type="button" class="btn btn-info" onclick="fnSave(); return false;"><i class="fa fa-pencil"></i> 저장</button> --%>
                                </div>
                            </div>

                        </div><!-- /.box -->


                        <!-- 미사용 센서리스트  -->
                        <%--
                        <div class="box box-primary">
                            <div class="box-header">
                                <h3 class="box-title">
                                    <i class="fa fa-fw fa-info-circle"></i> 사용 중지된 모델 정보
                                </h3>
                            </div><!-- /.box-header -->
                            <div class="box-body table-responsive no-padding">
                                <table id="unUseTable" class="table table-bordered">
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
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                        <col width="*">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th class="text-center"><input type="checkbox" id="all_chkbx2" /></th>
                                            <th class="text-center">No</th>
                                            <th class="text-center required_field">모델 시리얼</th>
                                            <th class="text-center ">우편번호</th>
                                            <th class="text-center ">주소</th>
                                            <th class="text-center ">주소 상세</th>
                                            <th class="text-center">좌표 구분</th>
                                            <th class="text-center">위도</th>
                                            <th class="text-center">경도</th>
                                            <th class="text-center">고도(미터)</th>
                                            <th class="text-center">건물 명</th>
                                            <th class="text-center">설치 층</th>
                                            <th class="text-center">설치 호</th>
                                            <th class="text-center">비고</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        DataMap unUseDataMap = null;
                                        for(int i = 0; i < unUseResultList.size(); i++){
                                            unUseDataMap = (DataMap) unUseResultList.get(i);
                                    %>
                                        <input type="hidden" id="oldModl_serial" name="oldModl_serial" value="<%=unUseDataMap.getString("MODL_SERIAL") %>"/>
                                        <tr>
                                            <input type="hidden" id="use_yn" name="use_yn" value="<%=unUseDataMap.getString("USE_YN") %>" />
                                            <td class="text-center"><input type="checkbox" name="reUse_chkbx" value="<%=unUseDataMap.getString("MODL_SERIAL") %>"/></td>
                                            <td class="text-center row_no">1</td>
                                            <td><%=unUseDataMap.getString("MODL_SERIAL") %></td>
                                            <td><%=unUseDataMap.getString("POST_NO") %></td>
                                            <td><%=unUseDataMap.getString("ADRES") %></td>
                                            <td><%=unUseDataMap.getString("ADRES_DETAIL") %></td>
                                            <td><%=unUseDataMap.getString("CRDNT_NM") %></td>
                                            <td><%=unUseDataMap.getString("LA") %></td>
                                            <td><%=unUseDataMap.getString("LO") %></td>
                                            <td><%=unUseDataMap.getString("ANTCTY") %></td>
                                            <td><%=unUseDataMap.getString("BULD_NM") %></td>
                                            <td><%=unUseDataMap.getString("INSTL_FLOOR") %></td>
                                            <td><%=unUseDataMap.getString("INSTL_HO_NO") %></td>
                                            <td><%=unUseDataMap.getString("RM") %></td>
                                        </tr>
                                    <% }%>
                                    </tbody>
                                </table>
                            </div>
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info" onclick="return fnReUse(); return false;"><i class="fa fa-pencil"></i> 사용 재시작</button>
                                </div>
                            </div>
                        </div><!-- /.box -->
                         --%>

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
