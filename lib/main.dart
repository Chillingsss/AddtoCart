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
  String _msg = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync'),
      ),
      body: Container(
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
                  color: Color.fromARGB(255, 203, 203, 203),
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
                          child: TextField(
                            controller: usernameController,
                            decoration:
                                const InputDecoration(labelText: "Username"),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          width: 300,
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: "Password"),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            login();
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
                              MaterialPageRoute(builder: (context) => Signup()),
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
    );
  }

  void login() async {
    String url = "http://localhost/db/lib/api/login.php";

    try {
      final Map<String, dynamic> queryParams = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      http.Response response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      print("eyy" + response.body);
      if (response.statusCode == 200) {
        var user = jsonDecode(response.body);

        if (user is List && user.isNotEmpty) {
          var firstUser = user[0];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
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
  int signUpCount = 0;

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
                              decoration: InputDecoration(
                                labelText: 'Firstname:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Middlename:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Lastname:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Email:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Contact Number:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Username:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Password:',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton.icon(
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
