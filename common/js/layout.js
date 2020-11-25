$(document).ready(function(){

    // 커스텀 스크롤바
    $('.table-responsive').addClass('scrollbar-outer');

    jQuery('.scrollbar-outer').scrollbar();
    jQuery('.scrollbar-inner').scrollbar();
    

    // //header 가로스크롤

    //main.html 에서만 적용
    // function bodyWidthSet(){
    //     $('body.main').css({
    //         'width' : window.innerWidth
    //     });

    //     if($('body.main').width() < 1920) {
    //         $('body.main').css({
    //             'width' : 1920
    //         });
    //     }
    // }

    // bodyWidthSet();

    // $(window).resize(function () {
    //     bodyWidthSet();
    // });


    // header fixed일때 가로스크롤 시 보이게
    $(window).scroll(function() {
        $('#header').css({left: 0 - $(this).scrollLeft()});
    });


    // depth2 hover
    $('.depth-wrap').on('mouseover', function(){
        $(this).addClass('on');

        $(this).on('mouseleave', function(){
            $(this).removeClass('on');
        })
    });

    // user 팝업
    $('.mypage-icon').on('click', function(){

        if($('.mypage-icon').hasClass('on')){
            $('.user-popup').hide();
            $('.mypage-icon').removeClass('on');
        }else {
            $('.user-popup').show();
            $('.mypage-icon').addClass('on');
        }
    });


    // 아코디언 게시판
    $('.accor-wrap .accor-li').find('.accor-ttl').on('click', function(){

        if($(this).hasClass('on')){
            $(this).removeClass('on');
            $(this).next('.accor-txt').slideUp();

        }else{
            $(this).addClass('on');
            $(this).next('.accor-txt').slideDown();
        }
    });


    //별, 삭제, 저장 버튼
    $('.star-btn, .delete-btn, .bookmark-btn').on('click', function(){
        if($(this).hasClass('on')){
            $(this).removeClass('on');
        }else{
            $(this).addClass('on');
        }
    });


    // 마이페이지 전채 선택
    var mypageCheckBox = $('.check-wrap .select-input input[type=checkbox]');

    // 전체선택 버튼
    $(".all-check input").on('click', function(){ 
        if($(".all-check").hasClass('checked')) {
            $('.all-check').removeClass('checked');
            mypageCheckBox.prop("checked",false); 
        } 
        else {
            $('.all-check').addClass('checked');
            mypageCheckBox.prop("checked",true);
        }
    });  
    
    //개별선택
    mypageCheckBox.on('click', function(){
        //전체선택이 활성화 상태일때 개별선택 해제 시
        if($(".all-check").hasClass('checked')){
            $('.all-check').removeClass('checked');
            $('.all-check input').prop("checked",false);
        }
    });

    //선택삭제 버튼
    $('.all-delete').on('click', function(){
        mypageCheckBox.prop("checked",false);

        if($(".all-check").hasClass('checked')){
            $('.all-check').removeClass('checked');
            $('.all-check input').prop("checked",false);
        }
    });


    //20201125 square-filter 영역 체크박스 기능 주석처리 

    // //커뮤니티, 마이페이지 그래프 검색 버튼
    // var selectAllBtn = $('.select-all .filter-item');
    // var selectBtn = $('.filter-box .filter-item');
    // // disabled 제외한 버튼 개수
    // var activeFilterNum = selectBtn.length - $('.filter-item.disabled').length;

    // //전체선택
    // selectAllBtn.on('click', function(){
    //     if(selectAllBtn.hasClass('active')){
    //         $(this).removeClass('active');
    //         selectBtn.not('.disabled').removeClass('active');
    //     }else{
    //         $(this).addClass('active');
    //         selectBtn.not('.disabled').addClass('active');
    //     }
    // });

    // //개별선택
    // selectBtn.not('.disabled').on('click', function(){
    //     if($(this).hasClass('active')){
    //         $(this).removeClass('active');
    //     }else{
    //         $(this).addClass('active');
    //     }    

    //     //전체선택이 활성화 상태일때 개별선택 해제 시
    //     if(selectAllBtn.hasClass('active')){
    //         selectAllBtn.removeClass('active');
    //     }

    //     //개별선택 전체 되면 전체선택 활성화
    //     if($('.filter-box .filter-item.active').length == activeFilterNum){
    //         selectAllBtn.addClass('active');
    //     }
    // });


    //20201125 square-filter 영역 탭메뉴 기능
    $('.square-filter .filter-item').not('.disabled').on('click', function(){
        $('.square-filter .filter-item').removeClass('active');
        $('.tab-cont > li').hide();

        if($(this).hasClass('active')){
            $(this).removeClass('active');
        }else {
            $(this).addClass('active');

            var tabBtnValue = $(this).val();
            var sameValueIndex = tabContList.indexOf(tabBtnValue);
            
            $('.tab-cont > li').eq(sameValueIndex).show();
        }
    });

    // 컨텐츠 영역 value 배열에 추가
    var tabContList = [];
    for(i = 0; i < $('.tab-cont > li').length; i++){
        tabContList.push($('.tab-cont > li').eq(i).attr('value'));
    }

});


$(window).load(function(){

    // gnb depth1 메뉴 갯수에 따라 넓이 지정
    var gnbWidthSum = 0;
    var menuLength = $('.depth-wrap').length;

    for(i = 0; i <= menuLength; i++){
        var widthNum = $('.depth-wrap').eq(i).innerWidth();
        gnbWidthSum += widthNum;

    }

    $('.gnb-menu').css({
        'width' : gnbWidthSum + 1
    });
}); 


