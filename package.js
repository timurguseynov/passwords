Package.describe({
  name: 'timtch:passwords',
  summary: 'Simple accounts-passwords templates with jade',
  version: '0.0.2'
});

Package.onUse(function (api) {

  api.versionsFrom('METEOR@0.9.0');

  api.use([
    'coffeescript',
    'templating',
    'underscore',
    'iron:router@0.9.4',
    ], ['client', 'server']);

  api.use([
    'less',
    'session',
    'sha',
    'mquandalle:jade@0.2.8',
    'anti:i18n@0.4.3',
    'timtch:flash@0.1.1',
    'amr:parsley.js@2.0.3'
    ], ['client']);

  api.addFiles([
    'client/Passwords.coffee',
    'client/router.coffee',
    'client/views/passwords.jade',
    'client/views/passwords.coffee',
    'client/i18n/en.coffee',
    'client/passwords.less'
    ], 'client');

  api.addFiles([
    'server/passwords.coffee',
    ], 'server');

  api.imply([
    'accounts-base',
    'accounts-password',
    ], ['client', 'server']);

  api.export('Passwords', ['client', 'server']);
  api.export([
    'i18n',
    'Flash',
    ], 'client');

  
});
