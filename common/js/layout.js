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


    //마이페이지 별 버튼
    $('.star-btn').on('click', function(){
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

    //선택삭제 버튼
    $('.all-delete').on('click', function(){
        mypageCheckBox.prop("checked",false);

        if($(".all-check").hasClass('checked')){
            $('.all-check').removeClass('checked');
            $('.all-check input').prop("checked",false);
        }
    });

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


