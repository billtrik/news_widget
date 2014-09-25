window.Widget = Ember.Application.create();

Widget.Router.map(function() {
  return this.resource('stories');
});

Widget.IndexRoute = Ember.Route.extend({
  redirect: function() {
    return this.transitionTo('stories');
  }
});

Widget.StoriesRoute = Ember.Route.extend({
  model: function() {
    return Widget.Story.all();
  },
  afterModel: function() {
    return $('#loader').fadeOut();
  }
});

Widget.Story = Ember.Object.extend();

Widget.Story.reopenClass({
  url: 'http://pipes.yahoo.com/pipes/pipe.run?_id=DqsF_ZG72xGLbes9l7okhQ&_render=json&_callback=?',
  all: function(count) {
    if (count == null) {
      count = 10;
    }
    return $.getJSON(Widget.Story.url).then(function(response) {
      var img, index, item, items, _i, _len, _ref;
      items = [];
      _ref = response.value.items;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        item = _ref[index];
        img = item['media:content'] || item['media:thumbnail'] || null;
        img = img ? img.url : 'img/no_image.gif';
        items.push(Widget.Story.create({
          id: index,
          title: item.title,
          date: new Date(item.pubDate),
          summary: item.description,
          link: item.link,
          img_link: img
        }));
      }
      this._items = items;
      return items.slice(0, count);
    });
  }
});

Widget.StoryController = Ember.ObjectController.extend({
  actions: {
    toggle: function() {
      return this.set('isToggled', !this.get('isToggled'));
    }
  },
  isToggled: false,
  className: (function() {
    return "story" + (this.get('isToggled') ? ' toggled' : '');
  }).property('isToggled'),
  formattedDate: (function() {
    return moment(this.get('date')).fromNow();
  }).property('date')
});

Ember.Handlebars.registerBoundHelper('strip_tags', function(txt) {
  var div, script_stripped;
  script_stripped = new Handlebars.SafeString(txt).string;
  div = document.createElement('div');
  div.innerHTML = script_stripped;
  return div.innerText;
});
