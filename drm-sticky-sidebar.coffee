###############################################################################
# Creates a navigation bar that stays put when the user scrolls
###############################################################################

( ($) ->

    drmStickyNav = {

        config: {
            nav: $ '.drm-sticky-nav'
            activeClass: 'active'
            content: $ '.sticky-nav-content'
        }

        init: (config) ->
            $.extend @.config, config
            links = drmStickyNav.config.nav.find 'a[href^="#"]'
            hash = window.location.hash
            content = drmStickyNav.config.content
            
            if hash
                hashLink = drmStickyNav.config.nav.find "a[href='#{hash}']"
                hashLink.addClass drmStickyNav.config.activeClass
                drmStickyNav.config.nav.on 'click', "a[href='#{hash}']", @goToSection
                hashLink.trigger 'click'
            else    
                links.first().addClass drmStickyNav.config.activeClass

            if drmStickyNav.config.nav.length > 0
                navPosition = drmStickyNav.config.nav.position().top
                positions = @.findPositions(content)
                spy = -> drmStickyNav.scrollSpy positions
                affix = -> drmStickyNav.affixNav navPosition
                $(window).on 'scroll', affix
                $(window).on 'scroll', spy

            drmStickyNav.config.nav.on 'click', 'a[href^="#"]', @goToSection

        affixNav: (navPosition) ->
            scroll = $('body').scrollTop()
            position = drmStickyNav.config.nav.data 'position'

            if scroll > (navPosition - 100)
                drmStickyNav.config.nav.addClass "sticky-#{position}"
            else
                drmStickyNav.config.nav.removeClass "sticky-#{position}"

        goToSection: (e) ->
            that = $ @
            target = that.attr 'href'
            content = $ 'body'

            e.preventDefault()

            $('a.active').removeClass drmStickyNav.config.activeClass
            that.addClass drmStickyNav.config.activeClass

            content.stop().animate {
                'scrollTop': $(target).position().top  
            }, 900, 'swing', ->
                window.location.hash = target
                return

        scrollSpy: (positions) ->
            scroll = $('body').scrollTop()
            links = drmStickyNav.config.nav.find 'a[href^="#"]'

            $.each positions, (index, value) ->
                if scroll == 0
                    $('a.active').removeClass drmStickyNav.config.activeClass  
                    links.eq(0).addClass drmStickyNav.config.activeClass
                # if value is less than scroll add activeClass to link with the same index
                else if value < scroll
                    $('a.active').removeClass drmStickyNav.config.activeClass  
                    links.eq(index).addClass drmStickyNav.config.activeClass

        findPositions: (content) ->
            content = drmStickyNav.config.content
            sections = content.find 'section'
            positions = []
            # populate positions array with the position of the top of each section element 
            sections.each (index) ->
                that = $ @
                length = sections.length

                # the first element's position should always be 0
                if index == 0
                    position = 0
                # subtract the bottom container's full height so final scroll value is equivalent 
                # to last container's position  
                else if index == length - 1
                    if that.height() > 200
                        position = that.position().top - (that.height() / 2)
                    else    
                        position = that.position().top - that.height()
                # for all other elements correct position by only subtracting half of its height 
                # from its top position
                else
                    position = that.position().top - (that.height() / 2)

                # correct for any elements that may have a negative position value  
                if position < 0 then positions.push 0 else positions.push position
                return positions           

            return positions        
    }

    drmStickyNav.init({
        nav: $ '.drm-sticky-sidebar'
        content: $ '.sticky-sidebar-content'
    })

) jQuery