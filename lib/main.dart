import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/log_in_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//    final supabase = await Supabase.initialize(
//       url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseApi);
//   runApp(MultiBlocProvider(providers: [
//     BlocProvider(
//       create: (_) => AuthBloc(
//         userSignup: UserSignUp(
//           AuthRepositoryImpl(
//             authRemoteDataSource:
//                 AuthRemoteDataSourceImpl(supabaseClient: supabase.client),
//           ),
//         ),
//       ),
//     ),
//     //here we are using implementing classes , so in future if we want to use Firebase then we simple have to create implementing classes ,interface classes will remain same and will be easy to implement all the required properties..
//   ], child: const MyApp()));
//   //runApp already has  WidgetsFlutterBinding.ensureInitialized() binding , but when we initialize something before runApp() we should use this binding so that bindings works correctly..
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<BlogBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
  //runApp already has  WidgetsFlutterBinding.ensureInitialized() binding , but when we initialize something before runApp() we should use this binding so that bindings works correctly..
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          }
          return const LogInPage();
        },
      ),
    );
  }
}
