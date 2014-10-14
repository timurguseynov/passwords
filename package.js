Package.describe({
  name: "timtch:passwords",
  summary: "Dead simple accounts-passwords templates with jade",
  version: "0.0.1"
});

Package.on_use(function (api) {

  api.versionsFrom("METEOR@0.9.0");

  api.use([
    "coffeescript",
    "templating",
    "underscore",
    "mquandalle:jade",
    "iron:router",
    ], ["client", "server"]);


  api.use([
    "less",
    "anti:i18n",
    "timtch:flash-messages-plus",
    "amr:parsley.js"
    ], ["client"]);

  api.addFiles([
    "client/Passwords.coffee",
    "client/router.coffee",
    "client/views/passwords.jade",
    "client/views/passwords.coffee",
    "client/i18n/en.coffee",
    "client/passwords.less"
    ], "client");

  api.addFiles([
    "server/passwords.coffee",
    ], "server");

});
