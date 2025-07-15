import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:smart_trip_planner/core/common/user/cubit/user_data_cubit.dart';
import 'package:smart_trip_planner/core/common/wrappers/auth_wraper.dart';
import 'package:smart_trip_planner/core/theme/app_theme.dart';
import 'package:smart_trip_planner/core/utils/userdata.dart';

import 'package:smart_trip_planner/features/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:smart_trip_planner/features/auth/presentation/pages/sing_up_page.dart';
import 'package:smart_trip_planner/features/trip_plan/data/model/itinerary_hive_model.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/home_page.dart';
import 'package:smart_trip_planner/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initDependencies();
  initAuth();
  initTrip();
  await Hive.initFlutter();

  Hive.registerAdapter(ItineraryHiveModelAdapter());
  Hive.registerAdapter(ItineraryDayHiveModelAdapter());
  Hive.registerAdapter(ItineraryItemHiveModelAdapter());
  await Hive.openBox<ItineraryHiveModel>('itineraries');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<UserDataCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBlocBloc>()),
        BlocProvider(create: (_) => serviceLocator<ItineraryBloc>()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
      home: AuthWrapper(
        child: BlocSelector<UserDataCubit, UserDataState, bool>(
          selector: (state) => state is UserLoggedIn,
          builder: (context, isLoggedIn) {
            if (!isLoggedIn) {
              return SingUpPage();
            }
            return HomePage();
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
