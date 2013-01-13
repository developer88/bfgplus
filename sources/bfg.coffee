class GooglePlus
  constructor: (@options) ->


class Bfg
  constructor: (@options) ->
    option = { resGetPath: 'js/locales/__lng__.json', lng: 'en-US' }
    $.i18n.init(option, (t) ->
      appName = t("key")
    )


  load_blog: (dom_obj) ->






