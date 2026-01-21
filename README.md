# SmartForm

SmartForm is a next-generation, fully customizable form framework for Flutter, designed to give developers full control over form inputs, behavior, layout, and platform appearance, while reducing boilerplate and handling common pain points automatically.

It is perfect for enterprise apps, design-heavy projects, and Flutter developers who want both flexibility and productivity.

## 🌟 Key Features

### 1️⃣ Wide Range of Field Types
- **Text Fields**: Text, Email, Password, Number, Multiline.
- **Searchable Dropdowns**: With debounce, async search, and full UI customization.
- **Choice Fields**: Segmented controls, radio groups (visual), supporting generic types.
- **Toggle Fields**: Switches with platform specific styling.
- **Custom Fields**: Full builder access for completely custom implementations.

### 2️⃣ Full Platform Awareness
- Supports **Material** (Android), **Cupertino** (iOS), and **Adaptive** modes.
- Automatically adapts to the current platform but can be overridden per field.
- Custom icons for different platforms.

### 3️⃣ Layout & Size Flexibility
- Configurable height and width per field.
- Works with standard Flutter layout widgets (Column, Row, Wrap).

### 4️⃣ Smart Behavior Built-In
- **Debounce** for text and search fields to minimize rebuilding and API calls.
- **State Management** via `SmartFormController`.

## 📦 Installation

Add `smart_form` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_form:
    path: path/to/smart_form
```

## 🚀 Running the Example

To see `SmartForm` in action, check out the example project:

```bash
cd example
flutter run
```

## 🛠 Advanced Usage

### Searchable Dropdown
```dart
SmartField.searchableDropdown<User>(
  name: 'user',
  search: (query) => api.searchUsers(query),
  itemBuilder: (context, user, isSelected) => ListTile(title: Text(user.name)),
  itemLabel: (user) => user.name,
)
```

### Choice Field
```dart
SmartField.choice<String>(
  name: 'theme',
  layout: ChoiceLayout.segmented,
  options: [
    ChoiceOption(value: 'light', label: 'Light', iconMaterial: Icons.light_mode),
    ChoiceOption(value: 'dark', label: 'Dark', iconMaterial: Icons.dark_mode),
  ],
)
```

### Custom Styling
You can force a specific style (Material or Cupertino) regardless of the platform:

```dart
SmartField.text(
  name: 'bio',
  style: SmartStyle.cupertino,
)
```

## 📄 License

MIT
