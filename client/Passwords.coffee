Passwords =
  settings:
    home: '/home'
    dashboard: '/dashboard'
    min: 6
    # privacy: 'privacy'
    # terms: 'terms'

    i18n:
      default: 'en'
      extra: ['es', 'ru']
      before:
        noPrefixDefault: true

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



  go: (to) ->
    url = if @settings[to] then  @settings[to] else to
    url = "/" + i18n.getLanguage() + url if i18n.getLanguage() in @settings.i18n.extra
    Router.go url

  signOut: ->
    @go '/sign-out'

  throwErr: (err) ->
    console.log err
    reason = err.reason or err or 'Unknown error'
    Session.set 'passwordsProccess', false
    Flash.clear()
    Flash.error i18n("errors.#{reason}"), autoHide: false

  config: (appConfig) ->
    @settings = _.extend(@settings, appConfig)

  signInRequired: (router, pause) ->
    unless Meteor.user()
      @throwErr 'signInRequired'
      router.render 'passwordsWrapper'
      pause.call()


@Passwords = Passwords



