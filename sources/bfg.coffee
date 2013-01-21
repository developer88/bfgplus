# Blog for Google+ (BFG)
# v 0.0.1
# by Eremin Andrey aka Developer, 2012-2013
# http://eremin.me
# 
# The library provides an easy way to create a lightweight blog 
# from posts of your Google+ profile.
# According to Google+ limitation BFG can only display 100 of your posts maximum.

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
    @count = $("meta[name='bfg:count']").attr "content"
    @annotation_length = 35;

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
      @render_posts( @pack_post(post) for post in posts when post['provider']['title'] isnt 'Google Check-ins' )
    else
      #@message $.t('app.messages.posts.empty')     

  # loads blog data and render it 
  load_blog: ->
    $.getJSON('https://www.googleapis.com/plus/v1/people/'+@userid+'/activities/public?maxResults='+@count+'&key='+@api_key, (data) =>
      @posts = data['items']
      @process_posts()
    )

  # displays message with type and text
  message: (text, type = 'info') ->
    $("#bfg div.bfg-container div.bfg-body").html("<span class='bfg-message-"+type+"'>"+text+"</span>")

  # returns preview imag url for post
  post_preview: (post) ->
    if post['object']['attachments'] && post['object']['attachments'][0]
      switch this.post_type(post)
        when "photo" then return post['object']['attachments'][0]['image']['url']
        when "video" then return post['object']['attachments'][0]['image']['url']
        when "album" then return post['object']['attachments'][0]['thumbnails'][0]['image']['url']
        when "article" then return null
        else this.d post     
    else
      return null

  # return annotation for post
  post_annotation: (post) ->
    # TODO refactor this
    return "" if !post['title'] || post['title'].length == 0 || post['title'].length < @annotation_length
    arr = post['title'].split(/\s/);
    ret = ""
    (ret += (if ret.length == 0 then '' else ' ') + chunk ) for chunk in arr when ret.length < @annotation_length
    return ret + '...'

  post_content: (post) ->
    if post['object']['attachments'] && post['object']['attachments'][0]
      return  post['object']['content'] + "<div class='bfg-post-read-more'><a href='"+post['object']['attachments'][0]['url']+"'>Read more</a>"
    else
      return post['object']['content']

  post_type: (post) ->
    if post['object']['attachments'] && post['object']['attachments'][0]
      return post['object']['attachments'][0]['objectType']
    else
      'note'

  post_title: (post) ->
    if post['title'].length > 0 
      return this.post_annotation(post)
    else
      return "" # use .t to return type stirng
  
  # returns html data for post modal
  post_body: (post) ->
    html  = "<div id='bfg-post-"+post['id']+"-modal' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='BfgPostLabel-"+post['id']+"' aria-hidden='true'>"
    html += "<div class='modal-header'>"
    # close button
    html += "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>x</button>"
    # post title
    html += "<h3 id='BfgPostLabel-"+post['id']+"'>"+this.post_title(post)+"</h3>"
    html += "</div>"
    # post body
    html += "<div class='modal-body'><div class='bfg-post-type'>Type: "+this.post_type(post)+"</div><div class='bfg-post-main-container'>"+this.post_content(post)+"</div></div>"
    html += "<div class='modal-footer'>"
    html += "<button class='btn' data-dismiss='modal' aria-hidden='true'>Close</button>"
    html += "</div></div>" 

  # creates a plate with short info of particular post from post variable
  pack_post: (post) ->
    preview = this.post_preview(post)
    html  = "<div id='bfg-post-"+post['id']+"' class='bfg-post bfg-post-background-" + this.post_type(post) + "' data-id='"+post['id']+"' data-image='"+this.post_preview(post)+"' >"
    html += "<span class='bfg-post-header'>"+this.post_annotation(post)+"</span>"
    html += "<div class='bfg-post-body'>"+this.post_body(post)+"</div>"
    html += "<a href='#bfg-post-"+post['id']+"-modal' role='button' class='btn' data-toggle='modal'>Launch demo modal</a>"
    html += "</div>"
    return html

    #@d post
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


  # puts posts array into dom_obj
  render_posts: (html) ->
    $("#bfg div.bfg-container div.bfg-body").html html
    $(".bfg-post").click ->
      #$('#bfg-post-'+$(this).data('id')+'-modal').modal 
      #$('#bfg-post-'+$(this).data('id')+'-modal').modal('show')
      # { show:true }

  # writes object data into Chrome console
  # this is for Chrome only, others browsers - fuck you!
  d: (obj) ->
    console.log obj

# Let's roll!
bfg = new Bfg
