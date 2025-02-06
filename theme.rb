
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

ImPlotScale = {
  Linear: 0,
  Time: 1,
  Log10: 2,
  SymLog: 3
}

ImPlotMarker = {
  None_: -1,
  Circle: 0,
  Square: 1,
  Diamond: 2,
  Up: 3,
  Down: 4,
  Left: 5,
  Right: 6,
  Cross: 7,
  Plus: 8,
  Asterisk: 9
}

ImGuiStyleVar = {
  Alpha: 0,
  DisabledAlpha: 1,
  WindowPadding: 2,
  WindowRounding: 3,
  WindowBorderSize: 4,
  WindowMinSize: 5,
  WindowTitleAlign: 6,
  ChildRounding: 7,
  ChildBorderSize: 8,
  PopupRounding: 9,
  PopupBorderSize: 10,
  FramePadding: 11,
  FrameRounding: 12,
  FrameBorderSize: 13,
  ItemSpacing: 14,
  ItemInnerSpacing: 15,
  IndentSpacing: 16,
  CellPadding: 17,
  ScrollbarSize: 18,
  ScrollbarRounding: 19,
  GrabMinSize: 20,
  GrabRounding: 21,
  TabRounding: 22,
  TabBorderSize: 23,
  TabBarBorderSize: 24,
  TableAngledHeadersAngle: 25,
  TableAngledHeadersTextAlign: 26,
  ButtonTextAlign: 27,
  SelectableTextAlign: 28,
  SeparatorTextBorderSize: 29,
  SeparatorTextAlign: 30,
  SeparatorTextPadding: 31
}

Align = {
  Left: "left",
  Right: "right"
}

Direction = {
  Inherit: "inherit",
  Ltr: "ltr",
  Rtl: "rtl"
}

FlexDirection = {
  Column: "column",
  ColumnReverse: "column-reverse",
  Row: "row",
  RowReverse: "row-reverse"
}

JustifyContent = {
  FlexStart: "flex-start",
  Center: "center",
  FlexEnd: "flex-end",
  SpaceBetween: "space-between",
  SpaceAround: "space-around",
  SpaceEvenly: "space-evenly"
}

AlignContent = {
  Auto: "auto",
  FlexStart: "flex-start",
  Center: "center",
  FlexEnd: "flex-end",
  Stretch: "stretch",
  SpaceBetween: "space-between",
  SpaceAround: "space-around",
  SpaceEvenly: "space-evenly"
}

AlignItems = {
  Auto: "auto",
  FlexStart: "flex-start",
  Center: "center",
  FlexEnd: "flex-end",
  Stretch: "stretch",
  Baseline: "baseline"
}

AlignSelf = {
  Auto: "auto",
  FlexStart: "flex-start",
  Center: "center",
  FlexEnd: "flex-end",
  Stretch: "stretch",
  Baseline: "baseline"
}

PositionType = {
  Static: "static",
  Relative: "relative",
  Absolute: "absolute"
}

FlexWrap = {
  NoWrap: "no-wrap",
  Wrap: "wrap",
  WrapReverse: "wrap-reverse"
}

Overflow = {
  Visible: "visible",
  Hidden: "hidden",
  Scroll: "scroll"
}

Display = {
  Flex: "flex",
  DisplayNone: "none"
}

Edge = {
  Left: "left",
  Top: "top",
  Right: "right",
  Bottom: "bottom",
  Start: "start",
  End: "end",
  Horizontal: "horizontal",
  Vertical: "vertical",
  All: "all"
}

Gutter = {
  Column: "column",
  Row: "row",
  All: "all"
}

RoundCorners = {
  All: "all",
  TopLeft: "topLeft",
  TopRight: "topRight",
  BottomLeft: "bottomLeft",
  BottomRight: "bottomRight"
}

class FontDef
  attr_accessor :name, :size

  def initialize(name:, size:)
    @name = name
    @size = size
  end

  def to_hash
    { "name" => @name, "size" => @size }
  end
end

class ImVec2
  attr_accessor :x, :y

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def to_hash
    { "x" => @x, "y" => @y }
  end
end


class StyleRules
  attr_accessor :align, :font, :colors, :vars

  def initialize(align: nil, font: nil, colors: nil, vars: nil)
    @align = align
    @font = font
    @colors = colors
    @vars = vars
  end

  def to_hash
    out = {}

    out[:align] = @align if @align
    out[:font] = @font.to_hash if @font
    out[:colors] = @colors.transform_keys(&:to_s) if @colors
    out[:vars] = @vars.transform_keys(&:to_s) if @vars

    out
  end
end


class BorderStyle
  attr_reader :color, :thickness

  def initialize(color:, thickness: nil)
    @color = color
    @thickness = thickness
  end

  def to_hash
    out = { 'color' => @color }

    out['thickness'] = @thickness if @thickness

    out
  end
end


