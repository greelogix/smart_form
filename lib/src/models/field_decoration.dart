import 'package:flutter/widgets.dart';

/// A class for customizing the visual appearance of [SmartForm] fields.
/// 
/// It encapsulates styling properties that are applied across both 
/// Material and Cupertino implementations.
class FieldDecoration {
  /// The radius of the field's corners.
  final double? borderRadius;

  /// Internal padding for the field content.
  final EdgeInsetsGeometry? padding;

  /// The background color of the field.
  final Color? fillColor;

  /// The color of the field's outline/border.
  final Color? borderColor;

  /// The thickness of the field's outline/border.
  final double? borderWidth;

  /// A list of shadows to apply to the field's container.
  final List<BoxShadow>? shadows;
  
  /// A widget to display at the very beginning of the field (inner).
  final Widget? prefix;

  /// A widget (typically an [Icon]) to display as a prefix.
  final Widget? prefixIcon;

  /// A widget to display at the very end of the field (inner).
  final Widget? suffix;

  /// A widget (typically an [Icon]) to display as a suffix.
  final Widget? suffixIcon;
  
  /// custom styling for the field's label.
  final TextStyle? labelStyle;

  /// custom styling for the field's hint/placeholder text.
  final TextStyle? hintStyle;

  /// Creates a [FieldDecoration].
  const FieldDecoration({
    this.borderRadius,
    this.padding,
    this.fillColor,
    this.borderColor,
    this.borderWidth,
    this.shadows,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.labelStyle,
    this.hintStyle,
  });
}
