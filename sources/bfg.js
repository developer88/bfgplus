// Generated by CoffeeScript 1.4.0
(function() {
  var Bfg;

  Bfg = (function() {

    function Bfg(options) {
      var option;
      this.options = options;
      option = {
        resGetPath: 'js/locales/__lng__.json',
        lng: 'en-US'
      };
      $.i18n.init(option, function(t) {
        var appName;
        return appName = t("key");
      });
    }

    Bfg.prototype.load_blog = function(dom_obj) {};

    return Bfg;

  })();

}).call(this);
