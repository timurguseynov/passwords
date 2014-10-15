Passwords =
  settings:
    homeRoute: '/home'
    dashboardRoute: '/dashboard'
    min: 6
    FlashMessages:
      autoHide: false
      # hideDelay: 2000

    # privacy: 'privacy'
    # terms: 'terms'

    routes: 
      signUp: 
        path: '/sign-up'
        fields: [
          {name:'email'}
          {name:'password'}
        ]

      signIn:
        path: '/sign-in'
        fields: [
          {name:'email'}
          {name:'password'}
        ]
    
      forgotPassword:
        path: '/forgot-password'
        fields: [
          {name:'email'}
        ]

      resetPassword:
        path: '/reset-password/:resetToken'
        fields: [
          {name:'password'}
        ]      

      signOut:
        path: '/sign-out'

        
  throwErr: (err) ->
    console.log err
    reason = err.reason or err or 'Unknown error'
    Session.set 'passwordsProccess', false
    FlashMessages.clear()
    FlashMessages.sendError i18n("errors.#{reason}"), 
      autoHide: @settings.FlashMessages.autoHide, hideDelay: @settings.FlashMessages.hideDelay

  config: (appConfig) ->
    @settings = _.extend(@settings, appConfig)

  signInRequired: (router, pause) ->
    unless Meteor.user()
      @throwErr 'signInRequired'
      router.render 'passwordsWrapper'
      pause.call()


@Passwords = Passwords



