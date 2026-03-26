import 'package:get_it/get_it.dart';
import 'package:smart_budget/features/authentication/domain/repositories/auth_repository.dart';
import 'package:smart_budget/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/authentication/data/repositories/auth_repository_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Register Supabase client
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<SupabaseClient>()),
  );


    // Register BLoCs
getIt.registerFactory<AuthBloc>(()=>AuthBloc(getIt<AuthRepository>()));
}
