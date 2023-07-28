import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sample/repositories/sendbird_repository.dart';
import 'package:sendbird_sample/utils/local_storage.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendbirdRepository repository;

  AuthBloc({required this.repository}) : super(Loading()) {
    on<CheckIfLoggedIn>(onCheckIfLoggedIn);
    on<Login>(onLogin);
    on<Logout>(onLogout);
  }

  onCheckIfLoggedIn(CheckIfLoggedIn event, Emitter<AuthState> emit) async {
    emit(Loading());
    var user = repository.sendbirdSdk.currentUser;
    final userId = await LocalStorage().getUserId();

    if (userId.isEmpty) {
      emit(LoggedOut());
      return;
    }

    user ??= await repository.sendbirdSdk.connect(userId);

    emit(LoggedIn(user: user));
  }

  onLogin(Login event, Emitter<AuthState> emit) async {
    emit(Loading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await repository.sendbirdSdk.connect(event.userId);
      final success = await LocalStorage().setUserId(event.userId);
      if (success) {
        emit(LoggedIn(user: user));
      } else {
        throw Error();
      }
    } catch (e) {
      emit(LoggedOut());
    }
  }

  onLogout(Logout event, Emitter<AuthState> emit) async {
    emit(Loading());
    await Future.delayed(const Duration(milliseconds: 500));
    await repository.sendbirdSdk.disconnect();
    await LocalStorage().deleteUserId();
    emit(LoggedOut());
  }
}
