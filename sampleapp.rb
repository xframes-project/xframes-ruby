require 'rx'
require_relative 'theme'
require_relative 'widgetnode'
require 'thread'
require 'concurrent-ruby'

class TodoItem
  attr_accessor :text, :done

  def initialize(text, done)
    @text = text
    @done = done
  end
end

class AppState
  attr_accessor :todo_text, :todo_items

  def initialize(todo_text, todo_items)
    @todo_text = todo_text
    @todo_items = todo_items
  end
end

$sample_app_state = Rx::BehaviorSubject.new(AppState.new("", []))

def on_click
  promise = Concurrent::Promise.execute do
    new_todo_item = TodoItem.new("New Todo", false)
    current_state = $sample_app_state.value
    new_state = AppState.new(
      current_state.todo_text,
      current_state.todo_items + [new_todo_item]
    )
    $sample_app_state.on_next(new_state)
  end

  promise.wait
end

$text_style = WidgetStyle.new(
  style: WidgetStyleDef.new(
    style_rules: StyleRules.new(
      font: FontDef.new(name: "roboto-regular", size: 32)
    )
  )
)

$button_style = WidgetStyle.new(
  style: WidgetStyleDef.new(
    style_rules: StyleRules.new(
      font: FontDef.new(name: "roboto-regular", size: 32)
    ),
    layout: YogaStyle.new(
      width: "50%",
      padding: {Edge[:Vertical] => 10},
      margin: {Edge[:Left] => 140}
    )
  )
)

class App < BaseComponent
  def initialize
    super({})

    promise = Concurrent::Promise.execute do
      $sample_app_state.subscribe do |latest_app_state|
        puts "app state changed"

        @props.on_next({
          "todo_text" => latest_app_state.todo_text,
          "todo_items" => latest_app_state.todo_items
        })
      end
    end
    
    promise.wait

    @props.on_next({
      "todo_text" => "",
      "todo_items" => [TodoItem.new("New Todo", false)]
    })
  end

  def render
    children = [button("Add todo", Proc.new {
      on_click()
    }, $button_style)]

    promise = Concurrent::Promise.execute do
      @props.value["todo_items"].each do |todo_item|
        text = "#{todo_item.text} (#{todo_item.done ? 'done' : 'to do'})."
        children << unformatted_text(text, $text_style)
      end
    end

    promise.wait

    node(children)
  end

  def dispose
    @app_state_subscription.dispose
  end
end

class Root < BaseComponent
  def initialize
    super({})
  end

  def render
    root_node([App.new])
  end
end
