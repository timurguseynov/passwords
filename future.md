# Passwords
Meteor simple accounts-password bootstrap authentication templates. 
Based on great accounts-entry, but it's just a password authentication with email.
If you are using coffeescript, Jade, Flash messages, i18n translations this package for you.

install:

```
meteor add timtch:passwords
```

## Provided routes

You will get routes and the necessary templates for:

```
/sign-in
/sign-out
/sign-up
/forgot-password
```

## Ensuring signed in users for routes

Here is an Iron-Router route example:

````coffeescript
  @route "some",
    path: '/some'
    onBeforeAction: (pause) ->
      Passwords.signInRequired this, pause
````
```@render``` will be used


## Setting up password login

### In CLIENT code only


```coffeescript
  Meteor.startup ->
    Passwords.config
      logo: 'logo.png'                  # if set displays logo above sign-in options
      privacy: '/privacy-policy'     # if set adds link to privacy policy and 'you agree to ...' on sign-up page
      terms: '/terms-of-use'         # if set adds link to terms  'you agree to ...' on sign-up page
      homeRoute: '/'                    # mandatory - path to redirect to after sign-out
      dashboardRoute: '/dashboard'      # mandatory - path to redirect to after successful sign-in

```

### In SERVER code only

Call `Passwords.config` with a hash of optional configuration:

```coffeescript
  Meteor.startup ->
    Passwords.config
      signUpCallback: ->
        # something
```