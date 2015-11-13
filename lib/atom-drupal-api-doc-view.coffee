{Range, CompositeDisposable}  = require 'atom'
{$, $$, ScrollView} = require 'atom-space-pen-views'
{View} = require 'space-pen'

module.exports =
class AtomDrupalApiDocView extends ScrollView
  item : ''

  initialize:(item) ->
    super
    @item = item
    @panel ?= atom.workspace.addRightPanel(item: @)
    @panel.show()

  @content: ->
    @div id: 'doc-view', =>
      @button('close api'
        id: 'doc-view-close',
      )
      @tag( 'webview'
        id: 'doc-view-frame',
        tabindex: -1,
      )

  attached: ->
    @webview = @element.querySelector('webview')
    @webview.src = 'https://api.drupal.org/apis/' + @item
    $this = @
    element = @element.querySelector('button')
    destroyCallback = =>
      $this.destroy()

    $(element).on 'click', destroyCallback

  destroy: ->
    @element.remove()
