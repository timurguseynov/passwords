Meteor.startup ->
  Accounts.urls.resetPassword = (token) ->
    Meteor.absoluteUrl('reset-password/' + token)

  Passwords =
    settings: {}

    config: (appConfig) ->
      @settings = _.extend(@settings, appConfig)

  @Passwords = Passwords

  Meteor.methods
    passwordsCreateUser: (user) ->
      check user, Object
      
      profile = Passwords.settings.defaultProfile || {}
      userId = Accounts.createUser
        email: user.email
        password: user.password
        profile: _.extend(profile, user.profile)

      if (user.email && Accounts._options.sendVerificationEmail)
        Accounts.sendVerificationEmail(userId, user.email)

      if Passwords.settings.signUpCallback
        Passwords.settings.signUpCallback(userId)