var marker = null;    //마커 객체
var lineLayer = null;   //샘플 폴리라인 객체
var polygonLayer = null;   //샘플 폴리곤 객체

var circle = null;  //원 객체
var rectangle = null; //사각형 객체

var curOldMapMode = null; //고지도 상태
var curOpacity = 0.7;


var circleMarker1 = null;
var circleMarker2 = null;
var clickCircleLayer = null;
var centerPoint = null;
var point = null;


//마커 표현 및 툴팁 샘플
function setPoint() {
	mkClear();
	map.setView([ 37.5683206, 126.9905207 ], 10); //지도 위치 이동  (좌표, 지도 레벨)
	marker = new L.Marker(new L.LatLng(37.5683206, 127.9905207),{icon: new L.Icon({   // 마커 찍기
    	iconUrl: "../images/img-map-pin-on.png",   //핀 이미지
    	iconAnchor: [13,34]  // 오프셋 (핀의 끝이 좌표로 매칭하기 위해 적용)
    })}).addTo(map);
	var content = "툴팁내용";
	
	marker.bindPopup(mkContent(content),{
		maxWidth:20,          //가로 최대 크기
		offset:[0,-30],          //오프셋
		keepInView:false,      //팝업이 열려 있는동안 지도 벗어나게 이동 막기
		autoPan:true,          //팝업창이 지도에서 안보일시 보이는 위치까지 자동 지도 이동
		closeButton:false      //팝업 닫기 버튼 유,무
		//'className':'dawul'    //팝업 테두리 없애기  (팝업 기본 테두리를 없애시려면 추가  중요:dw_popup.css 추가 시켜줘야 함.  테두리 제거 css가 들어있음)
	});
	
	
	/*var aaa = new Array();
	for(var i=0; i<13; i++) {
		aaa.push("aaaa"+i);
	}
	marker.bindPopup(popupContents(aaa),{
		maxWidth:20,          //가로 최대 크기
		offset:[35,-15],          //오프셋
		keepInView:false,      //팝업이 열려 있는동안 지도 벗어나게 이동 막기
		autoPan:true,          //팝업창이 지도에서 안보일시 보이는 위치까지 자동 지도 이동
		closeButton:false,     //팝업 닫기 버튼 유,무
		'className':'dawul'    //팝업 테두리 없애기  (팝업 기본 테두리를 없애시려면 추가  중요:dw_popup.css 추가 시켜줘야 함.  테두리 제거 css가 들어있음)
	});*/
}

//마커 이미지 변경
function mkImgChange(mode) {
	if(marker!=null) {
		if(mode==1) {
			marker.setIcon(new L.Icon({
				iconUrl: "../images/img-map-pin-on.png",   //핀 이미지
				iconAnchor: [13,34],
		   }));
		}else if(mode==2) {
			marker.setIcon(new L.Icon({
				iconUrl: "../images/img-map-pin-default.png",   //핀 이미지
				iconAnchor: [13,34],
		   }));
		}
		marker.closePopup();
		var content = "툴팁내용";
		marker.bindPopup(mkContent(content),{minWidth:20,offset:[0,-30]});
		
		/*var aaa = new Array();
		for(var i=0; i<13; i++) {
			aaa.push("aaaa"+i);
		}
		marker.bindPopup(popupContents(aaa),{minWidth:20,offset:[0,-30]});*/
	}
}


//마커 툴팁 내용 샘플
function mkContent(content){
	html_ = "<p>"+content+"</p>";
	return html_;
}

//마커 삭제
function mkClear() {
	if(marker!=null) {
		map.removeLayer(marker);
		marker = null;
	}
}


