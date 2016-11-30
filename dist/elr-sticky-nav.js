'use strict';

Object.defineProperty(exports, "__esModule", {
    value: true
});

var _elrUtilities = require('elr-utilities');

var _elrUtilities2 = _interopRequireDefault(_elrUtilities);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var $ = require('jquery');

var elr = (0, _elrUtilities2.default)();

var elrStickyNav = function elrStickyNav() {
    var _ref = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {},
        _ref$$nav = _ref.$nav,
        $nav = _ref$$nav === undefined ? $('nav.elr-sticky-nav') : _ref$$nav,
        _ref$activeClass = _ref.activeClass,
        activeClass = _ref$activeClass === undefined ? 'active' : _ref$activeClass,
        _ref$$content = _ref.$content,
        $content = _ref$$content === undefined ? $('div.sticky-nav-content') : _ref$$content,
        _ref$sectionEl = _ref.sectionEl,
        sectionEl = _ref$sectionEl === undefined ? 'section' : _ref$sectionEl,
        _ref$spy = _ref.spy,
        spy = _ref$spy === undefined ? false : _ref$spy;

    // const self = {};

    // make a more general function and add to elr utilities
    var affixElement = function affixElement($el, top) {
        var $win = $(window);
        var winHeight = $win.height();
        var scroll = $(document).scrollTop();
        var position = $el.data('position');
        var elementHeight = $el.height();
        var contentHeight = $content.height();

        if (scroll > top + contentHeight) {
            $el.removeClass('sticky-' + position);
        } else if (scroll > top - 50 && elementHeight < winHeight) {
            $el.addClass('sticky-' + position);
        } else {
            $el.removeClass('sticky-' + position);
        }
    };

    var gotoSection = function gotoSection(offset) {
        var $target = $('#' + $(this).attr('href').slice(1));
        var $content = $('body, html');

        $content.stop().animate({
            'scrollTop': $target.position().top - offset
        });

        return false;
    };

    if ($nav.length) {
        (function () {
            var $win = $(window);
            var $links = $nav.find('a[href^="#"]');
            var hash = window.location.hash;
            var navPositionTop = $nav.offset().top;
            var navPositionLeft = $nav.offset().left;

            $win.on('scroll', function () {
                affixElement($nav, navPositionTop);
            });

            if (spy) {
                $win.on('scroll', function () {
                    elr.scrollSpy($nav, $content, sectionEl, activeClass);
                });
            }

            $nav.on('click', 'a[href^="#"]', function (e) {
                e.preventDefault();
                $links.removeClass(activeClass);
                $(this).addClass(activeClass);
                gotoSection.call(this, 70);
            });
        })();
    }

    // return self;
};

exports.default = elrStickyNav;