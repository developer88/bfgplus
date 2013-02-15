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
  constructor: (@data) ->
    @options = @data['options']
    @id = @data['id']
    @attachments = if @data['object'] != undefined && @data['object']['attachments'] != undefined then @data['object']['attachments'] else []
    @type = @determine_type()    
    @preview = @determine_preview_background()
    @title = @determine_title()
    @annotation = @determine_annotation()
    @thumbnails = @determine_thumbnails()
    @content = @determine_content()

  determine_thumbnails: ->
    return "" if !(@attachments.length > 0 && @attachments[0]['thumbnails'] != undefined && @attachments[0]['thumbnails'].length > 0) 
    # make it as slider
    thumbnails = "<ul class='thumbnails'>"
    thumbnails += ("<li class='span3'><a href='"+thumbnail['url']+"' class='thumbnail'><img alt='' src='"+thumbnail['image']['url']+"'/></a>"+"</li>") for thumbnail in @attachments[0]['thumbnails']
    # TODO finish this (if thumbnail['description'].length != 0 then "<p>"+thumbnail['description']+"</p>")
    thumbnails += "</ul>"

  determine_annotation: ->
    return @data['annotation'] if @data['annotation']
    return "" if not @data['title']
    if @title != undefined
      return @title if @title.length <= parseInt(@options['annotation_length'])
      arr = @title.split(/\s/);
      ret = ""
      (ret += (if ret.length == 0 then '' else ' ') + chunk ) for chunk in arr when ret.length < @options['annotation_length']
      return ret + '...'

  determine_content: ->
    html = ""
    html = @data['title'] if @data['title']
    html += "<div>" + @data['content'] + "</div>" if @data['content']
    read_more = "<div class='bfg-post-read-more'><i class='icon-arrow-right'></i><a href='"+(if @attachments.length == 0 then @data['object']['url'] else @attachments[0]['url'])+"' target='_blank'>"+$.t("read_more")+"</a></div>"
    if @attachments.length > 0   
      switch @type
        when "photo" then return html + "<div class='bfg-photo-content'><img src='"+@attachments[0]['image']['url']+"' /></div>"
        when "article" then return html + "<div class='bfg-article-content well well-large'>"+@data['object']['attachments'][0]['content'] + ( if @attachments[0]['fullImage'] != undefined then "<img src='"+@attachments[0]['fullImage']['url']+"' class='img-polaroid'/>" else "") + "</div>"
        when "video" then return html + "<div class='bfg-video-content'>" + ( if @attachments[0]['embed'] != undefined then "<embed src='"+@attachments[0]['embed']['url']+"' type='"+@attachments[0]['embed']['type']+"'>") + "</div>"
        when "album" then return html + "<div class='bfg-album-content'>" + ( if @thumbnails.length != undefined then @thumbnails ) + "</div>"
    html += read_more
    return html

  modal:  ->
    html  = "<div id='bfg-post-"+@id+"-modal' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='BfgPostLabel-"+@id+"' aria-hidden='true'>"
    html += "<div class='modal-header'>"
    html += "<a href='#' class='close' data-dismiss='modal' aria-hidden='true'><i class='icon-remove'></i></a>"
    html += "<h3 id='BfgPostLabel-"+@id+"'>"+@title+"</h3>"
    html += "</div>"
    html += "<div class='modal-body'><div class='bfg-post-type'>"+@type+"</div><div class='bfg-post-main-container'>"+@content+"</div></div>"
    html += "<div class='modal-footer'>"
    html += "<button class='btn close_button' data-dismiss='modal' aria-hidden='true'>"+$.t("close")+"</button>"
    html += "</div></div>" 

  html: ->
    html  = "<div id='bfg-post-"+@id+"' class='thumbnail bfg-post bfg-post-background-" + @type + "' data-id='"+@id+"' data-image='"+@preview+"'>"
    html += "<span class='bfg-post-header'>"+@annotation+"</span>"
    html += "</div>" 

  render_to: (dom_id) ->
    $(dom_id).append @html()
    $('body').append @modal()
    @place_callbacks()

  place_callbacks: ->
    modal_id = '#bfg-post-'+@id+'-modal'
    plate_id = '#bfg-post-'+@id
    $(plate_id).click ->
      $(modal_id).modal 'show'
    if @preview
      $(plate_id).css('background-image', 'url(' + @preview + ')')
      $(plate_id).css('background-position','40% 40%')
      $(plate_id).css('background-size','250%')    

  determine_title:  -> 
    if @data['title'].length > 0 
      return @data['title']
    else
      return $.t("type."+ @type)

  determine_preview_background: ->
    if @attachments.length > 0
      switch @type
        when "post"  then return @attachments[0]['image']['url']
        when "photo" then return @attachments[0]['image']['url']
        when "video" then return @attachments[0]['image']['url']
        when "album" then return @attachments[0]['thumbnails'][0]['image']['url']
        when "article" then return ''
        when "event" then return ''
        else return ''    
    else
      return ''

  determine_type: ->
    if @attachments.length > 0
      return @attachments[0]['objectType']
    else
      'note'  


