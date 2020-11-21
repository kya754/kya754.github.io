<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="organComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="srvcStatusComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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
            //콤보 생성
            // fnSetLClassCombo();
            // 상, 하위 분류 콤보 생성
            fnSetHRankCombo();

            //기관 셀렉트 박스 변경시 조회
            $("#sch_organ_code").change(function () {
                fnSearch();
            });
            // 서비스 명 셀렉트 박스 변경시 조회
            $("#sch_srvc_nm").change(function () {
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

        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/iot/srvcInfo/selectPageListSrvcInfo.do", method: 'post'}).submit();
        }

        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/iot/srvcInfo/selectPageListSrvcInfo.do", method: 'post'}).submit();
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
                "menu_code": "seCode"
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

        /*
        //대분류 콤보
        function fnSetLClassCombo(){
            var req ={
                "group_id" : "R010090"
            };

            jQuery.ajax( {
                type : 'POST',
                dataType : 'json',
                url : '/common/selectCodeListAjax.do',
                data : req,
                success : function(param) {

                    if(param.resultStats.resultCode == "error"){
                        alert(param.resultStats.resultMsg);
                        return;
                    }

                    var html = '<option value="">서비스 대분류</option>';
                    var sel = "";
                    if(param.resultStats.resultList.length > 0){

                        for(i = 0; i < param.resultStats.resultList.length; i++){
                            sel = "";
                            if(param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_lclas_code")%>"){
								sel = 'selected="selected"';
							}
							html += '<option value="'+param.resultStats.resultList[i].CODE+'" '+sel+'>'+param.resultStats.resultList[i].CODE_NM+'</option>';

						}
					}

					$("#sch_srvc_lclas_code").html(html);

					fnSetMClassCombo();
				},
				error : function(jqXHR, textStatus, thrownError){
					ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
				}
			});
		}

		//중분류 콤보
		function fnSetMClassCombo(){
			var req ={
				"group_id" : "R010100"
				,"attrb_1" : $("#sch_srvc_lclas_code").val()
			};

			var html = "";

			if($("#sch_srvc_lclas_code").val() == ""){
				html += '<option value="">서비스 중분류</option>';
				$("#sch_srvc_mclas_code").html(html);
				$("#sch_srvc_mclas_code").attr("disabled", true);
				fnSetSClassCombo();
			}
			else{

				jQuery.ajax( {
					type : 'POST',
					dataType : 'json',
					url : '/common/selectCodeListAjax.do',
					data : req,
					success : function(param) {

						if(param.resultStats.resultCode == "error"){
							alert(param.resultStats.resultMsg);
							return;
						}

						var sel = "";
						html += '<option value="">서비스 중분류</option>';
						if(param.resultStats.resultList.length > 0){

							for(i = 0; i < param.resultStats.resultList.length; i++){

								sel = "";
								if(param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_mclas_code")%>"){
									sel = 'selected="selected"';
								}
								html += '<option value="'+param.resultStats.resultList[i].CODE+'" '+sel+'>'+param.resultStats.resultList[i].CODE_NM+'</option>';

							}
						}
						$("#sch_srvc_mclas_code").html(html);
						$("#sch_srvc_mclas_code").attr("disabled", false);
						fnSetSClassCombo();
					},
					error : function(jqXHR, textStatus, thrownError){
						ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
					}
				});
			}
		}

		//소분류 콤보
		function fnSetSClassCombo(){
			var req ={
				"group_id" : "R010110"
				,"attrb_2" : $("#sch_srvc_mclas_code").val()
			};

			var html = "";

			if($("#sch_srvc_mclas_code").val() == ""){
				html += '<option value="">서비스 소분류</option>';
				$("#sch_srvc_sclas_code").html(html);
				$("#sch_srvc_sclas_code").attr("disabled", true);

				fnSetServiceNmCombo();
			}
			else{

				jQuery.ajax( {
					type : 'POST',
					dataType : 'json',
					url : '/common/selectCodeListAjax.do',
					data : req,
					success : function(param) {

						if(param.resultStats.resultCode == "error"){
							alert(param.resultStats.resultMsg);
							return;
						}

						var sel = "";
						html += '<option value="">서비스 소분류</option>';
						if(param.resultStats.resultList.length > 0){

							for(i = 0; i < param.resultStats.resultList.length; i++){

								sel = "";
								if(param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_sclas_code")%>"){
									sel = 'selected="selected"';
								}
								html += '<option value="'+param.resultStats.resultList[i].CODE+'" '+sel+'>'+param.resultStats.resultList[i].CODE_NM+'</option>';

							}
						}
						$("#sch_srvc_sclas_code").html(html);
						$("#sch_srvc_sclas_code").attr("disabled", false);

						fnSetServiceNmCombo();
					},
					error : function(jqXHR, textStatus, thrownError){
						ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
					}
				});
			}
		}

		//서비스명 콤보
		function fnSetServiceNmCombo(){
			var req ={
				 "sch_srvc_lclas_code" : $("#sch_srvc_lclas_code").val()
				,"sch_srvc_mclas_code" : $("#sch_srvc_mclas_code").val()
				,"sch_srvc_sclas_code" : $("#sch_srvc_sclas_code").val()
				,"organ_code" : <%=param.getString("ss_organ_code")%>
			};

			var html = "";

			jQuery.ajax( {
				type : 'POST',
				dataType : 'json',
				url : '/common/selectListServiceNmAjax.do',
				data : req,
				success : function(param) {

					if(param.resultStats.resultCode == "error"){
						alert(param.resultStats.resultMsg);
						return;
					}

					var sel = "";
					html += '<option value="">서비스 명</option>';
					if(param.resultStats.resultList.length > 0){

						for(i = 0; i < param.resultStats.resultList.length; i++){

							sel = "";
							if(param.resultStats.resultList[i].CODE == "<%=param.getString("sch_svc_nm")%>"){
								sel = 'selected="selected"';
							}
							html += '<option value="'+param.resultStats.resultList[i].CODE+'" '+sel+'>'+param.resultStats.resultList[i].CODE_NM+'</option>';
						}
					}
					$("#sch_svc_nm").html(html);
				},
				error : function(jqXHR, textStatus, thrownError){
					ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
				}
			});
		}
		*/

        // 서비스별 상세 이동
        function fnDetail(trnsmit_server_no, data_no, organ_code, srvc_nm) {
            $("[name=trnsmit_server_no]").val(trnsmit_server_no);
            $("[name=data_no]").val(data_no);
            $("[name=organ_code]").val(organ_code);
            $("[name=srvc_nm]").val(srvc_nm);
            $("[name=p_srvc_nm]").val(srvc_nm);

            $("#pageList_sch_srvc_hrank_code").val($("#sch_srvc_hrank_code").val());
            $("#pageList_sch_srvc_lrank_code").val($("#sch_srvc_lrank_code").val());
            $("#pageList_currentPage").val($("#currentPage").val());
            $("#sch_srvc_hrank_code").empty();
            $("#sch_srvc_lrank_code").empty();
            $("#currentPage").empty();

            $("#aform").attr({
                action: "/iot/srvcInfo/saveFormSrvcInfoStep1.do"
                , method: 'post'
            }).submit();
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
            <h1>나의 정보 관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <!-- content 영역 -->
                    <form id="aform" method="post" action="iot/srvcInfo/selectPageListSrvcInfo.do">
                        <input type="hidden" id="pageList_currentPage" name="pageList_currentPage"/>
                        <input type="hidden" id="pageList_sch_srvc_hrank_code" name="pageList_sch_srvc_hrank_code"/>
                        <input type="hidden" id="pageList_sch_srvc_lrank_code" name="pageList_sch_srvc_lrank_code"/>
                        <input type="hidden" name="trnsmit_server_no">
                        <input type="hidden" name="data_no">
                        <input type="hidden" name="organ_code">
                        <input type="hidden" name="srvc_nm">
                        <input type="hidden" name="p_srvc_nm">

                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <!--  기관 구분 -->
                                    <div class="form-group">
                                        <c:if test="${comboYn eq 'Y'}">
                                            <select class="form-control input-sm" id="sch_organ_code"
                                                    name="sch_organ_code">
                                                <%=CommboUtil.getComboStr(organComboStr, "CODE", "CODE_NM", param.getString("sch_organ_code"), "기관")%>
                                            </select>
                                        </c:if>
                                    </div>
                                    <%-- 서비스 상위분류 --%>
                                    <div class="form-group">
                                        <select id="sch_srvc_hrank_code" name="sch_srvc_hrank_code"
                                                class="form-control input-sm" onchange="fnSetLRankCombo();"></select>
                                    </div>
                                    <%-- 서비스 하위분류 --%>
                                    <div class="form-group">
                                        <select id="sch_srvc_lrank_code" name="sch_srvc_lrank_code"
                                                class="form-control input-sm"
                                                onchange="fnSetServiceNmCombo();"></select>
                                    </div>
                                    <%--
                                    <div class="form-group">
                                    <!--서비스 대분류 -->
                                        <select id="sch_srvc_lclas_code" name="sch_srvc_lclas_code" class="form-control input-sm" onchange="fnSetMClassCombo();">
                                        </select>
                                    </div>
                                    <div class="form-group">
                                    <!--서비스 중분류-->
                                        <select id="sch_srvc_mclas_code" name="sch_srvc_mclas_code" class="form-control input-sm" onchange="fnSetSClassCombo();">
                                        </select>
                                    </div>
                                    <div class="form-group">
                                    <!--서비스 소분류-->
                                        <select id="sch_srvc_sclas_code" name="sch_srvc_sclas_code" class="form-control input-sm" onchange="fnSetServiceNmCombo();">
                                        </select>
                                    </div>
                                     --%>
                                    <div class="form-group">
                                        <!--서비스 명콤보 -->
                                        <select id="sch_srvc_nm" name="sch_srvc_nm" class="form-control input-sm">
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
                            <div class="box-body no-pad-top table-responsive">
                                <table class="table table-bordered table-hover">
                                    <colgroup>
                                        <col width="80px"/>
                                        <col width="10%"/>
                                        <col width="10%"/>
                                        <col width="10%"/>
                                        <col width="*"/>
                                        <col width="10%"/>
                                        <col width="15%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center">번호</th>
                                        <th colspan="2" class="text-center">서비스 분류</th>
                                        <th class="text-center">기관 명</th>
                                        <th class="text-center">서비스 명</th>
                                        <th class="text-center">서비스 상태</th>
                                        <th class="text-center">등록일시</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="data" items="${resultList}" varStatus="status">
                                        <tr style="cursor:pointer;cursor:hand;">
                                            <td class="text-center">
                                                <c:out value="${pageNavigationVo.totalCount - (pageNavigationVo.currentPage-1) * pageNavigationVo.rowPerPage - status.index}"/>
                                            </td>
                                            <td class="text-center"
                                                onclick="fnDetail('${data.TRNSMIT_SERVER_NO}', '${data.DATA_NO}', '${data.ORGAN_CODE}','${data.SRVC_NM}')">${data.SRVC_HRANK_NM}</td>
                                            <td class="text-center"
                                                onclick="fnDetail('${data.TRNSMIT_SERVER_NO}', '${data.DATA_NO}', '${data.ORGAN_CODE}','${data.SRVC_NM}')">${data.SRVC_LRANK_NM}</td>
                                            <td class="text-center"
                                                onclick="fnDetail('${data.TRNSMIT_SERVER_NO}', '${data.DATA_NO}', '${data.ORGAN_CODE}','${data.SRVC_NM}')">${data.ORGAN_NM}</td>
                                            <td onclick="fnDetail('${data.TRNSMIT_SERVER_NO}', '${data.DATA_NO}', '${data.ORGAN_CODE}','${data.SRVC_NM}')"> ${data.SRVC_NM}</td>
                                            <td class="text-center"
                                                onclick="fnDetail('${data.TRNSMIT_SERVER_NO}', '${data.DATA_NO}', '${data.ORGAN_CODE}','${data.SRVC_NM}')">${data.SRVC_STATUS_NM}</td>
                                            <td class="text-center"
                                                onclick="fnDetail('${data.TRNSMIT_SERVER_NO}', '${data.DATA_NO}', '${data.ORGAN_CODE}','${data.SRVC_NM}')">${data.REGIST_DT}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${fn:length(resultList) == 0}">
                                        <tr>
                                            <td class="text-center" colspan="7"><spring:message
                                                    code="msg.data.empty"/></td>
                                        </tr>
                                    </c:if>
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
                                ${navigationBar}
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
