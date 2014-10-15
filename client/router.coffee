Router.map ->
  _.each Passwords.settings.routes, (route, name) =>
    @route name,
      path: route.path
      action: ->
        @render 'passwordsWrapper'
      data: ->
        lang = lang: @params.lang if @params.lang
        lang: lang
        route: @route.name
        fields: route.fields
        resetToken: @params.resetToken
      onRun: ->
        @redirect Passwords.settings.dashboardRoute if Meteor.userId() and @route.name isnt 'signOut'
      onBeforeAction: (pause) ->
        FlashMessages.clear()
        Session.set 'passwordsProccess', false
        i18n.setLanguage @params.lang if @params.lang
        home = Passwords.settings.homeRoute
        if name is 'signOut' and home
          Meteor.logout ->
            if home.indexOf('http') > -1
              lang = i18n.getLanguage()
              home += "/#{lang}" if lang isnt 'en'
              window.location = home
            else
              Router.go home
          pause()
