import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class DioFactory {
  static PersistCookieJar? _cookieJar;

  static Future<void> clearCookies() async {
    await _cookieJar?.deleteAll();
  }

  static Future<Dio> createDio() async {
    final dir = await getApplicationDocumentsDirectory();

   _cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage('${dir.path}/.cookies/'),
    );

    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://bavix.k.frappe.cloud',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      ),
    );

    dio.interceptors.add(CookieManager(_cookieJar!));

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final csrf = response.headers.value('x-frappe-csrf-token');

          if (csrf != null && csrf.isNotEmpty) {
            dio.options.headers['X-Frappe-CSRF-Token'] = csrf;
          }

          handler.next(response);
        },
        onRequest: (options, handler) {
          options.headers['Accept'] = 'application/json';
          options.headers['X-Requested-With'] = 'XMLHttpRequest';

          final csrf = dio.options.headers['X-Frappe-CSRF-Token'];

          if (csrf != null) {
            options.headers['X-Frappe-CSRF-Token'] = csrf;
          }

          handler.next(options);
        },
      ),
    );

    return dio;
  }
}
