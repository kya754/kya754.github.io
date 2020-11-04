// //header 가로스크롤

function bodyWidthSet(){
    $('body').css({
        'width' : window.innerWidth
    });

    if($('body').width() < 1550) {
        $('body').css({
            'width' : 1550
        });
    }
}

// bodyWidthSet();

$(window).resize(function () {
    // bodyWidthSet();
});

// header fixed일때 가로스크롤 시 보이게
$(window).scroll(function() {
    $('#header').css({left: 0 - $(this).scrollLeft()});
});
