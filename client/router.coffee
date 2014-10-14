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
        lang = @params.lang or Meteor.user()?.profile?.lang
        i18n.setLanguage lang if lang
        if name is 'signOut' and Passwords.settings.homeRoute
          Meteor.logout () ->
            Router.go Passwords.settings.homeRoute
          pause()

