<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="menuTypeComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="ynComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="parentMenuIdComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>

    <%-- 	<link rel="stylesheet" href="<%=jsRoot%>jsTree/themes/default/style.min.css" /> --%>
    <%-- 	<script src="<%=jsRoot%>jsTree/jstree.js"></script> --%>
    <%-- 	<script src="<%=jsRoot%>jsTree/jstree.state.js"></script> --%>
    <%-- 	<script src="<%=jsRoot%>jsTree/jstree.wholerow.js"></script> --%>
    <%-- 	<script src="<%=jsRoot%>jsTree/jstree.checkbox.js"></script> --%>

    <link rel="stylesheet" href="<%=jsRoot%>jsTree_new/themes/default/style.min.css"/>
    <script src="<%=jsRoot%>jsTree_new/jstree.min.js"></script>

    <script type="text/javascript">
        //<![CDATA[
        $(function () {
            $('#jstree').jstree({
                "core": {
                    "themes": {
                        "icons": false,
                    }
                },
                "checkbox": {
                    "keep_selected_style": false,
                    "whole_node": true,
                },
                "plugins": [
                    "wholerow", "checkbox"
                ]
            });

            $('#jstree').jstree("open_all");

            var checkboxCnt = $("input[name='menu_id']").length;

            for (i = 0; i < checkboxCnt; i++) {

                if ($("input[name='menu_id']").eq(i).prop("checked") == true) {

                    if ($("input[name='menu_id']").eq(i).parent().parent().find("input:checked").length == 1) {	//말단 객체만 클릭 이벤트 실행
                        $(".jstree-anchor").eq(i + 1).trigger('click');
                    }
                }
            }

            $("#id_resize").css("height", $(window).height() - 200);
            $(window).resize(function () {
                $("#id_resize").css("height", $(window).height() - 200);
            });

        });

        function fnSetCheckBox() {
            var checkboxCnt = $(".jstree-anchor").length;
            for (i = 0; i < checkboxCnt; i++) {

                if (i > 0 && $(".jstree-anchor").eq(i).hasClass("jstree-clicked") || $(".jstree-checkbox").eq(i).hasClass("jstree-undetermined")) {

                    $("input[name='menu_id']").eq(i - 1).prop("checked", true);
                } else {
                    $("input[name='menu_id']").eq(i - 1).prop("checked", false);
                }
            }
        }

        function fnInsert() {
            // 전체를 저장시에는 jstree가 접혀있을경우 하위 태그들을 삭제하기 때문에 모두 펼친후 저장하도록 한다.
            $('#jstree').jstree("open_all");

            fnSetCheckBox();

            /*
            var menuIdList = f_getList("menu_id");
            var menuIdNullYn = true;

            for(i = 0 ; i < menuIdList.length; i++){
                if(menuIdList[i].checked == true){
                    menuIdNullYn = false;
                    break;
                }
            }
            if(menuIdNullYn == true){
                alert("메뉴를 선택해 주세요.");
                return;
            }
            */

            if (confirm("등록하시겠습니까?")) {
                $("#aform").attr({action: "/admin/authmenu/insertAuthMenuMgt.do", method: 'post'}).submit();
            }
        }

        function fnList() {
            $("#aform").attr({action: "/admin/authmenu/selectPageListAuthMenuMgt.do", method: 'post'}).submit();
        }

        function fnSelectCheckbox(menuId) {

            if ($("#" + menuId).prop("checked") == true) {
                $("#" + menuId).prop("checked", false);
            } else {
                $("#" + menuId).prop("checked", true);
            }
        }

        function fnChageParentMenuId() {
            $("#aform").attr({action: "/admin/authmenu/selectListAuthMenuMgt.do", method: 'post'}).submit();
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
            <h1>권한별 메뉴관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <!-- content 영역 -->
            <form id="aform" method="post" action="/admin/auth/selectPageListAuthMenuMgt.do">
                <!--검색조건-->
                <input type="hidden" name="author_id" id="author_id" value="<%=param.getString("author_id")%>"/>
                <input type="hidden" name="sch_authmenu_nm" value="<%=param.getString("sch_authmenu_nm")%>"/>
                <!--페이징조건-->
                <input type="hidden" name="currentPage" value="<%=param.getString("currentPage")%>"/>
                <%-- pageList --%>
                <input type="hidden" id="sch_organ_code" name="sch_organ_code" value="${param.sch_organ_code}"/>
                <input type="hidden" id="sch_row_per_page" name="sch_row_per_page" value="${param.sch_row_per_page}"/>

                <div class="row">
                    <div class="col-lg-6">
                        <div id="id_resize" class="box box-primary" style="overflow-y: auto;">
                            <div class="box-body">
                                <div class="row">
                                    <div class="col-xs-6">
                                        <select name="sch_parent_menu_id" id="sch_parent_menu_id" class="form-control"
                                                onchange="fnChageParentMenuId();">
                                            <%=CommboUtil.getComboStr(parentMenuIdComboStr, "MENU_ID", "MENU_NM", param.getString("sch_parent_menu_id"), "")%>
                                        </select>
                                    </div>
                                    <div class="col-xs-6"></div>
                                </div>
                            </div>
                            <!-- 접기, 펼치기 -->
                            <!-- 좌측 메뉴 트리 -->
                            <div class="left_list" id="jstree">
                                <ul>
                                    <li>
                                            <%
											int dataCnt = resultList.size();
											int tagSumCnt = 0;
											int lvDept = 0;

											DataMap resutMap = new DataMap();
											DataMap oldResutMap = new DataMap();
											String chkStr = "";

											for(int i = 0; i < dataCnt; i++){

												chkStr = "";

												resutMap = (DataMap)resultList.get(i);

												if(resutMap.getString("AUTH_YN").equals("Y")){
													chkStr = "checked";
												}

												if(i == 0){
													out.println(resutMap.getString("MENU_NM"));
												}
												else{

													oldResutMap = (DataMap)resultList.get(i-1);

													if(oldResutMap.getInt("MENU_LEVEL") < resutMap.getInt("MENU_LEVEL")){	//하위레벨일경우

														out.print("<ul><li>");
														tagSumCnt++;
													}

													if(oldResutMap.getInt("MENU_LEVEL") == resutMap.getInt("MENU_LEVEL")){	//동레벨일경우

														out.print("</li><li>");
													}

													if(oldResutMap.getInt("MENU_LEVEL") > resutMap.getInt("MENU_LEVEL")){	//상위레벨일경우

														lvDept = oldResutMap.getInt("MENU_LEVEL") - resutMap.getInt("MENU_LEVEL");

														for(int k = 0; k < lvDept; k++){

															out.println("</li></ul>");
															tagSumCnt--;
														}

														out.println("<li>");
													}

													//if(!resutMap.getString("MENU_TYPE_CODE").equals("10")){
														out.println("<input type=\"checkbox\" class=\"hide\" name=\"menu_id\" id=\""+resutMap.getString("MENU_ID")+"\" value=\""+resutMap.getString("MENU_ID")+"\" "+chkStr+" /> ");
													//}
													//out.println("<span class=\"chArea\" onclick=\"fnSelectCheckbox('"+ resutMap.getString("MENU_ID")+"');return false;\">"+resutMap.getString("MENU_NM")+"</span>");
													out.println(resutMap.getString("MENU_NM"));
												}
											}

											for(int i = 0; i < tagSumCnt; i++){
												out.println("</li></ul>");
												tagSumCnt--;
											}
										%>
                            </div><!-- /.좌측 메뉴 트리 -->
                        </div><!-- /.box -->
                    </div><!-- /.col-lg-6 -->
                    <div class="col-lg-6">
                        <div class="box box-primary">
                            <div class="box-body">
                                <table class="table table-bordered" id="defaultTb">
                                    <caption></caption>
                                    <colgroup>
                                        <col style="width: 20%;">
                                        <col style="width: 80%;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>권한 ID</th>
                                        <td>
                                            <div class="outBox1">
                                                <%=param.getString("author_id")%>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>권한 명</th>
                                        <td>
                                            <div class="outBox1">
                                                <%=param.getString("AUTHOR_NM")%>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="box-body">
                                <button type="button" class="btn btn-default" onclick="fnList(); return false;">목록
                                </button>
                                <button type="button" class="btn btn-info" onclick="fnInsert(); return false;">확인
                                </button>
                            </div>
                        </div>
                    </div>
                    </ul>
            </form>
            <!-- content 영역 -->
        </section><!-- /.content -->
    </div><!-- /.content-wrapper -->

    <!-- footer -->
    <%@ include file="/common/inc/footer.jspf" %>
    <!-- //fooer -->

</div><!-- ./wrapper -->
</body>
</html>
<%@ include file="/common/inc/msg.jspf" %>