class YogaStyle
  attr_reader :direction, :flex_direction, :justify_content, :align_content,
              :align_items, :align_self, :position_type, :flex_wrap, :overflow,
              :display, :flex, :flex_grow, :flex_shrink, :flex_basis, :flex_basis_percent,
              :position, :margin, :padding, :gap, :aspect_ratio, :width,
              :min_width, :max_width, :height, :min_height, :max_height

  def initialize(direction: nil, flex_direction: nil, justify_content: nil, align_content: nil,
                 align_items: nil, align_self: nil, position_type: nil, flex_wrap: nil, overflow: nil,
                 display: nil, flex: nil, flex_grow: nil, flex_shrink: nil, flex_basis: nil, flex_basis_percent: nil,
                 position: nil, margin: nil, padding: nil, gap: nil, aspect_ratio: nil, width: nil,
                 min_width: nil, max_width: nil, height: nil, min_height: nil, max_height: nil)
    @direction = direction
    @flex_direction = flex_direction
    @justify_content = justify_content
    @align_content = align_content
    @align_items = align_items
    @align_self = align_self
    @position_type = position_type
    @flex_wrap = flex_wrap
    @overflow = overflow
    @display = display
    @flex = flex
    @flex_grow = flex_grow
    @flex_shrink = flex_shrink
    @flex_basis = flex_basis
    @flex_basis_percent = flex_basis_percent
    @position = position
    @margin = margin
    @padding = padding
    @gap = gap
    @aspect_ratio = aspect_ratio
    @width = width
    @min_width = min_width
    @max_width = max_width
    @height = height
    @min_height = min_height
    @max_height = max_height
  end

  def to_hash
    out = {}

    add_to_hash(out, 'direction', @direction)
    add_to_hash(out, 'flexDirection', @flex_direction)
    add_to_hash(out, 'justifyContent', @justify_content)
    add_to_hash(out, 'alignContent', @align_content)
    add_to_hash(out, 'alignItems', @align_items)
    add_to_hash(out, 'alignSelf', @align_self)
    add_to_hash(out, 'positionType', @position_type)
    add_to_hash(out, 'flexWrap', @flex_wrap)
    add_to_hash(out, 'overflow', @overflow)
    add_to_hash(out, 'display', @display)
    add_to_hash(out, 'flex', @flex)
    add_to_hash(out, 'flexGrow', @flex_grow)
    add_to_hash(out, 'flexShrink', @flex_shrink)
    add_to_hash(out, 'flexBasis', @flex_basis)
    add_to_hash(out, 'flexBasisPercent', @flex_basis_percent)
    add_to_hash_with_edges(out, 'position', @position)
    add_to_hash_with_edges(out, 'margin', @margin)
    add_to_hash_with_edges(out, 'padding', @padding)
    add_to_hash_with_gutters(out, 'gap', @gap)
    add_to_hash(out, 'aspectRatio', @aspect_ratio)
    add_to_hash(out, 'width', @width)
    add_to_hash(out, 'minWidth', @min_width)
    add_to_hash(out, 'maxWidth', @max_width)
    add_to_hash(out, 'height', @height)
    add_to_hash(out, 'minHeight', @min_height)
    add_to_hash(out, 'maxHeight', @max_height)

    out
  end

  private

  def add_to_hash(hash, key, value)
    hash[key] = value unless value.nil?
  end

  def add_to_hash_with_edges(hash, key, value)
    return if value.nil?

    hash[key] = value.transform_keys(&:to_s) if value.is_a?(Hash)
  end

  def add_to_hash_with_gutters(hash, key, value)
    return if value.nil?

    hash[key] = value.transform_keys(&:to_s) if value.is_a?(Hash)
  end
end

class BaseDrawStyle
  attr_accessor :background_color, :border, :border_top, :border_right, :border_bottom, :border_left, :rounding, :round_corners

  def initialize(background_color: nil, border: nil, border_top: nil, border_right: nil, border_bottom: nil, border_left: nil, rounding: nil, round_corners: nil)
    @background_color = background_color
    @border = border
    @border_top = border_top
    @border_right = border_right
    @border_bottom = border_bottom
    @border_left = border_left
    @rounding = rounding
    @round_corners = round_corners
  end

  def to_hash
    out = {}

    out['backgroundColor'] = @background_color if @background_color
    out['border'] = @border.to_hash if @border
    out['borderTop'] = @border_top.to_hash if @border_top
    out['borderRight'] = @border_right.to_hash if @border_right
    out['borderBottom'] = @border_bottom.to_hash if @border_bottom
    out['borderLeft'] = @border_left.to_hash if @border_left
    out['rounding'] = @rounding if @rounding
    out['roundCorners'] = @round_corners if @round_corners

    out
  end
end

class NodeStyleDef
  attr_accessor :layout, :base_draw

  def initialize(layout: nil, base_draw: nil)
    @layout = layout
    @base_draw = base_draw
  end

  def to_hash
    out = {}

    out.merge!(layout.to_hash) if layout
    out.merge!(base_draw.to_hash) if base_draw

    out
  end
end

class WidgetStyleDef
  attr_accessor :style_rules, :layout, :base_draw

  def initialize(style_rules: nil, layout: nil, base_draw: nil)
    @style_rules = style_rules
    @layout = layout
    @base_draw = base_draw
  end

  def to_hash
    out = {}

    out.merge!(style_rules.to_hash) if style_rules
    out.merge!(layout.to_hash) if layout
    out.merge!(base_draw.to_hash) if base_draw

    out
  end
end

class NodeStyle
  attr_accessor :style, :hover_style, :active_style, :disabled_style

  def initialize(style: nil, hover_style: nil, active_style: nil, disabled_style: nil)
    @style = style
    @hover_style = hover_style
    @active_style = active_style
    @disabled_style = disabled_style
  end

  def to_hash
    out = {}

    out[:style] = style.to_hash if style
    out[:hover_style] = hover_style.to_hash if hover_style
    out[:active_style] = active_style.to_hash if active_style
    out[:disabled_style] = disabled_style.to_hash if disabled_style

    out
  end
end

class WidgetStyle
  attr_accessor :style, :hover_style, :active_style, :disabled_style

  def initialize(style: nil, hover_style: nil, active_style: nil, disabled_style: nil)
    @style = style
    @hover_style = hover_style
    @active_style = active_style
    @disabled_style = disabled_style
  end

  def to_hash
    out = {}

    out[:style] = style.to_hash if style
    out[:hover_style] = hover_style.to_hash if hover_style
    out[:active_style] = active_style.to_hash if active_style
    out[:disabled_style] = disabled_style.to_hash if disabled_style

    out
  end
end
