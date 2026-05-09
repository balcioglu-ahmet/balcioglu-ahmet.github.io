$(function() {
    "use strict";

    var scrollLink = $('.page-scroll[href^="#"]');
    var backToTop = $('.back-to-top');

    function setActiveLink(scrollTop) {
        scrollLink.each(function() {
            var target = $(this.hash);

            if (!target.length) {
                return;
            }

            if (target.offset().top - 90 <= scrollTop) {
                $(this).parent().addClass('active');
                $(this).parent().siblings().removeClass('active');
            }
        });
    }

    $(".navbar-toggler").on('click', function() {
        $(this).toggleClass('active');
    });

    $(".navbar-nav a").on('click', function() {
        $(".navbar-toggler").removeClass('active');
        $(".navbar-collapse").removeClass("show");
    });

    scrollLink.on('click', function(event) {
        var target = $(this.hash);

        if (target.length) {
            event.preventDefault();
            $('html, body').animate({
                scrollTop: target.offset().top - 85
            }, 800);
        }
    });

    $(window).on('scroll', function() {
        var scrollTop = $(this).scrollTop();

        $(".navgition").toggleClass("sticky", scrollTop >= 10);
        setActiveLink(scrollTop);

        if (scrollTop > 600) {
            backToTop.fadeIn(200);
        } else {
            backToTop.fadeOut(200);
        }
    });

    backToTop.on('click', function(event) {
        event.preventDefault();

        $('html, body').animate({
            scrollTop: 0
        }, 800);
    });

    $(window).trigger('scroll');
});
