// Generated by CoffeeScript 1.9.2
(function() {
  var Bfg, Post, root,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Post = (function() {
    function Post(data) {
      this.data = data;
    }

    Post.prototype.id = function() {
      return this.data['id'];
    };

    Post.prototype.attachments = function() {
      if (this.data['object'] !== void 0 && this.data['object']['attachments'] !== void 0) {
        return this.data['object']['attachments'];
      }
      return [];
    };

    Post.prototype.type = function() {
      if (this.type) {
        return this.type;
      }
      if (this.attachments().length > 0) {
        this.type = attachments()[0]['objectType'];
      }
      if (!this.type) {
        this.type = 'note';
      }
      return this.type;
    };

    Post.prototype.title = function() {
      return this.data['title'];
    };

    Post.prototype.annotation = function(annotation_length) {
      var arr, chunk, i, len, ret;
      if (!annotation_length) {
        annotation_length = 35;
      }
      if (this.annotation_record && this.annotation_record['text'] && this.annotation_record['length'] === annotation_length) {
        return this.annotation_record['text'];
      }
      if (this.data['annotation']) {
        this.annotation_record = {
          text: this.data['annotation'],
          length: annotation_length
        };
        return this.annotation_record['text'];
      }
      end;
      if (!this.data['title'] || this.data['title'].length <= annotation_length) {
        this.annotation_record = {
          text: this.data['title'],
          length: annotation_length
        };
        return this.annotation_record['text'];
      }
      end;
      arr = this.data['title'].split(/\s/);
      ret = "";
      for (i = 0, len = arr.length; i < len; i++) {
        chunk = arr[i];
        if (ret.length < annotation_length) {
          ret += (ret.length === 0 ? '' : ' ') + chunk;
        }
      }
      this.annotation_record = {
        text: ret + '...',
        length: annotation_length
      };
      return this.annotation_record['text'];
    };

    Post.prototype.preview_url = function() {
      if (attachments().length > 0) {
        switch (type()) {
          case "post":
            return attachments()[0]['image']['url'];
          case "photo":
            return attachments()[0]['image']['url'];
          case "video":
            return attachments()[0]['image']['url'];
          case "album":
            return attachments()[0]['thumbnails'][0]['image']['url'];
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

    Post.prototype.post_url = function() {
      if (attachments().length === 0) {
        return this.data['object']['url'];
      }
      return attachments()[0]['url'];
    };

    Post.prototype.content = function() {
      return this.data['content'];
    };

    return Post;

  })();

  Bfg = (function() {
    function Bfg(options) {
      this.options = options;
      this.data_loaded_callback = bind(this.data_loaded_callback, this);
      this.callback = null;
      this.options || (this.options = []);
      this.posts_loaded = false;
      this.post_loaded = false;
      this.posts = [];
      if (!this.options['api'] || !this.options['user']) {
        throw 'Cannot load BFG+ because of wrong initial params';
      }
    }

    Bfg.prototype.get_records = function(count, callback) {
      var url, xmlhttp;
      this.callback = callback;
      this.processed_posts = [];
      this.posts_loaded = false;
      count = parseInt(count) || 100;
      xmlhttp = this.getXmlHttp();
      url = 'https://www.googleapis.com/plus/v1/people/' + this.options['user'] + '/activities/public?maxResults=' + count + '&key=' + this.options['api'];
      xmlhttp.open('GET', url, true);
      xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState === 4) {
          console.log(xmlhttp.readyState);
          console.log(xmlhttp.status);
          if (xmlhttp.status === 200) {
            this.data_loaded_callback(xmlhttp.responseText);
            return this.posts_loaded = true;
          }
        }
      };
      return xmlhttp.send(null);
    };

    Bfg.prototype.data_loaded_callback = function(data) {
      var converted_data, post;
      converted_data = JSON.parse(data);
      this.posts = converted_data['items'];
      if (this.posts.length > 0) {
        this.processed_posts = (function() {
          var i, len, ref, results;
          ref = this.posts;
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            post = ref[i];
            if (post['provider']['title'] !== 'Google Check-ins') {
              results.push(this.process_post(post));
            }
          }
          return results;
        }).call(this);
      }
      if (isFunction(this.callback)) {
        this.callback(this.processed_posts);
      }
      return true;
    };

    Bfg.prototype.process_post = function(post) {
      var defined_post;
      if (!post) {
        return false;
      }
      return defined_post = new Post(post);
    };

    Bfg.prototype.isFunction = function(functionToCheck) {
      var getType;
      getType = {};
      return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
    };

    Bfg.prototype.getXmlHttp = function() {
      var E, e, xmlhttp;
      xmlhttp = null;
      try {
        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
      } catch (_error) {
        e = _error;
        try {
          xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (_error) {
          E = _error;
          xmlhttp = false;
        }
      }
      if (!xmlhttp && typeof XMLHttpRequest !== 'undefined') {
        xmlhttp = new XMLHttpRequest();
      }
      return xmlhttp;
    };

    return Bfg;

  })();

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.Bfg = Bfg;

}).call(this);
