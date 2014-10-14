hashPassword = (password) ->
  digest: SHA256(password)
  algorithm: "sha-256"

isStringEmail = (email) ->
  emailPattern = /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i
  if email.match emailPattern then true else false

p18n = (value) ->
  value

trimInput = (val)->
  val.replace /^\s*|\s*$/g, ""

throwErr = (err) ->
  console.log err
  FlashMessages.sendError i18n(err.reason or "Unknown error"), hideDelay: Passwords.settings.flashHideDelay

serialize = (target) ->
  form = {}
  array = $(target).serializeArray()
  _.each array, (formItem) ->
    type = $(target).find("input[name='" + formItem.name + "']").attr("type")
    form[formItem.name] = formItem.value
  form

login = (email, password)->
  Meteor.loginWithPassword email, password, (err) ->
    return throwErr err if err
    Router.go Passwords.settings.dashboardRoute

signUp = (data) ->
  Meteor.call 'passwordsCreateUser', data, (err, data) ->
    return throwErr err if err
    login(email, password)

forgotPassword = (email) ->
  Accounts.forgotPassword email: email, (err) ->
    return throwErr err if err
    Router.go Passwords.settings.homeRoute

resetPassword = (token, password) ->
  Accounts.resetPassword token, password, (error) ->
    return throwErr err if err
    Router.go Passwords.settings.dashboardRoute


Template.passwordsField.helpers
  type: () ->
    if @name.indexOf('password') > -1
      return 'password'
    else if @name.indexOf('email') > - 1
      return 'email'
  id: () ->
    @name
  placeholder: () ->
    p18n "ph.#{@name}"


Template.passwordsWrapper.helpers
  top: ->
    _.extend @, top: true
  bottom: ->
    _.extend @, top: false
  logo: ->
    Passwords.settings.logo
  privacyUrl: ->
    Passwords.settings.privacyUrl
  termsUrl: ->
    Passwords.settings.termsUrl


Template.passwordsWrapper.events
 'submit': (e, t) ->
    e.preventDefault()
    email = $('#email').val()
    email = trimInput email.toLowerCase() if isStringEmail(email)
    password = $('#password').val()
    if t.data.route is 'signUp'
      signUp serialize(e.target)
    else if t.data.route is 'signIn'
      login email, password
    else if t.data.route is 'forgotPassword'
      forgotPassword email
    else if t.data.route is 'resetPassword'
      resetPassword Session.get 'token' , password


Template.passwordsWrapper.rendered = ->
  @$('form').parsley
    # successClass: 'has-success'
    errorClass: 'has-error'
    classHandler: (el) ->
      return el.$element.closest(".form-group")
    errorsWrapper: "<span class='help-block'></span>"
    errorTemplate: '<span></span>'



