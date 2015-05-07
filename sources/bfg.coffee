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

  constructor: (data) ->
    @data = data

  # Helpers

  id: ->
    @data['id']

  attachments: ->
    return @data['object']['attachments'] if @data['object'] != undefined && @data['object']['attachments'] != undefined
    return []

  type: ->
    return @type if @type
    @type = attachments()[0]['objectType'] if @attachments().length > 0
    @type = 'note' if !@type
    return @type

  title:  ->
    @data['title']

  # Creates annotation  - short text for post's description
  annotation: (annotation_length)->
    annotation_length = 35 if !annotation_length
    return @annotation_record['text'] if @annotation_record && @annotation_record['text'] && @annotation_record['length'] == annotation_length
    if @data['annotation']
      @annotation_record = { text: @data['annotation'], length: annotation_length }
      return @annotation_record['text']
    end
    if !@data['title'] || @data['title'].length <= annotation_length
      @annotation_record = { text: @data['title'], length: annotation_length }
      return @annotation_record['text']
    end
    arr = @data['title'].split(/\s/);
    ret = ""
    (ret += (if ret.length == 0 then '' else ' ') + chunk ) for chunk in arr when ret.length < annotation_length
    @annotation_record = { text: ret + '...', length: annotation_length }
    return @annotation_record['text']

  preview_url: ->
    if attachments().length > 0
      switch type()
        when "post"  then return attachments()[0]['image']['url']
        when "photo" then return attachments()[0]['image']['url']
        when "video" then return attachments()[0]['image']['url']
        when "album" then return attachments()[0]['thumbnails'][0]['image']['url']
        when "article" then return ''
        when "event" then return ''
        else return ''
    else
      return ''

  post_url: ->
    return @data['object']['url'] if attachments().length == 0
    return attachments()[0]['url']

  content: ->
    @data['content']


# Main class for Blogs for Google+
# receives options:
# * api - Google+ API key (you can generate it on your Google Dashboard)  
# * user - Google+ user id to grab posts
#
# **Example:**
# Define it like  
# `var bfg = new Bfg({
#    api:'sample-api-key',  
#    user:'sample-user-id'
#  });`  
# and then get posts as `bfg.get_records(50, function(posts){console.log(posts)});`
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
