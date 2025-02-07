require 'rx'
require 'json'
require_relative 'widgetnode'
require_relative 'widgettypes'
require_relative 'services'

class ShadowNode
  attr_accessor :id, :renderable, :current_props, :children, :props_change_subscription, :children_change_subscription

  def initialize(id, renderable)
    @id = id
    @renderable = renderable
    @current_props = {}
    @children = []
    @props_change_subscription = nil
    @children_change_subscription = nil
  end

  def to_hash
    {
      "id" => @id,
      "current_props" => @current_props,
      "children" => @children.map(&:to_hash)
    }
  end

  def get_linkable_children
    out = []
    @children.each do |child|
      next if child.nil? || child.renderable.nil?

      if child.renderable.is_a?(WidgetNode)
        out << child
      elsif !child.children.empty?
        out.concat(child.get_linkable_children)
      end
    end
    out
  end
end

class ShadowNodeTraversalHelper
  def initialize(widget_registration_service)
    @widget_registration_service = widget_registration_service
  end

  def are_props_equal(props1, props2)
    props1 == props2
  end

  def subscribe_to_props_helper(shadow_node)
    if shadow_node.props_change_subscription
      shadow_node.props_change_subscription.dispose
    end

    return nil

    if shadow_node.renderable.is_a?(BaseComponent)
      component = shadow_node.renderable
      shadow_node.props_change_subscription = component.props.pipe(
        Rx::Operators.skip(1)
      ).subscribe { |new_props| handle_component_props_change(shadow_node, component, new_props) }
    elsif shadow_node.renderable.is_a?(WidgetNode)
      shadow_node.props_change_subscription = shadow_node.renderable.props.pipe(
        Rx::Operators.skip(1)
      ).subscribe { |new_props| handle_widget_node_props_change(shadow_node, shadow_node.renderable, new_props) }
    end
  end

  def handle_widget_node(widget)
    if widget.type == WidgetTypes[:Button]
      on_click = widget.props["on_click"]
      if on_click
        @widget_registration_service.register_on_click(widget.id, on_click)
      else
        puts "Button widget must have on_click prop"
      end
    end
  end

  def handle_component_props_change(shadow_node, component, new_props)
    return if are_props_equal(shadow_node.current_props, new_props)

    shadow_child = component.render
    shadow_node.children = [traverse_tree(shadow_child)]
    shadow_node.current_props = new_props

    linkable_children = shadow_node.get_linkable_children
    @widget_registration_service.link_children(shadow_node.id, linkable_children.map(&:id))
  end

  def handle_widget_node_props_change(shadow_node, widget_node, new_props)
    @widget_registration_service.create_widget(
      WidgetNode.create_raw_childless_widget_node_with_id(shadow_node.id, widget_node)
    )

    shadow_children = widget_node.children.map { |child| traverse_tree(child) }
    shadow_node.children = shadow_children
    shadow_node.current_props = new_props

    @widget_registration_service.link_children(shadow_node.id, shadow_node.children.map(&:id))
  end

  def traverse_tree(renderable)
    puts "a"

    if renderable.is_a?(BaseComponent)
      puts "b"
      rendered_child = renderable.render
      shadow_child = traverse_tree(rendered_child)
      puts "c"
      id = @widget_registration_service.get_next_component_id
      puts "d"
      shadow_node = ShadowNode.new(id, renderable)
      puts "e"
      shadow_node.children = [shadow_child]
      puts "f"
      # shadow_node.current_props = renderable.props.value
      puts "g"
      subscribe_to_props_helper(shadow_node)
      puts "h"
      return shadow_node
    elsif renderable.is_a?(WidgetNode)
      puts "i"
      id = @widget_registration_service.get_next_widget_id
      puts "j"
      raw_node = create_raw_childless_widget_node_with_id(id, renderable)
      puts "k"
      handle_widget_node(raw_node)
      puts "l"
      @widget_registration_service.create_widget(raw_node)
      puts "m"

      shadow_node = ShadowNode.new(id, renderable)
      puts "n"
      shadow_node.children = renderable.children.value.map { |child| traverse_tree(child) }
      puts "o"
      shadow_node.current_props = renderable.props.value
      puts "p"

      linkable_children = shadow_node.get_linkable_children
      puts "q"
      if !linkable_children.empty?
        puts "r"
        @widget_registration_service.link_children(id, linkable_children.map(&:id))
      end

      puts "s"

      subscribe_to_props_helper(shadow_node)

      puts "t"
      return shadow_node
    else
      raise 'Unrecognised renderable'
    end
  end
end
