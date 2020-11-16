<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>

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

        //등록
        function fnGoInsert() {
            if ($("#packet_size").val() == "") {
                alert("패킷 전체 사이즈를 입력해 주세요.");
                $("#packet_size").focus();
                return false;
            }

            if ($("#hder_size").val() == "") {
                alert("헤더 사이즈를 입력해 주세요.");
                $("#hder_size").focus();
                return false;
            }

            if ($("#data_size").val() == "") {
                alert("데이터 사이즈를 입력해 주세요.");
                $("#data_size").focus();
                return false;
            }

            if ($("#packet_size").val() != Number($('#hder_size').val()) + Number($('#data_size').val())) {
                alert("헤더와 데이터의 합이 전체 사이즈와 다릅니다.");
                return false;
            }

            if (confirm("저장하시겠습니까?")) {
                $("#aform").attr({
                    action: "/iot/certkey/saveCertKeyStep3.do",
                    method: 'post'
                }).submit();
            }
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
            $(".content-header h1").append("(<%=param.getString("p_srvc_nm")%>)");
        });
    </script>

    <!-- content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>인증키 관리 - 발급</h1>
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

                        <%@ include file="/common/inc/modelTap.jspf" %>
                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width: 20%;">
                                        <col style="width: 80%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="required_field">패킷 전체 사이즈</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control numeric" id="packet_size"
                                                       name="packet_size" placeholder="패킷 전체 사이즈" maxlength="10"
                                                       value="${resultMap.PACKET_SIZE}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">헤더 사이즈</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control numeric" id="hder_size"
                                                       name="hder_size" placeholder="헤더 사이즈" maxlength="10"
                                                       value="${resultMap.HDER_SIZE}">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="required_field">데이터 사이즈</th>
                                        <td>
                                            <div class="outBox1">
                                                <input type="text" class="form-control numeric" id="data_size"
                                                       name="data_size" placeholder="데이터 사이즈" maxlength="10"
                                                       value="${resultMap.DATA_SIZE}">
                                            </div>
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
                                    <button type="button" class="btn btn-info" onclick="fnGoInsert(); return false;">
                                        <i class="fa fa-pencil"></i> 저장
                                    </button>
                                </div>
                            </div><!-- /.box-footer -->
                        </div><!-- /.box -->
                </div>
                <!--  /.col-xs-12 -->
            </div>
            <!-- ./row -->
        </section>
        <!-- /.content -->
    </div>
    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!-- //fooer -->
</div>
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
