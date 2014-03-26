###############################################################################
# Creates a navigation bar that stays put when the user scrolls
###############################################################################
"use strict"

( ($) ->
    class window.DrmStickyNav
        constructor: (@nav = $('nav.drm-sticky-nav'), @activeClass = 'active', @content = $('div.sticky-nav-content')) ->
            self = @
            links = self.nav.find 'a[href^="#"]'
            hash = window.location.hash
            content = self.content
            
            if hash
                hashLink = self.nav.find "a[href='#{hash}']"
                hashLink.addClass self.activeClass
                self.nav.on 'click', "a[href='#{hash}']", self.goToSection
                hashLink.trigger 'click'
            else    
                links.first().addClass self.activeClass

            unless self.nav.length is 0
                navPosition = self.nav.position().top
                $(window).on 'scroll', -> self.affixNav navPosition
                $(window).on 'scroll', self.scrollSpy

            self.nav.on 'click', 'a[href^="#"]', -> self.goToSection.call @, self.activeClass

        affixNav: (navPosition) =>
            scroll = $('body').scrollTop()
            position = @nav.data 'position'

            if scroll > (navPosition - 100)
                @nav.addClass "sticky-#{position}"
            else
                @nav.removeClass "sticky-#{position}"

        goToSection: (activeClass) ->
            that = $ @
            target = that.attr 'href'
            content = $ 'body'

            $('a.active').removeClass activeClass
            that.addClass activeClass

            content.stop().animate {
                'scrollTop': $(target).position().top
            }, 900, 'swing', ->
                window.location.hash = target
                return

            return false

        scrollSpy: =>
            scroll = $('body').scrollTop()
            links = @nav.find 'a[href^="#"]'
            positions = @findPositions()

            $.each positions, (index, value) =>
                # console.log "value: #{value} : scroll: #{scroll}"
                if scroll is 0
                    $("a.#{@activeClass}").removeClass @activeClass  
                    links.eq(0).addClass @activeClass
                # if value is less than scroll add @activeClass to link with the same index
                else if value < scroll
                    $("a.#{@activeClass}").removeClass @activeClass
                    links.eq(index).addClass @activeClass

        findPositions: =>
            sections = @content.find 'section'
            positions = []
            # populate positions array with the position of the top of each section element 
            sections.each (index) ->
                that = $ @
                length = sections.length

                getPosition = (height) ->
                    if height > 200
                        position = that.position().top - (that.height() / 2)
                    else    
                        position = that.position().top - that.height()
                    position

                # the first element's position should always be 0
                if index is 0
                    position = 0
                # subtract the bottom container's full height so final scroll value is equivalent 
                # to last container's position  
                else if index is length - 1
                    position = getPosition that.height()
                # for all other elements correct position by only subtracting half of its height
                # from its top position
                else
                    position = that.position().top - (that.height() / 2)

                # correct for any elements that may have a negative position value  
                if position < 0 then positions.push 0 else positions.push position
                positions           

            positions

    new DrmStickyNav()

) jQuery