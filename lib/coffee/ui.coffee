# Requirements
command = require('./command')
blessed = require('blessed')
screen  = blessed.screen()

class Ui
  ###
  # The app title that should appear on body
  ###
  title: "Pulseaudio Multi Recorder"

  ###
  # Main app body
  ###
  body: null

  ###
  # Main app menu
  ###
  @menu: null

  # The class constructor
  constructor: ->
    # Quit on Escape, q, or Control-C.
    screen.key ['escape', 'q', 'C-c'], (ch, key) ->
      process.exit 0

    # creates the body
    @body = blessed.box(
      parent: screen
      top: 0
      left: 'center'
      width: '100%'
      height: '100%'
      tags: true
      border:
        type: 'line'
      content: "{center}{bold}#{@title}{/bold}{/center}"
    )

  ###
  # Start the application
  ###
  start: ->
    @actions_menu()
    @

  ###
  # Show the main, actions menu
  ###
  actions_menu: ->
    menu_items = [
      'List sinks'
      'List sink inputs'
      'List sources'
      'List source outputs'
      'Record audio from source'
      'Exit'
    ]

    @menu = blessed.list(
      parent: @body
      keys: true
      mouse: true
      align: 'center'
      top: 4
      left: 'center'
      width: 50
      height: 8
      border:
        type: 'line'
      style:
        selected:
          inverse: true
      scrollbar:
        ch: ' '
        style:
          inverse: true
      items: menu_items
    )

    @menu.prepend(blessed.text(
      top: 0
      left: 'center'
      content: 'Main menu'
    ))

    @menu.on 'select', @on_action_selected

    @menu.focus()
    screen.render()
    @

  ###
  # Callback for main menu item selected
  ###
  on_action_selected: (item, index) =>
    switch index
      when 0
        command.list_sinks @action_list
      when 2
        command.list_sources @action_list
      when 5
        process.exit 0

  ###
  # Action list items (sinks, sources, etc)
  # @param {String} err
  # @param {Object[]} data
  ###
  action_list: (err, data) =>
    if (err)
      @render_error err
      return

    # Concats the data content
    content = ""
    data.forEach (it) ->
      content = content.concat(
        "#{it.index} - #{it.description}\n"
      )

    # creates a box for showing the items list
    listbox = blessed.box(
      parent: @body
      top: 'center'
      left: 'center'
      width: '80%'
      height: '50%'
      tags: true
      border:
        type: 'line'
      scrollbar:
        ch: ' '
        style:
          inverse: true
      content: content
    )

    # Adds an "ok" button to the box
    okbutton = blessed.button(
      parent: listbox
      keys: true
      mouse: true
      bottom: 1
      left: 'center'
      shrink: true
      padding:
        left: 1
        right: 1
      style:
        inverse: true
        hover:
          inverse: false
      content: 'Ok'
    )

    # Ok button closes the box
    okbutton.on 'press', =>
      listbox.detach()
      @menu.focus()
      screen.render()

    okbutton.focus()
    screen.render()

module.exports = new Ui()