//폴리라인 샘플
function polyline() {
	polylineClear();
	
	//폴리라인 json 구현
	var linedata = "";
	linedata = {};
	linedata.type="Feature";  //중요
	linedata.geometry={};
	linedata.geometry.type="LineString";  //  중요  타입(폴리라인 : LineString)
	linedata.geometry.coordinates=[];
	
	//샘플 폴리라인 좌표============
	var coordsX = new Array();
	var coordsY = new Array();
	
	coordsX.push(954908);
	coordsY.push(1952800.36);
	
	coordsX.push(955080);
	coordsY.push(1952764.36);
	
	coordsX.push(955272);
	coordsY.push(1952508.36);
	
	coordsX.push(955255);
	coordsY.push(1952280.36);
	
	coordsX.push(955300);
	coordsY.push(1952190.36);
	//=============================
	
	lineLayer = new L.GeoJSON(
			linedata, {
				style : function() {
					return {
						weight: 4,   //라인굵기
						color : "#0100FF",  // 라인컬러
						opacity : 1   //투명도
					};						
				}
			}).addTo(map);
	
	
	for(var i=0; i<coordsX.length; i++) {
		var geoWgs = Coord_Trans("utmktowgs", new PT(coordsX[i], coordsY[i]));  //위경도로 좌표 변환
		//var geoWgs = Coord_Trans("utmktowgs", new PT(coordsX[i], coordsY[i]));  //위경도로 좌표 변환
		//json 에 좌표 적용
		linedata.geometry.coordinates[i]=[];
		linedata.geometry.coordinates[i][0] = geoWgs.y;  //latitude
		linedata.geometry.coordinates[i][1] = geoWgs.x;  //longitude
	}
	
	//linedata 지도에 표현
	lineLayer = new L.GeoJSON(
		linedata, {
			style : function() {
				return {
					weight: 4,   //라인굵기
					color : "#0100FF",  // 라인컬러
					opacity : 1   //투명도
				};						
			}
		}).addTo(map);
	
	map.fitBounds(lineLayer.getBounds(),{ padding: [100, 100] });  // 레이어 크기만큼 지도 레벨조정및 위치이동
}

//폴리라인 색 변경
function polylineChange(mode) {
	if(lineLayer!=null) {
		if(mode==1) {
			lineLayer.setStyle({color:"#0100FF"});
		}else if(mode==2) {
			lineLayer.setStyle({color:"#FF0000"});
		}
	}
}

//폴리라인 삭제
function polylineClear() {
	if(lineLayer!=null) {
		map.removeLayer(lineLayer);
		lineLayer = null;
	}
}

//폴리곤 샘플
function polygon() {
	polygonClear();
	
	var polygondata = "";
	polygondata = {};
	polygondata.type="Feature";  //중요
	polygondata.geometry={};
	polygondata.geometry.type="Polygon";  //  중요  타입(폴리곤 : Polygon)
	polygondata.geometry.coordinates=[];
	
	//샘플 폴리곤 좌표============
	var coordsX = new Array();
	var coordsY = new Array();
	coordsX.push(955365);
	coordsY.push(1952653.36);
	
	coordsX.push(955526);
	coordsY.push(1952760.36);
	
	coordsX.push(955616);
	coordsY.push(1952586.36);
	
	coordsX.push(955616);
	coordsY.push(1952339.36);
	
	coordsX.push(955380);
	coordsY.push(1952365.36);
	//=============================
	polygondata.geometry.coordinates[0]=[];
	for(var i=0; i<coordsX.length; i++) {
		var geoWgs = Coord_Trans("utmktowgs", new PT(coordsX[i], coordsY[i]));  //위경도로 좌표 변환
		//json 에 좌표 적용
		polygondata.geometry.coordinates[0][i]=[];
		polygondata.geometry.coordinates[0][i][0] = geoWgs.y;  //latitude
		polygondata.geometry.coordinates[0][i][1] = geoWgs.x;  //longitude
	}
	
	polygonLayer = new L.GeoJSON(
		polygondata, {
			style : function() {
				return {
					weight: 4,   //라인굵기
					color : "#0100FF",  // 라인컬러
					opacity : 1,   //투명도
					fillColor : "#0100FF",  //폴리곤 내부 컬러
					fillOpacity : 0.5  //폴리곤 내부 투명도
				};						
			}
		}).addTo(map);
	
	map.fitBounds(polygonLayer.getBounds(),{ padding: [100, 100] });  // 레이어 크기만큼 지도 레벨조정및 위치이동
}

