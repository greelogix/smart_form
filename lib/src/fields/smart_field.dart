import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_form_toolkit/src/controller/smart_form_controller.dart';
import 'package:smart_form_toolkit/src/fields/smart_custom_field.dart';
import 'package:smart_form_toolkit/src/fields/smart_text_field.dart';
import 'package:smart_form_toolkit/src/fields/smart_toggle_field.dart';
import 'package:smart_form_toolkit/src/fields/smart_choice_field.dart';
import 'package:smart_form_toolkit/src/fields/smart_searchable_dropdown.dart';
import 'package:smart_form_toolkit/src/models/field_decoration.dart';
import 'package:smart_form_toolkit/src/models/choice_option.dart';
import 'package:smart_form_toolkit/src/models/smart_style.dart';

/// A static factory class for creating various [SmartForm] fields with a clean API.
class SmartField {
  /// Creates a basic text input field.
  /// 
  /// [name] is the unique key used in [SmartFormController].
  /// [useFormField] determines if should use native `TextFormField` or `TextField`.
  static Widget text({
    required String name,
    String? label,
    String? hint,
    int? maxLines = 1,
    int? minLines,
    double? height,
    double? width,
    FieldDecoration? decoration,
    SmartStyle? style,
    bool useFormField = true,
    bool autofocus = false,
    bool readOnly = false,
    bool enabled = true,
    List<TextInputFormatter>? inputFormatters,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onEditingComplete,
    FocusNode? focusNode,
    TextEditingController? controller,
  }) {
    return SmartTextField(
      name: name,
      label: label,
      hint: hint,
      maxLines: maxLines,
      minLines: minLines,
      height: height,
      width: width,
      decoration: decoration,
      style: style,
      useFormField: useFormField,
      autofocus: autofocus,
      readOnly: readOnly,
      enabled: enabled,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      textStyle: textStyle,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      externalFocusNode: focusNode,
      externalController: controller,
    );
  }

  /// Creates a password input field with [obscureText] set to `true`.
  static Widget password({
    required String name,
    String? label,
    String? hint,
    double? height,
    double? width,
    FieldDecoration? decoration,
    SmartStyle? style,
    bool useFormField = true,
    bool autofocus = false,
    bool enabled = true,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FocusNode? focusNode,
  }) {
    return SmartTextField(
      name: name,
      label: label,
      hint: hint,
      obscureText: true,
      maxLines: 1,
      height: height,
      width: width,
      decoration: decoration,
      style: style,
      useFormField: useFormField,
      autofocus: autofocus,
      enabled: enabled,
      textAlign: textAlign,
      textStyle: textStyle,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      externalFocusNode: focusNode,
    );
  }

  /// Creates a numeric input field with decimal support.
  static Widget number({
    required String name,
    String? label,
    String? hint,
    double? height,
    double? width,
    FieldDecoration? decoration,
    SmartStyle? style,
    bool useFormField = true,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return SmartTextField(
      name: name,
      label: label,
      hint: hint,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      height: height,
      width: width,
      decoration: decoration,
      style: style,
      useFormField: useFormField,
      enabled: enabled,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
    );
  }

  /// Creates an email input field with appropriate keyboard type.
  static Widget email({
    required String name,
    String? label,
    String? hint,
    double? height,
    double? width,
    FieldDecoration? decoration,
    SmartStyle? style,
    bool useFormField = true,
    ValueChanged<String>? onChanged,
  }) {
    return SmartTextField(
      name: name,
      label: label,
      hint: hint,
      keyboardType: TextInputType.emailAddress,
      height: height,
      width: width,
      decoration: decoration,
      style: style,
      useFormField: useFormField,
      onChanged: onChanged,
    );
  }

  /// Creates a multi-line text input field.
  static Widget multiline({
    required String name,
    String? label,
    String? hint,
    int minLines = 3,
    int maxLines = 5,
    double? height,
    double? width,
    FieldDecoration? decoration,
    SmartStyle? style,
    bool useFormField = true,
    ValueChanged<String>? onChanged,
  }) {
    return SmartTextField(
      name: name,
      label: label,
      hint: hint,
      keyboardType: TextInputType.multiline,
      minLines: minLines,
      maxLines: maxLines,
      height: height,
      width: width,
      decoration: decoration,
      style: style,
      useFormField: useFormField,
      onChanged: onChanged,
    );
  }

  /// Creates a platform-adaptive toggle/switch field.
  static Widget toggle({
    required String name,
    required String label,
    IconData? onIcon,
    IconData? offIcon,
    SmartStyle? style,
    ValueChanged<bool>? onChanged,
  }) {
    return SmartToggleField(
      name: name,
      label: label,
      onIcon: onIcon,
      offIcon: offIcon,
      style: style,
      onChanged: onChanged,
    );
  }

  /// Creates a checkbox field.
  static Widget checkbox({
    required String name,
    required String label,
    IconData? onIcon,
    IconData? offIcon,
    SmartStyle? style,
    ValueChanged<bool>? onChanged,
  }) {
    return SmartToggleField(
      name: name,
      label: label,
      type: ToggleType.checkbox,
      onIcon: onIcon,
      offIcon: offIcon,
      style: style,
      onChanged: onChanged,
    );
  }

  /// Creates a radio button toggle field.
  static Widget radio({
    required String name,
    required String label,
    IconData? onIcon,
    IconData? offIcon,
    SmartStyle? style,
    ValueChanged<bool>? onChanged,
  }) {
    return SmartToggleField(
      name: name,
      label: label,
      type: ToggleType.radio,
      onIcon: onIcon,
      offIcon: offIcon,
      style: style,
      onChanged: onChanged,
    );
  }

  /// Creates a field for selecting from a predefined list of options.
  static Widget choice<T extends Object>({
    required String name,
    required List<ChoiceOption<T>> options,
    String? label,
    ChoiceLayout layout = ChoiceLayout.row,
    SmartStyle? style,
    ValueChanged<T?>? onChanged,
  }) {
    return SmartChoiceField<T>(
      name: name,
      options: options,
      label: label,
      layout: layout,
      style: style,
      onChanged: onChanged,
    );
  }

  /// Creates a searchable dropdown with asynchronous data fetching.
  static Widget searchableDropdown<T extends Object>({
    required String name,
    required Future<List<T>> Function(String query) search,
    required Widget Function(BuildContext, T, bool) itemBuilder,
    String? label,
    Duration debounce = const Duration(milliseconds: 300),
    SmartStyle? style,
    FieldDecoration? decoration,
    double? height,
    double? width,
    String Function(T)? itemLabel,
    ValueChanged<T?>? onChanged,
  }) {
    return SmartSearchableDropdown<T>(
      name: name,
      search: search,
      itemBuilder: itemBuilder,
      label: label,
      debounce: debounce,
      style: style,
      decoration: decoration,
      height: height,
      width: width,
      itemLabel: itemLabel,
      onChanged: onChanged,
    );
  }
  
  /// Creates a completely custom field with direct access to [SmartFormController].
  static Widget custom({
    required String name,
    required Widget Function(BuildContext context, SmartFormController controller) builder,
  }) {
    return SmartCustomField(
      name: name,
      builder: builder,
    );
  }
}
