// we use a interface here so that in future if the remote server changes(like Supabase to Firebas) we have a deal or rule to implements this fields so that we don't miss out anything..

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

// we should name it as AuthSupabaseRemoteDataSourceImpl .. In future we can create for AuthFirebaseRemoteDataSourceImpl like the same way ..
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // We are not going to initialize  SupabaseClient here because - 1.we don't want to put any dependency here(so that easily change to firebase or other).. 2. for easy unit testing.. so we will use dependency injection here
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user == null) {
        throw const ServerException("User does not exits! please sign up");
      }
      return UserModel.fromJson(response.user!.toJson());
      // UserModel.fromJson() method returns an instance ,, with that instance we are calling the copyWith() method which will create another object with existing values and new email(previously email was empty string),, and at the end it will return a object with all the fields..
    } on AuthApiException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
          // here you can add user profile, address etc..
        },
      );

      if (response.user == null) {
        throw const ServerException("Sign Up failed! , please try again");
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthApiException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

//currentSession will give only id and email of the user if he is logged in, but we need more info so we will use this userSession to fetch live data from the server
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        // userData is a list of maps [{},{},{}] where a map itself is a particular user data , but we put a condition here in eq() method so we get only one user data [{}] which matches the condition .. and fromJson() takes only map so we pass first map from the list which is nothing but the matched user ..
        return UserModel.fromJson(userData.first)
            .copyWith(email: currentUserSession!.user.email);
        // we are using copyWith() as we have not stored user email in the data base so we are retriving it from supabase authentication file ..
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

// in the database query we are fetching the table with name "profiles" selecting all the columns where and a row where 'id'= userSession!.user.id
