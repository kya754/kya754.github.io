<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="resultMap" class="egovframework.framework.common.object.DataMap" scope="request"/>

<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>
    <script type="text/javascript">
        //<![CDATA[

        $(function () {

        });

        function fnGoUpdate() {
            if ($("[name=postpne_pd]").val() == "") {
                alert("데이터 제공 유예 기간을 입력해 주세요.");
                return;
            }

            if ($("[name=postpne_pd]").val() > 365) {
                alert("데이터 제공 유예 최대 기간을 365일을 초과했습니다.");
                return;
            }

            if (confirm("데이터 제공 유예기간을 수정하시겠습니까?")) {
                $("#aform").attr({action: "/admin/provd/updateProvdPostpnePd.do", method: 'post'}).submit();
            }
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
            <h1>데이터 제공 관리</h1>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform">
                        <div class="box box-primary">
                            <div class="box-body no-padding"><br>
                                <h4 class="text-center"> 현재 데이터 제공 유예 기간은
                                    <b><%=resultMap.getString("PROVD_POSTPNE_PD")%>일 </b> 입니다. </h4> <br>
                            </div><!-- /.box-body -->
                        </div><!-- /.box -->

                        <div class="box box-primary">
                            <div class="box-header">
                                <h3 class="box-title">
                                    <i class="fa fa-fw fa-info-circle"></i> 데이터 제공 유예 기간 설정
                                </h3>
                            </div><!-- /.box-header -->
                            <div class="box-body no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col style="width:15%;">
                                        <col style="width:*;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="text-center">
                                            데이터 제공 유예 기간
                                        </th>
                                        <td>
                                            <input type="text" name="postpne_pd" class="form-control numeric"
                                                   value='<%=resultMap.getString("PROVD_POSTPNE_PD")%>'
                                                   style="display:inline-block; width:150px">
                                            일
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-info" onclick="fnGoUpdate(); return false;"><i
                                            class="fa fa-pencil"></i> 저장
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
