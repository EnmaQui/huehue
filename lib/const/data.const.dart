import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DataConst {
    static final String googleApiKey = kReleaseMode ? const String.fromEnvironment('GOOGLEAPIKEY') :  dotenv.get('GOOGLEAPIKEY'); 
    static final String googleMapApi = kReleaseMode ? const String.fromEnvironment('GOOGLEMAPAPI') :  dotenv.get('GOOGLEMAPAPI');
}