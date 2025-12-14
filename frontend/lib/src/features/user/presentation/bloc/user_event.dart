import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserLoginEvent extends UserEvent {
  final String username;
  final String password;

  UserLoginEvent(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class UserRegisterEvent extends UserEvent {
  final String username;
  final String email;
  final String password;

  UserRegisterEvent(this.username, this.email, this.password);

  @override
  List<Object?> get props => [username, email, password];
}
