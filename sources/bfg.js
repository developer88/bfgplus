// Generated by CoffeeScript 1.4.0
(function() {
  var Bfg, bfg;

  Bfg = (function() {

    function Bfg() {
      var option;
      this.api_key = this.s('api') ? this.s('api') : null;
      this.userid = this.s('user') ? this.s('user') : null;
      this.locale = this.s('locale') ? this.s('locale') : 'en-US';
      this.count = this.s('count') ? this.s('count') : 100;
      this.annotation_length = 35;
      this.loaded = false;
      if (!this.api_key || !this.userid) {
        this.d('Cannot load BFG+ because of wrong initial params');
        return false;
      }
      this.prepare_container();
      this.show_progress_bar();
      option = {
        resGetPath: 'js/locales/__lng__.json',
        lng: this.locale,
        debug: true
      };
      $.i18n.init(option, function(t) {
        var appName;
        return appName = t("key");
      });
      this.loaded = true;
      this.load_blog();
    }

    Bfg.prototype.show_progress_bar = function() {
      var html;
      html = "<div class='progress progress-striped active bfg-progress-bar'>";
      html += "<div class='bar' id='bfg-progress-bar' style='width: 10%;'></div>";
      html += "</div>";
      return $("#bfg div.bfg-container div.bfg-body").html(html);
    };

    Bfg.prototype.set_progress_bar = function(value) {
      if (value < 0 || value > 100) {
        value = 10;
      }
      return $('#bfg-progress-bar').css('width', value + '%');
    };

    Bfg.prototype.s = function(name) {
      if (!name) {
        return null;
      }
      return $("meta[name='bfg:" + name + "']").attr("content");
    };

    Bfg.prototype.prepare_container = function() {
      return $("#bfg div.bfg-container").html("<div class='bfg-message'></div><div class='bfg-body'></div>");
    };

    Bfg.prototype.blog_posts = function() {
      return this.posts;
    };

    Bfg.prototype.process_posts = function() {
      var post, posts;
      posts = this.blog_posts();
      this.d(posts);
      this.d(posts.length);
      if (posts.length > 0) {
        return this.render_posts((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = posts.length; _i < _len; _i++) {
            post = posts[_i];
            if (post['provider']['title'] !== 'Google Check-ins') {
              _results.push(this.pack_post(post));
            }
          }
          return _results;
        }).call(this));
      } else {

      }
    };

    Bfg.prototype.load_blog = function() {
      var _this = this;
      if (!this.loaded) {
        return false;
      }
      return $.getJSON('https://www.googleapis.com/plus/v1/people/' + this.userid + '/activities/public?maxResults=' + this.count + '&key=' + this.api_key, function(data) {
        _this.set_progress_bar(40);
        _this.posts = data['items'];
        return _this.process_posts();
      });
    };

    Bfg.prototype.message = function(text, type) {
      var html;
      if (type == null) {
        type = 'info';
      }
      html = "<div class='" + type + "'>";
      html += "<button type='button' class='close' data-dismiss='" + type + "'>&times;</button>";
      html += text;
      html += "</div>";
      return $("#bfg div.bfg-container div.bfg-message").html(html);
    };

    Bfg.prototype.post_preview = function(post) {
      var default_image;
      default_image = './img/post-bg-';
      if (post['object']['attachments'] && post['object']['attachments'][0]) {
        console.log(this.post_type(post));
        switch (this.post_type(post)) {
          case "post":
            return post['object']['attachments'][0]['image']['url'];
          case "photo":
            return post['object']['attachments'][0]['image']['url'];
          case "video":
            return post['object']['attachments'][0]['image']['url'];
          case "album":
            return post['object']['attachments'][0]['thumbnails'][0]['image']['url'];
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

    Bfg.prototype.post_annotation = function(post) {
      var arr, chunk, ret, _i, _len;
      if (post['annotation']) {
        return post['annotation'];
      }
      if (!post['title'] || post['title'].length === 0 || post['title'].length < this.annotation_length) {
        return post['title'];
      }
      arr = post['title'].split(/\s/);
      ret = "";
      for (_i = 0, _len = arr.length; _i < _len; _i++) {
        chunk = arr[_i];
        if (ret.length < this.annotation_length) {
          ret += (ret.length === 0 ? '' : ' ') + chunk;
        }
      }
      return ret + '...';
    };

    Bfg.prototype.prepare_content_thumbnails = function(post) {
      var thumbnail, thumbnails, _i, _len, _ref;
      if (post['object']['attachments'][0]['thumbnails'] === void 0) {
        return "";
      }
      thumbnails = "<ul class='thumbnails'>";
      _ref = post['object']['attachments'][0]['thumbnails'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        thumbnail = _ref[_i];
        thumbnails += "<li class='span3'><a href='" + thumbnail['url'] + "' class='thumbnail'><img alt='' src='" + thumbnail['image']['url'] + "'/></a>" + "</li>";
      }
      return thumbnails += "</ul>";
    };

    Bfg.prototype.post_content = function(post) {
      var read_more;
      if (post['object']['attachments'] && post['object']['attachments'][0]) {
        read_more = "<div class='bfg-post-read-more'><i class='icon-arrow-right'></i><a href='" + post['object']['attachments'][0]['url'] + "' target='_blank'>Read more</a></div>";
        switch (this.post_type(post)) {
          case "photo":
            return post['object']['content'] + "<div class='bfg-photo-content'><img src='" + post['object']['attachments'][0]['image']['url'] + "' /></div>" + read_more;
          case "article":
            return post['object']['content'] + "<div class='bfg-article-content well well-large'>" + post['object']['attachments'][0]['content'] + (post['object']['attachments'][0]['fullImage'] !== void 0 ? "<img src='" + post['object']['attachments'][0]['fullImage']['url'] + "' class='img-polaroid'/>" : "") + "</div>" + read_more;
          case "video":
            return post['object']['content'] + "<div class='bfg-video-content'>" + (post['object']['attachments'][0]['embed'] !== void 0 ? "<embed src='" + post['object']['attachments'][0]['embed']['url'] + "' type='" + post['object']['attachments'][0]['embed']['type'] + "'>" : void 0) + "</div>" + read_more;
          case "album":
            return post['object']['content'] + "<div class='bfg-album-content'>" + (post['object']['attachments'][0]['thumbnails'] !== void 0 ? this.prepare_content_thumbnails(post) : void 0) + "</div>" + read_more;
          default:
            return post['object']['content'] + read_more;
        }
      } else {
        return post['object']['content'];
      }
    };

    Bfg.prototype.post_type = function(post) {
      if (post['object']['attachments'] && post['object']['attachments'][0]) {
        return post['object']['attachments'][0]['objectType'];
      } else {
        return 'note';
      }
    };

    Bfg.prototype.post_title = function(post) {
      if (post['title'].length > 0) {
        return this.post_annotation(post);
      } else {
        return "";
      }
    };

    Bfg.prototype.post_body = function(post) {
      var html;
      html = "<div id='bfg-post-" + post['id'] + "-modal' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='BfgPostLabel-" + post['id'] + "' aria-hidden='true'>";
      html += "<div class='modal-header'>";
      html += "<a href='#' class='close' data-dismiss='modal' aria-hidden='true'><i class='icon-remove'></i></a>";
      html += "<h3 id='BfgPostLabel-" + post['id'] + "'>" + this.post_title(post) + "</h3>";
      html += "</div>";
      html += "<div class='modal-body'><div class='bfg-post-type'> " + this.post_type(post) + "</div><div class='bfg-post-main-container'>" + this.post_content(post) + "</div></div>";
      html += "<div class='modal-footer'>";
      html += "<button class='btn close_button' data-dismiss='modal' aria-hidden='true'>Close</button>";
      return html += "</div></div>";
    };

    Bfg.prototype.pack_post = function(post) {
      var html, preview;
      preview = this.post_preview(post);
      html = "<div id='bfg-post-" + post['id'] + "' class='thumbnail bfg-post bfg-post-background-" + this.post_type(post) + "' data-id='" + post['id'] + "' data-image='" + this.post_preview(post) + "'>";
      html += "<span class='bfg-post-header'>" + this.post_annotation(post) + "</span>";
      $('body').append(this.post_body(post));
      html += "</div>";
      return html;
    };

    Bfg.prototype.render_posts = function(html) {
      $("#bfg div.bfg-container div.bfg-body").html(html);
      return $(".bfg-post").each(function(index) {
        var id;
        id = '#bfg-post-' + $(this).data('id') + '-modal';
        if ($(this).data('image').length > 0) {
          $(this).css('background-image', 'url(' + $(this).data('image') + ')');
          $(this).css('background-position', '40% 40%');
          $(this).css('background-size', '250%');
        }
        return $(this).click(function() {
          return $(id).modal('show');
        });
      });
    };

    Bfg.prototype.d = function(obj) {
      return console.log(obj);
    };

    return Bfg;

  })();

  bfg = new Bfg;

}).call(this);
