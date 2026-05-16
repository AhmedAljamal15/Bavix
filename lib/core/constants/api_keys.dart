import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String get gemini =>
      dotenv.env['GEMINI_API_KEY'] ?? '';
}