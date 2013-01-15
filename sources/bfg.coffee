# Blog for Google+ (BFG)
# v 0.0.1
# by Eremin Andrey aka Developer, 2012-2013
# http://eremin.me
# 
# The library provides an easy way to create a lightweight blog 
# from posts of your Google+ profile.
# According to Google+ limitation BFG can only display 100 of your posts.

# Blog for Google+
# This is just an atempt to create a blog using Google+ as a source of content.
# So my vision is one should not have lots of blogs (blogspot, wordpress etc. + twitter)
# but should have only one profile in Google+ and many (if one need to do so) websites with this script.
# But this is just a dream.
class Bfg
  constructor: ->
    @api_key = $("meta[name='bfg:api']").attr "content"
    @userid = $("meta[name='bfg:user']").attr "content"
    @locale = $("meta[name='bfg:locale']").attr "content"
    # TODO: Finish with locales
    #option = { resGetPath: 'js/locales/__lng__.json', lng: 'en-US' }
    #$.i18n.init(option, (t) ->
    #  appName = t("key")
    #)
    this.prepare_container()
    this.load_blog()

  # prepares necessary tags for posts and messages
  prepare_container: ->
    $("#bfg div.bfg-container").html "<div class='bfg-message'></div><div class='bfg-body'></div>"
  
  # returns loaded posts
  blog_posts: ->
    @posts

  # processes posts received from Google+
  process_posts: ->
    posts = this.blog_posts()
    this.d posts
    this.d posts.length
    if posts.length > 0
      @render_posts( @pack_post(post) for post in posts )
    else
      #@message $.t('app.messages.posts.empty')     

  # loads blog data and render it 
  load_blog: ->
    $.getJSON('https://www.googleapis.com/plus/v1/people/'+@userid+'/activities/public?key='+@api_key, (data) =>
      @posts = data['items']
      @process_posts()
    )

  # loads post data and render it to dom_obj
  load_post: (id) ->
    if parseInt(id) == 0
      return message($.t('app.messages.posts.not_found'))
    post = post for post in blog_posts when post['id'] is id
    post_html = unpack_post(post)
    render_post(post_html)

  # displays message with type and text
  message: (text, type = 'info') ->
    $("#bfg div.bfg-container div.bfg-body").html("<span class='bfg-message-"+type+"'>"+text+"</span>")

  # creates a plate with short info of particular post from post variable
  pack_post: (post) ->
    @d post
    #title
    #url
    #id
    #annotation
    #object.content
    #attachments[]
    #  url
    #  objectType
    #  id
    #  article ->
    #   content
    #   url
    #  image ->
    #   image
    #     url


  # creates a modal window with post data from post variable
  unpack_post: (post) ->

  # puts posts array into dom_obj
  render_posts: (html) ->
    $("#bfg div.bfg-container div.bfg-body").html html
    # TODO bind events for posts

  # puts post data into dom_obj
  render_post: (html) ->
    # kill all opened modal forms
    # open a new one
    # bind necessary events

  # writes object data into Chrome console
  # this is for Chrome only, others browsers - fuck you!
  d: (obj) ->
    console.log obj

# Let's roll!
bfg = new Bfg
