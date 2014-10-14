Router.map ->

  @route "signIn",
    path: "/sign-in"
    action: ->
      @render 'passwordsWrapper'
    data: ->
      Passwords.settings.signInData
    onRun: ->
      if Meteor.userId()
        Router.go AccountsEntry.settings.dashboardRoute

  @route "signUp",
    path: "/sign-up"
    action: ->
      @render 'passwordsWrapper'
    data: ->
      Passwords.settings.signUpData


  @route "forgotPassword",
    path: "/forgot-password"
    data: ->
      Passwords.settings.forgotPasswordData
    onBeforeAction: ->
      Session.set('entryError', undefined)


  @route 'resetPassword',
    path: 'reset-password/:resetToken'
    data: ->
      Passwords.settings.resetPasswordData
    onBeforeAction: ->
      Session.set('resetToken', @params.resetToken)


  @route 'signOut',
    path: '/sign-out'
    onBeforeAction: (pause)->
      Session.set('entryError', undefined)
      if AccountsEntry.settings.homeRoute
        Meteor.logout () ->
          Router.go AccountsEntry.settings.homeRoute
      pause()

