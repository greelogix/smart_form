## 0.0.3

* **Major: Enhanced `SmartFormBuilder` JSON schema support**:
  - Added comprehensive decoration parsing from JSON (borderRadius, padding, fillColor, borderColor, borderWidth, shadows, labelStyle, hintStyle)
  - Added icon parsing from JSON (prefixIcon and suffixIcon, supports string names or detailed map config with color/size)
  - Added support for initial values via `value` field in JSON
  - Added `enablePasswordToggle` option
  - Added `minLines`/`maxLines` for multiline fields
  - Added duplicate field name detection (warns and skips duplicates)
  - Added `mounted` check in form submission to prevent errors
  - Added validator support for `SmartChoiceField` in JSON
  - Improved validation null safety
  - Added BoxShadow, Offset, TextStyle, FontWeight, EdgeInsets, and Color parsers
  - Added extensive icon name mapping (30+ common icons)

## 0.0.2

* Enhanced documentation for `SmartFormBuilder`.
* Clarified JSON schema alignment requirements in README and code.

## 0.0.1

* Initial release of SmartForm Toolkit.
* **SmartFormBuilder**: New feature to generate forms completely from a JSON schema.
* **Unified State Management**: Centralized form state via `SmartFormController`.
* **Platform-Aware Fields**: Automatic adaptation between Material and Cupertino.
* **Advanced Parity**: Full feature parity for `SmartTextField` with native Flutter widgets.
* **Rich Styling**: Global and per-field customization via `FieldDecoration` and `SmartStyle`.
* **Generic Choice Fields**: Supports `Switch`, `Checkbox`, `Radio`, and `Segmented` layouts.
* **Searchable Dropdowns**: Asynchronous searching with debouncing support.
