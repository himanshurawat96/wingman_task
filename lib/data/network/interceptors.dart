import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInterceptors extends Interceptor {
  @override
  Future<dynamic> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint("===[${options.method}] ${options.baseUrl}${options.path}");
    if(options.queryParameters.isNotEmpty) {
      debugPrint("===[PARAMS] ${options.queryParameters}");
    }
    if(options.data!=null) {
      debugPrint("===[BODY] ${(options.data.runtimeType == FormData ? (options.data as FormData).fields : options.data).toString()}");
    }

    if (options.headers.containsKey("token")) {

      options.headers.remove("token");
      var token =  prefs.get("token");

      options.headers["Token"] = "$token";
      return handler.next(options);
    }
    return handler.next(options);
  }

  @override
  Future<dynamic> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response != null &&
        err.response?.statusCode != null &&
        err.response?.statusCode == 401) {
      // (await CacheManager()).cleanCache();
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString("apiToken", "");
      // navigatorKey.currentState.pushNamed(SplashScreen.routeName);

    }
    debugPrint('===[ERROR RESPONSE[${err.response?.statusCode}] - ${err.response?.realUri.toString()}] - ${err.response}');
    debugPrint('===END');
    return handler.next(err);
  }

  @override
  Future<dynamic> onResponse(Response response, ResponseInterceptorHandler handler) async {
    debugPrint('===[RESPONSE[${response.statusCode}-${response.realUri.toString()}]] - ${response.data}');
    debugPrint('===END');
    return handler.next(response);
  }
}