import 'package:project/User.dart';
import 'package:project/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Users users = Users();
  String _msg = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync'),
        backgroundColor: Color.fromARGB(255, 155, 155, 155),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: const Color.fromARGB(
            255,
            17,
            16,
            16,
          ), // Set your desired background color here
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    color: Color.fromARGB(255, 155, 155, 155),
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(fontSize: 24.0),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: usernameController,
                              decoration:
                                  const InputDecoration(labelText: "Username"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input field';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration:
                                  const InputDecoration(labelText: "Password"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input field';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                login();
                              }
                            },
                            child: Text('Login'),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()),
                              );
                            },
                            icon: Icon(Icons.person_add),
                            label: Text('Sign Up'),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            _msg,
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    String url = "http://localhost/api/login.php";

    try {
      final Map<String, dynamic> queryParams = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      http.Response response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      print("eyy" + response.body);
      if (response.statusCode == 200) {
        List<dynamic> userList = jsonDecode(response.body);

        if (userList.isNotEmpty) {
          var user = userList[0];
          users.SetInformation(
            user['firstname'],
            user['middlename'],
            user['lastname'],
            user['address'],
            user['email'],
            user['cpnumber'].toString(),
            user['username'],
          );

          print("userFirstname: " + users.getFirstName());
          print("userMiddlename: " + user['middlename']);
          print("userLastname: " + user['lastname']);
          print("userAddress: " + user['address']);
          print("userEmail: " + user['email']);
          print("userCpnumber: " +
              user['cpnumber'].toString()); // Convert to string
          print("userUsername: " + user['username']);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          print("Invalid username or password");
          setState(() {
            _msg = "Invalid username or password";
          });
        }
      } else {
        print("Invalid username or password");
        setState(() {
          _msg = "Invalid username or password";
        });
      }
    } catch (error) {
      print("Error occurred. Please try again later." + error.toString());
      setState(() {
        _msg = "Error occurred. Please try again later.";
      });
    }
  }
}

class Signup extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<Signup> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cpnumberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();

  Future<void> signUp() async {
    if (firstnameController.text.isEmpty ||
        middlenameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        addressController.text.isEmpty ||
        emailController.text.isEmpty ||
        cpnumberController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        retypePasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    String url = "http://localhost/api/register.php";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "reg-firstname": firstnameController.text,
          "reg-middlename": middlenameController.text,
          "reg-lastname": lastnameController.text,
          "reg-address": addressController.text,
          "reg-email": emailController.text,
          "reg-cpnumber": cpnumberController.text,
          "reg-username": usernameController.text,
          "reg-password": passwordController.text,
          "reg-retype-password": retypePasswordController.text,
        },
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(content: Text('Registration successful')),
            )
            .closed
            .then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyApp()), // Replace MyApp with your main.dart widget
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      }
    } catch (error) {
      // Error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 17, 16, 16),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    color: Color.fromARGB(255, 203, 203, 203),
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 24.0),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: firstnameController,
                              decoration: InputDecoration(
                                labelText: 'Firstname:',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .red), // Set border color to red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: middlenameController,
                              decoration: InputDecoration(
                                labelText: 'Middlename:',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .red), // Set border color to red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: lastnameController,
                              decoration: InputDecoration(
                                labelText: 'Lastname:',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .red), // Set border color to red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                labelText: 'Address:',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .red), // Set border color to red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email:',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .red), // Set border color to red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: cpnumberController,
                              decoration: InputDecoration(
                                labelText: 'Contact Number:',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .red), // Set border color to red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username:',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .red), // Set border color to red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password:',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .red), // Set border color to red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: retypePasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Retype Password:',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .red), // Set border color to red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: signUp,
                            child: Text('Sign Up'),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
                              );
                            },
                            icon: Icon(Icons.login),
                            label: Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
