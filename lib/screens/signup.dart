import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harjeet_prj/styles/app_colors.dart';
import 'package:harjeet_prj/screens/signin.dart';
import 'package:harjeet_prj/widgets/custom_button.dart';
import 'package:harjeet_prj/widgets/custom_formfield.dart';
import 'package:harjeet_prj/widgets/custom_header.dart';
import 'package:harjeet_prj/widgets/custom_richtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:auth/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);



  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _userName = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get userName => _userName.text.trim();

  String get email => _emailController.text.trim();

  String get password => _passwordController.text.trim();

  void update() async {
    if (email.isEmpty) {
      print("Email is Empty");
    } else {
      if (password.isEmpty) {
        print("Password is Empty");
      }
      else {
        if(userName.isEmpty) {
          print("Username is Empty ");
        } else {
          context.read<AuthService>().signup(
            userName,email,password).then((value) async {
              User? user = FirebaseAuth.instance.currentUser ;

              await FirebaseFirestore.instance.collection("users").doc(user!.uid).set(
                  {
                    'userName': userName,
                    'email': email ,
                    'password':password,
                    'userid' : user.uid,
                  }
              );
          }
          );
        }
      }
    }

  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  color: Color.fromRGBO(130, 32, 92, 1),
                ),
                CustomHeader(
                    text: 'Sign Up.',
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()));
                    }),
                Positioned(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.08,
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.9,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: const BoxDecoration(
                        color: AppColors.whiteshade,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 200,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            margin: EdgeInsets.only(
                                left: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.09),
                            // child: const Text('Image')
                            child: Image.asset("assets/images/img3.jpeg")
                          // child:Image.asset("assets/images/login.png"),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "UserName",
                          hintText: "username",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          controller: _userName,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "Email",
                          hintText: "Email",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          controller: _passwordController,
                          headingText: "Password",
                          hintText: "At least 8 Character",
                          obsecureText: true,
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () {}),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        AuthButton(
                          onTap: () {update();},
                          text: 'Sign Up',
                        ),
                        CustomRichText(
                          discription: 'Already Have an account? ',
                          text: 'Log In here',
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()));
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      );
    }
  }

mixin AuthService {
  signup(String userName, String email, String password) {}
}



