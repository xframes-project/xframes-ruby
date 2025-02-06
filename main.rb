require 'ffi'
require 'json'
require 'eventmachine'
require_relative 'theme'
require_relative 'sampleapp'
require_relative 'services'
require_relative 'treetraversal'
require_relative 'xframes'

# Colors for theme generation
theme2Colors = {
  darkestGrey: "#141f2c",
  darkerGrey: "#2a2e39",
  darkGrey: "#363b4a",
  lightGrey: "#5a5a5a",
  lighterGrey: "#7A818C",
  evenLighterGrey: "#8491a3",
  black: "#0A0B0D",
  green: "#75f986",
  red: "#ff0062",
  white: "#fff"
}

theme2 = {
    colors: {
        ImGuiCol[:Text] => [theme2Colors[:white], 1],
        ImGuiCol[:TextDisabled] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:WindowBg] => [theme2Colors[:black], 1],
        ImGuiCol[:ChildBg] => [theme2Colors[:black], 1],
        ImGuiCol[:PopupBg] => [theme2Colors[:white], 1],
        ImGuiCol[:Border] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:BorderShadow] => [theme2Colors[:darkestGrey], 1],
        ImGuiCol[:FrameBg] => [theme2Colors[:black], 1],
        ImGuiCol[:FrameBgHovered] => [theme2Colors[:darkerGrey], 1],
        ImGuiCol[:FrameBgActive] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:TitleBg] => [theme2Colors[:darkGrey], 1],
        ImGuiCol[:TitleBgActive] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:TitleBgCollapsed] => [theme2Colors[:darkGrey], 1],
        ImGuiCol[:MenuBarBg] => [theme2Colors[:darkerGrey], 1],
        ImGuiCol[:ScrollbarBg] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:ScrollbarGrab] => [theme2Colors[:darkestGrey], 1],
        ImGuiCol[:ScrollbarGrabHovered] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:ScrollbarGrabActive] => [theme2Colors[:black], 1],
        ImGuiCol[:CheckMark] => [theme2Colors[:black], 1],
        ImGuiCol[:SliderGrab] => [theme2Colors[:darkerGrey], 1],
        ImGuiCol[:SliderGrabActive] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:Button] => [theme2Colors[:black], 1],
        ImGuiCol[:ButtonHovered] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:ButtonActive] => [theme2Colors[:black], 1],
        ImGuiCol[:Header] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:HeaderHovered] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:HeaderActive] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:Separator] => [theme2Colors[:darkestGrey], 1],
        ImGuiCol[:SeparatorHovered] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:SeparatorActive] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:ResizeGrip] => [theme2Colors[:black], 1],
        ImGuiCol[:ResizeGripHovered] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:ResizeGripActive] => [theme2Colors[:darkerGrey], 1],
        ImGuiCol[:Tab] => [theme2Colors[:black], 1],
        ImGuiCol[:TabHovered] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:TabActive] => [theme2Colors[:darkerGrey], 1],
        ImGuiCol[:TabUnfocused] => [theme2Colors[:darkGrey], 1],
        ImGuiCol[:TabUnfocusedActive] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:PlotLines] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:PlotLinesHovered] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:PlotHistogram] => [theme2Colors[:lightGrey], 1],
        ImGuiCol[:PlotHistogramHovered] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:TableHeaderBg] => [theme2Colors[:black], 1],
        ImGuiCol[:TableBorderStrong] => [theme2Colors[:lighterGrey], 1],
        ImGuiCol[:TableBorderLight] => [theme2Colors[:darkGrey], 1],
        ImGuiCol[:TableRowBg] => [theme2Colors[:darkerGrey], 1],
        ImGuiCol[:TableRowBgAlt] => [theme2Colors[:darkestGrey], 1],
        ImGuiCol[:TextSelectedBg] => [theme2Colors[:darkerGrey], 1],
        ImGuiCol[:DragDropTarget] => [theme2Colors[:darkGrey], 1],
        ImGuiCol[:NavHighlight] => [theme2Colors[:darkerGrey], 1],
        ImGuiCol[:NavWindowingHighlight] => [theme2Colors[:darkerGrey], 1],
        ImGuiCol[:NavWindowingDimBg] => [theme2Colors[:darkestGrey], 1],
        ImGuiCol[:ModalWindowDimBg] => [theme2Colors[:darkestGrey], 1]
    }
}

base_font_defs = {
  defs: [
    { name: "roboto-regular", sizes: [16, 18, 20, 24, 28, 32, 36, 48] }
  ]
}

font_size_pairs = base_font_defs[:defs].flat_map { |font|
  font[:sizes].map { |size| { name: font[:name], size: size } }
}

font_defs_json = JSON.pretty_generate(defs: font_size_pairs)
theme_json = JSON.pretty_generate(theme2)

class Node
    attr_accessor :id, :root
  
    def initialize(id, root)
      @type = 'node'
      @id = id
      @root = root
    end
  
    def to_json(*options)
      {
        type: @type,
        id: @id,
        root: @root
      }.to_json(*options)
    end
  end

  class UnformattedText
      attr_accessor :id, :text
    
      def initialize(id, text)
        @type = 'unformatted-text'
        @id = id
        @text = text
      end
    
      def to_json(*options)
        {
          type: @type,
          id: @id,
          text: @text
        }.to_json(*options)
      end
    end



on_init = FFI::Function.new(:void, []) do
  puts "OnInit called!"

  node = Node.new(0, true)
  unformatted_text = UnformattedText.new(1, "Hello, world")

  children_ids = [1]

  XFrames.setElement(node.to_json)
  XFrames.setElement(unformatted_text.to_json)

  XFrames.setChildren(0, children_ids.to_json)
end

on_text_changed = FFI::Function.new(:void, [:int, :string]) do |id, text|
  puts "Text changed: ID=#{id}, Text=#{text}"
end

on_combo_changed = FFI::Function.new(:void, [:int, :int]) do |id, selected_index|
  puts "Combo changed: ID=#{id}, Selected=#{selected_index}"
end

on_numeric_value_changed = FFI::Function.new(:void, [:int, :float]) do |id, value|
  puts "Numeric value changed: ID=#{id}, Value=#{value}"
end

on_boolean_value_changed = FFI::Function.new(:void, [:int, :int]) do |id, state|
  puts "Boolean value changed: ID=#{id}, State=#{state}"
end

on_multiple_numeric_values_changed = FFI::Function.new(:void, [:int, :pointer, :int]) do |id, values_ptr, num_values|
  # Dereference the float array (you may need additional code to handle this)
  puts "Multiple numeric values changed: ID=#{id}, NumValues=#{num_values}"
end

on_click = FFI::Function.new(:void, [:int]) do |id|
  puts "Button clicked: ID=#{id}"
end

# Call init with callbacks
assets_base_path = './assets'
XFrames.init(
  assets_base_path,
  font_defs_json,
  theme_json,
  on_init,
  on_text_changed,
  on_combo_changed,
  on_numeric_value_changed,
  on_boolean_value_changed,
  on_multiple_numeric_values_changed,
  on_click
)

EM.run do
  EM.add_periodic_timer(1) {  }
end

