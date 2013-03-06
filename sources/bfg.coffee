# Blog for Google+ (BFG)
# ===================
# v 0.0.1
# by Eremin Andrey aka Developer, 2012-2013
# [http://eremin.me](http://eremin.me)
#
# Icons by http://www.pixel-mixer.com/
# http://www.iconfinder.com/search/?q=iconset%3Abasicset
# 
# The library provides an easy way to create a lightweight blog 
# with posts of your Google+ profile.
# According to Google+ limitation BFG can only display 100 of your posts maximum.

# **N.B.:**
# *This is just an attempt to create a blog using Google+ as a source of content.
# So my vision is one should not have lots of blogs (blogspot, wordpress etc. + twitter)
# but should have only one profile in Google+ and many (if one need to do so) websites with this script.
# But this is just a dream.*

# Class for Google+ Post
# Receives **@data** as Google+ Post Json object
class Post

  # Constructor method
  constructor: (@data) ->
    @options = @data['options']
    @id = @data['id']
    @attachments = if @data['object'] != undefined && @data['object']['attachments'] != undefined then @data['object']['attachments'] else []
    @type = @determine_type()    
    @preview = @determine_preview_background()
    @title = @determine_title()
    @annotation = @determine_annotation()
    @album_content = @determine_album_content()
    @content = @determine_content()

  # Creates thumbnails for posts with album type
  determine_album_content: ->
    return "" if !(@attachments.length > 0 && @attachments[0]['thumbnails'] != undefined && @attachments[0]['thumbnails'].length > 0) 
    thumbnails = "<ul class='thumbnails'>"
    index = 0
    thumbnails += ("<li class='"+(if index == 0 then 'span4' else 'span2')+"' data-number='"+(index += 1)+"'><a href='"+thumbnail['url']+"' class='thumbnail'><img alt='' src='"+thumbnail['image']['url']+"'/></a>"+"</li>") for thumbnail in @attachments[0]['thumbnails']
    thumbnails += "</ul>"

  # Creates annotation  - short text for post's description
  determine_annotation: ->
    return @data['annotation'] if @data['annotation']
    return "" if not @data['title']
    if @title != undefined
      return @title if @title.length <= parseInt(@options['annotation_length'])
      arr = @title.split(/\s/);
      ret = ""
      (ret += (if ret.length == 0 then '' else ' ') + chunk ) for chunk in arr when ret.length < @options['annotation_length']
      return ret + '...'

  # Creates content for modal window based on post's type
  determine_content: ->
    html = ""
    html = @data['title'] if @data['title']
    html += "<div>" + @data['content'] + "</div>" if @data['content']
    read_more = "<div class='bfg-post-read-more'><i class='icon-arrow-right'></i><a href='"+(if @attachments.length == 0 then @data['object']['url'] else @attachments[0]['url'])+"' target='_blank'>"+$.t("read_more")+"</a></div>"
    html += read_more
    if @attachments.length > 0   
      switch @type
        when "photo" then html += "<div class='bfg-photo-content'><img src='"+@attachments[0]['image']['url']+"' /></div>"
        when "article" then html += "<div class='bfg-article-content well well-large'>"+@data['object']['attachments'][0]['content'] + ( if @attachments[0]['fullImage'] != undefined then "<img src='"+@attachments[0]['fullImage']['url']+"' class='img-polaroid'/>" else "") + "</div>"
        when "video" then html += "<div class='bfg-video-content'>" + "<div class='video-caption'>" + @attachments[0]['displayName'] + "</div>" + ( if @attachments[0]['embed'] != undefined then "<embed src='"+@attachments[0]['embed']['url']+"' type='"+@attachments[0]['embed']['type']+"'>" else "<img src='"+@attachments[0]['image']['url']+"' />") + "</div>"
        when "album" then html +=  "<div class='bfg-album-content'>" + ( if @album_content.length != undefined then @album_content ) + "</div>"
    return html

  # Generates modal window html
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

  # Generates plate html for posts
  html: ->
    html  = "<div id='bfg-post-"+@id+"' class='thumbnail bfg-post bfg-post-background-" + @type + "' data-id='"+@id+"' data-image='"+@preview+"'>"
    html += "<span class='bfg-post-header'>"+@annotation+"</span>"
    html += "</div>" 

  # Append post's plate and modal window html to **dom_id** object on the page
  render_to: (dom_id) ->
    $(dom_id).append @html()
    $('body').append @modal()
    @place_callbacks()

  # Bind callbacks to rendered objects
  place_callbacks: ->
    modal_id = '#bfg-post-'+@id+'-modal'
    plate_id = '#bfg-post-'+@id
    carousel_id = '#bfg-post-'+@id+'-carousel'
    $(plate_id).click =>
      $(modal_id).modal 'show'
    if @preview
      $(plate_id).css('background-image', 'url(' + @preview + ')')
      $(plate_id).css('background-position','40% 40%')
      $(plate_id).css('background-size','250%')    

  # Creates title for post
  determine_title:  -> 
    if @data['title'].length > 0 
      return @data['title']
    else
      return $.t("type."+ @type)

  # Creates background picture for post's plate
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

  # Finds out post's type
  determine_type: ->
    if @attachments.length > 0
      return @attachments[0]['objectType']
    else
      'note'  

