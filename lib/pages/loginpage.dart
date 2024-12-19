import 'package:chat_scolar/components/custom_button.dart';
import 'package:chat_scolar/components/custom_textfield.dart';
import 'package:chat_scolar/constant.dart';
import 'package:chat_scolar/helper/show_snack_bar.dart';
import 'package:chat_scolar/pages/chat_page.dart';
import 'package:chat_scolar/pages/cubit/chat_cubit/chat_cubit.dart';
import 'package:chat_scolar/pages/cubit/login_cubit/login_cubit.dart';
import 'package:chat_scolar/pages/cubit/login_cubit/login_state.dart';
import 'package:chat_scolar/pages/registerpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(email: email)));
        } else if (state is LoginFailure) {
          showSnackBar(context, state.errMessage);
        }
      },
      child: ModalProgressHUD(
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
                          'Login',
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
                      isPassword: true,
                      onChanged: (data) {
                        password = data;
                      },
                      hintText: 'Password',
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await loginUser();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success Login")));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          email: email,
                                        )));
                          } catch (e) {
                            print(e.toString());
                            showSnackBar(context, e.toString());
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      text: 'Login',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Don't Have An Account?",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            '   Click To Register',
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
      ),
    );
  }

  Future<void> loginUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential userCred = await auth.signInWithEmailAndPassword(email: email!, password: password!);
  }
}
