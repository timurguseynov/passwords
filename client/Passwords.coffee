Passwords =
  settings:
    homeRoute: '/home'
    dashboardRoute: '/'
    min: 6
    FlashMessages:
      autoHide: false
      # hideDelay: 2000

    privacy: 'privacy'
    terms: 'terms'

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
    FlashMessages.clear()
    FlashMessages.sendError i18n("errors.#{reason}"), 
      autoHide: @settings.FlashMessages.autoHide, hideDelay: @settings.FlashMessages.hideDelay

  config: (appConfig) ->
    @settings = _.extend(@settings, appConfig)
    i18n.setDefaultLanguage 'en'

    if appConfig.language
      i18n.setLanguage appConfig.language

  signInRequired: (router, pause, extraCondition) ->
    extraCondition ?= true
    unless Meteor.loggingIn()
      unless Meteor.user() and extraCondition
        lang = Session.get('passwordsLang') or router?.data?.lang?.lang
        Router.go("/sign-in")
        @throwErr 'signInRequired'
        pause.call()


@Passwords = Passwords




