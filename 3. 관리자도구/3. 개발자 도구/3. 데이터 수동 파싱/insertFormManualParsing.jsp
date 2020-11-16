<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="serviceInfo" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="packetDetailList" type="java.util.List" class="java.util.ArrayList" scope="request"/>

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
        var fileCkeckFlag = false;	// 파일 검증 플래그, true 일때 업로드 가능
        var fileCkeckErrorCnt = 0;	// 파일 검증 에러건수, 파일 업로드 시 에러건수 alert 노출
        $(function () {
            fnComboStrOneFile('.fileBoxWrap');

            $('span[name=toggle-control]').click(function () {
                $("#packet_info").toggle();
                $('span[name=toggle-control]').toggle();
            });

            // 첨부 파일 선택 시, 파일 검증 플래그 false
            $("#upload").change(function () {
                fileCkeckFlag = false;
            });

        });

        // 업로드
        function fnExcelUpload() {
            if (fileCkeckFlag == false) {
                alert("파일 검증 진행 후 업로드가 가능합니다.");
                return false;
            }

            if (fileCkeckErrorCnt > 0) {
                if (confirm("오류 패킷이 있습니다. 그래도 진행하시겠습니까?")) {
                    excelUpload();
                } else {
                    return false;
                }
            } else {
                excelUpload();
            }
        }

        // 업로드 ajax
        function excelUpload() {
            // Get form
            var form = $('#aform')[0];
            // Create an FormData object
            var data = new FormData(form);

            $.ajax({
                type: 'post',
                dataType: 'json',
                url: '/iot/data/excelUploadParsingAjax.do',
                data: data,
                enctype: 'multipart/form-data', // 필수
                processData: false, 						// 필수
                contentType: false, 						// 필수
                success: function (response) {
                    if (response.resultStats.resultCode == "ok") {
                        var successCnt = response.resultStats.resultCnt.successCnt;
                        var errorCnt = response.resultStats.resultCnt.errorCnt;

                        alert("파일 업로드가 완료되었습니다. (성공 : " + successCnt + " 건, 오류 : " + errorCnt + " 건)");
                        location.reload();
                    } else {
                        alert(response.resultStats.resultMsg);
                        return;
                    }
                    fileCkeckFlag = false;
                }
            });
        }

        // 파일 검증
        function fnFileCkeck() {
            if ($("#upload").val() == "") {
                alert("파일을 선택해 주세요.");
                return false;
            }

            // Get form
            var form = $('#aform')[0];
            // Create an FormData object
            var data = new FormData(form);

            $.ajax({
                type: 'post',
                dataType: 'json',
                url: '/iot/data/fileCheckAjax.do',
                data: data,
                enctype: 'multipart/form-data', // 필수
                processData: false, 						// 필수
                contentType: false, 						// 필수
                success: function (response) {
                    if (response.resultStats.resultCode == "ok") {
                        var html = "";
                        var successCnt = response.resultStats.successCnt;
                        var errorCnt = response.resultStats.errorCnt;
                        fileCkeckErrorCnt = errorCnt;

                        $('#cntTable tbody>tr').remove();

                        html += '<tr>';
                        html += '	<th>성공 건수</th>';
                        html += '	<td><b>' + successCnt + ' 건</b></td>';
                        html += '</tr>';
                        html += '<tr>';
                        html += '	<th>오류 건수</th>';
                        html += '	<td><b>' + errorCnt + ' 건</b></td>';
                        html += '</tr>';
                        $('#cntTable tbody').append(html);

                        var loopCnt = response.resultStats.resultList.length;
                        var colCnt = $('#errorTable th').length;

                        $('#errorTable tbody>tr').remove();

                        html = '';
                        if (loopCnt == 0) {
                            html += '<tr>';
                            html += '	<td class="text-center" colspan="' + colCnt + '"><spring:message code="msg.data.empty"/></td>';
                            html += '</tr>';
                        } else {
                            for (var i = 0; i < loopCnt; i++) {
                                html += '<tr>';
                                html += '	<td class="text-center">' + (i + 1) + '</td>';
                                for (var j = 0; j < (colCnt - 1); j++) {
                                    html += '	<td>' + nvl(eval("response.resultStats.resultList[i].COLUMN" + j), '') + '</td>';
                                }
                                html += '</tr>';
                            }
                        }
                        $('#errorTable tbody').append(html);
                    } else {
                        alert(response.resultStats.resultMsg);
                        return;
                    }
                    fileCkeckFlag = true;
                }
            });
        }

        // 목록
        function fnGoList() {
            $('#aform').attr({action: '/iot/data/selectPageListDataMgt.do', method: 'post'}).submit();
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
            <h1>데이터 서비스</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" enctype="multipart/form-data">
                        <!-- 내용 DOC ID -->
                        <input type="hidden" id="trnsmit_server_no" name="trnsmit_server_no"
                               value="${param.trnsmit_server_no}"/>
                        <input type="hidden" id="data_no" name="data_no" value="${param.data_no}"/>
                        <input type="hidden" id="srvc_nm" name="srvc_nm" value="${param.srvc_nm}"/>
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
                        <input type="hidden" id="sch_senser_code" name="sch_senser_code"
                               value="${param.sch_senser_code}"/>
                        <input type="hidden" id="sch_srvc_status" name="sch_srvc_status"
                               value="${param.sch_srvc_status}"/>
                        <input type="hidden" id="sch_srvc_nm2" name="sch_srvc_nm2" value="${param.sch_srvc_nm2}"/>
                        <input type="hidden" id="sch_row_per_page" name="sch_row_per_page"/>

                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width: 15%;"/>
                                        <col style="width: 85%;"/>
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
                                    <tr>
                                        <th>누적 데이터 수</th>
                                        <td>
                                            <fmt:formatNumber type="number" maxFractionDigits="3"
                                                              value='<%=serviceInfo.getString("PACKET_TOT_CNT")%>'/>

                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                        </div><!-- /.box -->

                        <div class="box box-primary">
                            <div class="box-body">
                                <span name="toggle-control"> <a> ▶ 패킷 정보 펼치기 </a> </span>
                                <span name="toggle-control" style="display:none;"> <a> ▶ 패킷 정보 접기 </a> </span>
                            </div>
                            <div class="box-body table-responsive no-padding" id="packet_info" style="display:none;">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col width="40">
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
                                        <th class="text-center">구분</th>
                                        <th class="text-center">명칭</th>
                                        <th class="text-center">길이</th>
                                        <th class="text-center">단위</th>
                                        <th class="text-center">범주</th>
                                        <th class="text-center">설명</th>
                                        <th class="text-center">공개 구분</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        DataMap packetInfoMap = null;
                                        for (int i = 0; i < packetDetailList.size(); i++) {
                                            packetInfoMap = (DataMap) packetDetailList.get(i);
                                    %>
                                    <tr>
                                        <td class="text-center"><%=i + 1%>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PACKET_SE_NM") %>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PACKET_NM") %>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PACKET_BYTE") %>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PACKET_UNIT") %>
                                        </td>
                                        <td><%=packetInfoMap.getString("PACKET_CTGRY") %>
                                        </td>
                                        <td><%=packetInfoMap.getString("DC") %>
                                        </td>
                                        <td class="text-center"><%=packetInfoMap.getString("PUBLIC_YN_NM") %>
                                        </td>
                                    </tr>
                                    <% }%>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                        </div><!-- /.box -->

                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title"><i class="fa fa-fw fa-info-circle"></i>수동 파싱 데이터 파일 업로드</h3>
                            </div>
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width: 15%;"/>
                                        <col style="width: 85%;"/>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>데이터 파일</th>
                                        <td>
                                            <div class="outBox1 fileBoxWrap">
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="box-footer">
                                    <div class="pull-right">
                                        <button type="button" class="btn btn-default"
                                                onclick="fnGoList(); return false;"><i class="fa fa-reply"></i> 목록
                                        </button>
                                        <button type="button" class="btn btn-info"
                                                onclick="fnFileCkeck(); return false;"><i class="fa fa-pencil"></i> 파일
                                            검증
                                        </button>
                                        <button type="button" class="btn btn-info"
                                                onclick="fnExcelUpload(); return false;"><i class="fa fa-pencil"></i>
                                            업로드
                                        </button>
                                    </div>
                                </div>
                                <div class="box-header">
                                    <div class="text-left form-inline">
                                        <div class="form-group">
                                            <b>파일 검증 결과</b>
                                        </div>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body table-responsive no-padding">
                                    <table id="cntTable" class="table table-bordered">
                                        <colgroup>
                                            <col style="width: 15%;"/>
                                            <col style="width: 85%;"/>
                                        </colgroup>
                                        <tbody>
                                        <tr>
                                            <th>성공 건수</th>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <th>오류 건수</th>
                                            <td></td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <b>최근 10개의 '패킷 길이 오류' 패킷입니다.</b>
                                <div class="box-body table-responsive no-padding">
                                    <table id="errorTable" class="table table-bordered table-hover">
                                        <colgroup>
                                            <col width="50">
                                            <%for (int i = 0; i < packetDetailList.size(); i++) {%>
                                            <col width="*">
                                            <%}%>
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th class="text-center">번호</th>
                                            <%
                                                for (int i = 0; i < packetDetailList.size(); i++) {
                                                    packetInfoMap = (DataMap) packetDetailList.get(i);
                                            %>
                                            <th class="text-center"><%=packetInfoMap.getString("PACKET_NM")%>
                                            </th>
                                            <%}%>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td class="text-center" colspan="<%=packetDetailList.size()+1%>">
                                                <spring:message code="msg.data.empty"/></td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div><!-- /.box-body -->
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
