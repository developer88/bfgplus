# Blog for Google+ (BFG)
# v 0.0.1
# by Eremin Andrey aka Developer, 2012-2013
# http://eremin.me
# 
# The library provides an easy way to create a lightweight blog 
# from posts of your Google+ profile.
# According to Google+ limitation BFG can only display 100 of your posts.

# main class of Blog for Google+
class Bfg
  constructor: ->
    @api_key = $("meta[name='bfg:api']").attr "content"
    @userid = $("meta[name='bfg:user']").attr "content"
    # TODO: Finish with locales
    #option = { resGetPath: 'js/locales/__lng__.json', lng: 'en-US' }
    #$.i18n.init(option, (t) ->
    #  appName = t("key")
    #)
    this.prepare_container()
    this.load_blog()


  prepare_container: ->
    $("#bfg div.bfg-container").html "<div class='bfg-message'></div><div class='bfg-body'></div>"
  
  blog_posts: ->
    @posts

  process_posts: ->
    posts = this.blog_posts()
    this.d posts
    this.d posts.length
    if posts.length > 0
      @render_posts( @pack_post(post) for post in posts )
    else
      #@message $.t('app.messages.posts.empty')     

  # load blog data and render it to dom_obj
  load_blog: ->
    $.getJSON('https://www.googleapis.com/plus/v1/people/'+@userid+'/activities/public?key='+@api_key, (data) =>
      @posts = data['items']
      @process_posts()
    )

  # load post data and render it to dom_obj
  load_post: (id) ->
    if parseInt(id) == 0
      return message($.t('app.messages.posts.not_found'))
    post = post for post in blog_posts when post['id'] is id
    post_html = unpack_post(post)
    render_post(post_html)

  # display message with type and text
  message: (text, type = 'info') ->
    $("#bfg div.bfg-container div.bfg-body").html("<span class='bfg-message-"+type+"'>"+text+"</span>")

  # create a plate with short info of particular post from post variable
  pack_post: (post) ->

  # create a modal window with post data from post variable
  unpack_post: (post) ->

  # put posts array into dom_obj
  render_posts: (html) ->
    $("#bfg div.bfg-container div.bfg-body").html html

  # put post data into dom_obj
  render_post: (html) ->

  d: (obj) ->
    console.log obj


bfg = new Bfg









