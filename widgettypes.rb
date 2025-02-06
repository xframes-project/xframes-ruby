class WidgetTypes
  include JsonSerializableEnum

  JsonSerializableEnum.define_enum(self,
    { name: :Component, string: 'component' },
    { name: :Node, string: 'node' },
    { name: :UnformattedText, string: 'unformatted-text' },
    { name: :Button, string: 'di-button' }
  )
end