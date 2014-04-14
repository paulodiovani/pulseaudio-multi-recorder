# Requirements
command = require('./command')
blessed = require('blessed')

#create a screen object
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

  # The class constructor
  constructor: ->
    # Quit on Escape, q, or Control-C.
    screen.key ['escape', 'q', 'C-c'], (ch, key) ->
      process.exit 0

    # creates the body
    @body = blessed.box(
      top: 0
      left: 'center'
      width: '100%'
      height: '100%'
      tags: true
      border:
        type: 'line'
    )
    @set_body_content ""
    screen.append @body

  ###
  # Start the application
  ###
  start: ->
    @actions_menu()
    @

  ###
  # Set the body (text) content, keeping the title
  # @param {String} text
  ###
  set_body_content: (text) ->
    @body.setContent "{center}
      {bold}#{@title}{/bold}\n\n
      #{text}
      {/center}"
    @

  ###
  # Show the main, actions menu
  ###
  actions_menu: ->
    # @set_body_content "Please, select an option below."
    menu_items = [
      'List sinks'
      'List sink inputs'
      'List sources'
      'List source outputs'
      'Record audio from source'
    ]

    menu = blessed.list(
      keys: true
      mouse: true
      align: 'center'
      top: 4
      left: 'center'
      width: 50
      height: 7
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

    menu.prepend(blessed.text(
      top: -1
      left: 'center'
      content: 'Main menu'
    ))


    menu.on 'select', @on_action_selected

    @body.append menu
    menu.focus()
    menu.select(0)
    screen.render()
    @

  on_action_selected: (item, index) ->
    console.log index
    # process.exit 0

module.exports = new Ui()