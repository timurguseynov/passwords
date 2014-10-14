Passwords =
  settings:
    homeRoute: '/home'
    dashboardRoute: '/dashboard'
    flashHideDelay: 2000

    i18nShowMissing: true

    signUpData: 
      route: 'signUp'
      head: 'singUp.createAccount'
      fields: [
        {name:'email'}
        {name:'password', min: 6}
      ]
      submit: 'Sign Up'

    signInData: 
      route: 'signIn'
      head: 'signIn.head'
      fields: [
        {name:'email'}
        {name:'password', min: 6}
      ]
      submit: 'Sign In'
    
    forgotPasswordData:
      route: 'forgotPassword'
      head: 'forgot.head'
      fields: [
        {name:'email'}
      ]
      submit: 'Send email verfication token'

    resetPasswordData:
      route: 'resetPassword'
      head: 'reset.head'
      fields: [
        {name:'password'}
      ]
      submit: 'Reset password'


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
        Session.set('entryError', t9n('error.signInRequired'))
        pause.call()


@Passwords = Passwords




