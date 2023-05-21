import 'dart:math';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wingman_task/data/repository/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingman_task/ui/auth/login.dart';
import 'data/network/api_service.dart';
import 'package:animations/animations.dart';
import 'data/network/interceptors.dart';

import 'utils/constants.dart';
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  final sharedPreferences = await SharedPreferences.getInstance();
  Dio dio = Dio();
  dio.interceptors.add(AppInterceptors());
  final ApiService apiService = ApiService(dio);
  runApp(MyApp(sharedPreferences, apiService));
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp(this.prefs, this.apiService, {Key? key}) : super(key: key);

  final SharedPreferences prefs;
  final ApiService apiService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: AuthRepository(widget.prefs, widget.apiService)),
        Provider<SharedPreferences>.value(value: widget.prefs),
      ],
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) {
            return MaterialApp(
              navigatorKey: MyApp.navigatorKey,
              title: 'Wingman Test',
              debugShowCheckedModeBanner: false,
              builder: (context, widget) {
                //add this line
                // ScreenUtil.setContext(context);
                return MediaQuery(
                  //Setting font does not change with system font size
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                );
              },
              theme: ThemeData(
                primarySwatch: Colors.green,
                scaffoldBackgroundColor: K.themeColorBg,
                appBarTheme: const AppBarTheme(
                  backgroundColor: K.themeColorBg,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: K.fontFamily,
                      color: K.themeColorPrimary
                  ),
                  iconTheme: IconThemeData(
                      color: K.themeColorPrimary,
                      size: 22
                  ),
                  centerTitle: true,
                ),
                useMaterial3: true,
                bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                ),
                pageTransitionsTheme: const PageTransitionsTheme(builders: {
                  TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
                }),
                fontFamily: K.fontFamily,
              ),
              initialRoute: LoginPage.route,
              routes: Routes.routes,
            );
          }
      ),
    );
  }
}