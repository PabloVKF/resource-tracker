import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/authentication_service.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authService;

  AuthenticationBloc(this._authService) : super(AuthenticationInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await _authService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthenticationSuccess());
    } catch (error) {
      emit(AuthenticationFailure(error: error.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await _authService.createWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthenticationSuccess());
    } catch (error) {
      emit(AuthenticationFailure(error: error.toString()));
    }
  }
}
