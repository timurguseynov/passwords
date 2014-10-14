Router.map ->
  _.each Passwords.settings.routes, (route, name) =>
    @route name,
      path: route.path
      action: ->
        @render 'passwordsWrapper'
      data: ->
        lang = lang: @params.lang if @params.lang
        lang: lang
        route: name
        fields: route.fields
        resetToken: @params.resetToken
      onRun: ->
        Router.go Passwords.settings.dashboardRoute if Meteor.userId() and name isnt 'signOut'
      onBeforeAction: (pause) ->
        FlashMessages.clear()
        lang = @params.lang or Session.get('passwordsLang')
        # i18n.setLanguage lang if lang
        home = Passwords.settings.homeRoute
        if name is 'signOut' and home
          Meteor.logout ->
            if home.indexOf('http') > -1  
              window.location = home + lang
            else
              Router.go home
          pause()

