import elrUI from 'elr-ui';
const $ = require('jquery');

let ui = elrUI();

const elrStickyNav = function({
    $nav = $('nav.elr-sticky-nav'),
    activeClass = 'active',
    $content = $('div.sticky-nav-content'),
    sectionEl = 'section',
    spy = false
} = {}) {
    // const self = {};

    // make a more general function and add to elr utilities
    const affixElement = function($el, top) {
        const $win = $(window);
        const winHeight = $win.height();
        const scroll = $(document).scrollTop();
        const position = $el.data('position');
        const elementHeight = $el.height();
        const contentHeight = $content.height();

        if (scroll > (top + contentHeight)) {
            $el.removeClass(`sticky-${position}`);
        } else if (scroll > (top - 50) && elementHeight < winHeight) {
            $el.addClass(`sticky-${position}`);
        } else {
            $el.removeClass(`sticky-${position}`);
        }
    };

    const gotoSection = function(offset) {
        const $target = $(`#${$(this).attr('href').slice(1)}`);
        const $content = $('body, html');

        $content.stop().animate({
            'scrollTop': $target.position().top - offset
        });

        return false;
    };

    if ($nav.length) {
        const $win = $(window);
        const $links = $nav.find('a[href^="#"]');
        const hash = window.location.hash;
        const navPositionTop = $nav.offset().top;
        const navPositionLeft = $nav.offset().left;

        $win.on('scroll', function() {
            affixElement($nav, navPositionTop);
        });

        if (spy) {
            $win.on('scroll', function() {
                ui.scrollSpy($nav, $content, sectionEl, activeClass);
            });
        }

        $nav.on('click', 'a[href^="#"]', function(e) {
            e.preventDefault();
            $links.removeClass(activeClass);
            $(this).addClass(activeClass);
            gotoSection.call(this, 70);
        });
    }

    // return self;
};

export default elrStickyNav;