require 'rx'
require 'json'
require_relative 'theme'
require_relative 'widgettypes'

class BaseComponent
  def initialize(props)
    @props = Rx::BehaviorSubject.new(props)
  end

  # Abstract method to be overridden
  def render
    raise NotImplementedError, 'You must implement the render method'
  end
end

class WidgetNode
  attr_accessor :type, :props, :children

  def initialize(type, props = {}, children = [])
    @type = type
    @props = Rx::BehaviorSubject.new(props)
    @children = Rx::BehaviorSubject.new(children)
  end
end

class RawChildlessWidgetNodeWithId
  attr_reader :id, :type, :props

  def initialize(id, type, props = {})
    @id = id
    @type = type
    @props = props
  end

  def to_hash
    out = {
      'id' => @id,
      'type' => @type.to_s
    }

    @props.each do |key, value|
      unless value.is_a?(Proc) 
        if (value.is_a?(WidgetStyleDef) || value.is_a?(NodeStyleDef))
          out[key] = value.to_hash
        else
          out[key] = value
        end
      end
    end

    out
  end
end

def widget_node_factory(widget_type, props = {}, children = [])
  WidgetNode.new(widget_type, props, children)
end

def create_raw_childless_widget_node_with_id(id, node)
  RawChildlessWidgetNodeWithId.new(id, node.type, node.props.value)
end

def init_props_with_style(style = nil)
  props = {}

  if style
    props['style'] = style.style if style.style
    props['activeStyle'] = style.active_style if style.active_style
    props['hoverStyle'] = style.hover_style if style.hover_style
    props['disabledStyle'] = style.disabled_style if style.disabled_style
  end

  props
end

def root_node(children, style = nil)
  props = init_props_with_style(style)
  props['root'] = true

  widget_node_factory(WidgetTypes[:Node], props, children)
end

def node(children, style = nil)
  props = init_props_with_style(style)
  props['root'] = false

  widget_node_factory(WidgetTypes[:Node], props, children)
end

def unformatted_text(text, style = nil)
  props = init_props_with_style(style)
  props['text'] = text

  widget_node_factory(WidgetTypes[:UnformattedText], props, [])
end

def button(label, on_click = nil, style = nil)
  raise TypeError, 'on_click must be a callable' if on_click && !on_click.is_a?(Proc)

  props = init_props_with_style(style)
  props['label'] = label
  props['on_click'] = on_click if on_click

  widget_node_factory(WidgetTypes[:Button], props, [])
end

