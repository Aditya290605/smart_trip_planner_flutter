import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/common/user/cubit/user_data_cubit.dart';
import 'package:smart_trip_planner/core/theme/app_theme.dart';
import 'package:smart_trip_planner/features/auth/data/data_source/auth_remote_data_soucre.dart';
import 'package:smart_trip_planner/features/auth/data/repository/auth_repository_impl.dart';

import 'package:smart_trip_planner/features/auth/domain/usercase/sign_up_usecase.dart';
import 'package:smart_trip_planner/features/auth/domain/usercase/user_auth_usecase.dart';
import 'package:smart_trip_planner/features/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:smart_trip_planner/features/auth/presentation/pages/sing_up_page.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserDataCubit()),
        BlocProvider(
          create: (_) => AuthBlocBloc(
            userDataCubit: UserDataCubit(),

            usecasae: UserAuthUsecase(
              authRepository: AuthRepositoryImpl(
                dataSoucre: RemoteDataSourceImpl(
                  auth: FirebaseAuth.instance,
                  firestore: FirebaseFirestore.instance,
                ),
              ),
            ),

            signUpUseCase: SignUpUsecase(
              authRepository: AuthRepositoryImpl(
                dataSoucre: RemoteDataSourceImpl(
                  auth: FirebaseAuth.instance,
                  firestore: FirebaseFirestore.instance,
                ),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
    context.read<AuthBlocBloc>().add(UserCurrentLogin());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itinera AI',
      theme: AppTheme.lightTheme,
      home: BlocSelector<UserDataCubit, UserDataState, bool>(
        selector: (state) => state is UserLoggedIn,
        builder: (context, isLoggedIn) {
          if (!isLoggedIn) {
            return SingUpPage();
          }
          return HomePage();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
