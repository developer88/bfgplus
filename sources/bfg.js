// Generated by CoffeeScript 1.4.0
(function() {
  var Bfg, Post, root;

  Post = (function() {

    function Post(data) {
      this.data = data;
      this.options = this.data['options'];
      this.id = this.data['id'];
      this.attachments = this.data['object'] !== void 0 && this.data['object']['attachments'] !== void 0 ? this.data['object']['attachments'] : [];
      this.type = this.determine_type();
      this.preview = this.determine_preview_background();
      this.title = this.determine_title();
      this.annotation = this.determine_annotation();
      this.album_content = this.determine_album_content();
      this.content = this.determine_content();
    }

    Post.prototype.determine_album_content = function() {
      var index, thumbnail, thumbnails, _i, _len, _ref;
      if (!(this.attachments.length > 0 && this.attachments[0]['thumbnails'] !== void 0 && this.attachments[0]['thumbnails'].length > 0)) {
        return "";
      }
      thumbnails = "<ul class='thumbnails'>";
      index = 0;
      _ref = this.attachments[0]['thumbnails'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        thumbnail = _ref[_i];
        thumbnails += "<li class='" + (index === 0 ? 'span4' : 'span2') + "' data-number='" + (index += 1) + "'><a href='" + thumbnail['url'] + "' class='thumbnail'><img alt='' src='" + thumbnail['image']['url'] + "'/></a>" + "</li>";
      }
      return thumbnails += "</ul>";
    };

    Post.prototype.determine_annotation = function() {
      var arr, chunk, ret, _i, _len;
      if (this.data['annotation']) {
        return this.data['annotation'];
      }
      if (!this.data['title']) {
        return "";
      }
      if (this.title !== void 0) {
        if (this.title.length <= parseInt(this.options['annotation_length'])) {
          return this.title;
        }
        arr = this.title.split(/\s/);
        ret = "";
        for (_i = 0, _len = arr.length; _i < _len; _i++) {
          chunk = arr[_i];
          if (ret.length < this.options['annotation_length']) {
            ret += (ret.length === 0 ? '' : ' ') + chunk;
          }
        }
        return ret + '...';
      }
    };

    Post.prototype.determine_content = function() {
      var html, read_more;
      html = "";
      if (this.data['title']) {
        html = this.data['title'];
      }
      if (this.data['content']) {
        html += "<div>" + this.data['content'] + "</div>";
      }
      read_more = "<div class='bfg-post-read-more'><i class='icon-arrow-right'></i><a href='" + (this.attachments.length === 0 ? this.data['object']['url'] : this.attachments[0]['url']) + "' target='_blank'>" + $.t("read_more") + "</a></div>";
      html += read_more;
      if (this.attachments.length > 0) {
        switch (this.type) {
          case "photo":
            html += "<div class='bfg-photo-content'><img src='" + this.attachments[0]['image']['url'] + "' /></div>";
            break;
          case "article":
            html += "<div class='bfg-article-content well well-large'>" + this.data['object']['attachments'][0]['content'] + (this.attachments[0]['fullImage'] !== void 0 ? "<img src='" + this.attachments[0]['fullImage']['url'] + "' class='img-polaroid'/>" : "") + "</div>";
            break;
          case "video":
            html += "<div class='bfg-video-content'>" + "<div class='video-caption'>" + this.attachments[0]['displayName'] + "</div>" + (this.attachments[0]['embed'] !== void 0 ? "<embed src='" + this.attachments[0]['embed']['url'] + "' type='" + this.attachments[0]['embed']['type'] + "'>" : "<img src='" + this.attachments[0]['image']['url'] + "' />") + "</div>";
            break;
          case "album":
            html += "<div class='bfg-album-content'>" + (this.album_content.length !== void 0 ? this.album_content : void 0) + "</div>";
        }
      }
      return html;
    };

    Post.prototype.modal = function() {
      var html;
      html = "<div id='bfg-post-" + this.id + "-modal' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='BfgPostLabel-" + this.id + "' aria-hidden='true'>";
      html += "<div class='modal-header'>";
      html += "<a href='#' class='close' data-dismiss='modal' aria-hidden='true'><i class='icon-remove'></i></a>";
      html += "<h3 id='BfgPostLabel-" + this.id + "'>" + this.title + "</h3>";
      html += "</div>";
      html += "<div class='modal-body'><div class='bfg-post-type'>" + this.type + "</div><div class='bfg-post-main-container'>" + this.content + "</div></div>";
      html += "<div class='modal-footer'>";
      html += "<button class='btn close_button' data-dismiss='modal' aria-hidden='true'>" + $.t("close") + "</button>";
      return html += "</div></div>";
    };

    Post.prototype.html = function() {
      var html;
      html = "<div id='bfg-post-" + this.id + "' class='thumbnail bfg-post bfg-post-background-" + this.type + "' data-id='" + this.id + "' data-image='" + this.preview + "'>";
      html += "<span class='bfg-post-header'>" + this.annotation + "</span>";
      return html += "</div>";
    };

    Post.prototype.render_to = function(dom_id) {
      $(dom_id).append(this.html());
      $('body').append(this.modal());
      return this.place_callbacks();
    };

    Post.prototype.place_callbacks = function() {
      var carousel_id, modal_id, plate_id,
        _this = this;
      modal_id = '#bfg-post-' + this.id + '-modal';
      plate_id = '#bfg-post-' + this.id;
      carousel_id = '#bfg-post-' + this.id + '-carousel';
      $(plate_id).click(function() {
        return $(modal_id).modal('show');
      });
      if (this.preview) {
        $(plate_id).css('background-image', 'url(' + this.preview + ')');
        $(plate_id).css('background-position', '40% 40%');
        return $(plate_id).css('background-size', '250%');
      }
    };

    Post.prototype.determine_title = function() {
      if (this.data['title'].length > 0) {
        return this.data['title'];
      } else {
        return $.t("type." + this.type);
      }
    };

    Post.prototype.determine_preview_background = function() {
      if (this.attachments.length > 0) {
        switch (this.type) {
          case "post":
            return this.attachments[0]['image']['url'];
          case "photo":
            return this.attachments[0]['image']['url'];
          case "video":
            return this.attachments[0]['image']['url'];
          case "album":
            return this.attachments[0]['thumbnails'][0]['image']['url'];
          case "article":
            return '';
          case "event":
            return '';
          default:
            return '';
        }
      } else {
        return '';
      }
    };

    Post.prototype.determine_type = function() {
      if (this.attachments.length > 0) {
        return this.attachments[0]['objectType'];
      } else {
        return 'note';
      }
    };

    return Post;

  })();

  Bfg = (function() {

    Bfg.prototype.languages = function() {
      var en, resources, ru;
      en = {
        translation: {
          'read_more': 'Read more',
          'close': 'Close',
          'type': {
            'video': 'Video',
            'post': 'Post',
            'photo': 'Photo',
            'album': 'Album',
            'article': 'Article',
            'event': 'Event'
          }
        }
      };
      ru = {
        translation: {
          'read_more': 'Подробнее',
          'close': 'Закрыть',
          'type': {
            'video': 'Видео',
            'post': 'Заметка',
            'photo': 'Фото',
            'album': 'Альбом',
            'article': 'Статья',
            'event': 'Событие'
          }
        }
      };
      return resources = {
        dev: en,
        en: en,
        'en-US': en,
        'ru-RU': ru,
        ru: ru
      };
    };

    function Bfg(options) {
      var option;
      this.options = options;
      this.options['annotation_length'] = 35;
      this.processed_posts = [];
      this.posts = [];
      if (!this.options['api'] || !this.options['user']) {
        this.d('Cannot load BFG+ because of wrong initial params');
        return false;
      }
      option = {
        resStore: this.languages(),
        lng: this.options['locale'],
        debug: false
      };
      $.i18n.init(option);
      $(this.options['dom']).html('');
      this.place_and_show_progress_bar();
      this.load_blog();
    }

    Bfg.prototype.load_blog = function() {
      var _this = this;
      return $.getJSON('https://www.googleapis.com/plus/v1/people/' + this.options['user'] + '/activities/public?maxResults=' + this.options['count'] + '&key=' + this.options['api'], function(data) {
        var post, _i, _len, _ref, _results;
        _this.posts = data['items'];
        _this.d(_this.posts);
        if (_this.posts.length > 0) {
          _this.hide_div_and_prepare_container();
          _ref = _this.posts;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            post = _ref[_i];
            if (post['provider']['title'] !== 'Google Check-ins') {
              _results.push(_this.process_post(post));
            }
          }
          return _results;
        }
      });
    };

    Bfg.prototype.process_post = function(post) {
      var defined_post;
      post['options'] = this.options;
      defined_post = new Post(post);
      return defined_post.render_to(this.options['dom']);
    };

    Bfg.prototype.place_and_show_progress_bar = function() {
      return $(this.options['dom']).html('<div class="bfg-margin-auto"><div class="progress progress-striped active"><div class="bar" style="width: 20%;"></div></div></div>');
    };

    Bfg.prototype.hide_div_and_prepare_container = function() {
      $(this.options['dom']).html('');
      return $(this.options['dom']).addClass('bfg-body');
    };

    Bfg.prototype.d = function(obj) {
      return console.log(obj);
    };

    return Bfg;

  })();

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.Bfg = Bfg;

}).call(this);
