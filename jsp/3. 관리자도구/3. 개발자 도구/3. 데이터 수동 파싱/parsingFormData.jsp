<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>

<%@ page import="egovframework.framework.common.object.DataMap" %>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="organComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="lclasComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="sensorComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="certkeyStatusComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="parsingComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="packetComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>

    <link rel="stylesheet" href="<%=jsRoot%>jsTree_new/themes/default/style.min.css"/>
    <script src="<%=jsRoot%>jsTree_new/jstree.min.js"></script>

    <script type="text/javascript">
        $(function () {

            $('[name=sch_regist_de_from], [name=sch_regist_de_to]').datetimepicker({
                locale: 'ko', 	// 화면에 출력될 언어를 한국어로 설정한다.
                format: 'YYYY.MM.DD',
                useCurrent: false, 	//Important! See issue #1075
                sideBySide: true,
            });

            $('[name=sch_srvc_lclas_code]').change(function () {
                if ($(this).val() == "") {
                    $('[name=sch_srvc_mclas_code]').val("");
                    $('[name=sch_srvc_sclas_code]').val("");
                    $('[name=sch_srvc_mclas_code]').attr("disabled", true);
                    $('[name=sch_srvc_sclas_code]').attr("disabled", true);
                } else {
                    fnSetServiceCode(1, $('[name=sch_srvc_lclas_code]').val(), "", "");
                }
            });

            $('[name=sch_srvc_mclas_code]').change(function () {
                if ($(this).val() == "") {
                    $('[name=sch_srvc_sclas_code]').val("");
                    $('[name=sch_srvc_sclas_code]').attr("disabled", true);
                } else {
                    fnSetServiceCode(2, $('[name=sch_srvc_lclas_code]').val(), $('[name=sch_srvc_mclas_code]').val(), "");
                }
            });

            $('[name=sch_srvc_sclas_code]').change(function () {
                fnSetServiceName($('[name=sch_srvc_lclas_code]').val(), $('[name=sch_srvc_mclas_code]').val(), $('[name=sch_srvc_sclas_code]').val(), "");
            });


            $('[name=sch_srvc_nm]').change(function () {
                if ($(this).val() == "") {
                    $('[name=sch_srvc_nm_text]').val("");
                    $('[name=sch_srvc_nm_text]').attr("readonly", false);
                } else {
                    $('[name=sch_srvc_nm_text]').val($(this).val());
                    $('[name=sch_srvc_nm_text]').attr("readonly", true);
                }
            });


            <% if(!param.getString("sch_srvc_lclas_code").equals("")){ %>
            fnSetServiceCode(1, <%=param.getString("sch_srvc_lclas_code")%>, "");
            $('[name=sch_srvc_mclas_code]').val("<%=param.getString("sch_srvc_mclas_code")%>");
            <% } %>
            <% if(!param.getString("sch_srvc_mclas_code").equals("")){ %>
            fnSetServiceCode(2, <%=param.getString("sch_srvc_lclas_code")%>, <%=param.getString("sch_srvc_mclas_code")%>);
            $('[name=sch_srvc_sclas_code]').val("<%=param.getString("sch_srvc_sclas_code")%>");
            <% } %>
            <% if(!param.getString("sch_srvc_sclas_code").equals("")){ %>
            fnSetServiceName('<%=param.getString("sch_srvc_lclas_code")%>', '<%=param.getString("sch_srvc_mclas_code")%>', '<%=param.getString("sch_srvc_sclas_code")%>', '<%=param.getString("sch_srvc_nm")%>');
            <% } %>
            <% if(!param.getString("sch_srvc_nm").equals("") && !param.getString("sch_srvc_nm_text").equals("")){ %>
            $('[name=sch_srvc_nm_text]').attr("readonly", true);
            <% } %>

        });

        //서비스 코드 조회
        function fnSetServiceCode(level, code1, code2) {

            var param = {
                level: level,
                attrb_1: code1,
                attrb_2: code2
            };

            $.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/iot/data/selectListServiceCodeAjax.do',
                data: param,
                success: function (param) {
                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    var obj = "", text = "", value = "", selected;
                    if (level == 1) {
                        obj = "sch_srvc_mclas_code";
                        text = "서비스 중분류";
                        value = "<%=param.getString("sch_srvc_mclas_code")%>";
                    } else {
                        obj = "sch_srvc_sclas_code";
                        text = "서비스 소분류";
                        value = "<%=param.getString("sch_srvc_sclas_code")%>";
                    }

                    if (param.resultList.length == 0) {
                        $("[name=" + obj + "]").empty().append('<option value="">' + text + '</option>');
                        $("[name=" + obj + "]").attr('disabled', true);
                    } else {
                        $("[name=" + obj + "]").empty().append('<option value="">' + text + '</option>');
                        $.each(param.resultList, function (i, data) {
                            if (data.CODE == value) {
                                selected = "selected=\'selected\'";
                            } else {
                                selected = "";
                            }
                            $("[name=" + obj + "]").append("<option value=\'" + data.CODE + "\' " + selected + ">" + data.CODE_NM + "</option>");
                        });
                        $("[name=" + obj + "]").attr('disabled', false);
                    }
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        //서비스명 조회
        function fnSetServiceName(code1, code2, code3, selValue) {

            var param = {
                sch_srvc_lclas_code: code1,
                sch_srvc_mclas_code: code2,
                sch_srvc_sclas_code: code3
            };

            $.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/common/selectListServiceNmAjax.do',
                data: param,
                success: function (param) {
                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    if (param.resultStats.resultList.length == 0) {
                        $("[name=sch_srvc_nm]").empty().append('<option value="">서비스 명 직접입력</option>');
                        $("[name=sch_srvc_nm]").attr('disabled', true);
                    } else {
                        var selected;
                        $("[name=sch_srvc_nm]").empty().append('<option value="">서비스 명 직접입력</option>');
                        $.each(param.resultStats.resultList, function (i, data) {
                            if (data.CODE == selValue) {
                                selected = "selected=\'selected\'";
                            } else {
                                selected = "";
                            }
                            $("[name=sch_srvc_nm]").append("<option value=\'" + data.CODE + "' " + selected + ">" + data.CODE_NM + "</option>");
                            $("[name=sch_srvc_nm]").attr('disabled', false);
                        });
                    }
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        //검색
        function fnSearch() {

            var param = $('#aform').serialize();

            $.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/iot/data/selectTotCntDataAjax.do',
                data: param,
                success: function (param) {
                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    if (param.totCnt == 0) {
                        $('#msg').text('조회된 데이터가 없습니다.');
                    } else {
                        $('#msg').text(param.totCnt + '건의 데이터가 조회되었습니다.');
                    }
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }


        function fnGoList() {
            $("#aform").attr({action: "/iot/data/selectPageListDataMgt.do", method: 'post'}).submit();
        }

        function fnParsing() {
            if ($('#msg').text() == "") {
                alert("검색 결과가 없습니다.");
            } else {
                var param = $("#aform").serialize();

                $.ajax({
                    type: 'POST',
                    dataType: 'json',
                    url: '/iot/data/parsingDataAjax.do',
                    data: param,
                    success: function (param) {
                        if (param.resultStats.resultCode == "error") {
                            alert(param.resultStats.resultMsg);
                            return;
                        }

                        if (param.parsingCnt > 0) {
                            $('#msg').text(param.parsingCnt + '건의 데이터가 파싱되었습니다.');
                        } else {
                            $('#msg').text('데이터 파싱에 실패하였습니다.');
                        }
                    },
                    error: function (jqXHR, textStatus, thrownError) {
                        ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                    }
                });


            }


        }

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
            <h1>데이터 관리 - 수동 파싱</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <form id="aform" method="post" action="/admin/menu/selectListMenuMgt.do">
                    <div class="col-lg-5">
                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width:30%">
                                        <col style="width:*;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>기관</th>
                                        <td>
                                            <select name="sch_organ_code" class="form-control input-sm">
                                                <%= CommboUtil.getComboStr(organComboStr, "CODE", "CODE_NM", param.getString("sch_organ_code"), "전체") %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>서비스 대분류</th>
                                        <td>
                                            <select name="sch_srvc_lclas_code" class="form-control input-sm">
                                                <%= CommboUtil.getComboStr(lclasComboStr, "CODE", "CODE_NM", param.getString("sch_srvc_lclas_code"), "전체") %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>서비스 중분류</th>
                                        <td>
                                            <select name="sch_srvc_mclas_code" class="form-control input-sm" disabled>
                                                <option value="">서비스 중분류</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>서비스 소분류</th>
                                        <td>
                                            <select name="sch_srvc_sclas_code" class="form-control input-sm" disabled>
                                                <option value="">서비스 소분류</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th rowspan="2">서비스 명</th>
                                        <td>
                                            <select name="sch_srvc_nm" class="form-control input-sm" disabled>
                                                <option value="">서비스 명 직접입력</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input type="text" class="form-control" name="sch_srvc_nm_text"
                                                   placeholder="서비스 명 직접입력"
                                                   value="<%=param.getString("sch_srvc_nm_text")%>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>데이터 번호</th>
                                        <td>
                                            <input type="text" class="form-control" name="sch_data_no"
                                                   placeholder="데이터 번호" value="<%=param.getString("sch_data_no")%>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>모델 명</th>
                                        <td>
                                            <input type="text" class="form-control" name="sch_modl_nm"
                                                   placeholder="모델 명" value="<%=param.getString("sch_modl_nm")%>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>센서 구분</th>
                                        <td>
                                            <select name="sch_sensor_se_code" class="form-control input-sm">
                                                <%= CommboUtil.getComboStr(sensorComboStr, "CODE", "CODE_NM", param.getString("sch_sensor_se_code"), "전체") %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>인증키 상태</th>
                                        <td>
                                            <select name="sch_certkey_sttus_code" class="form-control input-sm">
                                                <%= CommboUtil.getComboStr(certkeyStatusComboStr, "CODE", "CODE_NM", param.getString("sch_certkey_sttus_code"), "전체") %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>인증 키</th>
                                        <td>
                                            <input type="text" class="form-control" name="sch_crtfc_key"
                                                   placeholder="인증 키" value="<%=param.getString("sch_crtfc_key")%>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>파싱 구분</th>
                                        <td>
                                            <select name="sch_pars_se_code" class="form-control input-sm">
                                                <%= CommboUtil.getComboStr(parsingComboStr, "CODE", "CODE_NM", param.getString("sch_pars_se_code"), "전체") %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>수신 시작 일시</th>
                                        <td>
                                            <input type="text" class="form-control" name="sch_regist_de_from"
                                                   maxlength="" placeholder="수신 시작 일시"
                                                   value="<%=param.getString("sch_regist_de_from")%>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>수신 종료 일시</th>
                                        <td>
                                            <input type="text" class="form-control" name="sch_regist_de_to" maxlength=""
                                                   placeholder="수신 종료 일시"
                                                   value="<%=param.getString("sch_regist_de_to")%>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>수신 상태</th>
                                        <td>
                                            <select name="sch_packet_sttus_code" class="form-control input-sm">
                                                <%=CommboUtil.getComboStr(packetComboStr, "CODE", "CODE_NM", param.getString("sch_packet_sttus_code"), "전체")%>
                                            </select>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnSearch(); return false;"><i
                                            class="fa fa-search"></i></i> 검색
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- 우측 메뉴 정보 -->
                    <div class="col-lg-7">
                        <div class="box box-primary">
                            <div class="box-body no-padding">
                                <table class="table table-bordered" style="overflow-y:hidden;">
                                    <colgroup>
                                        <col style="width:20%">
                                        <col style="width:*;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>메시지</th>
                                        <td id="msg"></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="box-footer">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnGoList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnParsing(); return false;"><i
                                            class="fa fa-pencil"></i> 파싱
                                    </button>
                                </div>
                            </div>
                        </div><!-- box-primary -->
                    </div><!-- col-xs-7 -->
                </form>    <!-- aform -->
            </div>    <!-- row -->
        </section>    <!-- content -->
    </div>    <!-- content-wrapper -->

    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!--//footer -->
</div>    <!-- wrapper -->
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>