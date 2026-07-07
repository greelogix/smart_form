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
      title: 'Smart Form Toolkit Demo',
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

  final List<Map<String, dynamic>> _formSchema1 = [
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
      'decoration': {
        'borderRadius': 16,
        'padding': {
          'vertical': 16,
          'horizontal': 20,
        },
        'fillColor': '#F5F5F5',
        'borderColor': '#E0E0E0',
        'borderWidth': 1.5,
        'prefixIcon': 'person',
        'labelStyle': {
          'fontSize': 14,
          'fontWeight': 'semibold',
          'color': '#616161',
        },
        'hintStyle': {
          'fontSize': 14,
          'color': '#9E9E9E',
        },
      },
    },
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
      'decoration': {
        'borderRadius': 16,
        'padding': {
          'vertical': 16,
          'horizontal': 20,
        },
        'fillColor': '#F5F5F5',
        'borderColor': '#E0E0E0',
        'borderWidth': 1.5,
        'prefixIcon': 'person',
        'labelStyle': {
          'fontSize': 14,
          'fontWeight': 'semibold',
          'color': '#616161',
        },
        'hintStyle': {
          'fontSize': 14,
          'color': '#9E9E9E',
        },
      },
    },
    {
      'type': 'email',
      'name': 'user_email',
      'label': 'Email Address',
      'hint': 'name@example.com',
      'validation': {
        'required': true,
        'email': true,
      },
      'decoration': {
        'borderRadius': 16,
        'padding': {
          'vertical': 16,
          'horizontal': 20,
        },
        'fillColor': '#F5F5F5',
        'borderColor': '#E0E0E0',
        'borderWidth': 1.5,
        'prefixIcon': 'email',
      },
    },
  ];

  final List<Map<String, dynamic>> _formSchema2 = [
    {
      'type': 'password',
      'name': 'user_password',
      'label': 'Password',
      'hint': 'Choose a secure password',
      'enablePasswordToggle': true,
      'validation': {
        'required': true,
        'minLength': 6,
      },
      'decoration': {
        'borderRadius': 16,
        'padding': {
          'vertical': 16,
          'horizontal': 20,
        },
        'fillColor': '#F5F5F5',
        'borderColor': '#E0E0E0',
        'borderWidth': 1.5,
        'prefixIcon': 'lock',
      },
    },
    {
      'type': 'choice',
      'name': 'account_type',
      'label': 'Account Type',
      'validation': {
        'required': true,
      },
      'options': [
        {'value': 'personal', 'label': 'Personal'},
        {'value': 'business', 'label': 'Business'},
      ],
    },
    {
      'type': 'choice',
      'name': 'experience',
      'label': 'Years of Experience',
      'layout': 'segmented',
      'validation': {
        'required': true,
      },
      'options': [
        {'value': 'entry', 'label': '0-2 years'},
        {'value': 'mid', 'label': '3-5 years'},
        {'value': 'senior', 'label': '5+ years'},
      ],
    },
    {
      'type': 'toggle',
      'name': 'notifications',
      'label': 'Enable Notifications',
      'value': true,
    },
  ];

  List<Map<String, dynamic>>? _currentSchema;
  int _selectedSchemaIndex = -1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Form Toolkit'),
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Standard API', icon: Icon(Icons.code)),
              Tab(text: 'Dynamic JSON', icon: Icon(Icons.dynamic_form)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStandardForm(context),
            _buildDynamicJsonForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: SmartForm(
        controller: _formController,
        showDefaultSubmitButton: false,
        onSubmit: (values) {
          debugPrint('Standard Form Submitted: $values');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Form Success! Username: ${values['username']}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        },
        fields: [
          SmartField.text(
            name: 'username',
            label: 'Username',
            hint: 'Enter your username',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
            decoration: const FieldDecoration(
              borderRadius: 16,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              fillColor: Color(0xFFF5F5F5),
              borderColor: Color(0xFFE0E0E0),
              borderWidth: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SmartField.password(
            name: 'password',
            label: 'Password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            decoration: const FieldDecoration(
              borderRadius: 16,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              fillColor: Color(0xFFF5F5F5),
              borderColor: Color(0xFFE0E0E0),
              borderWidth: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SmartField.choice<String>(
            name: 'gender',
            label: 'Gender',
            layout: ChoiceLayout.wrap,
            validator: (value) {
              if (value == null) {
                return 'Please select a gender';
              }
              return null;
            },
            options: [
              const ChoiceOption(
                value: 'male',
                label: 'Male',
              ),
              const ChoiceOption(
                value: 'female',
                label: 'Female',
              ),
              const ChoiceOption(
                value: 'other',
                label: 'Other',
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () async {
              await _formController.submit();
            },
            icon: const Icon(Icons.send),
            label: const Text('Submit Form'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicJsonForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _jsonFormController.reset();
                      _currentSchema = _formSchema1;
                      _selectedSchemaIndex = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedSchemaIndex == 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: _selectedSchemaIndex == 0
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  child: const Text('Load Schema 1'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _jsonFormController.reset();
                      _currentSchema = _formSchema2;
                      _selectedSchemaIndex = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedSchemaIndex == 1
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: _selectedSchemaIndex == 1
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  child: const Text('Load Schema 2'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _jsonFormController.reset();
                _currentSchema = null;
                _selectedSchemaIndex = -1;
              });
            },
            icon: const Icon(Icons.close),
            label: const Text('Clear Form'),
          ),
          const SizedBox(height: 32),
          if (_currentSchema != null)
            SmartFormBuilder(
              controller: _jsonFormController,
              schema: _currentSchema!,
              spacing: 20,
              showDefaultSubmitButton: false,
              onSubmit: (values) {
                debugPrint('Dynamic Form Submitted: $values');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dynamic Form Data Saved!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              submitButton: ElevatedButton.icon(
                onPressed: () async {
                  await _jsonFormController.submit();
                },
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Submit Dynamic Form'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (_currentSchema == null)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.dynamic_form,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select a schema above to load a form',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
