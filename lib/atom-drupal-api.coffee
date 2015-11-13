AtomDrupalApiView = require './atom-drupal-api-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomDrupalApi =
  atomDrupalApiView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomDrupalApiView = new AtomDrupalApiView(state.atomDrupalApiViewState, @)
    @modalPanel = atom.workspace.addModalPanel(
      item: @atomDrupalApiView.getElement(), visible: false
    )

    # Events subscribed to in atom's system
    # can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'atom-drupal-api:toggle': => @toggle(),

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomDrupalApiView.destroy()

  serialize: ->
    atomDrupalApiViewState: @atomDrupalApiView.serialize()

  toggleSub: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  toggle: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      if selection
        selection = selection.trim()
      if selection != ''
        @atomDrupalApiView.setSelection selection
      else
        @toggleSub()
    else @toggleSub()
