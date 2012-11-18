function Bfg (options) {
    this.t = null;
    this.options = options;
    this.initialize = function() {
       var option = { resGetPath: 'js/locales/__lng__.json', lng: 'en-US' };
       // TODO delete lng option in the future
       this.t = i18n.init(option, function(t) { 
          //var appName = t("key");
        });
    };
}