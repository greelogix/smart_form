import 'package:flutter/widgets.dart';

/// Represents a single selectable option in a choice field or dropdown.
class ChoiceOption<T extends Object> {
  /// The underlying value mapped to this option.
  final T value;

  /// The human-readable text label for this option.
  final String label;

  /// Optional icon to display when using Material style.
  final IconData? iconMaterial;

  /// Optional icon to display when using Cupertino style.
  final IconData? iconCupertino;

  /// Creates a [ChoiceOption].
  const ChoiceOption({
    required this.value,
    required this.label,
    this.iconMaterial,
    this.iconCupertino,
  });
}
