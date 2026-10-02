import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: StudentForm()));

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});
  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _address = TextEditingController();
  final _contact = TextEditingController();
  final _email = TextEditingController();
  String? _gender;
  String _result = '';

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  Widget _field(
    String label,
    TextEditingController c, {
    TextInputType? type,
    String? Function(String?)? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator ?? _required,
    ),
  );

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(
        () => _result =
            'Name: ${_name.text}\n'
            'Age: ${_age.text}\n'
            'Gender: $_gender\n'
            'Address: ${_address.text}\n'
            'Contact: ${_contact.text}\n'
            'Email: ${_email.text}',
      );
    }
  }

  void _clear() {
    _formKey.currentState!.reset();
    for (var c in [_name, _age, _address, _contact, _email]) {
      c.clear();
    }
    setState(() {
      _gender = null;
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field('Full Name', _name),
              _field('Age', _age, type: TextInputType.number),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _gender = v),
                validator: (v) => v == null ? 'Please select gender' : null,
              ),
              const SizedBox(height: 12),
              _field('Address', _address),
              _field('Contact Number', _contact, type: TextInputType.phone),
              _field(
                'Email',
                _email,
                type: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Enter a valid email'
                    : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(onPressed: _clear, child: const Text('Clear')),
                ],
              ),
              const SizedBox(height: 20),
              if (_result.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(_result),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
