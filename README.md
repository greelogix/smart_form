# SmartForm Toolkit 🛠️

SmartForm Toolkit is a next-generation, platform-aware form framework for Flutter. It is designed to give developers full control over form inputs, behavior, and layout while drastically reducing boilerplate and handling internal state management automatically.

Perfect for enterprise applications, design-heavy projects, and developers who need both flexibility and productivity.

## 🌟 Key Features

- **JSON-Dynamic Forms**: Build entire forms effortlessly using a comprehensive JSON schema with `SmartFormBuilder`.
- **Wide Range of Field Types**: Text, Email, Password, Number, Multiline, Toggles, Checkboxes, Radios, and Searchable Dropdowns.
- **Full Platform Awareness**: Automatically adapts to Material (Android) and Cupertino (iOS) design languages.
- **Unified State Management**: Centralized form state and validation via `SmartFormController`.
- **Debounced Inputs**: Optimized performance with built-in debouncing for text and search fields.
- **Rich Customization**: Deep control over styling, icons, and layout per field.

## 📦 Installation

Add `smart_form_toolkit` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_form_toolkit: ^0.0.3
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
    'value': 'Default Name', // initial value
    'decoration': {
      'prefixIcon': 'person',
      'borderRadius': 12,
      'fillColor': '#F5F5F5',
    },
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
    'decoration': {
      'prefixIcon': {'name': 'email', 'color': '#2196F3', 'size': 24},
    },
    'validation': { 'email': true }
  },
  {
    'type': 'password',
    'name': 'password',
    'label': 'Password',
    'enablePasswordToggle': true,
    'validation': {
      'required': true,
      'minLength': 8,
    }
  },
  {
    'type': 'multiline',
    'name': 'bio',
    'label': 'Biography',
    'minLines': 3,
    'maxLines': 6,
  },
  {
    'type': 'choice',
    'name': 'gender',
    'label': 'Select Gender',
    'layout': 'segmented',
    'options': [
      {'value': 'm', 'label': 'Male'},
      {'value': 'f', 'label': 'Female'},
    ],
    'validation': {'required': true}
  }
];

// In your Widget build:
SmartFormBuilder(
  schema: schema,
  controller: myController,
  onSubmit: (values) => print('Form Data: $values'),
);
```

### Complete JSON Schema Reference

#### Common Field Properties (All Types)
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `type` | String | Yes | Field type: `text`, `password`, `email`, `number`, `multiline`, `toggle`, `switch`, `checkbox`, `radio`, `choice` |
| `name` | String | Yes | Unique identifier for the field (used in the result map) |
| `label` | String | No | Field label text |
| `value` | dynamic | No | Initial value for the field |
| `decoration` | Map | No | Custom decoration configuration (see details below) |
| `validation` | Map | No | Validation rules (see details below) |

#### Decoration Object Properties
| Property | Type | Description |
|----------|------|-------------|
| `borderRadius` | num | Border corner radius |
| `padding` | num or Map | Padding (num for all, or Map with `all`, `vertical`, `horizontal`, `left`, `top`, `right`, `bottom`) |
| `fillColor` | String | Background color as hex string (e.g., `#FF5722` or `#80FF5722` for alpha) |
| `borderColor` | String | Border color as hex string |
| `borderWidth` | num | Border width |
| `shadows` | List | List of shadow objects (see details below) |
| `labelStyle` | Map | TextStyle config for label |
| `hintStyle` | Map | TextStyle config for hint |
| `prefixIcon` | String or Map | Prefix icon (string name or detailed config) |
| `suffixIcon` | String or Map | Suffix icon (string name or detailed config) |

#### Icon Config (String or Map)
- **String format**: Just the icon name (e.g., `'person'`, `'email'`)
- **Map format**: Detailed config with `name`, `color`, and `size`

**Supported Icon Names**: `person`, `mail`, `email`, `lock`, `visibility`, `visibilityoff`, `phone`, `search`, `home`, `settings`, `calendar`, `date`, `edit`, `add`, `remove`, `close`, `check`, `star`, `favorite`, `location`, `place`, `shoppingcart`, `account`, `camera`, `image`, `gallery`, `help`, `info`, `warning`, `error`, `success`

#### Shadow Object Properties
| Property | Type | Description |
|----------|------|-------------|
| `color` | String | Shadow color as hex string |
| `blurRadius` | num | Blur radius |
| `spreadRadius` | num | Spread radius |
| `offset` | Map | Shadow offset with `dx` and `dy` |

#### TextStyle Object Properties
| Property | Type | Description |
|----------|------|-------------|
| `fontSize` | num | Font size |
| `color` | String | Text color as hex string |
| `fontWeight` | String or num | FontWeight (string: `thin`, `light`, `normal`, `medium`, `semibold`, `bold`, `extrabold`, `black`; or num: 100-900) |
| `letterSpacing` | num | Letter spacing |
| `wordSpacing` | num | Word spacing |

#### Validation Object Properties
| Property | Type | Description |
|----------|------|-------------|
| `required` | bool | Whether field is required |
| `email` | bool | Whether to validate email format |
| `minLength` | int | Minimum character length |
| `maxLength` | int | Maximum character length |
| `pattern` | String | Regex pattern for format validation |
| `requiredError` | String | Custom error message for required validation |
| `emailError` | String | Custom error message for email validation |
| `minLengthError` | String | Custom error message for minLength validation |
| `maxLengthError` | String | Custom error message for maxLength validation |
| `patternError` | String | Custom error message for pattern validation |

#### Type-Specific Properties

##### Password Field (`type: 'password'`)
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `enablePasswordToggle` | bool | true | Whether to show password visibility toggle |

##### Multiline Field (`type: 'multiline'`)
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `minLines` | int | 3 | Minimum number of lines |
| `maxLines` | int | 5 | Maximum number of lines |

##### Choice Field (`type: 'choice'`)
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `options` | List | Yes | List of option objects with `value` and `label` |
| `layout` | String | 'wrap' | Layout style: `wrap`, `column`, `row`, `segmented` |

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
