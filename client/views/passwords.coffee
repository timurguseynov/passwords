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

signUp = (data, lang) ->
  data.profile = {}
  data.profile.lang = lang.lang if lang?.lang
  Meteor.call 'passwordsCreateUser', data, (err) ->
    return throwErr err if err
    login(data.email, data.password)

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
    if @name is 'password' or @name is 'email' then @name else 'text'
  min: ->
    Passwords.settings.min if UI._parentData(1).route is 'signUp' and @name is 'password' 
  placeholder: ->
    i18n "placeholders.#{@name}"

Template.passwordsField.rendered = ->
  @$('#password').val('')
  @$('#email').val('')


Template.passwordsWrapper.helpers
  formId: ->
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


Template.passwordsWrapper.events
 'submit': (e, t) ->
    e.preventDefault()
    email = $('#email').val()
    password = $('#password').val()
    if t.data.route is 'signUp'
      signUp serialize(e.target), t.data.lang
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




