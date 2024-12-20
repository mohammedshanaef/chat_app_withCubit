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
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   AuthBloc() : super(AuthInitial()) {
//     on<LoginEvent>((event, emit) async {
//       emit(LoginLoading());
//       try {
//         // Login :)
//         var auth = FirebaseAuth.instance;
//         await auth.signInWithEmailAndPassword(
//           email: event.email,
//           password: event.password,
//         );
//         emit(LoginSuccess());
//       } catch (e) {
//         emit(LoginFailure(errMessage: e.toString()));
//       }
//     });

//     on<LogoutEvent>((event, emit) async {
//       emit(LogoutLoading());
//       try {
//         var auth = FirebaseAuth.instance;
//         await auth.signOut(); // Logout :)
//         emit(LogoutSuccess());
//       } catch (e) {
//         emit(LogoutFailure(errMessage: e.toString()));
//       }
//     });

//     on<LogoutWithClearDataEvent>((event, emit) async {
//       emit(LogoutLoading());
//       try {
//         var auth = FirebaseAuth.instance;
//         await auth.signOut(); // logout
//         // clear whole data :)
//         await clearLocalData();
//         emit(LogoutSuccess());
//       } catch (e) {
//         emit(LogoutFailure(errMessage: e.toString()));
//       }
//     });

//     on<ForceLogoutEvent>((event, emit) {
//       emit(ForceLogout(reason: event.reason));
//     });

//     on<ChangePasswordEvent>((event, emit) async {
//       emit(ChangePasswordLoading());
//       try {
//         var auth = FirebaseAuth.instance.currentUser;

//         if (auth != null) {
//           // تغيير كلمة المرور
//           await auth.updatePassword(event.newPassword);
//           emit(ChangePasswordSuccess());
//         } else {
//           emit(ChangePasswordFailure(errMessage: "User not logged in"));
//         }
//       } catch (e) {
//         emit(ChangePasswordFailure(errMessage: e.toString()));
//       }
//     });
//   }

//   Future<void> clearLocalData() async {
//     // clear Data Stored
//   }
// }