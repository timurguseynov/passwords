Router.map ->

  _.each Passwords.settings.routes, (route, name) =>
    prefixes = []
    if Passwords.settings.i18n?.before?.noPrefixDefault
      prefixes.push "", "/:lang"
    else if Passwords.settings.i18n?.before
      prefixes.push "/:lang"
    else
      prefixes.push ""

    _.each prefixes, (prefix) =>
      @route name,
        path: prefix+route.path
        action: ->
          @render 'passwordsWrapper'
        data: ->
          lang: @params.lang or ''
          route: @route.name
          fields: route.fields
          resetToken: @params.resetToken
        onBeforeAction: (pause) ->
          Flash.clear()
          Session.set 'passwordsProccess', false
          i18n.setLanguage @params.lang or 'en'
          Passwords.go 'dashboard' if Meteor.userId() and @route.name isnt 'signOut'
          if name is 'signOut'
            Meteor.logout ->
              Passwords.go 'home'
            pause()


if Passwords.settings.i18n?.before?.noPrefixDefault
  Router.onBeforeAction ->
    @params.lang ?= ""
    good = Passwords.settings.i18n.extra.slice(0)
    good.push ""
    Passwords.go 'home' if @params.lang not in good
        
      




