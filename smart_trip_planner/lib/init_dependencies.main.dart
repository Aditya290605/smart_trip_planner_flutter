part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  serviceLocator.registerLazySingleton(() => auth);
  serviceLocator.registerLazySingleton(() => fireStore);
  serviceLocator.registerLazySingleton(() => UserDataCubit());
}

void initAuth() {
  serviceLocator.registerFactory<RemoteDataSoucre>(
    () => RemoteDataSourceImpl(
      auth: serviceLocator(),
      firestore: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(dataSoucre: serviceLocator()),
  );

  serviceLocator.registerFactory<SignUpUsecase>(
    () => SignUpUsecase(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<UserAuthUsecase>(
    () => UserAuthUsecase(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<SignInUsecase>(
    () => SignInUsecase(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(() => UserCurrentLogin());

  serviceLocator.registerLazySingleton(
    () => AuthBlocBloc(
      signUpUseCase: serviceLocator(),
      usecasae: serviceLocator(),
      userDataCubit: serviceLocator(),
      signInUseCase: serviceLocator(),
    ),
  );
}

void initTrip() {
  const apiKey = geminiAPIKey;

  serviceLocator.registerLazySingleton<TripRemoteDatasource>(
    () => TripRemoteDatasourceImpl(apiKey),
  );
  serviceLocator.registerLazySingleton<ItineraryRepository>(
    () => ItineraryRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GenerateItineraryUseCase>(
    () => GenerateItineraryUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory(() => ItineraryBloc(serviceLocator()));
}
