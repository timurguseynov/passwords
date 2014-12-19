Passwords =
  settings:
    home: '/home'
    dashboard: '/dashboard'
    min: 6
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

  go: (to) ->
    url = if @settings[to] then  @settings[to] else to
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

  signInRequired: (router) ->
    if not Meteor.user()
      @throwErr 'signInRequired'
      router.render 'passwordsWrapper'
    else
      router.next()


@Passwords = Passwords
