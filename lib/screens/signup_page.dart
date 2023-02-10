// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:newsapp/screens/login_page.dart';
import 'package:newsapp/screens/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password, _name;
  bool spinner = false;
  final countryPicker = FlCountryCodePicker();
  CountryCode? countryCode;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Social',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20.0,
                  letterSpacing: 1.5),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'X',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 35.0,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 250, 21, 4),
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: isPortrait
                    ? screensize.height * 0.075
                    : screensize.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => LoginPage()))),
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 250, 21, 4),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35.0),
                              bottomRight: Radius.circular(35.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: isPortrait
                    ? screensize.height * 0.7
                    : screensize.height * 1.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 35, right: 35),
                    child: Column(
                      children: [
                        Text(
                          'Create an Account',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (input) => _name = input!,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            alignLabelWithHint: true,
                            hintText: 'John Doe',
                            suffixIcon: Icon(
                              Icons.person,
                            ),
                            suffixIconColor: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Please enter an email';
                            }
                            return null;
                          },
                          onSaved: (input) => _email = input!,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            alignLabelWithHint: true,
                            hintText: 'example@gmail.com',
                            suffixIcon: Icon(
                              Icons.email,
                            ),
                            suffixIconColor: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Contact no',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            hintText: '9876543210',
                            suffixIcon: Icon(
                              Icons.phone,
                            ),
                            suffixIconColor: Colors.red,
                            prefixIcon: Container(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final code = await countryPicker
                                          .showPicker(context: context);
                                      setState(() {
                                        countryCode = code;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          child: countryCode != null
                                              ? countryCode!.flagImage
                                              : null,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          child: Text(
                                            countryCode != null
                                                ? countryCode!.code
                                                : 'IN',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          child: Text(
                                              countryCode?.dialCode ?? '+1'),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length != 10) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input!.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onSaved: (input) => _password = input!,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '********',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            suffixIcon: Icon(Icons.lock_outline),
                            suffixIconColor: Colors.red,
                          ),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              activeColor: Colors.red,
                              focusColor: Colors.red,
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            Text("I agree with "),
                            Text(
                              "terms and conditions",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                decorationThickness: 2.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account ? '),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => LoginPage()))),
                              child: Text(
                                'Sign In!',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () => _submit(),
                  child: Container(
                    height: screensize.height * 0.08,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 250, 21, 4),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          topRight: Radius.circular(35.0)),
                    ),
                    child: Center(
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _isChecked) {
      _formKey.currentState!.save();
      setState(() {
        spinner = true;
      });
      try {
        final newuser = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        if (newuser != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));
        }
        setState(() {
          spinner = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          spinner = false;
        });
      }
    } else if (!_isChecked) {
      final snackbar =
          SnackBar(content: Text('Please agree with terms and conditions'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
