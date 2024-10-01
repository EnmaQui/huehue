import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:huehue/config/dio.map.config.dart';
import 'package:huehue/infrastructure/datasource/google/google.map.datasource.impl.dart';
import 'package:huehue/infrastructure/repository/google/google.map.repository.impl.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';

final serviceLocator = GetIt.instance;

void setUpServiceLocator() {
  serviceLocator
  ..registerSingleton<Dio>(DioMapConfig.dio)
  ..registerSingleton<PlaceBloc>(PlaceBloc(
    googleMapRepository: GoogleMapRepositoryImpl(
      googleMapDataSource: GoogleMapDataSourceImpl()
    )
  ));
}