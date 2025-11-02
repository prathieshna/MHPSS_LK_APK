
import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstants {
  // Testing Env
  static String baseUrl = dotenv.env['TESTING_BASE_URL']!;

  // Local Afaq Dev
  // static const String baseUrl = dotenv.env['LOCAL_BASE_URL']!;
}
