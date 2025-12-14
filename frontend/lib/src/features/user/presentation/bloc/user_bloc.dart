import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../domain/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<UserLoginEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await repository.login(event.username, event.password);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UserRegisterEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await repository.register(
          event.username,
          event.email,
          event.password,
        );
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
