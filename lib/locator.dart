import 'package:Rapdi/services/firestore_service.dart';
import 'package:get_it/get_it.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FiretoreService());
}