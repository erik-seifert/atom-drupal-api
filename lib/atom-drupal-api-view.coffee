{Range, CompositeDisposable}  = require 'atom'
{$, $$, SelectListView} = require 'atom-space-pen-views'
{$, View} = require 'space-pen'
DocView = require './atom-drupal-api-doc-view'

module.exports =
class AtomDrupalApiView extends SelectListView

  maxItems : 20
  oldQuery : false
  view : false
  isLoading : false
  inputThrottle : 1000
  parent : null

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  initialize: (state,parent) ->
    super
    @subscriptions = new CompositeDisposable
    @setItems([])
    @focusFilterEditor()
    inputThrottle = 1000
    @parent = parent

  populateLoadingList: ->
    $this = @
    filterQuery = @getFilterQuery()
    @list.empty()
    @setItems()

    @isLoading = true
    $.get('https://api.drupal.org/api/suggest/' + filterQuery,(data) ->

      $this.setItems data[1]
      $this.populateList()
      $this.isLoading = false
    )

  checkLoading: ->
    @isLoading

  setSelection:(text) ->
    if @view
      @view.destroy()
      @view = null

    @view = new DocView(text)

  schedulePopulateList: ->
    clearTimeout(@scheduleTimeout)
    populateCallback = =>
      @populateLoadingList() if @isOnDom() && !@checkLoading()
    @scheduleTimeout = setTimeout(populateCallback,  @inputThrottle)

  viewForItem: (item) ->
    $("<li>#{item}</li>")

  confirmed: (item) ->
    if @view
      @view.destroy()
      @view = null

    @view = new DocView(item)
    @parent.toggle()

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
