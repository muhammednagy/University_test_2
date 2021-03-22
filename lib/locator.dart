import 'package:get_it/get_it.dart';

import 'API/CRUDModel.dart';
import 'API/api.dart';
GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => Api('randomNumbers'));
  locator.registerLazySingleton(() => CRUDModel()) ;
}