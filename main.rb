require 'ffi'
require 'json'
require 'eventmachine'

# ImGui colors as per your original mapping
ImGuiCol = {
  Text: 0,
  TextDisabled: 1,
  WindowBg: 2,
  ChildBg: 3,
  PopupBg: 4,
  Border: 5,
  BorderShadow: 6,
  FrameBg: 7,
  FrameBgHovered: 8,
  FrameBgActive: 9,
  TitleBg: 10,
  TitleBgActive: 11,
  TitleBgCollapsed: 12,
  MenuBarBg: 13,
  ScrollbarBg: 14,
  ScrollbarGrab: 15,
  ScrollbarGrabHovered: 16,
  ScrollbarGrabActive: 17,
  CheckMark: 18,
  SliderGrab: 19,
  SliderGrabActive: 20,
  Button: 21,
  ButtonHovered: 22,
  ButtonActive: 23,
  Header: 24,
  HeaderHovered: 25,
  HeaderActive: 26,
  Separator: 27,
  SeparatorHovered: 28,
  SeparatorActive: 29,
  ResizeGrip: 30,
  ResizeGripHovered: 31,
  ResizeGripActive: 32,
  Tab: 33,
  TabHovered: 34,
  TabActive: 35,
  TabUnfocused: 36,
  TabUnfocusedActive: 37,
  PlotLines: 38,
  PlotLinesHovered: 39,
  PlotHistogram: 40,
  PlotHistogramHovered: 41,
  TableHeaderBg: 42,
  TableBorderStrong: 43,
  TableBorderLight: 44,
  TableRowBg: 45,
  TableRowBgAlt: 46,
  TextSelectedBg: 47,
  DragDropTarget: 48,
  NavHighlight: 49,
  NavWindowingHighlight: 50,
  NavWindowingDimBg: 51,
  ModalWindowDimBg: 52,
  COUNT: 53
}

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

# Generate font definitions
base_font_defs = {
  defs: [
    { name: "roboto-regular", sizes: [16, 18, 20, 24, 28, 32, 36, 48] }
  ]
}

# Generate font size pairs
font_size_pairs = base_font_defs[:defs].flat_map { |font|
  font[:sizes].map { |size| { name: font[:name], size: size } }
}

# JSON for font_defs and theme
font_defs_json = JSON.pretty_generate(defs: font_size_pairs)
theme_json = JSON.pretty_generate(theme2)

# Print the generated JSON for font definitions and theme
# puts "Font Definitions JSON:"
# puts font_defs_json
# puts "\nTheme JSON:"
# puts theme_json

class Node
    attr_accessor :id, :root
  
    # Initialize method to set the values for type and id
    def initialize(id, root)
      @type = 'node'
      @id = id
      @root = root
    end
  
    # Convert the object to JSON
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
    
      # Initialize method to set the values for type and id
      def initialize(id, text)
        @type = 'unformatted-text'
        @id = id
        @text = text
      end
    
      # Convert the object to JSON
      def to_json(*options)
        {
          type: @type,
          id: @id,
          text: @text
        }.to_json(*options)
      end
    end


module XFrames
  extend FFI::Library
  if RUBY_PLATFORM =~ /win32|mingw|cygwin/
    ffi_lib './xframesshared.dll'
  else
    ffi_lib './libxframesshared.so'
  end

  # Define callback types
  callback :OnInitCb, [:pointer], :void
  callback :OnTextChangedCb, [:int, :string], :void
  callback :OnComboChangedCb, [:int, :int], :void
  callback :OnNumericValueChangedCb, [:int, :float], :void
  callback :OnBooleanValueChangedCb, [:int, :int], :void
  callback :OnMultipleNumericValuesChangedCb, [:int, :pointer, :int], :void
  callback :OnClickCb, [:int], :void

  attach_function :init, [
    :string,        # assetsBasePath
    :string,        # rawFontDefinitions
    :string,        # rawStyleOverrideDefinitions
    :OnInitCb,
    :OnTextChangedCb,
    :OnComboChangedCb,
    :OnNumericValueChangedCb,
    :OnBooleanValueChangedCb,
    :OnMultipleNumericValuesChangedCb,
    :OnClickCb
  ], :void

  attach_function :setElement, [:string], :void

  attach_function :setChildren, [:int, :string], :void
end

# Callback implementations
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

