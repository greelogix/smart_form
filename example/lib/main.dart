import 'package:flutter/material.dart';
import 'package:smart_form_builder/smart_form_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartForm Advanced Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SmartFormExamplePage(),
    );
  }
}

class User {
  final String name;

  User(this.name);

  @override
  String toString() => name;
}

class Api {
  Future<List<User>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (query.isEmpty) return [];
    return [
      User('John Doe'),
      User('Jane Smith'),
      User('Alice Johnson'),
      User('Bob Brown'),
      User('Charlie Davis'),
    ].where((u) => u.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}

final api = Api();

class SmartFormExamplePage extends StatefulWidget {
  const SmartFormExamplePage({super.key});

  @override
  State<SmartFormExamplePage> createState() => _SmartFormExamplePageState();
}

class _SmartFormExamplePageState extends State<SmartFormExamplePage> {
  final SmartFormController form = SmartFormController();
  String _liveEmailUpdate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartForm Features Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => form.submit(), // Programmatic submission
            tooltip: 'Trigger Submit via Controller',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SmartForm(
          controller: form,
          // Customizing the default submit button
          submitButton: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => form.submit(),
              icon: const Icon(Icons.check),
              label: const Text('PROCESS FORM'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          fields: [
            const Text(
              'Section: Text vs TextFormField',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Example of TextField (non-form field)
            SmartField.text(
              name: 'simple_text',
              label: 'Plain TextField (no FormField)',
              useFormField: false,
              decoration: const FieldDecoration(
                prefixIcon: Icon(Icons.text_fields),
                suffix: Text('Chars'),
              ),
              onChanged: (val) => debugPrint('Live check: $val'),
            ),
            const SizedBox(height: 16),
            // Example of TextFormField
            SmartField.email(
              name: 'email',
              label: 'Email (TextFormField)',
              useFormField: true,
              decoration: const FieldDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                suffixIcon: Icon(Icons.verified_user, color: Colors.green),
              ),
              onChanged: (val) {
                setState(() {
                  _liveEmailUpdate = val;
                });
              },
            ),
            if (_liveEmailUpdate.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Typing: $_liveEmailUpdate',
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            const SizedBox(height: 16),
            SmartField.password(
              name: 'password',
              label: 'Password with Submit Action',
              textInputAction: TextInputAction.done,
              onSubmitted: (val) {
                debugPrint('Password submitted: $val');
                form.submit();
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Section: Toggles & Choices',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SmartField.checkbox(
              name: 'terms',
              label: 'Accept Terms (Checkbox)',
              onChanged: (val) => debugPrint('Terms accepted: $val'),
            ),
            SmartField.choice<String>(
              name: 'priority',
              label: 'Task Priority',
              layout: ChoiceLayout.segmented,
              options: [
                const ChoiceOption(value: 'low', label: 'Low'),
                const ChoiceOption(value: 'med', label: 'Medium'),
                const ChoiceOption(value: 'high', label: 'High'),
              ],
              onChanged: (val) => debugPrint('Priority changed: $val'),
            ),
            const SizedBox(height: 16),
            SmartField.searchableDropdown<User>(
              name: 'owner',
              label: 'Search Owner',
              itemLabel: (u) => u.name,
              search: api.searchUsers,
              decoration: const FieldDecoration(prefixIcon: Icon(Icons.search)),
              onChanged: (u) => debugPrint('Selected owner: ${u?.name}'),
              itemBuilder: (context, user, selected) =>
                  ListTile(title: Text(user.name), selected: selected),
            ),
          ],
          onSubmit: (values) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Valid Form Data Received'),
                content: Text(values.toString()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
