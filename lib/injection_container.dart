import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/tasks/data/datasources/task_remote_datasource.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/repositories/task_repository.dart';
import 'features/tasks/domain/usecases/create_task.dart';
import 'features/tasks/domain/usecases/delete_task.dart';
import 'features/tasks/domain/usecases/get_tasks.dart';
import 'features/tasks/domain/usecases/toggle_task_completion.dart';
import 'features/tasks/domain/usecases/update_task.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';

// Service Locator instance
final sl = GetIt.instance;

// Entry point to initialize all dependencies before the app starts
Future<void> init() async {
  // ---------------------------------------------------------------------------
  // BLoCs (Presentation Layer)
  // Registered as Factories so a new instance is created for every usage/screen
  // ---------------------------------------------------------------------------
  sl.registerFactory(
    () => AuthBloc(
      registerUser: sl(),
      loginUser: sl(),
      logoutUser: sl(),
      getCurrentUser: sl(),
      authRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      toggleTaskCompletion: sl(),
      taskRepository: sl(),
    ),
  );

  // Use Cases (Domain Layer)
  // Registered as Lazy Singletons (created only when first requested)
  // Auth
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Tasks
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => ToggleTaskCompletion(sl()));

  // Repositories (Domain & Data Layer)
  // Maps abstract interfaces to concrete implementations
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources (Data Layer)
  // Handles direct communication with external APIs/Databases
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(firestore: sl()),
  );

  // External Dependencies
  // Third-party libraries (Firebase, etc.)
  sl.registerLazySingleton(() => firebase_auth.FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
