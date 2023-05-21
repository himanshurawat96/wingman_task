
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wingman_task/bloc/auth_bloc.dart';
import 'package:wingman_task/data/repository/auth_repository.dart';
import 'package:wingman_task/ui/auth/register_page.dart';
import 'package:wingman_task/ui/auth/widgets/bg_container.dart';
import 'package:wingman_task/ui/home/home_page.dart';
import 'package:wingman_task/ui/widget/app_button.dart';
import 'package:wingman_task/ui/widget/app_text_field.dart';
import 'package:wingman_task/ui/widget/responsive_widget.dart';
import 'package:wingman_task/utils/constants.dart';
import 'package:wingman_task/utils/image_icons.dart';
import 'package:wingman_task/utils/message_handler.dart';

import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  static const route = "/";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late AuthBloc bloc;

  @override
  void initState() {
    bloc = AuthBloc(context.read<AuthRepository>());
    super.initState();
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    bloc.authController.stream.listen((event) {
      switch(event) {
        case "AUTH_SUCCESS":
          Navigator.pushNamedAndRemoveUntil(context, HomePage.route, (r) => false);

          break;
        case "NEW_USER":
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Provider.value(
                value: bloc,
                child: const RegisterPage(),
              )
          ));
          break;
      }
    });

  }

  Duration delay = const Duration(milliseconds: 1075);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(bloc.showOTPScreen.value) {
          bloc.showOTPScreen.value = false;
        } else {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        body: Builder(
          builder: (context) {

            Widget child = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(ResponsiveWidget.isSmallScreen(context)) Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: const BoxDecoration(
                            color: K.themeColorPrimary,
                          ),
                          child: SafeArea(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppImages.logo, width: 0.5.sw,),
                                ],
                              )),
                        )
                            .animate()
                            .fade(duration: delay),

                        if(ResponsiveWidget.isSmallScreen(context)) Image.asset(AppImages.loginBG, width: 1.sw, fit: BoxFit.contain,)
                            .animate()
                            .fade(duration: delay),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveWidget.isLargeScreen(context) ? 80 : 20),
                          child: Form(
                            key: bloc.loginForm,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(!ResponsiveWidget.isSmallScreen(context)) Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Image.asset(AppImages.logo, color: K.themeColorPrimary, height: 50),
                                    const SizedBox(height: 100),
                                  ],
                                ),
                                ValueListenableBuilder(
                                  valueListenable: bloc.showOTPScreen,
                                  builder: (context, bool showOTP, _) {
                                    if(showOTP) {
                                      return Provider.value(value: bloc, child: OTPPage());
                                    }
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Artificial Intelligence giving you travel recommendations", style: TextStyle(
                                          color: K.themeColorSecondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),),
                                        const SizedBox(height: 10),
                                        const Text("Welcome Back, Please login to your account", style: TextStyle(
                                          color: K.themeColorTertiary1,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),),
                                        const SizedBox(height: 20),
                                        AppTextField(
                                          controller: bloc.phone,
                                          title: 'Phone',
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(10),
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                          validate: true,
                                          validator: (v) => v!.length < 10 ? "Please enter valid phone number" : null,
                                          icon: GestureDetector(
                                            onTap: () async {
                                              final code = await bloc.countryPicker.showPicker(
                                                context: context,
                                              );
                                              if (code != null)  {
                                                bloc.updateDialCode(code);
                                              }
                                            },
                                            child: Container(
                                              // padding: const EdgeInsets.symmetric(
                                              //     horizontal: 8.0, vertical: 4.0),
                                              // margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                              height: 45,
                                              width: 60,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                // color: Colors.blue,
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                              child: ValueListenableBuilder(
                                                  valueListenable: bloc.dialCode,
                                                  builder: (context, CountryCode dialCode, _) {
                                                    return Text(dialCode.dialCode,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        // color: Colors.white,
                                                      ),
                                                    );
                                                  }
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ValueListenableBuilder(
                                            valueListenable: bloc.loginLoading,
                                            builder: (context, bool loading, _) {
                                              return AppButton(
                                                title: "Continue",
                                                onTap: () {
                                                  if(bloc.loginForm.currentState!.validate()) {
                                                    bloc.sendOTP();
                                                  }
                                                },
                                                loading: loading,
                                                margin: EdgeInsets.zero,
                                              );
                                            }
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    );
                                  }
                                ),
                              ].animate(delay: delay)
                                  // .slideY(duration: delay)
                                  .fade(duration: delay),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if(!ResponsiveWidget.isSmallScreen(context)) Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: K.themeColorTertiary2
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.loginBG, fit: BoxFit.contain,),
                        ],
                      )),
                )
              ],
            );

            if(ResponsiveWidget.isSmallScreen(context)) {
              return child;
            }
            return WebBGContainer(child: child);
          }
        ),
      ),
    );
  }
}
