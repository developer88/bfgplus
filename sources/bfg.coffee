# Blog for Google+ (BFG)
# v 0.0.1
# by Eremin Andrey aka Developer, 2012-2013
# http://eremin.me
# 
# The library provides an easy way to create a lightweight blog 
# from posts of your Google+ profile.
# According to Google+ limitation BFG can only display 100 of your posts.

# helper class for retrieving data from Google+
class GooglePlus
  constructor: (@options) ->

  posts: ->

  post: (id) ->


# main class of Blog for Google+
class Bfg
  constructor: (@options) ->
    option = { resGetPath: 'js/locales/__lng__.json', lng: 'en-US' }
    $.i18n.init(option, (t) ->
      appName = t("key")
    )
    @gplus = new GooglePlus

  # alias for @gplus object
  plus: ->
    @gplus

  # load blog data and render it to dom_obj
  load_blog: (dom_obj) ->
    posts = plus.posts
    if posts.size > 0
      render_posts(dom_obj, pack_post(post) for post in posts )
    else
      message($.t('app.messages.posts.empty'))

  # load post data and render it to dom_obj
  load_post: (id) ->
    if parseInt(id) == 0
      return message($.t('app.messages.posts.not_found'))
    post = plus.post(id)
    post_html = unpack_post(post)
    render_post(post_html)

  # display message with type and text
  message: (text, type = 'info') ->

  # create a plate with short info of particular post from post variable
  pack_post: (post) ->

  # create a modal window with post data from post variable
  unpack_post: (post) ->

  # put posts array into dom_obj
  render_posts: (dom_obj, html) ->

  # put post data into dom_obj
  render_post: (html) ->







