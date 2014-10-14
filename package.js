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
    "anti:i18n",
    "mrt:flash-messages",
    "amr:parsley.js",
    ], ["client", "server"]);

  api.use(["less"], ["client"]);

  api.addFiles([
    "both/router.coffee"
  ], ["client", "server"]);

  api.addFiles([
    "client/passwords.coffee",
    "client/views/passwords.jade",
    "client/views/passwords.coffee",
    ], "client");

  api.addFiles([
    "server/passwords.coffee",
    ], "server");

});
