{Range, CompositeDisposable}  = require 'atom'
{$, $$, ScrollView} = require 'atom-space-pen-views'
{$, View} = require 'space-pen'

module.exports =
class AtomDrupalApiDocView extends ScrollView
  init = false

  initialize: ->
    super
    if !init
      init = true
      @panel ?= atom.workspace.addRightPanel(item: @)
      @panel.show()

  @content: ->
    @div id: 'doc-view', =>
      @iframe(
        id: 'doc-view-frame',
        name: 'disable-x-frame-options',
        tabindex: -1,
        src: ""
      )

  setKeyword: (item) ->
    @.find('#doc-view-frame').attr('src', 'https://api.drupal.org/apis/' + item)
    #@reloadIframe()

  reloadIframe: () ->
    if ( @.find('#doc-view-frame')[0].contentDocument )
      @.find('#doc-view-frame')[0].contentDocument.location.reload(true)
