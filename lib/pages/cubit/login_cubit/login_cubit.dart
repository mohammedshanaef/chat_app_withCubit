import 'package:chat_scolar/pages/cubit/login_cubit/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      var auth = FirebaseAuth.instance;

      // Attempt login with email and password
      await auth.signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess()); // Emit success state when login is successful
    } on FirebaseAuthException catch (ex) {
      // Handle Firebase-specific errors
      if (ex.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'User Not Found'));
      } else if (ex.code == 'wrong-password') {
        emit(LoginFailure(errMessage: 'Wrong Password'));
      } else {
        emit(LoginFailure(errMessage: 'Error: ${ex.message}'));
      }
    } catch (e) {
      // Handle generic exceptions
      emit(LoginFailure(errMessage: 'Something Went Wrong, Please Try Again Later'));
    }
  }
}
