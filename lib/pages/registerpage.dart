import 'package:chat_scolar/components/custom_button.dart';
import 'package:chat_scolar/components/custom_textfield.dart';
import 'package:chat_scolar/constant.dart';
import 'package:chat_scolar/helper/show_snack_bar.dart';
import 'package:chat_scolar/pages/cubit/register_cubit/register_cubit.dart';
import 'package:chat_scolar/pages/cubit/register_cubit/register_state.dart';
import 'package:chat_scolar/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));
          isLoading = false;
        } else if (state is RegisterFailure) {
          showSnackBar(context, state.errMessage);
          isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Image.asset('assets/images/scholar.png'),
                      const Text(
                        'Scholar Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Pacifico',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Row(
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextFormField(
                        onChanged: (data) {
                          email = data;
                        },
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        onChanged: (data) {
                          password = data;
                        },
                        hintText: 'Password',
                        isPassword: true,
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        text: 'Register',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<RegisterCubit>(context).registerUser(email: email!, password: password!);
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Already Have An Account ?",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '   Click To Login',
                              style: TextStyle(
                                color: Color(0xffc4e9c7),
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> registerUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential userCred = await auth.createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
