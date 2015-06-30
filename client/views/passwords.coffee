serialize = (target) ->
  form = {}
  $.each $(target).serializeArray(), ->
    form[@name] = @value
  form

throwErr = (err) ->
  Passwords.throwErr err

login = (email, password)->
  Meteor.loginWithPassword email, password, (err) ->
    return throwErr err if err
    Passwords.go 'dashboard'

signUp = (data, lang) ->
  data.profile = {}
  data.profile.lang = lang
  Meteor.call 'passwordsCreateUser', data, (err) ->
    return throwErr err if err
    login(data.email, data.password)

forgotPassword = (email, lang) ->
  Accounts.forgotPassword email: email, (err) ->
    return throwErr err if err
    Passwords.go '/sign-in'
    Flash.success i18n('success.forgotLinkSent')

resetPassword = (token, password) ->
  Accounts.resetPassword token, password, (err) ->
    return throwErr err if err
    Passwords.go 'dashboard'


Template.passwordsField.helpers
  type: ->
    if @name is 'password' or @name is 'email' then @name else 'text'
  min: ->
    Passwords.settings.min if UI._parentData(1)?.route is 'signUp' and @name is 'password' 
  placeholder: ->
    i18n "placeholders.#{@name}"

Template.passwordsField.rendered = ->
  @$('#password').val('')
  @$('#email').val('')


Template.passwordsWrapper.helpers
  route: ->
    @route or 'signIn'
  fields: ->
    @fields or Passwords.settings.routes.signIn.fields
  formId: ->
    "form-#{@route or 'signIn'}"
  top: ->
    _.extend _.clone(@), top: true
  middle: ->
    _.extend _.clone(@), middle: true
  bottom: ->
    _.extend _.clone(@), bottom: true
  head: ->
    i18n "#{@route or 'signIn'}.head"
  submit: ->
    i18n "#{@route or 'signIn'}.submit"
  logo: ->
    Passwords.settings.logo
  spinner: ->
    "<i class='fa fa-spinner fa-spin'></i>" if Session.get 'passwordsProccess'
  disabled: ->
    Session.get 'passwordsProccess'


Template.passwordsWrapper.events
 'submit': (e, t) ->
    e.preventDefault()
    Session.set 'passwordsProccess', true
    email = $('#email').val()
    password = $('#password').val()
    if t.data?.route is 'signUp'
      signUp serialize(e.target), i18n.getLanguage()
    else if t.data?.route is 'forgotPassword'
      forgotPassword email, i18n.getLanguage()
    else if t.data?.route is 'resetPassword'
      resetPassword t.data.resetToken , password
    else
      login email, password


Template.passwordsWrapper.rendered = ->
  @$('form').parsley
    # successClass: 'has-success'
    errorClass: 'has-error'
    classHandler: (el) ->
      return el.$element.closest(".form-group")
    errorsWrapper: "<span class='help-block'></span>"
    errorTemplate: '<span></span>'
    
Template.passwordsWrapper.destroyed = ->
  Flash.clear()
  Session.set 'passwordsProccess', false

getLink = (obj, lang) ->
  lang ?= 'en'
  urls = Passwords.settings[obj]
  url = if _.isObject urls then urls[lang] else urls
  if url then url: url, target: url.indexOf('http') > -1 and '_blank' else false

Template.signUp.helpers
  privacy: ->
    getLink 'privacy', @lang
  terms: ->
    getLink 'terms', @lang




