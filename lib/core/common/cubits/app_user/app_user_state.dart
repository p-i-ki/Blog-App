part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {
  const AppUserState();
}

// this is the state when the user is not logged in or he just logged out..
final class AppUserInitial extends AppUserState {}

// we got user data in the auth bloc but auth bloc should only be used for auth features not anywhere else..
final class AppUserLoggedIn extends AppUserState {
  final User user;
  const AppUserLoggedIn(this.user);
}
// NOTE => Core features can be used anywhere but no other features should be used in the Core ..