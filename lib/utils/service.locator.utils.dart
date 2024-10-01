import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:huehue/config/dio.map.config.dart';

final serviceLocator = GetIt.instance;

void setUpServiceLocator() {
  serviceLocator.registerSingleton<Dio>(DioMapConfig.dio);
}