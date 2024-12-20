import 'package:chat_scolar/pages/blocs/auth_event.dart';
import 'package:chat_scolar/pages/cubit/auth_cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvenet, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvenet>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoading());
        try {
          var auth = FirebaseAuth.instance;

          // Attempt login with email and password
          await auth.signInWithEmailAndPassword(email: event.email, password: event.password);
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
        onTransition(Transition<AuthEvenet, AuthState> transition) {
          super.onTransition(transition);
          print(transition);
        }
      }
    });
  }
}
