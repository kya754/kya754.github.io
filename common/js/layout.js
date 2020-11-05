
$(document).ready(function(){
    // //header 가로스크롤

    // main.html 에서만 적용
    function bodyWidthSet(){
        $('body.main').css({
            'width' : window.innerWidth
        });

        if($('body.main').width() < 1550) {
            $('body.main').css({
                'width' : 1550
            });
        }
    }

    bodyWidthSet();

    $(window).resize(function () {
        bodyWidthSet();
    });


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

});
