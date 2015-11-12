{Range, CompositeDisposable}  = require 'atom'
{$, $$, SelectListView} = require 'atom-space-pen-views'
{$, View} = require 'space-pen'

module.exports =
class AtomDrupalApiView extends SelectListView
  maxItems = 20
  oldQuery = false

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  initialize: ->
    super
    @subscriptions = new CompositeDisposable
    @setItems([])

  populateList: ->
    filterQuery = @getFilterQuery()
    if filterQuery != '' && filterQuery != @oldQuery
      @alternatPopulateList()
      super


  alternatPopulateList: ->
    $this = @
    @list.empty()
    filterQuery =  @oldQuery  = @getFilterQuery()
    $.get('https://api.drupal.org/api/suggest/' + filterQuery,(data) ->
      $this.setItems data[1]
      filteredItems = data[1]

      if filteredItems.length
        filteredItems.forEach (item) ->
          itemView = $($this.viewForItem(item))
          itemView.data('select-list-item', item)
          $this.list.append(itemView)

      else
        $this.setError(
          $this.getEmptyMessage(@items.length, filteredItems.length))
    )

  confirmSelection: ->
    item = @getSelectedItem()
    console.log item

  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    console.log("#{item} was selected")

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
