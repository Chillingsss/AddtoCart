import 'package:flutter/material.dart';
import 'package:project/User.dart';
import 'dashboard.dart'; // Import your Dashboard screen

class ProfilePage extends StatefulWidget {
  final Widget? listView;
  final double? total;
  final double? moneytendered;
  final double? change;

  ProfilePage({
    this.listView,
    this.total,
    this.moneytendered,
    this.change,
  });

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
  Users users = Users();

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
          if (_editMode) // Show "Ok" button only in edit mode
            TextButton(
              onPressed: () {
                // Navigate to the Dashboard screen when "Ok" is clicked
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/pogi.jpg'),
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
              Card(
                child: Column(
                  children: [
                    Text("Recent Purchased"),
                    if (widget.listView != null) widget.listView!,
                  ],
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileDetails() {
    return Column(
      children: [
        Text(
            'Name:  ${users.getFirstName()}  ${users.getMiddleName()} ${users.getLastName()}'),
        SizedBox(height: 10),
        Text('Email: ${users.getEmail()}'),
        SizedBox(height: 10),
        Text('Contact Number: ${users.getCPNumber()}'),
        SizedBox(height: 10),
        Text('Username: ${users.getUsername()}'),
        SizedBox(height: 10),
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
