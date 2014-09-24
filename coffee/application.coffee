window.Widget = Ember.Application.create()

Widget.Router.map ->
  @resource('stories')

Widget.IndexRoute = Ember.Route.extend
  redirect: ->
   @transitionTo('stories')

Widget.StoriesRoute = Ember.Route.extend
  model: -> Widget.Story.all()

Widget.Story = Ember.Object.extend()
Widget.Story.reopenClass
  url: 'http://pipes.yahoo.com/pipes/pipe.run?_id=DqsF_ZG72xGLbes9l7okhQ&_render=json&_callback=?'
  all: (count = 10)-> $.getJSON(Widget.Story.url).then (response)->
    items = []

    for item, index in response.value.items
      img = item['media:content'] or item['media:thumbnail'] or null
      img = if img then img.url else 'img/no_image.gif'

      items.push Widget.Story.create
        id: index
        title: item.title
        date: new Date(item.pubDate)
        summary: item.description
        link: item.link
        img_link: img

    @_items = items
    items.slice(0, count)

Widget.StoryController = Ember.ObjectController.extend
  actions:
    toggle: -> @set 'isToggled', !@get('isToggled')

  isToggled: false

  className: (-> "story#{if @get('isToggled') then ' toggled' else ''}").property('isToggled')

  formattedDate: (-> moment(@get('date')).fromNow()
  ).property('date')

Ember.Handlebars.registerBoundHelper 'strip_tags', (txt)->
  script_stripped = new Handlebars.SafeString(txt).string
  div = document.createElement('div')
  div.innerHTML = script_stripped
  div.innerText