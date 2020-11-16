<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="egovframework.framework.common.object.DataMap" %>
<%@ page import="egovframework.framework.common.util.CommboUtil" %>

<jsp:useBean id="param" class="egovframework.framework.common.object.DataMap" scope="request"/>
<jsp:useBean id="pageNavigationVo" class="egovframework.framework.common.page.vo.pageNavigationVo" scope="request"/>
<jsp:useBean id="packeInstlList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="sensorInstList" type="java.util.List" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="rowPerPageComboStr" type="java.util.List" class="java.util.ArrayList" scope="request"/>

<%@ include file="/common/inc/common.jspf" %>
<%@ include file="/common/inc/docType.jspf" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/common/inc/meta.jspf" %>
    <title><%=headTitle%>
    </title>
    <%@ include file="/common/inc/cssScript.jspf" %>


    <!-- 지도 sdk -->
    <style type="text/css">

        #map {
            width: 100%;
            height: 100%;
        }
    </style>
    <!-- 서울맵 지도 SDK -->
    <link rel="stylesheet" type="text/css" href="https://map.seoul.go.kr/smgis/apps/mapsvr.do?cmd=gisMapCss">
    <script type="text/javascript"
            src="https://map.seoul.go.kr/smgis/apps/mapsvr.do?cmd=gisMapJs&key=6413fff343724983b9a0c343239f8654"></script>
    <script type="text/javascript" src="/common/js/map_api/seoul_map/api.js"></script>


    <script type="text/javascript">
        var marker = null;
        var map = null;

        //지도 설정
        var mapInit = function () {
            map = L.map('map', {
                continuousWorld: true
                , worldCopyJump: false
                , zoomControl: false
                , zoomAnimation: true
                , markerZoomAnimation: true
                , fadeAnimation: true
                , inertia: false
                , closePopupOnClick: true
                , attributionControl: true
            });

            map.setView([37.5683206, 126.9905207], 7);  //지도의 뷰를 좌표 이동,기본 뷰: 서울시청
            BaseMapChange(map, L.Dawul.BASEMAP_GEN);  // 지도의 종류를 일반지도로 지정

            // 스케일바
            var scaleBar = new L.Control.Scale({position: 'bottomright'});
            map.addControl(scaleBar);
        };


        $(document).ready(function () {
            mapInit();	//지도 호출
            map.on('Click', function () {
                map.removeLayer(marker1);
            });

            <c:choose>
            <c:when test="${sensorInstList.size() == 0}">
            $("#fnSerial").attr('onclick', '').unbind('click');
            alert("등록된 위도, 경도가 없거나 표시할수 없는 정보입니다.");
            </c:when>
            <c:otherwise>
            <c:forEach var="resultSet" items="${sensorInstList}" varStatus="status">
            //마커 찍기
            setPoint('${resultSet.LO_MAP}', '${resultSet.LA_MAP}', '${resultSet.SERIAL_GROUP}', '${resultSet.MESURE_IEM}', '${resultSet.LAST_RECPTN_DT}');
            //마지막 마커에 뷰 포커스
            <c:if test="${status.last}">
            map.setView(['${resultSet.LA_MAP}', '${resultSet.LO_MAP}'], 8);
            </c:if>
            </c:forEach>
            </c:otherwise>
            </c:choose>
        });


        //마커 찍는 함수
        //파라미터 : 경도 , 위도, 관리번호값, 측정 항목, 최종수신시간
        function setPoint(y, x, modl_serial, iem, time) {
            marker = new L.Marker(new L.LatLng(x, y), {
                icon: new L.Icon(
                    {   // 마커 찍기
                        iconUrl: "/common/images/img-map-pin-default.png",   //핀 이미지
                        iconAnchor: [15, 31]  // 오프셋 (핀의 끝이 좌표로 매칭하기 위해 적용)
                    })
            }).addTo(map);

            var t_data = "<b><div class='tooltip_col'>관리번호 </div>: " + modl_serial + "</b><br/>"
                + "<div class='tooltip_col'>측정항목 : </div>" + iem + "<br/>"
                + "<div class='tooltip_col'>마지막 수신 일시  : </div>" + time + "<br/>"
                + "<div class='tooltip_col'>위도 : </div>" + x + " / <div class='tooltip_col'>경도 : </div>" + y;

            marker.bindPopup(mkContent(t_data), {
                offset: [0, -30],          //오프셋
                keepInView: false,      //팝업이 열려 있는동안 지도 벗어나게 이동 막기
                autoPan: true,          //팝업창이 지도에서 안보일시 보이는 위치까지 자동 지도 이동
                closeButton: true      //팝업 닫기 버튼 유,무
            });

            marker.on('popupclose', function () {	//마커 팝업 클로즈일 경우
                map.setView([x, y], 7);
                map.removeLayer(marker1);
            });

            marker.on('popupopen', function () {		//마커 팝업 오픈일 경우
                marker1 = new L.Marker(new L.LatLng(x, y), {
                    icon: new L.Icon({   // 마커 찍기
                        iconUrl: "/common/images/img-map-pin-on.png",   //핀 이미지
                        iconAnchor: [15, 35]  // 오프셋 (핀의 끝이 좌표로 매칭하기 위해 적용)
                    })
                }).addTo(map);
                map.setView([x, y], 10);
            });
        }

        /////////////////////////////////////////////////////////////////////////////////////////////

        //<![CDATA[
        $(function () {
            $("#currentPage").val("1");
            // 목록 수 셀렉트 박스 변경시 조회
            $("#sch_row_per_page_2").change(function () {
                fnSearch();
            })
        });

        // 페이지 이동
        function fnGoPage(currentPage) {
            $("#currentPage").val(currentPage);
            $("#aform").attr({action: "/data/service/selectPage2.do", method: 'post'}).submit();
        }

        // 목록으로 이동
        function fnList() {
            if ($("#currentPage").val() == null) {
                var hiddenHtml = "";
                hiddenHtml += '<input type="hidden" id="currentPage" name="currentPage" />';
                $('#aform').append(hiddenHtml);
            }

            $("#currentPage").val($("#pageList_currentPage").val());
            $("#sch_row_per_page").val($("#pageList_sch_row_per_page").val());
            $("#aform").attr({action: "/data/service/selectPageListDataSrvc.do", method: 'post'}).submit();
        }

        //기본 정보 엑셀 다운로드
        function fnExceldownload() {
            $("#aform").attr({action: "/data/service/exceldownloadPage2.do", method: 'post'}).submit();
        }

        // 검색
        function fnSearch() {
            $("#currentPage").val("1");
            $("#aform").attr({action: "/data/service/selectPage2.do", method: 'post'}).submit();
        }

        //아래 표에서 시리얼 넘버를 클릭했을시 발생하는 이벤트
        function fnSerialClick(la, lo, modl_serial, iem, time) {

            if (la != 0 && lo != 0) {
                marker1 = new L.Marker(new L.LatLng(la, lo), {
                    icon: new L.Icon({   // 마커 찍기
                        iconUrl: "/common/images/img-map-pin-on.png",   //핀 이미지
                        iconAnchor: [13, 34]  // 오프셋 (핀의 끝이 좌표로 매칭하기 위해 적용)
                    })
                }).addTo(map);

                var t_data = "<b><div class='tooltip_col'>관리번호 </div>: " + modl_serial + "</b><br/>"
                    + "<div class='tooltip_col'>측정항목 : </div>" + iem + "<br/>"
                    + "<div class='tooltip_col'>마지막 수신 일시  </div>: " + time + "<br/>"
                    + "<div class='tooltip_col'>위도 </div>: " + la + " / <div class='tooltip_col'>경도 </div>: " + lo + "<br/>";

                marker1.bindPopup(mkContent(t_data), {
                    offset: [0, -30],          //오프셋
                    keepInView: false,      //팝업이 열려 있는동안 지도 벗어나게 이동 막기
                    autoPan: true,          //팝업창이 지도에서 안보일시 보이는 위치까지 자동 지도 이동
                    closeButton: true      //팝업 닫기 버튼 유,무
                });

                marker1.on('popupclose', function () {
                    map.setView([la, lo], 7);
                    map.removeLayer(marker1);
                });

                marker1.openPopup();
                map.setView([la, lo], 10);
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
            $(".content-header h1").append("(<%=param.getString("srvc_nm")%>)");
        });
    </script>

    <!-- content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>서비스 열람</h1>
        </section>
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form role="form" id="aform" method="post">
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

                        <%@ include file="/common/inc/dataSrvcTap.jspf" %>
                        <div class="box box-primary" style="height: 650px;">
                            <%-- 지도 들어갈 영역--%>
                            <div id="map"></div>
                        </div><!-- /.box -->
                        <div class="box box-primary map-search">
                            <div class="box-header">
                                <div class="text-right form-inline">
                                    <input type="text" class="form-control input-sm" id="sch_modl_serial"
                                           name="sch_modl_serial" placeholder="관리번호 직접 입력"
                                           onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                           value="<%=param.getString("sch_modl_serial")%>"/>
                                    <input type="text" class="form-control input-sm" id="sch_adres" name="sch_adres"
                                           placeholder="주소 직접 입력"
                                           onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                           value="<%=param.getString("sch_adres")%>"/>
                                    <input type="text" class="form-control input-sm" id="sch_la" name="sch_la"
                                           placeholder="위도 직접 입력"
                                           onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                           value="<%=param.getString("sch_la")%>"/>
                                    <input type="text" class="form-control input-sm" id="sch_lo" name="sch_lo"
                                           placeholder="경도 직접 입력"
                                           onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                           value="<%=param.getString("sch_lo")%>"/>
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <input type="text" class="form-control input-sm" id="sch_buld_nm"
                                                   name="sch_buld_nm" placeholder="건물명 직접 입력"
                                                   onKeydown="if(event.keyCode==13){fnSearch(); return false;}"
                                                   value="<%=param.getString("sch_buld_nm")%>"/>
                                            <div class="input-group-btn">
                                                <button type="button" class="btn btn-sm btn-default"
                                                        onclick="fnSearch(); return false;"><i class="fa fa-search"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div><!-- /.box-header -->
                            <div class="box-body table-responsive no-padding">
                                <table class="table table-bordered">
                                    <colgroup>
                                        <col width="50px;">
                                        <col width="135px;">
                                        <col width="80px;">
                                        <col width="200px;">
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
                                        <th class="text-center">관리번호</th>
                                        <th class="text-center">우편번호</th>
                                        <th class="text-left">주소</th>
                                        <th class="text-center">주소 상세</th>
                                        <th class="text-center">좌표 구분</th>
                                        <th class="text-center">위도</th>
                                        <th class="text-center">경도</th>
                                        <th class="text-center">고도(미터)</th>
                                        <th class="text-center">건물 명</th>
                                        <th class="text-center">설치 층</th>
                                        <th class="text-center">설치 호</th>
                                        <th class="text-center">사용 유무</th>
                                        <th class="text-center">비고</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:set value="${pageNavigationVo.getCurrDataNo()}" var="dataNo"></c:set>
                                    <c:forEach var="resultSet" items="${packeInstlList}" varStatus="status">
                                        <tr>
                                            <td class="text-center txt_overflow">${dataNo - status.index} </td>
                                            <td class="text-center" id="fnSerial" style="cursor:pointer;cursor:hand;"
                                                onClick="fnSerialClick('${resultSet.LA_MAP}','${resultSet.LO_MAP}', '${resultSet.MODL_SERIAL}','${resultSet.MESURE_IEM}','${resultSet.LAST_RECPTN_DT}');">${resultSet.MODL_SERIAL}</td>
                                            <td class="text-center">${resultSet.POST_NO}</td>
                                            <td>${resultSet.ADRES}</td>
                                            <td>${resultSet.ADRES_DETAIL}</td>
                                            <td class="text-center">${resultSet.CRDNT_CODE}</td>
                                            <td class="text-center">${resultSet.LA}</td>
                                            <td class="text-center">${resultSet.LO}</td>
                                            <td class="text-center">${resultSet.ANTCTY}</td>
                                            <td>${resultSet.BULD_NM}</td>
                                            <td class="text-center">${resultSet.INSTL_FLOOR}</td>
                                            <td class="text-center">${resultSet.INSTL_HO_NO}</td>
                                            <td class="text-center">${resultSet.USE_NM}</td>
                                            <td>${resultSet.RM}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix text-center">
                                <div class="pull-left form-inline">
                                    <select id="sch_row_per_page_2" name="sch_row_per_page_2"
                                            class="form-control input-sm">
                                        <%=CommboUtil.getComboStr(rowPerPageComboStr, "CODE", "CODE_NM", param.getString("sch_row_per_page_2"), "")%>
                                    </select>
                                </div>
                                ${navigationBar}
                            </div>
                            <div class="box-footer clearfix no-pad-top">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-default" onclick="fnList(); return false;"><i
                                            class="fa fa-reply"></i> 목록
                                    </button>
                                    <button type="button" class="btn btn-info"
                                            onclick="fnExceldownload(); return false;"><i
                                            class="fa fa-file-excel-o"></i> 설치 정보 엑셀 다운로드
                                    </button>
                                </div>
                            </div>
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