class Bfg
  languages: ->
    en = { translation: { 'read_more': 'Read more', 'close':'Close', 'type':{'video':'Video', 'post':'Post', 'photo':'Photo', 'album':'Album', 'article':'Article','event':'Event'} } }
    ru = { translation: { 'read_more': 'Подробнее', 'close':'Закрыть', 'type':{'video':'Видео', 'post':'Заметка', 'photo':'Фото', 'album':'Альбом', 'article':'Статья','event':'Событие'} } }
    resources = {
      dev: en,
      en: en,            
      'en-US': en,
      'ru-RU': ru,
      ru: ru
    }

  constructor: (@options) ->
    @options['annotation_length'] = 35
    @processed_posts = []
    @posts = []
    if !@options['api'] || !@options['user']
      @d 'Cannot load BFG+ because of wrong initial params'
      return false 

    option = { resStore: @languages(), lng: @options['locale'], debug: false }
    $.i18n.init option

    $(@options['dom']).html ''
    
    @load_blog()

  load_blog: ->
    $.getJSON('https://www.googleapis.com/plus/v1/people/'+@options['user']+'/activities/public?maxResults='+@options['count']+'&key='+@options['api'], (data) =>
      @posts = data['items']
      @d @posts
      if @posts.length > 0
        @process_post(post) for post in @posts when post['provider']['title'] isnt 'Google Check-ins'
      #@process_posts() if @posts.length > 0
    )

  # processes posts received from Google+
  process_post: (post) ->
    post['options'] = @options
    defined_post = new Post(post)
    #@processed_posts << new Post(post)
    defined_post.render_to(@options['dom'])
    #@processed_posts << new Post((post['options'] = @options)) for post in @posts when post['provider']['title'] isnt 'Google Check-ins'
    # for post in @processed_posts

  # writes object data into Chrome console
  # this is for Chrome only, others browsers - fuck you!
  d: (obj) ->
    console.log obj



  #show_progress_bar: ->
  #  html  = "<div class='progress progress-striped active bfg-progress-bar'>"
  #  html += "<div class='bar' id='bfg-progress-bar' style='width: 10%;'></div>"
  #  html += "</div>"
  #  $("#bfg div.bfg-container div.bfg-body").html html

  #set_progress_bar: (value) ->
  #  value = 10 if value < 0 || value > 100
  #  $('#bfg-progress-bar').css('width',value+'%')

  #s: (name) ->
  #  return null if !name
  #  $("meta[name='bfg:"+name+"']").attr "content"

  # prepares necessary tags for posts and messages
  #prepare_container: ->
  #  $("#bfg div.bfg-container").html "<div class='bfg-message'></div><div class='bfg-body'></div>"
  
  # returns loaded posts
  #blog_posts: ->
  #  @posts

   

  # loads blog data and render it 


  # displays message with type and text
  #message: (text, type = 'info') ->
  #  html  = "<div class='"+type+"'>"
  #  html += "<button type='button' class='close' data-dismiss='"+type+"'>&times;</button>"
  #  html += text
  #  html += "</div>"
  #  $("#bfg div.bfg-container div.bfg-message").html html



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




# Let's roll!
#bfg = new Bfg
root = exports ? this
root.Bfg = Bfg
