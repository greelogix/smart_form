import 'package:flutter/widgets.dart';
import 'package:smart_form_toolkit/smart_form_toolkit.dart';

/// A widget that builds a [SmartForm] automatically from a JSON-like schema.
/// 
/// The [schema] is a list of maps where each map defines a field's properties.
class SmartFormBuilder extends StatelessWidget {
  /// The JSON-like list of field definitions.
  final List<Map<String, dynamic>> schema;

  /// The controller to manage form state.
  final SmartFormController controller;

  /// Global style for all fields in the form.
  final SmartStyle? style;

  /// Optional padding for the form container.
  final EdgeInsetsGeometry? padding;

  /// Spacing between fields.
  final double spacing;

  /// Logic to execute when the form is submitted.
  final Function(Map<String, dynamic> values)? onSubmit;

  /// Whether to show the default submit button.
  final bool showDefaultSubmitButton;

  /// Custom submit button widget.
  final Widget? submitButton;

  /// Creates a [SmartFormBuilder].
  const SmartFormBuilder({
    super.key,
    required this.schema,
    required this.controller,
    this.style,
    this.padding,
    this.spacing = 16.0,
    this.onSubmit,
    this.showDefaultSubmitButton = true,
    this.submitButton,
  });

  @override
  Widget build(BuildContext context) {
    return SmartForm(
      controller: controller,
      style: style ?? SmartStyle.adaptive,
      onSubmit: onSubmit,
      showDefaultSubmitButton: showDefaultSubmitButton,
      submitButton: submitButton,
      fields: _buildFields(context),
    );
  }

  List<Widget> _buildFields(BuildContext context) {
    final List<Widget> fieldWidgets = [];
    for (int i = 0; i < schema.length; i++) {
      final fieldDef = schema[i];
      final widget = _mapJsonToField(fieldDef);
      fieldWidgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: i < schema.length - 1 ? spacing : 0),
          child: widget,
        ),
      );
    }
    return fieldWidgets;
  }

  Widget _mapJsonToField(Map<String, dynamic> def) {
    final String type = def['type'] ?? 'text';
    final String name = def['name'] ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}';
    final String? label = def['label'];
    final String? hint = def['hint'];
    final dynamic initialValue = def['value'];

    // Handle validations from JSON
    final validationRules = def['validation'] as Map<String, dynamic>?;
    
    Future<String?> Function(String?)? validator;
    if (validationRules != null) {
      validator = (value) async {
        if (validationRules['required'] == true && (value == null || value.isEmpty)) {
          return validationRules['requiredError'] ?? 'This field is required';
        }
        if (validationRules['email'] == true) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (value != null && value.isNotEmpty && !emailRegex.hasMatch(value)) {
            return validationRules['emailError'] ?? 'Invalid email address';
          }
        }
        if (validationRules['minLength'] != null) {
           final min = validationRules['minLength'] as int;
           if (value != null && value.length < min) {
             return validationRules['minLengthError'] ?? 'Minimum length is $min characters';
           }
        }
        if (validationRules['maxLength'] != null) {
           final max = validationRules['maxLength'] as int;
           if (value != null && value.length > max) {
             return validationRules['maxLengthError'] ?? 'Maximum length is $max characters';
           }
        }
        if (validationRules['pattern'] != null) {
           final pattern = validationRules['pattern'] as String;
           final regex = RegExp(pattern);
           if (value != null && value.isNotEmpty && !regex.hasMatch(value)) {
              return validationRules['patternError'] ?? 'Invalid format';
           }
        }
        return null;
      };
    }

    // Set initial value in controller if provided
    if (initialValue != null) {
      controller.setValue(name, initialValue);
    }

    switch (type) {
      case 'password':
        return SmartTextField(
          name: name,
          label: label,
          hint: hint,
          obscureText: true,
          validator: validator,
          style: style,
        );
      case 'email':
        return SmartTextField(
          name: name,
          label: label,
          hint: hint,
          keyboardType: TextInputType.emailAddress,
          validator: validator,
          style: style,
        );
      case 'number':
        return SmartTextField(
          name: name,
          label: label,
          hint: hint,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validator,
          style: style,
        );
      case 'multiline':
        return SmartTextField(
          name: name,
          label: label,
          hint: hint,
          keyboardType: TextInputType.multiline,
          minLines: def['minLines'] ?? 3,
          maxLines: def['maxLines'] ?? 5,
          validator: validator,
          style: style,
        );
      case 'toggle':
      case 'switch':
        return SmartToggleField(
          name: name,
          label: label ?? '',
          style: style,
        );
      case 'checkbox':
        return SmartToggleField(
          name: name,
          label: label ?? '',
          type: ToggleType.checkbox,
          style: style,
        );
      case 'radio':
        return SmartToggleField(
          name: name,
          label: label ?? '',
          type: ToggleType.radio,
          style: style,
        );
      case 'choice':
        final optionsJson = def['options'] as List<dynamic>? ?? [];
        final List<ChoiceOption<String>> options = optionsJson.map((o) {
           if (o is Map) {
             return ChoiceOption<String>(
               value: o['value'].toString(), 
               label: o['label']?.toString() ?? o['value'].toString()
             );
           }
           return ChoiceOption<String>(value: o.toString(), label: o.toString());
        }).toList();
        
        ChoiceLayout layout = ChoiceLayout.row;
        if (def['layout'] == 'column') layout = ChoiceLayout.column;
        if (def['layout'] == 'segmented') layout = ChoiceLayout.segmented;
        if (def['layout'] == 'wrap') layout = ChoiceLayout.wrap;

        return SmartChoiceField<String>(
          name: name,
          label: label,
          options: options,
          layout: layout,
          style: style,
        );
      case 'text':
      default:
        return SmartTextField(
          name: name,
          label: label,
          hint: hint,
          validator: validator,
          style: style,
        );
    }
  }
}
