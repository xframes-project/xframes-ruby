require 'ffi'

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