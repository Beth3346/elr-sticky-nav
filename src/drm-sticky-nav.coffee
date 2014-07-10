###############################################################################
# Creates a navigation bar that stays put when the user scrolls
###############################################################################
"use strict"

$ = jQuery
class @DrmStickyNav
    constructor: (@nav = $('nav.drm-sticky-nav'), @activeClass = 'active', @content = $('div.sticky-nav-content'), @spy = yes) ->
        self = @
        _links = self.nav.find 'a[href^="#"]'
        _hash = window.location.hash
        
        if _hash
            _hashLink = self.nav.find "a[href='#{_hash}']"
            _hashLink.addClass self.activeClass
            self.nav.on 'click', "a[href='#{_hash}']", self.goToSection
            _hashLink.trigger 'click'
        else
            _links.first().addClass self.activeClass

        unless self.nav.length is 0
            _win = $(window)
            navPositionTop = self.nav.position().top
            _win.on 'scroll', -> self.affixNav navPositionTop
            # _win.on 'resize', -> self.positionRight
            
            if self.spy
                _win.on 'scroll', self.scrollSpy

        self.nav.on 'click', 'a[href^="#"]', -> self.goToSection.call @, self.activeClass

    affixNav: (top) =>
        _scroll = $('body').scrollTop()
        _position = @nav.data 'position'
        navPositionLeft = @nav.position().left
        _winHeight = $(window).height()
        _navHeight = @nav.height()
        _contentHeight = @content.height()

        if _scroll > (top + _contentHeight)
            @nav.removeClass "sticky-#{_position}"
        else if _scroll > (top - 50) and _navHeight < _winHeight
            @nav.addClass "sticky-#{_position}"
            @positionRight navPositionLeft
        else
            @nav.removeClass "sticky-#{_position}"

    positionRight: (navPositionLeft) =>
        _position = @nav.data 'position'

        if _position isnt 'top'
            @nav.css 'left': navPositionLeft
        else
            @nav.css 'left': 0

    goToSection: (activeClass) ->
        _that = $ @
        target = _that.attr 'href'
        _content = $ 'body'

        $('a.active').removeClass activeClass
        _that.addClass activeClass

        _content.stop().animate {
            'scrollTop': $(target).position().top
        }, 900, 'swing', ->
            window.location.hash = target
            return

        false

    scrollSpy: =>
        scroll = $('body').scrollTop()
        links = @nav.find 'a[href^="#"]'

        _findPositions = =>
            sections = @content.find 'section'
            positions = []
            # populate positions array with the position of the top of each section element 
            sections.each (index) ->
                _that = $ @
                _length = sections.length

                getPosition = (height) ->
                    if height > 200
                        _that.position().top - (_that.height() / 2)
                    else    
                        _that.position().top - _that.height()

                # the first element's position should always be 0
                if index is 0
                    _position = 0
                # subtract the bottom container's full height so final scroll value is equivalent 
                # to last container's position  
                else if index is _length - 1
                    _position = getPosition _that.height()
                # for all other elements correct position by only subtracting half of its height
                # from its top position
                else
                    _position = _that.position().top - (_that.height() / 2)

                # correct for any elements _that may have a negative position value  
                if _position < 0 then positions.push 0 else positions.push _position

            positions

        positions = _findPositions()

        $.each positions, (index, value) =>
            # console.log "value: #{value} : scroll: #{scroll}"
            if scroll is 0
                $("a.#{@activeClass}").removeClass @activeClass  
                links.eq(0).addClass @activeClass
            # if value is less than scroll add @activeClass to link with the same index
            else if value < scroll
                $("a.#{@activeClass}").removeClass @activeClass
                links.eq(index).addClass @activeClass

new DrmStickyNav()