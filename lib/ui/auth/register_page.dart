
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wingman_task/bloc/auth_bloc.dart';
import 'package:wingman_task/ui/widget/app_button.dart';
import 'package:wingman_task/ui/widget/app_text_field.dart';
import 'package:wingman_task/ui/widget/responsive_widget.dart';
import 'package:wingman_task/utils/constants.dart';
import 'package:wingman_task/utils/image_icons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  late AuthBloc bloc;

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
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
                          .fade(),
                          if(ResponsiveWidget.isSmallScreen(context)) Image.asset(AppImages.loginBG, width: 1.sw, fit: BoxFit.contain,)
                              .animate()
                              .fade(),
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveWidget.isLargeScreen(context) ? 80 : 20),
                            child: Form(
                              key: bloc.registerForm,
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Welcome", style: TextStyle(
                                        color: K.themeColorSecondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),),
                                      const SizedBox(height: 10),
                                      const Text("Looks like you are new here. Tell us a bit about yourself.", style: TextStyle(
                                        color: K.themeColorTertiary1,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),),
                                      const SizedBox(height: 20),
                                      AppTextField(
                                        controller: bloc.name,
                                        title: 'Name',
                                        keyboardType: TextInputType.name,
                                        validate: true,
                                        validator: (v) => v!.isEmpty ? "Please enter your name" : null,
                                      ),
                                      const SizedBox(height: 20),
                                      AppTextField(
                                        controller: bloc.email,
                                        title: 'Email',
                                        keyboardType: TextInputType.emailAddress,
                                        validate: true,
                                        validator: (v) => !Validate.emailValidation.hasMatch(v!) ? "Please enter valid email" : null,
                                      ),
                                      const SizedBox(height: 20),
                                      ValueListenableBuilder(
                                          valueListenable: bloc.registering,
                                          builder: (context, bool loading, _) {
                                            return AppButton(
                                              title: "Submit",
                                              onTap: () {
                                                if(bloc.registerForm.currentState!.validate()) {
                                                  bloc.registerUser();
                                                }
                                              },
                                              loading: loading,
                                              margin: EdgeInsets.zero,
                                            );
                                          }
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ],
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
              return Container(
                color: K.themeColorPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 50,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0,10),
                            blurRadius: 15,
                            spreadRadius: -10
                        )
                      ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: child,
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
