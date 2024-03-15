import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mottoController = TextEditingController();

  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _editMode = true;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/coke.jpg'),
            ),
            SizedBox(height: 20),
            if (!_editMode) ...[
              // Display profile details when not in edit mode
              buildProfileDetails(),
            ] else ...[
              // Display input fields when in edit mode
              buildInputField("Name", _nameController),
              buildInputField("Age", _ageController),
              buildInputField("Address", _addressController),
              buildInputField("Birthday", _birthdayController),
              buildInputField("Email", _emailController),
              buildInputField("Motto in Life", _mottoController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submitProfile();
                },
                child: Text('Submit'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildProfileDetails() {
    return Column(
      children: [
        Text('Name: ${_nameController.text}'),
        SizedBox(height: 10),
        Text('Age: ${_ageController.text}'),
        SizedBox(height: 10),
        Text('Address: ${_addressController.text}'),
        SizedBox(height: 10),
        Text('Birthday: ${_birthdayController.text}'),
        SizedBox(height: 10),
        Text('Email: ${_emailController.text}'),
        SizedBox(height: 10),
        Text('Motto in Life: ${_mottoController.text}'),
      ],
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void submitProfile() {
    print('Name: ${_nameController.text}');
    print('Age: ${_ageController.text}');
    print('Address: ${_addressController.text}');
    print('Birthday: ${_birthdayController.text}');
    print('Email: ${_emailController.text}');
    print('Motto in Life: ${_mottoController.text}');

    setState(() {
      _editMode = false;
    });
  }
}
