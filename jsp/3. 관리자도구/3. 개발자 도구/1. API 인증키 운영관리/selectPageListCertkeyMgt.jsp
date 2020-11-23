<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="organSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="lclasSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="mclasSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="sclasSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="senserSeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="certkeyStatusComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
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
            //콤보 생성
            // fnSetLClassCombo();
            fnSetHRankCombo();			// 상, 하위 분류 콤보 생성

            // 기관, 서비스명 셀렉트 박스 변경시 조회
            $('[name=sch_organ_code], [name=sch_srvc_nm], [name=sch_senser_code], [name=sch_certkey_status_code], [name=sch_row_per_page]').change(function () {
                fnSearch();
            });
        });

        // 페이지 이동
        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/iot/certkey/selectPageListCertKey.do", method: 'post'}).submit();
        }

        // 서버 저장 폼 이동
        function fnInsertForm() {
            document.location.href = "/iot/certkey/saveFormCertKeyStep0.do";
        }

        // 상세조회
        function fnDetail(seq_no) {
            $("#trnsmit_server_no").val(seq_no);

            $("#pageList_currentPage").val($("#currentPage").val());
            $("#pageList_sch_srvc_hrank_code").val($("#sch_srvc_hrank_code").val());
            $("#pageList_sch_srvc_lrank_code").val($("#sch_srvc_lrank_code").val());
            $("#currentPage").empty();
            $("#sch_srvc_hrank_code").empty();
            $("#sch_srvc_lrank_code").empty();

            $("#aform").attr({action: "/iot/certkey/saveFormCertKeyStep0.do", method: 'post'}).submit();
        }

        //삭제
        function fnDelete() {
            var delTrnsmitServerNoList = f_getList("del_trnsmit_server_no");
            var chkFag = false;

            for (i = 0; i < delTrnsmitServerNoList.length; i++) {
                if (delTrnsmitServerNoList[i].checked == true) {
                    chkFag = true;
                    break;
                }
            }

            if (chkFag == false) {
                alert("삭제할 송신 서버를 선택해 주세요.");
                return;
            }

            if (confirm("삭제하시겠습니까?")) {
                $("#aform").attr({action: "/iot/certkey/deleteServerMgt.do", method: 'post'}).submit();
            }
        }

        // 검색
        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/iot/certkey/selectPageListCertKey.do", method: 'get'}).submit();
            fnSetServiceNmCombo();
        }

        function fnExceldownload() {
            $("#aform").attr({action: "/iot/certkey/exceldownloadCertKey.do", method: 'post'}).submit();
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
                "sch_srvc_hrank_code": $("#sch_srvc_hrank_code").val()
                , "sch_srvc_lrank_code": $("#sch_srvc_lrank_code").val()
                , "sch_organ_code": $("#sch_organ_code").val()
                , "disp_yn": "ALL"
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
							if(param.resultStats.resultList[i].CODE == "<%=param.getString("sch_srvc_nm")%>"){
								sel = 'selected="selected"';
							}
							html += '<option value="'+param.resultStats.resultList[i].CODE+'" '+sel+'>'+param.resultStats.resultList[i].CODE_NM+'</option>';
						}
					}
					$("#sch_srvc_nm").html(html);
				},
				error : function(jqXHR, textStatus, thrownError){
					ajaxJsonErrorAlert(jqXHR, textStatus, thrownError)
				}
			});
		}
		*/
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
            <h1>인증키 관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post" action="/admin/user/selectPageListUserMgt.do">
                        <input type="hidden" id="pageList_currentPage" name="pageList_currentPage"/>
                        <input type="hidden" id="pageList_sch_srvc_hrank_code" name="pageList_sch_srvc_hrank_code"/>
                        <input type="hidden" id="pageList_sch_srvc_lrank_code" name="pageList_sch_srvc_lrank_code"/>
                        <input type="hidden" id="trnsmit_server_no" name="trnsmit_server_no"/>
                        <input type="hidden" id="organ_code" name="organ_code"/>

                        <div class="box box-primary">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <!--기관 구분 -->
                                    <div class="form-group">
                                        <select id="sch_organ_code" name="sch_organ_code" class="form-control input-sm"
                                                width>
                                            <%=CommboUtil.getComboStr(organSeComboStr, "CODE", "CODE_NM", param.getString("sch_organ_code"), "기관")%>
                                        </select>
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
                                    <!--서비스 대분류 -->
                                    <div class="form-group">
                                        <select id="sch_srvc_lclas_code" name="sch_srvc_lclas_code" class="form-control input-sm" onchange="fnSetMClassCombo();" ></select>
                                    </div>
                                    <!--서비스 중분류-->
                                    <div class="form-group">
                                        <select id="sch_srvc_mclas_code" name="sch_srvc_mclas_code" class="form-control input-sm" onchange="fnSetSClassCombo();"></select>
                                    </div>
                                    <!--서비스 소분류-->
                                    <div class="form-group">
                                        <select id="sch_srvc_sclas_code" name="sch_srvc_sclas_code" class="form-control input-sm" onchange="fnSetServiceNmCombo();"></select>
                                    </div>
                                     --%>
                                    <div class="form-group">
                                        <!--서비스 명콤보 -->
                                        <select id="sch_srvc_nm" name="sch_srvc_nm"
                                                class="form-control input-sm"></select>
                                    </div>
                                    <div class="form-group">
                                        <input type="text" class="form-control input-sm" id="sch_srvc_nm2"
                                               name="sch_srvc_nm2" placeholder="서비스 명 직접 입력"
                                               onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                               value="<%=param.getString("sch_srvc_nm2")%>"/>
                                    </div>
                                    <%--
                                    <div class="form-group">
                                        <input type="text" class="form-control input-sm" id="sch_data_num" name="sch_data_num" placeholder="데이터 번호" onKeydown="if(event.keyCode==13){fnSearch(); return false;}" value="<%=param.getString("sch_data_num")%>" />
                                        <input type="text" class="form-control input-sm" id="sch_model_nm" name="sch_model_nm" placeholder="모델 명" onKeydown="if(event.keyCode==13){fnSearch(); return false;}" value="<%=param.getString("sch_model_nm")%>" />
                                    </div>
                                    <!--센서 구분-->
                                    <div class="form-group">
                                        <select id="sch_senser_code" name="sch_senser_code" class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(senserSeComboStr, "CODE", "CODE_NM",param.getString("sch_senser_code"), "센서 구분")%>
                                        </select>
                                    </div>
                                    --%>
                                    <!--인증키 상태-->
                                    <div class="form-group">
                                        <select id="sch_certkey_status_code" name="sch_certkey_status_code"
                                                class="form-control input-sm">
                                            <%=CommboUtil.getComboStr(certkeyStatusComboStr, "CODE", "CODE_NM", param.getString("sch_certkey_status_code"), "인증키 상태")%>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <input type="text" class="form-control" id="sch_cert_key"
                                                   name="sch_cert_key" placeholder="인증키"
                                                   onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                                   value="<%=param.getString("sch_cert_key")%>"/>
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
                                <table class="table table-hover table-bordered">
                                    <colgroup>
                                        <col width="40"/>
                                        <col width="80"/>
                                        <col width="8%"/>
                                        <col width="8%"/>
                                        <col width="8%"/>
                                        <col width="*"/>
                                        <col width="*"/>
                                        <col width="8%"/>
                                        <col width="8%"/>
                                        <col width="10%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="text-center"></th>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">기관명</th>
                                        <th colspan="2" class="text-center">서비스 분류</th>
                                        <th class="text-center">담당 부서 명</th>
                                        <th class="text-center">서버 명</th>
                                        <th class="text-center">등록 제품 수</th>
                                        <th class="text-center">인증키 상태</th>
                                        <th class="text-center">등록일</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:set value="${pageNavigationVo.getCurrDataNo()}" var="dataNo"></c:set>
                                    <c:choose>
                                        <c:when test="${resultList.size() == 0}">
                                            <td class="text-center" colspan="8"><spring:message
                                                    code="msg.data.empty"/></td>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="resultSet" items="${resultList}" varStatus="status">
                                                <tr style="cursor:pointer;cursor:hand;">
                                                    <td class="text-center txt_overflow"><input type="checkbox"
                                                                                                name="del_trnsmit_server_no"
                                                                                                value="${resultSet.TRNSMIT_SERVER_NO}"/>
                                                    </td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}')">${dataNo - status.index} </td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}')">${resultSet.ORGAN_NM } </td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}')">${resultSet.SRVC_HRANK_NM } </td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}')">${resultSet.SRVC_LRANK_NM } </td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}')">${resultSet.CHRG_DEPT_NM } </td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}')">${resultSet.SERVER_NM } </td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}')">${resultSet.MODEL_REG_CNT } </td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}')">${resultSet.STTUS_NM}</td>
                                                    <td class="text-center txt_overflow"
                                                        onclick="fnDetail('${resultSet.TRNSMIT_SERVER_NO}')">${resultSet.REGIST_YMD}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
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
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-left">
                                    <button type="button" class="btn btn-info"
                                            onclick="fnExceldownload(); return false;"><i
                                            class="fa fa-file-excel-o"></i> 검색결과 엑셀 다운로드
                                    </button>
                                    <button type="button" class="btn bg-purple"
                                            onclick="document.location.href='/common/file/directFileDown.do?file_nm=인증키발급용_양식_Ver0.7.xlsx'">
                                        <i class="fa fa-file-excel-o"></i> 인증키 발급 양식 다운로드
                                    </button>
                                </div>
                                <div class="pull-right">
                                    <button type="button" class="btn btn-warning" onclick="fnDelete(); return false;"><i
                                            class="fa fa-trash"></i> 삭제
                                    </button>
                                    <button type="button" class="btn btn-info" onclick="fnInsertForm(); return false;">
                                        <i class="fa fa-pencil"></i> 인증키 발급
                                    </button>
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