# Main class for Blog for Google+
# receives options:
# * dom - CSS selector of DOM object to render BFG to  
# * api - Google+ API key (you can generate it on your Google Dashboard)  
# * user - Google+ user id to grab posts  
# * locale - default locale (by default en-US, but can be ru-RU)  
# * count - limit for post being displayed (default and maximum value is 100)  
#
# **Example:**
# Define it like  
# `var bfg = new Bfg({   
#    dom:'#bfg-sample',  
#    api:'sample-api-key',  
#    user:'sample-user-id',  
#    locale:'en-US',  
#    count:100  
#  });`  
# and then initialize blog as `bfg.initialize();`
#
class Bfg
  # Array with translations. You can add as much as you like translations to this array and use it with **locale** params
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
  
  # Main constructor class
  constructor: (@options) ->
    @options ||= []
    @options['locale'] ||= 'en-US'
    @options['count'] ||= 100
    @options['annotation_length'] = 35
    @processed_posts = []
    @posts = []
    if !@options['api'] || !@options['user'] || !@options['dom']
      throw 'Cannot load BFG+ because of wrong initial params'

    option = { resStore: @languages(), lng: @options['locale'], debug: false }
    $.i18n.init option
 
  # Method to start receiving Google+ posts and render them to the page
  initialize: ->
    $(@options['dom']).html ''    
    @place_and_show_progress_bar()
    @load_blog()

  # Receives Google+ content and parse it
  load_blog: ->
    $.getJSON('https://www.googleapis.com/plus/v1/people/'+@options['user']+'/activities/public?maxResults='+@options['count']+'&key='+@options['api'], @load_blog_callback)
      #(data) =>
     # @posts = data['items']
      #if @posts.length > 0
      #  @hide_div_and_prepare_container()
      #  @process_post(post) for post in @posts when post['provider']['title'] isnt 'Google Check-ins'
    #)

  load_blog_callback: (data) =>
    @posts = data['items']
    if @posts.length > 0
      @hide_div_and_prepare_container()
      @process_post(post) for post in @posts when post['provider']['title'] isnt 'Google Check-ins'
    return true

  # Returns all loaded posts from Google+
  blog_posts: ->
    @posts

  # Processes posts received from Google+
  process_post: (post) ->
    return false if !post
    post['options'] = @options
    defined_post = new Post(post)
    defined_post.render_to(@options['dom'])

  # Displays progress bar 
  place_and_show_progress_bar: ->
    $(@options['dom']).html '<div class="bfg-margin-auto"><div class="progress progress-striped active"><div class="bar" style="width: 20%;"></div></div></div>'

  # Removes progressbar
  hide_div_and_prepare_container: ->
    $(@options['dom']).html ''
    $(@options['dom']).addClass 'bfg-body'

  # Writes object data into Chrome console
  d: (obj) ->
    console.log obj

# Let's roll!
root = exports ? this
root.Bfg = Bfg
