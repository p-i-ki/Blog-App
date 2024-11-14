import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/domain/use_cases/current_user.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_log_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignup,
    required UserLogIn userLogIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignup,
        _userLogIn = userLogIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    // on<AuthEvent>(
    //   //for any kind of AuthEvent we will emit AuthLoading() state first ,, so that we don't have to do in each auth event..
    //   (_, emit) => emit(AuthLoading()),
    // );
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogIn>(_onAuthLogIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    print("------SIGN-UP EVENT IS TRIGGERED-------");
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }
  // void _onAuthSignUp(
  //   AuthSignUp event,
  //   Emitter<AuthState> emit,
  // ) {
  //   (event, emit) async {
  //     print("------SIGN-UP EVENT IS TRIGGERED-------");
  //     emit(AuthLoading());
  //     print("------SIGN-UP EVENT IS TRIGGERED-------");
  //     try {
  //       final res = await _userSignUp(UserSignUpParams(
  //         email: event.email,
  //         password: event.password,
  //         name: event.name,
  //       ));
  //       res.fold(
  //         (l) => emit(AuthFailure(l.message)),
  //         (r) => _emitAuthSuccess(r, emit),
  //       ); // r is the uid itself
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   };
  // }

  void _onAuthLogIn(
    AuthLogIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _userLogIn(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}

// UserSignUp class is a callable class means we can call it's instance as normal functions and we are passing UserSignUpParams as argument.. it is like we are calling the "call" function and passing the arguments..

// The AuthBloc class manages the state and events related to authentication.It uses the UserSignUp use case to handle the sign-up process.
// When an AuthSignUp event is received, it triggers the UserSignUp use case, passing the user's email, password, and name.
// The result of the use case is then handled by either emitting an AuthFailure state (if the sign-up failed) or an AuthSuccess state (if the sign-up succeeded).