import 'package:flutter/material.dart';
import 'package:smart_form_toolkit/smart_form_toolkit.dart';

/// A widget that builds a [SmartForm] automatically from a JSON-like schema.
/// 
/// **Important**: For this builder to function correctly, the [schema] provided must
/// align exactly with the expected field definitions (keys like 'type', 'name', 'validation', etc.).
/// Effortless form generation depends on this alignment with the package's internal mapping.
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
    final seenNames = <String>{};
    for (int i = 0; i < schema.length; i++) {
      final fieldDef = schema[i];
      final name = fieldDef['name']?.toString();

      if (name != null && seenNames.contains(name)) {
        debugPrint('Warning: Skipping duplicate field name "$name" in schema!');
        continue;
      }
      if (name != null) {
        seenNames.add(name);
      }

      final widget = _mapJsonToField(fieldDef, context);
      fieldWidgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: i < schema.length - 1 ? spacing : 0),
          child: widget,
        ),
      );
    }
    return fieldWidgets;
  }

  /// Helper to parse a color from hex string or named color
  Color? _parseColor(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final hex = value.replaceFirst('#', '');
      if (hex.length == 6) {
        return Color(int.parse('0xFF$hex'));
      } else if (hex.length == 8) {
        return Color(int.parse('0x$hex'));
      }
    }
    return null;
  }

  /// Helper to parse EdgeInsets from JSON (all, vertical/horizontal, or individual)
  EdgeInsetsGeometry? _parseEdgeInsets(dynamic value) {
    if (value == null) return null;
    if (value is num) {
      return EdgeInsets.all(value.toDouble());
    }
    if (value is Map<String, dynamic>) {
      if (value.containsKey('all')) {
        return EdgeInsets.all((value['all'] as num).toDouble());
      } else if (value.containsKey('vertical') || value.containsKey('horizontal')) {
        return EdgeInsets.symmetric(
          vertical: (value['vertical'] as num?)?.toDouble() ?? 0,
          horizontal: (value['horizontal'] as num?)?.toDouble() ?? 0,
        );
      } else {
        return EdgeInsets.only(
          left: (value['left'] as num?)?.toDouble() ?? 0,
          top: (value['top'] as num?)?.toDouble() ?? 0,
          right: (value['right'] as num?)?.toDouble() ?? 0,
          bottom: (value['bottom'] as num?)?.toDouble() ?? 0,
        );
      }
    }
    return null;
  }

  /// Helper to parse IconData from string name
  IconData? _parseIconData(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final lowerValue = value.toLowerCase().replaceAll(' ', '');
      final iconMap = {
        'person': Icons.person,
        'mail': Icons.mail,
        'email': Icons.email,
        'lock': Icons.lock,
        'visibility': Icons.visibility,
        'visibilityoff': Icons.visibility_off,
        'phone': Icons.phone,
        'search': Icons.search,
        'home': Icons.home,
        'settings': Icons.settings,
        'calendar': Icons.calendar_today,
        'date': Icons.date_range,
        'edit': Icons.edit,
        'add': Icons.add,
        'remove': Icons.remove,
        'close': Icons.close,
        'check': Icons.check,
        'star': Icons.star,
        'favorite': Icons.favorite,
        'location': Icons.location_on,
        'place': Icons.place,
        'shoppingcart': Icons.shopping_cart,
        'account': Icons.account_circle,
        'camera': Icons.camera_alt,
        'image': Icons.image,
        'gallery': Icons.photo_library,
        'help': Icons.help,
        'info': Icons.info,
        'warning': Icons.warning,
        'error': Icons.error,
        'success': Icons.check_circle,
      };
      return iconMap[lowerValue];
    }
    return null;
  }

  /// Helper to parse TextStyle from JSON
  TextStyle? _parseTextStyle(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) {
      return TextStyle(
        fontSize: (value['fontSize'] as num?)?.toDouble(),
        color: _parseColor(value['color']),
        fontWeight: _parseFontWeight(value['fontWeight']),
        letterSpacing: (value['letterSpacing'] as num?)?.toDouble(),
        wordSpacing: (value['wordSpacing'] as num?)?.toDouble(),
      );
    }
    return null;
  }

  /// Helper to parse FontWeight from string or num
  FontWeight? _parseFontWeight(dynamic value) {
    if (value == null) return null;
    if (value is num) {
      final index = ((value.clamp(100, 900) / 100) - 1).toInt().clamp(0, 8);
      return FontWeight.values[index];
    }
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'thin':
          return FontWeight.w100;
        case 'extralight':
        case 'ultralight':
          return FontWeight.w200;
        case 'light':
          return FontWeight.w300;
        case 'normal':
        case 'regular':
          return FontWeight.w400;
        case 'medium':
          return FontWeight.w500;
        case 'semibold':
        case 'demibold':
          return FontWeight.w600;
        case 'bold':
          return FontWeight.w700;
        case 'extrabold':
        case 'ultrabold':
          return FontWeight.w800;
        case 'black':
        case 'heavy':
          return FontWeight.w900;
      }
    }
    return null;
  }

  /// Helper to parse BoxShadow from JSON
  List<BoxShadow>? _parseBoxShadows(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((item) {
        if (item is Map<String, dynamic>) {
          return BoxShadow(
            color: _parseColor(item['color']) ?? Colors.black.withValues(alpha: 0.2),
            blurRadius: (item['blurRadius'] as num?)?.toDouble() ?? 0,
            spreadRadius: (item['spreadRadius'] as num?)?.toDouble() ?? 0,
            offset: _parseOffset(item['offset']),
          );
        }
        return const BoxShadow();
      }).toList();
    }
    return null;
  }

  /// Helper to parse Offset from JSON
  Offset _parseOffset(dynamic value) {
    if (value == null) return Offset.zero;
    if (value is Map<String, dynamic>) {
      return Offset(
        (value['dx'] as num?)?.toDouble() ?? 0,
        (value['dy'] as num?)?.toDouble() ?? 0,
      );
    }
    if (value is List) {
      if (value.length >= 2) {
        return Offset(
          (value[0] as num?)?.toDouble() ?? 0,
          (value[1] as num?)?.toDouble() ?? 0,
        );
      }
    }
    return Offset.zero;
  }

  Widget? _parseIcon(
    dynamic iconConfig,
    BuildContext context,
  ) {
    if (iconConfig == null) return null;

    // If it's just a string, treat it as the icon name with defaults
    if (iconConfig is String) {
      final iconData = _parseIconData(iconConfig);
      if (iconData == null) return null;
      return Icon(
        iconData,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 20,
      );
    }

    // If it's a map, parse all properties
    if (iconConfig is Map<String, dynamic>) {
      final iconData = _parseIconData(iconConfig['name']);
      if (iconData == null) return null;
      return Icon(
        iconData,
        color: _parseColor(iconConfig['color']) ??
            Theme.of(context).colorScheme.onSurfaceVariant,
        size: (iconConfig['size'] as num?)?.toDouble() ?? 20,
      );
    }

    return null;
  }

  Widget _mapJsonToField(Map<String, dynamic> def, BuildContext context) {
    final String type = def['type'] ?? 'text';
    final String? name = def['name'];
    final String? label = def['label'];
    final String? hint = def['hint'];
    final dynamic initialValue = def['value'];
    final bool enablePasswordToggle = def['enablePasswordToggle'] ?? (type == 'password');

    // Handle decoration from JSON
    final decorationJson = def['decoration'] as Map<String, dynamic>?;
    FieldDecoration? decoration;
    if (decorationJson != null) {
      decoration = FieldDecoration(
        borderRadius: (decorationJson['borderRadius'] as num?)?.toDouble(),
        padding: _parseEdgeInsets(decorationJson['padding']),
        fillColor: _parseColor(decorationJson['fillColor']),
        borderColor: _parseColor(decorationJson['borderColor']),
        borderWidth: (decorationJson['borderWidth'] as num?)?.toDouble(),
        shadows: _parseBoxShadows(decorationJson['shadows']),
        // NOTE: We'll set prefixIcon and suffixIcon below using _parseIcon
        prefixIcon: null,
        suffixIcon: null,
        labelStyle: _parseTextStyle(decorationJson['labelStyle']),
        hintStyle: _parseTextStyle(decorationJson['hintStyle']),
      );
    }

    // Handle validations from JSON
    final validationRules = def['validation'] as Map<String, dynamic>?;

    Future<String?> Function(dynamic)? validator;
    if (validationRules != null) {
      validator = (value) async {
        if (validationRules['required'] == true &&
            (value == null || (value is String && value.isEmpty))) {
          return validationRules['requiredError'] ?? 'This field is required';
        }
        if (validationRules['email'] == true && value is String) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (value.isNotEmpty && !emailRegex.hasMatch(value)) {
            return validationRules['emailError'] ?? 'Invalid email address';
          }
        }
        if (validationRules['minLength'] != null && value is String) {
          final min = validationRules['minLength'] as int;
          if (value.length < min) {
            return validationRules['minLengthError'] ??
                'Minimum length is $min characters';
          }
        }
        if (validationRules['maxLength'] != null && value is String) {
          final max = validationRules['maxLength'] as int;
          if (value.length > max) {
            return validationRules['maxLengthError'] ??
                'Maximum length is $max characters';
          }
        }
        if (validationRules['pattern'] != null && value is String) {
          final pattern = validationRules['pattern'] as String;
          final regex = RegExp(pattern);
          if (value.isNotEmpty && !regex.hasMatch(value)) {
            return validationRules['patternError'] ?? 'Invalid format';
          }
        }
        return null;
      };
    }

    // Set initial value in controller if provided
    if (name != null && initialValue != null) {
      controller.setValue(name, initialValue);
    }

    switch (type) {
      case 'password':
        return SmartTextField(
          name: name ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}',
          label: label,
          hint: hint,
          obscureText: true,
          enablePasswordToggle: enablePasswordToggle,
          decoration: decoration?.copyWith(
            prefixIcon: _parseIcon(decorationJson?['prefixIcon'], context),
            suffixIcon: _parseIcon(decorationJson?['suffixIcon'], context),
          ),
          validator: validator,
          style: style,
        );
      case 'email':
        return SmartTextField(
          name: name ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}',
          label: label,
          hint: hint,
          keyboardType: TextInputType.emailAddress,
          decoration: decoration?.copyWith(
            prefixIcon: _parseIcon(decorationJson?['prefixIcon'], context),
            suffixIcon: _parseIcon(decorationJson?['suffixIcon'], context),
          ),
          validator: validator,
          style: style,
        );
      case 'number':
        return SmartTextField(
          name: name ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}',
          label: label,
          hint: hint,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: decoration?.copyWith(
            prefixIcon: _parseIcon(decorationJson?['prefixIcon'], context),
            suffixIcon: _parseIcon(decorationJson?['suffixIcon'], context),
          ),
          validator: validator,
          style: style,
        );
      case 'multiline':
        return SmartTextField(
          name: name ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}',
          label: label,
          hint: hint,
          keyboardType: TextInputType.multiline,
          minLines: def['minLines'] ?? 3,
          maxLines: def['maxLines'] ?? 5,
          decoration: decoration?.copyWith(
            prefixIcon: _parseIcon(decorationJson?['prefixIcon'], context),
            suffixIcon: _parseIcon(decorationJson?['suffixIcon'], context),
          ),
          validator: validator,
          style: style,
        );
      case 'toggle':
      case 'switch':
        return SmartToggleField(
          name: name ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}',
          label: label ?? '',
          style: style,
        );
      case 'checkbox':
        return SmartToggleField(
          name: name ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}',
          label: label ?? '',
          type: ToggleType.checkbox,
          style: style,
        );
      case 'radio':
        return SmartToggleField(
          name: name ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}',
          label: label ?? '',
          type: ToggleType.radio,
          style: style,
        );
      case 'choice':
        final optionsJson = def['options'] as List<dynamic>? ?? [];
        final List<ChoiceOption<String>> options = optionsJson.map((item) {
          if (item is Map) {
            return ChoiceOption<String>(
              value: item['value'].toString(),
              label: item['label']?.toString() ?? item['value'].toString(),
            );
          }
          return ChoiceOption<String>(value: item.toString(), label: item.toString());
        }).toList();

        ChoiceLayout layout = ChoiceLayout.wrap;
        if (def['layout'] == 'column') layout = ChoiceLayout.column;
        if (def['layout'] == 'segmented') layout = ChoiceLayout.segmented;
        if (def['layout'] == 'wrap') layout = ChoiceLayout.wrap;
        if (def['layout'] == 'row') layout = ChoiceLayout.row;

        return SmartChoiceField<String>(
          name: name ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}',
          label: label,
          options: options,
          layout: layout,
          style: style,
          validator: validator,
        );
      case 'text':
      default:
        return SmartTextField(
          name: name ?? 'unnamed_${DateTime.now().millisecondsSinceEpoch}',
          label: label,
          hint: hint,
          decoration: decoration?.copyWith(
            prefixIcon: _parseIcon(decorationJson?['prefixIcon'], context),
            suffixIcon: _parseIcon(decorationJson?['suffixIcon'], context),
          ),
          validator: validator,
          style: style,
        );
    }
  }
}
