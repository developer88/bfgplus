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

#TODO
# 1. i18n
# 2. refactor
# 3. no initialization tags 
# 4. tests + document code with docco
# 5. main page & RTM


class Post
  constructor: (data) ->
    @options = data['options']
    @id = data['id']
    @attachements = if data['object']['attachments'] != undefined then data['object']['attachments'] else []
    @raw_content = data['content']
    @type = this.determine_type(data)    
    @preview = this.determine_preview_background(data)
    @title = this.determine_title(data)
    @annotation = this.determine_annotation(data)
    @thumbnails = this.determine_thumbnails(data)
    @content = this.determine_content(data)

   
  options: (option) ->
    @options[option]

  type: ->
    @type

  raw_content: ->
    @raw_content

  attachements: ->
    @attachements

  attachement: ->
    return if this.attachements.length > 0 then @attachements[0] else []

  preview: ->
    @preview

  title: ->
    @title

  id: ->
    @id

  annotation: ->
    @annotation

  thumbnails: ->
    @thumbnails

  content: ->
    @content

  determine_thumbnails: (post) ->
    return "" if this.attachement().length > 0 && this.attachement()['thumbnails'] == undefined
    thumbnails = "<ul class='thumbnails'>"
    thumbnails += ("<li class='span3'><a href='"+thumbnail['url']+"' class='thumbnail'><img alt='' src='"+thumbnail['image']['url']+"'/></a>"+"</li>") for thumbnail in this.attachements()[0]['thumbnails']
    # TODO finish this (if thumbnail['description'].length != 0 then "<p>"+thumbnail['description']+"</p>")
    thumbnails += "</ul>"

  determine_annotation: (post) ->
    return post['annotation'] if post['annotation']
    if this.title() != undefined
      return this.title() if this.title().length <= this.options('annotation_length')
      arr = this.title().split(/\s/);
      ret = ""
      (ret += (if ret.length == 0 then '' else ' ') + chunk ) for chunk in arr when ret.length < this.options('annotation_length')
      return ret + '...'

  determine_content: (post) ->
    html = this.raw_content()
    read_more = "<div class='bfg-post-read-more'><i class='icon-arrow-right'></i><a href='"+this.attachement()['url']+"' target='_blank'>"+$.t("read_more")+"</a></div>"
    if this.attachement().length > 0      
      switch this.type()
        when "photo" then return html + "<div class='bfg-photo-content'><img src='"+this.attachement()['image']['url']+"' /></div>"
        when "article" then return html + "<div class='bfg-article-content well well-large'>"+post['object']['attachments'][0]['content'] + ( if this.attachement()['fullImage'] != undefined then "<img src='"+this.attachement()['fullImage']['url']+"' class='img-polaroid'/>" else "") + "</div>"
        when "video" then return html + "<div class='bfg-video-content'>" + ( if this.attachement()['embed'] != undefined then "<embed src='"+this.attachement()['embed']['url']+"' type='"+this.attachement()['embed']['type']+"'>") + "</div>"
        when "album" then return html + "<div class='bfg-album-content'>" + ( if this.thumbnails().length != undefined then this.thumbnails() ) + "</div>"
      html += read_more
    return html

  body: (post) ->
    html  = "<div id='bfg-post-"+this.id()+"-modal' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='BfgPostLabel-"+this.id()+"' aria-hidden='true'>"
    html += "<div class='modal-header'>"
    html += "<a href='#' class='close' data-dismiss='modal' aria-hidden='true'><i class='icon-remove'></i></a>"
    html += "<h3 id='BfgPostLabel-"+this.id()+"'>"+this.title()+"</h3>"
    html += "</div>"
    html += "<div class='modal-body'><div class='bfg-post-type'>"+this.type()+"</div><div class='bfg-post-main-container'>"+this.content()+"</div></div>"
    html += "<div class='modal-footer'>"
    html += "<button class='btn close_button' data-dismiss='modal' aria-hidden='true'>"+$.t("close")+"</button>"
    html += "</div></div>" 

  determine_title: (post) -> 
    if post['title'].length > 0 
      return this.post_annotation(post)
    else
      return ""

  determine_preview_background: (post) ->
    if this.attachements().length > 0
      switch this.type()
        when "post"  then return this.attachements()[0]['image']['url']
        when "photo" then return this.attachements()[0]['image']['url']
        when "video" then return this.attachements()[0]['image']['url']
        when "album" then return this.attachements()[0]['thumbnails'][0]['image']['url']
        when "article" then return ''
        when "event" then return ''
        else return ''    
    else
      return ''

  determine_type: (post) ->
    if this.attachements().length > 0
      return this.attachements()[0]['objectType']
    else
      'note'  


