<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="organComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="lclasComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="sensorComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="certkeyStatusComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="parsingComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="packetComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

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
            //서비스명 조회
            $('[name=sch_srvc_lclas_code]').change(function () {
                if ($(this).val() == "") {
                    $('[name=sch_srvc_mclas_code]').val("");
                    $('[name=sch_srvc_sclas_code]').val("");
                    $('[name=sch_srvc_mclas_code]').attr("disabled", true);
                    $('[name=sch_srvc_sclas_code]').attr("disabled", true);
                    fnSetServiceName('', '', '', '');
                } else {
                    fnSetServiceCode(1, $('[name=sch_srvc_lclas_code]').val(), "", "");
                    fnSetServiceName($('[name=sch_srvc_lclas_code]').val(), "", "", "");
                }
            });

            $('[name=sch_srvc_mclas_code]').change(function () {
                if ($(this).val() == "") {
                    $('[name=sch_srvc_sclas_code]').val("");
                    $('[name=sch_srvc_sclas_code]').attr("disabled", true);
                    fnSetServiceName($('[name=sch_srvc_lclas_code]').val(), '', '', '');
                } else {
                    fnSetServiceCode(2, $('[name=sch_srvc_lclas_code]').val(), $('[name=sch_srvc_mclas_code]').val(), "", "");
                    fnSetServiceName($('[name=sch_srvc_lclas_code]').val(), $('[name=sch_srvc_mclas_code]').val(), "", "");
                }
            });

            $('[name=sch_srvc_sclas_code]').change(function () {
                fnSetServiceName($('[name=sch_srvc_lclas_code]').val(), $('[name=sch_srvc_mclas_code]').val(), $('[name=sch_srvc_sclas_code]').val(), "");
            });


            if ("<%=param.getString("sch_srvc_lclas_code")%>" != "") {
                fnSetServiceCode(1, '<%=param.getString("sch_srvc_lclas_code")%>', "", '<%=param.getString("sch_srvc_mclas_code")%>');
            }
            if ("<%=param.getString("sch_srvc_mclas_code")%>" != "") {
                fnSetServiceCode(2, '<%=param.getString("sch_srvc_lclas_code")%>', '<%=param.getString("sch_srvc_mclas_code")%>', '<%=param.getString("sch_srvc_sclas_code")%>');
            }
            fnSetServiceName($('[name=sch_srvc_lclas_code]').val(), $('[name=sch_srvc_mclas_code]').val(), $('[name=sch_srvc_sclas_code]').val(), '<%=param.getString("sch_srvc_nm")%>');


        });

        //서비스 코드 조회
        function fnSetServiceCode(level, code1, code2, selValue) {

            var param = {
                level: level,
                attrb_1: code1,
                attrb_2: code2
            };

            $.ajax({
                type: 'POST',
                dataType: 'json',
                async: false,
                url: '/iot/data/selectListServiceCodeAjax.do',
                data: param,
                success: function (param) {
                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    var obj = "", text = "", selected;
                    if (level == 1) {
                        obj = "sch_srvc_mclas_code";
                        text = "서비스 중분류";
                    } else {
                        obj = "sch_srvc_sclas_code";
                        text = "서비스 소분류";
                    }

                    if (param.resultList.length == 0) {
                        $("[name=" + obj + "]").empty().append('<option value="">' + text + '</option>');
                        $("[name=" + obj + "]").attr('disabled', true);
                    } else {
                        $("[name=" + obj + "]").empty().append('<option value="">' + text + '</option>');
                        $.each(param.resultList, function (i, data) {
                            if (data.CODE == selValue) {
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
                        $("[name=sch_srvc_nm]").empty().append('<option value="">서비스 명</option>');
                    } else {
                        var selected;
                        $("[name=sch_srvc_nm]").empty().append('<option value="">서비스 명</option>');
                        $.each(param.resultStats.resultList, function (i, data) {
                            if (data.CODE == selValue) {
                                selected = "selected=\'selected\'";
                            } else {
                                selected = "";
                            }
                            $("[name=sch_srvc_nm]").append("<option value=\'" + data.CODE + "' " + selected + ">" + data.CODE_NM + "</option>");
                        });
                    }
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        function fnKeydown() {
            if (event.keyCode == 13) {
                fnSearch();
            }
        }

        // 검색
        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/iot/data/selectPageListDataMgt.do", method: 'get'}).submit();
        }

        // 페이지 이동
        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/iot/data/selectPageListDataMgt.do", method: 'post'}).submit();
        }

        //엑셀다운로드
        function fnExceldownload() {
            $("#aform").attr({action: "/iot/data/exceldownloadDataMgt.do", method: 'post'}).submit();
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
            <h1>데이터 관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post">
                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <!-- 서비스 대분류  -->
                                    <div class="form-group">
                                        <select name="sch_srvc_lclas_code" class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(lclasComboStr, "CODE", "CODE_NM", param.getString("sch_srvc_lclas_code"), "서비스 대분류")%>
                                        </select>
                                    </div>
                                    <!-- 서비스 중분류 -->
                                    <div class="form-group">
                                        <select name="sch_srvc_mclas_code" class="form-control input-sm" disabled>
                                            <option value="">서비스 중분류</option>
                                        </select>
                                    </div>
                                    <!-- 서비스 소분류  -->
                                    <div class="form-group">
                                        <select name="sch_srvc_sclas_code" class="form-control input-sm" disabled>
                                            <option value="">서비스 소분류</option>
                                        </select>
                                    </div>
                                    <!-- 서비스 명  -->
                                    <div class="form-group">
                                        <select name="sch_srvc_nm" class="form-control input-sm"></select>
                                    </div>
                                    <!-- 모델 시리얼 직접입력 -->
                                    <div class="form-group">
                                        <input type="text" class="form-control input-sm" name="sch_srvc_nm_text"
                                               placeholder="모델 시리얼" onKeydown="fnKeydown()"
                                               value="<%=param.getString("sch_srvc_nm_text")%>" style="width:120px;"/>
                                    </div>
                                    <!-- 파싱 구분  -->
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <span style="margin: 5px">수신확인</span>
                                            <div class="form-group">
                                                <div class="outBox1">
                                                    <input type="text" class="form-control input-sm"
                                                           name="sch_rcpt_time" placeholder="시간" onKeydown="fnKeydown()"
                                                           value="<%=param.getString("sch_srvc_rcpt_time")%>"
                                                           style="display: inline-block; width: 100px"/>
                                                    <span style="margin: 5px">시간</span>
                                                </div>
                                            </div>
                                            <div class="input-group-btn">
                                                <button type="button" class="btn btn-sm btn-default"
                                                        onclick="fnSearch(); return false;"><i
                                                        class="fa fa-search">검색</i></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div><!-- /.box-header -->
                            <div class="box-body no-pad-top table-responsive">
                                <table class="table table-hover table-bordered table_fixed">
                                    <colgroup>
                                        <col width="80"/>
                                        <col width="80"/>
                                        <col width="20%"/>
                                        <col width="*"/>
                                        <col width="15%"/>
                                        <col width="10%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center"></th>
                                        <th class="text-center">No</th>
                                        <th class="text-center">기관명</th>
                                        <th class="text-center txt_overflow">서비스 명</th>
                                        <th class="text-center">모델 시리얼</th>
                                        <th class="text-center">수신 상태</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td class="text-center"></td>
                                        <td class="text-center"></td>
                                        <td></td>
                                        <td class="text-center"></td>
                                        <td class="text-center"></td>
                                        <td class="text-center"></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
                                ${navigationBar }
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <button type="button" class="btn btn-info" onclick="fnExceldownload(); return false;"><i
                                        class="fa fa-pencil"></i> 검색결과 엑셀 다운로드
                                </button>
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="">모델 사용중지</button>
                                </div>
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