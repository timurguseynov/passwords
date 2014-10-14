serialize = (target) ->
  form = {}
  $.each $(target).serializeArray(), ->
    form[@name] = @value
  form

hashPassword = (password) ->
  digest: SHA256(password)
  algorithm: "sha-256"

throwErr = (err) ->
  Passwords.throwErr err


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
  Accounts.resetPassword token, password, (err) ->
    return throwErr err if err
    Router.go Passwords.settings.dashboardRoute


Template.passwordsField.helpers
  type: ->
    if @name.indexOf('password') > -1
      'password'
    else if @name.indexOf('email') > - 1
      'email'
    else
      'text'
  id: ->
    @name
  placeholder: ->
    i18n "placeholders.#{@name}"

Template.passwordsField.rendered = ->
  @$('#password').val('')


Template.passwordsWrapper.helpers
  formId: ->
    console.log "form-#{@route}"
    "form-#{@route}"
  top: ->
    _.extend _.clone(@), top: true
  middle: ->
    _.extend _.clone(@), middle: true
  bottom: ->
    _.extend _.clone(@), bottom: true
  head: ->
    i18n "#{@route}.head"
  submit: ->
    i18n "#{@route}.submit"
  logo: ->
    Passwords.settings.logo
  privacyUrl: ->
    Passwords.settings.privacyUrl
  termsUrl: ->
    Passwords.settings.termsUrl


Template.passwordsWrapper.events
 'submit': (e, t) ->
    e.preventDefault()
    FlashMessages.clear()
    email = $('#email').val()
    password = $('#password').val()
    if t.data.route is 'signUp'
      signUp serialize(e.target)
    else if t.data.route is 'signIn'
      login email, password
    else if t.data.route is 'forgotPassword'
      forgotPassword email
    else if t.data.route is 'resetPassword'
      resetPassword t.data.resetToken , password


Template.passwordsWrapper.rendered = ->
  @$('form').parsley
    # successClass: 'has-success'
    errorClass: 'has-error'
    classHandler: (el) ->
      return el.$element.closest(".form-group")
    errorsWrapper: "<span class='help-block'></span>"
    errorTemplate: '<span></span>'


getLink = (obj, lang) ->
  lang ?= 'en'
  urls = Passwords.settings[obj]
  url = if _.isObject urls then urls[lang] else urls

  url: url, target: url.indexOf('http') > -1 and '_blank'

Template.signUp.helpers
  privacy: ->
    getLink 'privacy', @lang?.lang
  terms: ->
    getLink 'terms', @lang?.lang 




