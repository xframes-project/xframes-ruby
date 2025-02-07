require 'json'
require 'rx'
require 'thread'
require_relative 'xframes'

class WidgetRegistrationService
  def initialize
    @id_generator_lock = Mutex.new
    @id_widget_registration_lock = Mutex.new
    @id_event_registration_lock = Mutex.new

    @events_subject = Rx::ReplaySubject.new(10)
    # @events_subject.debounce(0.001).subscribe { |fn| fn.call }

    @widget_registry = {}
    @on_click_registry = Rx::BehaviorSubject.new({})

    @last_widget_id = 0
    @last_component_id = 0
  end

  def get_widget_by_id(widget_id)
    @id_widget_registration_lock.synchronize do
      @widget_registry[widget_id]
    end
  end

  def register_widget(widget_id, widget)
    @id_widget_registration_lock.synchronize do
      @widget_registry[widget_id] = widget
    end
  end

  def get_next_widget_id
    @id_generator_lock.synchronize do
      widget_id = @last_widget_id
      @last_widget_id += 1
      widget_id
    end
  end

  def get_next_component_id
    @id_generator_lock.synchronize do
      component_id = @last_component_id
      @last_component_id += 1
      component_id
    end
  end

  def register_on_click(widget_id, on_click)
    @id_event_registration_lock.synchronize do
      new_registry = @on_click_registry.value.dup
      new_registry[widget_id] = on_click
      @on_click_registry.on_next(new_registry)
    end
  end

  def dispatch_on_click_event(widget_id)
    on_click = @on_click_registry.value[widget_id]
    if on_click
      @events_subject.on_next(on_click)
    else
      puts "Widget with id #{widget_id} has no on_click handler"
    end
  end

  def create_widget(widget)
    widget_json = widget.to_serializable_hash.to_json
    set_element(widget_json)
  end

  def patch_widget(widget_id, widget)
    widget_json = widget.to_json
    patch_element(widget_id, widget_json)
  end

  def link_children(widget_id, child_ids)
    children_json = child_ids.to_json
    set_children(widget_id, children_json)
  end

  def set_data(widget_id, data)
    data_json = data.to_json
    element_internal_op(widget_id, data_json)
  end

  def append_data(widget_id, data)
    data_json = data.to_json
    element_internal_op(widget_id, data_json)
  end

  def reset_data(widget_id)
    data_json = "".to_json
    element_internal_op(widget_id, data_json)
  end

  def append_data_to_plot_line(widget_id, x, y)
    plot_data = { x: x, y: y }
    element_internal_op(widget_id, plot_data.to_json)
  end

  def set_plot_line_axes_decimal_digits(widget_id, x, y)
    axes_data = { x: x, y: y }
    element_internal_op(widget_id, axes_data.to_json)
  end

  def append_text_to_clipped_multi_line_text_renderer(widget_id, text)
    extern_append_text(widget_id, text)
  end

  def set_input_text_value(widget_id, value)
    input_text_data = { value: value }
    element_internal_op(widget_id, value)
  end

  def set_combo_selected_index(widget_id, index)
    selected_index_data = { index: index }
    element_internal_op(widget_id, selected_index_data.to_json)
  end

  private

  def set_element(json_data)
    XFrames.setElement(json_data)
  end

  def patch_element(widget_id, json_data)
    # Implement patch logic if needed
  end

  def set_children(widget_id, json_data)
    XFrames.setChildren(widget_id, json_data)
  end

  def element_internal_op(widget_id, json_data)
    # Implement internal operation if needed
  end

  def extern_append_text(widget_id, text)
    # Handle external append text logic
  end
end
