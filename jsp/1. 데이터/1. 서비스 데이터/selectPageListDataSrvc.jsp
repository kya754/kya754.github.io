<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="organSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="senserSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="srvcStatusComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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
            // fnSetLClassCombo();		//콤보 생성
            fnSetHRankCombo();			// 상, 하위 분류 콤보 생성

            // 서비스 명 셀렉트 박스 변경시 조회
            $("#sch_srvc_nm").change(function () {
                fnSearch();
            });
            // 기관 셀렉트 박스 변경시 조회
            $("#sch_organ_code").change(function () {
                fnSearch();
            });
            // 센서구분 셀렉트 박스 변경시 조회
            $("#sch_senser_code").change(function () {
                fnSearch();
            });
            // 서비스 상태 셀렉트 박스 변경시 조회
            $("#sch_srvc_status").change(function () {
                fnSearch();
            });
            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page").change(function () {
                fnSearch();
            });
        });

        // 페이지 이동
        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/data/service/selectPageListDataSrvc.do", method: 'post'}).submit();
        }

        // 검색
        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/data/service/selectPageListDataSrvc.do", method: 'post'}).submit();
            fnSetServiceNmCombo();
        }

        // 상세조회
        function fnDetail(trnsmit_server_no, data_no, srvc_nm) {
            $("#trnsmit_server_no").val(trnsmit_server_no);
            $("#data_no").val(data_no);
            $("#srvc_nm").val(srvc_nm);

            $("#pageList_currentPage").val($("#currentPage").val());
            $("#pageList_sch_row_per_page").val($("#sch_row_per_page").val());
            $("#currentPage").empty();
            $("#sch_row_per_page").empty();

            $("#aform").attr({action: "/data/service/selectPage1.do", method: 'post'}).submit();
        }

        // 상위분류 콤보
        function fnSetHRankCombo() {
            var req = {
                "group_id": "R010250"
            };

            jQuery.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/common/selectCodeListAjax.do',
                data: req,
                success: function (param) {

                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    var html = '<option value="">서비스 상위분류</option>';
                    var sel = "";
                    if (param.resultStats.resultList.length > 0) {

                        for (i = 0; i < param.resultStats.resultList.length; i++) {
                            sel = "";
                            if (param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_hrank_code")%>") {
                                sel = 'selected="selected"';
                            }
                            html += '<option value="' + param.resultStats.resultList[i].CODE + '" ' + sel + '>' + param.resultStats.resultList[i].CODE_NM + '</option>';

                        }
                    }

                    $("#sch_srvc_hrank_code").html(html);

                    fnSetLRankCombo();
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
        }

        // 하위분류 콤보
        function fnSetLRankCombo() {
            var req = {
                "group_id": "R010260"
                , "attrb_1": $("#sch_srvc_hrank_code").val()
            };

            var html = "";

            if ($("#sch_srvc_hrank_code").val() == "") {
                html += '<option value="">서비스 하위분류</option>';
                $("#sch_srvc_lrank_code").html(html);
                $("#sch_srvc_lrank_code").attr("disabled", true);

                fnSetServiceNmCombo();
            } else {

                jQuery.ajax({
                    type: 'POST',
                    dataType: 'json',
                    url: '/common/selectCodeListAjax.do',
                    data: req,
                    success: function (param) {

                        if (param.resultStats.resultCode == "error") {
                            alert(param.resultStats.resultMsg);
                            return;
                        }

                        var sel = "";
                        html += '<option value="">서비스 하위분류</option>';
                        if (param.resultStats.resultList.length > 0) {

                            for (i = 0; i < param.resultStats.resultList.length; i++) {

                                sel = "";
                                if (param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_lrank_code")%>") {
                                    sel = 'selected="selected"';
                                }
                                html += '<option value="' + param.resultStats.resultList[i].CODE + '" ' + sel + '>' + param.resultStats.resultList[i].CODE_NM + '</option>';

                            }
                        }
                        $("#sch_srvc_lrank_code").html(html);
                        $("#sch_srvc_lrank_code").attr("disabled", false);

                        fnSetServiceNmCombo();
                    },
                    error: function (jqXHR, textStatus, thrownError) {
                        ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                    }
                });
            }
        }

        //서비스명 콤보
        function fnSetServiceNmCombo() {
            var req = {
                "menu_code": "dataSrvc"
                , "sch_srvc_hrank_code": $("#sch_srvc_hrank_code").val()
                , "sch_srvc_lrank_code": $("#sch_srvc_lrank_code").val()
                , "sch_organ_code": $("#sch_organ_code").val()
            };

            var html = "";

            jQuery.ajax({
                type: 'POST',
                dataType: 'json',
                url: '/common/selectListServiceNmAjax.do',
                data: req,
                success: function (param) {

                    if (param.resultStats.resultCode == "error") {
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    var sel = "";
                    html += '<option value="">서비스 명</option>';
                    if (param.resultStats.resultList.length > 0) {

                        for (i = 0; i < param.resultStats.resultList.length; i++) {

                            sel = "";
                            if (param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_nm")%>") {
                                sel = 'selected="selected"';
                            }
                            html += '<option value="' + param.resultStats.resultList[i].CODE + '" ' + sel + '>' + param.resultStats.resultList[i].CODE_NM + '</option>';
                        }
                    }
                    $("#sch_srvc_nm").html(html);
                },
                error: function (jqXHR, textStatus, thrownError) {
                    ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
                }
            });
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
            <h1>서비스 데이터</h1>
            <small>S-DoT 센서 데이터를 수집하는 서비스에 대한 상세 정보를 제공합니다.</small>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" action="/admin/user/selectPageListUserMgt.do">
                        <input type="hidden" id="pageList_currentPage" name="pageList_currentPage"/>
                        <input type="hidden" id="pageList_sch_row_per_page" name="pageList_sch_row_per_page"/>
                        <input type="hidden" id="trnsmit_server_no" name="trnsmit_server_no"/>
                        <input type="hidden" id="data_no" name="data_no"/>
                        <input type="hidden" id="srvc_nm" name="srvc_nm"/>

                        <div class="box box-success">
                            <div class="box-body">
                                <div class="text-right form-inline">
                                    <!--  기관 구분 -->
                                    <div class="form-group">
                                        <select id="sch_organ_code" name="sch_organ_code" class="form-control input-sm"
                                                width>
                                            <%=CommboUtil.getComboStr(organSeComboStr, "CODE", "CODE_NM", param.getString("sch_organ_code"), "기관")%>
                                        </select>
                                    </div>
                                    <%-- 서비스 상위분류 --%>
                                    <div class="form-group">
                                        <select id="sch_srvc_hrank_code" name="sch_srvc_hrank_code"
                                                class="form-control input-sm"
                                                onchange="fnSetLRankCombo(<%=param.getString("sch_srvc_hrank_code")%>);"></select>
                                    </div>
                                    <%-- 서비스 하위분류 --%>
                                    <div class="form-group">
                                        <select id="sch_srvc_lrank_code" name="sch_srvc_lrank_code"
                                                class="form-control input-sm"
                                                onchange="fnSetServiceNmCombo();"></select>
                                    </div>

                                    <!--서비스 명콤보 -->
                                    <div class="form-group">
                                        <select id="sch_srvc_nm" name="sch_srvc_nm"
                                                class="form-control input-sm"></select>
                                    </div>
                                    <div class="form-group">
                                        <!--센서 구분-->
                                        <select id="sch_senser_code" name="sch_senser_code"
                                                class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(senserSeComboStr, "CODE", "CODE_NM", param.getString("sch_senser_code"), "센서 구분")%>
                                        </select>
                                    </div>
                                    <%-- 서비스 상태 --%>
                                    <div class="form-group">
                                        <select id="sch_srvc_status" name="sch_srvc_status"
                                                class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(srvcStatusComboStr, "CODE", "CODE_NM", param.getString("sch_srvc_status"), "서비스 상태")%>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <input type="text" class="form-control input-sm" id="sch_srvc_nm2"
                                                   name="sch_srvc_nm2" placeholder="서비스 명 직접 입력"
                                                   onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                                   value="<%=param.getString("sch_srvc_nm2")%>"/>
                                            <div class="input-group-btn">
                                                <button type="button" class="btn btn-sm btn-default"
                                                        onclick="fnSearch(); return false;"><i class="fa fa-search"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div><!-- /.box-header -->
                        </div>
                        <div class="box">
                            <div class="box-body">
                                <table class="table table-bordered table-hover">
                                    <tbody>
                                    <tr>
                                        <th style="width: 80px">번호</th>
                                        <th style="width: 8%;" colspan="2">서비스 분류</th>
                                        <th style="width: 8%;">기관 명</th>
                                        <th style="width: auto;">서비스 명</th>
                                        <th style="width: 8%;">센서 구분</th>
                                        <th style="width: 5%;">설치 수</th>
                                        <th style="width: 8%;">누적 데이터 수</th>
                                        <th style="width: 8%;">서비스 상태</th>
                                        <th style="width: 8%;">등록일자</th>
                                    </tr>
                                    <c:set value="${pageNavigationVo.getCurrDataNo()}" var="dataNo"/>
                                    <c:choose>
                                        <c:when test="${resultList.size() == 0}">
                                            <tr>
                                                <td class="text-center" colspan="10"><spring:message
                                                        code="msg.data.empty"/></td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="resultSet" items="${resultList}" varStatus="status">
                                                <tr>
                                                    <td class="txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${dataNo - status.index} </td>
                                                    <td class="txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.HRANK_NM} </td>
                                                    <td class="txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.LRANK_NM} </td>
                                                    <td class="txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.ORGAN_NM} </td>
                                                    <td class="td-text-left txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.SRVC_NM} </td>
                                                    <td class="txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.SENSOR_SE_NM} </td>
                                                    <td class="txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.MODL_INSTL_CNT} </td>
                                                    <td class="txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">
                                                        <fmt:formatNumber type="number" maxFractionDigits="3"
                                                                          value="${resultSet.DATA_CNT}"/>
                                                    </td>
                                                    <td class="txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.SRVC_STATUS_NM} </td>
                                                    <td class="txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}', '${resultSet.DATA_NO}', '${resultSet.SRVC_NM}')">${resultSet.REGIST_YMD} </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
                                <div class="pull-left form-inline">
                                    <select id="sch_row_per_page" name="sch_row_per_page" class="form-control input-sm">
                                        <%=CommboUtil.getComboStr(rowPerPageComboStr, "CODE", "CODE_NM", param.getString("sch_row_per_page"), "")%>
                                    </select>
                                </div>
                                ${navigationBar}
                            </div>
                        </div>
                    </form>
                </div><!-- /.col-xs-12 -->
            </div><!--  /.row -->
        </section><!-- /.content -->
    </div><!-- ./row -->

</div><!-- /.content-wrapper -->

<!-- footer -->
<%@ include file="/common/inc/footer.jspf" %>
<!-- //fooer -->

</div><!-- ./wrapper -->
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