//폴리곤 색 변경
function polygonChange(mode) {
	if(polygonLayer!=null) {
		if(mode==1) {
			polygonLayer.setStyle({color:"#0100FF",fillColor : "#0100FF"});
		}else if(mode==2) {
			polygonLayer.setStyle({color:"#FF0000",fillColor : "#FF0000"});
		}
	}
}

//폴리곤 삭제
function polygonClear() {
	if(polygonLayer!=null) {
		map.removeLayer(polygonLayer);
		polygonLayer = null;
	}
}


//모든 마커,레이어 삭제 (초기화)
function allClear() {
	vMarkerClear();
	vLayerClear();
	mkClear();
	polygonClear();
	polylineClear();
	markersClear();
	layersClear();
}

//원 레이어
function circle1() {
	circleClear();
	circle = new L.Circle(
			map.getCenter(),100
	).addTo(map);
	circle.setStyle({
		weight: 2,
		color : "#0100FF",
		opacity : 1,
		fillColor : "#0100FF",
		fillOpacity : 0
	});
}

//원 레이어 삭제
function circleClear() {
	if(circle!=null) {
		map.removeLayer(circle);
		circle = null;
	}
}


//사각형 레이어
function rectangle1() {
	rectangleClear();
	var geoWgsSouthwest = Coord_Trans("utmktowgs", new PT(954920,1952271.36));  //위경도로 좌표 변환  (왼쪽 아래)
	var geoWgsNortheast = Coord_Trans("utmktowgs", new PT(955096,1952516.36));  //위경도로 좌표 변환  (오른쪽 위)
	var southwest = L.latLng(geoWgsSouthwest.y,geoWgsSouthwest.x);
	var northeast = L.latLng(geoWgsNortheast.y,geoWgsNortheast.x);
	var bounds = L.latLngBounds(southwest, northeast);
	rectangle = new L.rectangle(bounds).addTo(map);
	rectangle.setStyle({
		weight: 2,
		color : "#0100FF",
		opacity : 1,
		fillColor : "#0100FF",
		fillOpacity : 0
	});
}

//사각형 레이어 삭제
function rectangleClear() {
	if(rectangle!=null) {
		map.removeLayer(rectangle);
		rectangle = null;
	}
}


//클릭 원형 레이어
function clickCircle() {
	var p1 = Coord_Trans("wgstoutmk", new PT(centerPoint.lng, centerPoint.lat));
	var p2 = Coord_Trans("wgstoutmk", new PT(point.lng, point.lat));
	var dist = Math.sqrt(Math.pow(p2.x-p1.x,2)+Math.pow(p2.y-p1.y,2));
	clickCircleLayer = new L.Circle(
			centerPoint,dist
	).addTo(map);
	clickCircleLayer.setStyle({
		weight: 2,
		color : "#0100FF",
		opacity : 1,
		fillColor : "#0100FF",
		fillOpacity : 0
	});
}

function clickCircleClear() {
	if(clickCircleLayer!=null) {
		map.removeLayer(clickCircleLayer);
		clickCircleLayer = null;
	}
	
	if(circleMarker1!=null) {
		map.removeLayer(circleMarker1);
		circleMarker1 = null;
	}
	
	if(circleMarker2!=null) {
		map.removeLayer(circleMarker2);
		circleMarker2 = null;
	}
	centerPoint = null;
	point = null;
}







function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();
	if (n.length < digits) {
		for (i = 0; i < digits - n.length; i++) {
			zero += '0';
		}
	}
	return zero + n;
}


function objectToJSONString(object) {
	var isArray = (object.join && object.pop && object.push
			&& object.reverse && object.shift && object.slice && object.splice);
	var results = [];

	for ( var i in object) {
		var value = object[i];

		if (typeof value == "object" && value != null)
			results.push((isArray ? "" : "\"" + i.toString() + "\" : ")
					+ objectToJSONString(value));
		else
			results.push((isArray ? "" : "\"" + i.toString() + "\" : ")
					+ (typeof value == "string" ? "\"" + value + "\""
							: value));
	}
	return (isArray ? "[" : "{") + results.join(", ") + (isArray ? "]" : "}");
}
