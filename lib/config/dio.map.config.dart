import 'package:dio/dio.dart';
import 'package:huehue/const/data.const.dart';

class DioMapConfig {

  DioMapConfig();
  
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: DataConst.googleMapApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
}