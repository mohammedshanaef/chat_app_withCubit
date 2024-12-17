import 'package:chat_scolar/pages/cubit/register_cubit/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

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
        emit(RegisterFailure(errMessage: 'email-already-in-use'));
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