class Bfg
  languages: ->
    en = { translation: { 'read_more': 'Read more', 'close':'Close' } }
    ru = { translation: { 'read_more': 'Подробнее', 'close':'Закрыть' } }
    resources = {
      dev: en,
      en: en,            
      'en-US': en,
      'ru-RU': ru,
      ru: ru
    }

  constructor: ->
    # load settings
    @api_key = if this.s('api') then this.s('api') else null
    @userid = if this.s('user') then this.s('user') else null 
    @locale = if this.s('locale') then this.s('locale') else 'en-US' 
    @count = if this.s('count') then this.s('count') else 100
    @annotation_length = 35 
    @loaded = false

    if !@api_key || !@userid
      this.d 'Cannot load BFG+ because of wrong initial params'
      return false    

    this.prepare_container()
    this.show_progress_bar()

    option = { resStore: @languages(), lng: @locale, debug: false }
    $.i18n.init option

    @loaded = true
    
    this.load_blog()

  show_progress_bar: ->
    html  = "<div class='progress progress-striped active bfg-progress-bar'>"
    html += "<div class='bar' id='bfg-progress-bar' style='width: 10%;'></div>"
    html += "</div>"
    $("#bfg div.bfg-container div.bfg-body").html html

  set_progress_bar: (value) ->
    value = 10 if value < 0 || value > 100
    $('#bfg-progress-bar').css('width',value+'%')

  s: (name) ->
    return null if !name
    $("meta[name='bfg:"+name+"']").attr "content"

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
    return false if !@loaded
    $.getJSON('https://www.googleapis.com/plus/v1/people/'+@userid+'/activities/public?maxResults='+@count+'&key='+@api_key, (data) =>
      @set_progress_bar(40)
      @posts = data['items']
      @process_posts()
    )

  # displays message with type and text
  message: (text, type = 'info') ->
    html  = "<div class='"+type+"'>"
    html += "<button type='button' class='close' data-dismiss='"+type+"'>&times;</button>"
    html += text
    html += "</div>"
    $("#bfg div.bfg-container div.bfg-message").html html

  # returns preview image url for post
  post_preview: (post) ->
    default_image = './img/post-bg-'
    if post['object']['attachments'] && post['object']['attachments'][0]
      console.log this.post_type(post)
      switch this.post_type(post)
        when "post"  then return post['object']['attachments'][0]['image']['url']
        when "photo" then return post['object']['attachments'][0]['image']['url']
        when "video" then return post['object']['attachments'][0]['image']['url']
        when "album" then return post['object']['attachments'][0]['thumbnails'][0]['image']['url']
        when "article" then return ''
        when "event" then return ''
        else return ''
        #else this.d post     
    else
      return ''

  # return annotation for post
  post_annotation: (post) ->
    return post['annotation'] if post['annotation']
    # TODO refactor this
    return post['title'] if !post['title'] || post['title'].length == 0 || post['title'].length < @annotation_length
    arr = post['title'].split(/\s/);
    ret = ""
    (ret += (if ret.length == 0 then '' else ' ') + chunk ) for chunk in arr when ret.length < @annotation_length
    return ret + '...'

  prepare_content_thumbnails: (post) ->
    return "" if post['object']['attachments'][0]['thumbnails'] == undefined
    thumbnails = "<ul class='thumbnails'>"
    thumbnails += ("<li class='span3'><a href='"+thumbnail['url']+"' class='thumbnail'><img alt='' src='"+thumbnail['image']['url']+"'/></a>"+"</li>") for thumbnail in post['object']['attachments'][0]['thumbnails']
    # TODO finish this (if thumbnail['description'].length != 0 then "<p>"+thumbnail['description']+"</p>")
    thumbnails += "</ul>"

  post_content: (post) ->
    if post['object']['attachments'] && post['object']['attachments'][0]
      read_more = "<div class='bfg-post-read-more'><i class='icon-arrow-right'></i><a href='"+post['object']['attachments'][0]['url']+"' target='_blank'>"+$.t("read_more")+"</a></div>"
      switch this.post_type(post)
        when "photo" then return post['object']['content'] + "<div class='bfg-photo-content'><img src='"+post['object']['attachments'][0]['image']['url']+"' /></div>" + read_more
        when "article" then return post['object']['content'] + "<div class='bfg-article-content well well-large'>"+post['object']['attachments'][0]['content'] + ( if post['object']['attachments'][0]['fullImage'] != undefined then "<img src='"+post['object']['attachments'][0]['fullImage']['url']+"' class='img-polaroid'/>" else "") + "</div>" + read_more
        when "video" then return post['object']['content'] + "<div class='bfg-video-content'>" + ( if post['object']['attachments'][0]['embed'] != undefined then "<embed src='"+post['object']['attachments'][0]['embed']['url']+"' type='"+post['object']['attachments'][0]['embed']['type']+"'>") + "</div>" + read_more
        when "album" then return post['object']['content'] + "<div class='bfg-album-content'>" + ( if post['object']['attachments'][0]['thumbnails'] != undefined then this.prepare_content_thumbnails(post) ) + "</div>" + read_more
        else return post['object']['content'] + read_more
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
    html += "<a href='#' class='close' data-dismiss='modal' aria-hidden='true'><i class='icon-remove'></i></a>"
    # post title
    html += "<h3 id='BfgPostLabel-"+post['id']+"'>"+this.post_title(post)+"</h3>"
    html += "</div>"
    # post body
    html += "<div class='modal-body'><div class='bfg-post-type'>"+this.post_type(post)+"</div><div class='bfg-post-main-container'>"+this.post_content(post)+"</div></div>"
    html += "<div class='modal-footer'>"
    html += "<button class='btn close_button' data-dismiss='modal' aria-hidden='true'>"+$.t("close")+"</button>"
    html += "</div></div>" 

  # creates a plate with short info of particular post from post variable
  pack_post: (post) ->
    preview = this.post_preview(post)
    html  = "<div id='bfg-post-"+post['id']+"' class='thumbnail bfg-post bfg-post-background-" + this.post_type(post) + "' data-id='"+post['id']+"' data-image='"+this.post_preview(post)+"'>"
    html += "<span class='bfg-post-header'>"+this.post_annotation(post)+"</span>"
    #html += "<div class='bfg-post-body'>"+this.post_body(post)+"</div>"
    $('body').append this.post_body(post)
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
    $(".bfg-post").each (index) -> 
      id = '#bfg-post-'+$(this).data('id')+'-modal'
      if $(this).data('image').length > 0
        $(this).css('background-image', 'url(' + $(this).data('image') + ')')
        $(this).css('background-position','40% 40%')
        $(this).css('background-size','250%')
      $(this).click ->
        $(id).modal('show')


  # writes object data into Chrome console
  # this is for Chrome only, others browsers - fuck you!
  d: (obj) ->
    console.log obj

# Let's roll!
bfg = new Bfg
