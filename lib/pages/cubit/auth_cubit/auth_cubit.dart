import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

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

  Future<void> registerUser({required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      var auth = FirebaseAuth.instance;

      // Attempt login with email and password
      UserCredential userCred = await auth.createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess()); // Emit success state when login is successful
    } on FirebaseAuthException catch (ex) {
      // Handle Firebase-specific errors
      if (ex.code == 'weak-password') {
        emit(RegisterFailure(errMessage: 'Weak Password'));
      } else if (ex.code == 'Email Already In Used') {
        emit(RegisterFailure(errMessage: 'Email Already In Used'));
      } else {
        emit(RegisterFailure(errMessage: 'Error: ${ex.message}'));
      }
    } catch (e) {
      // Handle generic exceptions
      emit(RegisterFailure(errMessage: 'Something Went Wrong, Please Try Again Later'));
    }
  }
}
