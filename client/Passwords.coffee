Passwords =
  settings:
    homeRoute: '/home'
    dashboardRoute: '/'
    i18nShowMissing: true
    min: 6
    FlashMessages:
      autoHide: false
      # hideDelay: 2000

    privacy: 
      en: 'privacy'
      ru: 'ruprivacy'
    terms: 
      en: 'terms'
      ru: 'ruterms'

    routes: 
      signUp: 
        path: '/sign-up'
        fields: [
          {name:'email', value: 'timtch@gmail.com'}
          {name:'password', value: 'test12345', min: @min}
        ]

      signIn:
        path: '/sign-in'
        fields: [
          {name:'email'}
          {name:'password', min: @min}
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
    FlashMessages.sendError i18n("errors.#{reason}"), 
      autoHide: @settings.FlashMessages.autoHide, hideDelay: @settings.FlashMessages.hideDelay

  config: (appConfig) ->
    @settings = _.extend(@settings, appConfig)
    i18n.setDefaultLanguage 'en'

    i18n.showMissing @settings.i18nShowMissing

    if appConfig.language
      i18n.setLanguage appConfig.language

  signInRequired: (router, pause, extraCondition) ->
    extraCondition ?= true
    unless Meteor.loggingIn()
      unless Meteor.user() and extraCondition
        Router.go('/sign-in')
        @throwErr 'signInRequired'
        pause.call()


@Passwords = Passwords




