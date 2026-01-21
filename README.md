# SmartForm Toolkit 🛠️

SmartForm Toolkit is a next-generation, platform-aware form framework for Flutter. It is designed to give developers full control over form inputs, behavior, and layout while drastically reducing boilerplate and handling internal state management automatically.

Perfect for enterprise applications, design-heavy projects, and developers who need both flexibility and productivity.

## 🌟 Key Features

- **JSON-Dynamic Forms**: Build entire forms effortlessly using a JSON schema with `SmartFormBuilder`.
- **Wide Range of Field Types**: Text, Email, Password, Number, Multiline, Toggles, Checkboxes, Radios, and Searchable Dropdowns.
- **Full Platform Awareness**: Automatically adapts to Material (Android) and Cupertino (iOS) design languages.
- **Unified State Management**: Centralized form state and validation via `SmartFormController`.
- **Debounced Inputs**: Optimized performance with built-in debouncing for text and search fields.
- **Rich Customization**: Deep control over styling, icons, and layout per field.

## 📦 Installation

Add `smart_form_toolkit` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_form_toolkit: ^0.0.1
```

## 🚀 Quick Start (JSON Builder)

The most powerful feature of `SmartForm Toolkit` is the `SmartFormBuilder`. It allows you to build forms by simply defining a JSON-like schema.

> **Note**: For `SmartFormBuilder` to work effortlessly, your JSON schema **must align** with the expected pattern defined by the toolkit.

```dart
final List<Map<String, dynamic>> schema = [
  {
    'type': 'text',
    'name': 'full_name',
    'label': 'Full Name',
    'hint': 'John Doe',
    'validation': {
      'required': true,
      'minLength': 3,
      'requiredError': 'Name is needed',
    }
  },
  {
    'type': 'email',
    'name': 'user_email',
    'label': 'Email Address',
    'validation': { 'email': true }
  },
  {
    'type': 'choice',
    'name': 'gender',
    'label': 'Select Gender',
    'layout': 'segmented',
    'options': [
      {'value': 'm', 'label': 'Male'},
      {'value': 'f', 'label': 'Female'},
    ]
  }
];

// In your Widget build:
SmartFormBuilder(
  schema: schema,
  controller: myController,
  onSubmit: (values) => print('Form Data: $values'),
)
```

### JSON Schema Alignment Requirements
To ensure the builder works correctly, follow these key definitions:
- **`type`**: `text`, `password`, `email`, `number`, `multiline`, `toggle`, `checkbox`, `radio`, `choice`.
- **`name`**: Unique identifier for the field (used in the result map).
- **`validation`**: Map containing `required` (bool), `email` (bool), `minLength` (int), `maxLength` (int), or `pattern` (Regex string).
- **`options`**: Required for `choice` types; a list of `{'value': ..., 'label': ...}` maps.

## 🛠 Standard Usage (Manual)

If you prefer more manual control, you can use `SmartField` factory methods:

```dart
SmartForm(
  controller: _controller,
  fields: [
    SmartField.text(
      name: 'username',
      label: 'Username',
      decoration: FieldDecoration(prefixIcon: Icon(Icons.person)),
    ),
    SmartField.choice<String>(
      name: 'theme',
      layout: ChoiceLayout.segmented,
      options: [
        ChoiceOption(value: 'light', label: 'Light', iconMaterial: Icons.light_mode),
        ChoiceOption(value: 'dark', label: 'Dark', iconMaterial: Icons.dark_mode),
      ],
    ),
  ],
  onSubmit: (values) => print(values),
)
```

## 📄 License

MIT
