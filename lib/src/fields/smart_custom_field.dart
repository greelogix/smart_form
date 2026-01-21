import 'package:flutter/widgets.dart';
import 'package:smart_form_toolkit/src/controller/smart_form_controller.dart';
import 'package:smart_form_toolkit/src/smart_form.dart';

/// A widget that allows developers to create completely custom form fields.
/// 
/// It provides access to the [SmartFormController] via a [builder] function, 
/// enabling seamless integration of any widget into the [SmartForm] state.
class SmartCustomField extends StatelessWidget {
  /// The unique key for this field in the [SmartFormController].
  final String name;

  /// A function that builds the custom field widget.
  /// 
  /// Provides the [BuildContext] and the active [SmartFormController].
  final Widget Function(BuildContext context, SmartFormController controller) builder;

  /// Creates a [SmartCustomField].
  const SmartCustomField({
    super.key,
    required this.name,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final provider = SmartFormProvider.of(context);
    if (provider == null) return const SizedBox.shrink();
    return builder(context, provider.controller);
  }
}
