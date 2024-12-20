abstract class AuthEvenet {}

class LoginEvent extends AuthEvenet {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvenet {}
