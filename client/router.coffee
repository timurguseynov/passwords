Router.map ->

  _.each Passwords.settings.routes, (route, name) =>
    @route name,
      path: route.path
      action: ->
        @render 'passwordsWrapper'
      data: ->
        lang: @params.lang or ''
        route: @route.getName()
        fields: route.fields
        resetToken: @params.resetToken
      onBeforeAction: ->
        Flash.clear()
        Session.set 'passwordsProccess', false
        i18n.setLanguage @params.lang or 'en'
        Passwords.go 'dashboard' if Meteor.userId() and @route.name isnt 'signOut'
        if name is 'signOut'
          Meteor.logout ->
            Passwords.go 'home'
        @next()
      # onAfterAction: ->
        # SEO.set title: i18n('SEO.site')+' - '+i18n('SEO.titles.'+@route.name) if SEO
