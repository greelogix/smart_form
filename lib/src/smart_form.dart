import 'package:flutter/material.dart';
import 'controller/smart_form_controller.dart';
import 'models/smart_style.dart';

/// An [InheritedWidget] that provides [SmartFormController] and default [SmartStyle] to the form tree.
class SmartFormProvider extends InheritedWidget {
  /// The controller managing this form's state.
  final SmartFormController controller;

  /// The default styling mode for fields within this form.
  final SmartStyle defaultStyle;

  /// Creates a [SmartFormProvider].
  const SmartFormProvider({
    super.key,
    required this.controller,
    required super.child,
    this.defaultStyle = SmartStyle.adaptive,
  });

  /// Retrieves the nearest [SmartFormProvider] from the widget tree.
  static SmartFormProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SmartFormProvider>();
  }

  @override
  bool updateShouldNotify(SmartFormProvider oldWidget) {
    return controller != oldWidget.controller || defaultStyle != oldWidget.defaultStyle;
  }
}

/// The main widget for creating smart, platform-aware forms.
/// 
/// It coordinates state via a [SmartFormController] and provides a unified layout for [fields].
class SmartForm extends StatefulWidget {
  /// The controller that will manage the data and validation for this form.
  final SmartFormController controller;

  /// The list of form field widgets (recommend using [SmartField] factory).
  final List<Widget> fields;

  /// A callback triggered when the form is submitted and valid.
  final ValueChanged<Map<String, dynamic>>? onSubmit;

  /// The visual style of the form (Material, Cupertino, or Adaptive).
  final SmartStyle style;

  /// Whether to show the default Material [ElevatedButton] at the bottom.
  final bool showDefaultSubmitButton;

  /// A custom widget to use as the submit button.
  final Widget? submitButton;

  /// Creates a [SmartForm].
  const SmartForm({
    super.key,
    required this.controller,
    required this.fields,
    this.onSubmit,
    this.style = SmartStyle.adaptive,
    this.showDefaultSubmitButton = true,
    this.submitButton,
  });

  @override
  State<SmartForm> createState() => _SmartFormState();
}

class _SmartFormState extends State<SmartForm> {

  @override
  void initState() {
    super.initState();
    widget.controller.setOnSubmitCallback(_handleSystemSubmit);
  }

  @override
  void didUpdateWidget(SmartForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.setOnSubmitCallback(null);
      widget.controller.setOnSubmitCallback(_handleSystemSubmit);
    }
  }

  @override
  void dispose() {
    widget.controller.setOnSubmitCallback(null);
    super.dispose();
  }

  Future<void> _handleSystemSubmit() async {
    final isValid = await widget.controller.validate();
    if (isValid) {
      widget.onSubmit?.call(widget.controller.values);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fix errors before submitting')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartFormProvider(
      controller: widget.controller,
      defaultStyle: widget.style,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.fields,
          if (widget.showDefaultSubmitButton || widget.submitButton != null)
             Padding(
               padding: const EdgeInsets.only(top: 20.0),
               child: widget.submitButton ?? ElevatedButton(
                 onPressed: _handleSystemSubmit,
                 child: const Text('Submit'),
               ),
             ),
        ],
      ),
    );
  }
}
