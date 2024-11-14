//HERE WE WILL REGISTER SERVICES means CREATING INSTANC OR OBJECTS OF THE SERVICES IN CENTRALIZE WAY so that we can use or access them as needed easily and globaly..
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/daata_resources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/use_cases/current_user.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_log_in.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_remote_data_sourece.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repositorie_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//GetIt is a callable class so we can use it's objects as function like serviceLocator<T>()
final serviceLocator = GetIt.instance; //returns a singleton object

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseApi);
  // for creating a single instance..
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

// for initializing all the auth related dependencies..
void _initAuth() {
  // Data source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator<SupabaseClient>(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
      ),
    )
    //Use cases - SignUp
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    //Use cases - SignIn
//we don't need any implementing class to register again ,, UserLogIn also needs repo,data source but they are already register and it can easily get those instances..
    ..registerFactory(
      () => UserLogIn(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    //Bloc
//we need only one instance or object of the AuthBloc, so that only one state exist ,, if it is not then each time a new AuthBloc instance get created then previous state get lost we get AuthInitial() state each time..
    ..registerLazySingleton(
      () => AuthBloc(
        userSignup: serviceLocator(),
        userLogIn: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  // Data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSourece>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    ) //Repo
    ..registerFactory<BlogRepository>(() => BlogRepositorieImpl(
          serviceLocator(),
        )) //Usecase -
    ..registerFactory(() => UploadBlog(
          serviceLocator(),
        )) //UseCase -
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    ) //Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}

// before calling serviceLocator() make sure that the dependency is already registered ,, like if you are calling it from UserSignUp then the dependency AuthRepository must be registered else it will give error..
// here if you don't pass the generic type <SupabaseClient> then also get_it will find it itself.. it will see that AuthRemoteDataSourceImpl requires SupabaseClient so it will search for any registered SupabaseClient object and returns that object..
// but for the AuthRepositoryImpl it requires AuthRemoteDataSource not AuthRemoteDataSourceImpl and we have registered only AuthRemoteDataSourceImpl , so we have to explicitly mention that AuthRemoteDataSourceImpl returns AuthRemoteDataSource object ..Same for UserSignUp as it requires  AuthRepository not AuthRepositoryImpl..

// After initializing these dependencies in initDependencies(), any class in your Flutter app can access these services without worrying about how they are created or managed.
// example: AuthBloc authBloc = serviceLocator<AuthBloc>();
// Here, you can retrieve an AuthBloc instance from the service locator, and it will automatically have all its dependencies injected.. means you don't have to take care of instances if Use cases it takes or other dependencies it will automatically retrieve ..
