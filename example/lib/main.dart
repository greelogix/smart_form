import 'package:flutter/material.dart';
import 'package:smart_form_toolkit/smart_form_toolkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartForm Toolkit Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SmartFormController _formController = SmartFormController();
  final SmartFormController _jsonFormController = SmartFormController();

  final List<Map<String, dynamic>> _formSchema = [
    {
      'type': 'text',
      'name': 'full_name',
      'label': 'Full Name',
      'hint': 'Enter your first and last name',
      'validation': {
        'required': true,
        'minLength': 3,
        'requiredError': 'Full name is strictly required',
      },
    },
    {
      'type': 'email',
      'name': 'user_email',
      'label': 'Email Address',
      'hint': 'name@example.com',
      'validation': {'required': true, 'email': true},
    },
    {
      'type': 'password',
      'name': 'user_password',
      'label': 'Password',
      'hint': 'Choose a secure password',
    },
    {
      'type': 'choice',
      'name': 'experience',
      'label': 'Years of Experience',
      'layout': 'segmented',
      'options': [
        {'value': 'entry', 'label': '0-2 years'},
        {'value': 'mid', 'label': '3-5 years'},
        {'value': 'senior', 'label': '5+ years'},
      ],
    },
    {
      'type': 'toggle',
      'name': 'notifications',
      'label': 'Enable Push Notifications',
      'value': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SmartForm Toolkit'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Standard API', icon: Icon(Icons.code)),
              Tab(text: 'JSON Builder', icon: Icon(Icons.settings_ethernet)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _formController.submit(),
              tooltip: 'Submit Standard Form',
            ),
          ],
        ),
        body: TabBarView(children: [_buildStandardForm(), _buildJsonForm()]),
      ),
    );
  }

  Widget _buildStandardForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: SmartForm(
        controller: _formController,
        onSubmit: (values) {
          debugPrint('Standard Form Submitted: $values');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form Success: ${values['username']}')),
          );
        },
        fields: [
          SmartField.text(
            name: 'username',
            label: 'Username',
            hint: 'Enter your username',
            decoration: const FieldDecoration(
              prefixIcon: Icon(Icons.person_outline),
              borderRadius: 12,
            ),
          ),
          const SizedBox(height: 16),
          SmartField.password(
            name: 'password',
            label: 'Password',
            decoration: const FieldDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              borderRadius: 12,
            ),
          ),
          const SizedBox(height: 16),
          SmartField.choice<String>(
            name: 'gender',
            label: 'Gender',
            layout: ChoiceLayout.segmented,
            options: [
              const ChoiceOption(
                value: 'male',
                label: 'Male',
                iconMaterial: Icons.male,
              ),
              const ChoiceOption(
                value: 'female',
                label: 'Female',
                iconMaterial: Icons.female,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildJsonForm() {
    return SingleChildScrollView(
      child: SmartFormBuilder(
        controller: _jsonFormController,
        schema: _formSchema,
        spacing: 20,
        onSubmit: (values) {
          debugPrint('JSON Form Submitted: $values');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('JSON Form Data Saved!')),
          );
        },
        submitButton: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          child: ElevatedButton.icon(
            onPressed: () => _jsonFormController.submit(),
            icon: const Icon(Icons.rocket_launch),
            label: const Text('SUBMIT JSON FORM'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
