# Blogs for Google+ (BFG)
# ===================
# v 1.0.0
# by Andrey Eremin, 2012-2015
# [http://aeremin.ru](http://aeremin.ru)
#
# 
# The library provides an easy way to retrieve public posts from Google+
# According to Google+ limitation BFG can only display 100 of your posts maximum.

# Class for Google+ Post
# Receives **@data** as Google+ Post Json object
class Post

  # Constructor method
  constructor: (@data) ->
    @annotation_length = 35
    @id = @data['id']
    @type = @determine_type()
    @title = @determine_title()
    @annotation = @determine_annotation()
    @attachments = @get_attachments()
    @preview_url = @determine_preview_url()









    @album_content = @determine_album_content()
    @content = @determine_content()

  get_attachments: ->
    return @data['object']['attachments'] if @data['object'] != undefined && @data['object']['attachments'] != undefined
    return []

  # Finds out post's type
  determine_type: ->
    return @attachments[0]['objectType'] if @attachments.length > 0
    return 'note'

  # Creates title for post
  determine_title:  ->
    return @data['title'] if @data['title'].length > 0
    return $.t("type."+ @type)

  # Creates annotation  - short text for post's description
  determine_annotation: ->
    return @data['annotation'] if @data['annotation']
    return "" if not @data['title']
    if @title != undefined
      return @title if @title.length <= @annotation_length
      arr = @title.split(/\s/);
      ret = ""
      (ret += (if ret.length == 0 then '' else ' ') + chunk ) for chunk in arr when ret.length < @annotation_length
      return ret + '...'

  # Creates background picture for post's plate
  determine_preview_url: ->
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






  # Creates thumbnails for posts with album type
  determine_album_content: ->
    return "" if !(@attachments.length > 0 && @attachments[0]['thumbnails'] != undefined && @attachments[0]['thumbnails'].length > 0) 
    thumbnails = "<ul class='thumbnails'>"
    index = 0
    thumbnails += ("<li class='"+(if index == 0 then 'span4' else 'span2')+"' data-number='"+(index += 1)+"'><a href='"+thumbnail['url']+"' class='thumbnail'><img alt='' src='"+thumbnail['image']['url']+"'/></a>"+"</li>") for thumbnail in @attachments[0]['thumbnails']
    thumbnails += "</ul>"



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
#    api:'sample-api-key',  
#    user:'sample-user-id',  
#    locale:'en-US'
#  });`  
# and then initialize blog as `bfg.initialize();`
#
class Bfg
  
  # Main constructor class
  constructor: (@options) ->
    @callback = null;
    @options ||= []

    @posts = []
    if !@options['api'] || !@options['user']
      throw 'Cannot load BFG+ because of wrong initial params'

  # Receives Google+ content and parse it
  get_records: (count, callback)->
    @callback = callback
    @processed_posts = []
    count = parseInt(count) || 100
    $.getJSON('https://www.googleapis.com/plus/v1/people/'+@options['user']+'/activities/public?maxResults='+@options['count']+'&key='+@options['api'], @data_loaded_callback)

  # Callback for AJAX request to process data from Google+
  data_loaded_callback: (data) =>
    @posts = data['items']
    if @posts.length > 0
      @processed_posts = (@process_post(post) for post in @posts when post['provider']['title'] isnt 'Google Check-ins')
    @callback(@processed_posts) if isFunction(@callback)
    return true

  # Processes posts received from Google+
  process_post: (post) ->
    return false if !post
    defined_post = new Post(post)

  isFunction: (functionToCheck)->
    getType = {}
    return functionToCheck && getType.toString.call(functionToCheck) == '[object Function]'

# Let's roll!
root = exports ? this
root.Bfg = Bfg
