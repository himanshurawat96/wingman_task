import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:wingman_task/bloc/auth_bloc.dart';
import 'package:wingman_task/ui/widget/app_button.dart';
import 'package:wingman_task/ui/widget/responsive_widget.dart';
import 'package:wingman_task/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key? key}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  late AuthBloc bloc;

  String otp = '';

  void initState() {
    super.initState();
    bloc = context.read<AuthBloc>();
    // bloc.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text("Verify Phone"),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(PhosphorIcons.arrow_left_bold),
            onPressed: () {
              bloc.showOTPScreen.value = false;
            },
          ),
        ),
        const SizedBox(height: 20),
        Text("OTP has been sent to your phone +91-${bloc.phone.text}"),
        const SizedBox(height: 50),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: ResponsiveWidget.isMediumScreen(context) ? 0 : 30),
          child: PinCodeTextField(
            appContext: context,
            length: 6,
            onChanged: (v) => otp = v,
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: K.themeColorPrimary,
              activeColor: K.themeColorPrimary,
              selectedFillColor: K.themeColorPrimary.withOpacity(0.2), //Colors.white,
              selectedColor: K.themeColorPrimary.withOpacity(0.2),
              inactiveFillColor: K.themeColorPrimary.withOpacity(0.2), //Colors.white,
              inactiveColor: K.themeColorPrimary.withOpacity(0.2), //Colors.white,
            ),
            animationDuration: const Duration(milliseconds: 300),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            enableActiveFill: true,
            controller: TextEditingController(),
            onCompleted: (v) {
              // print("Completed");
            },
            beforeTextPaste: (text) {
              // print("Allowing to paste $text");
              return true;
            },
          ),
        ),

        // const SizedBox(height: 20),

        StatefulBuilder(
            key: bloc.builderKey,
            builder: (context, setBuilderState) {
              if(bloc.start==0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Didn\'t receive code.',
                      style: TextStyle(
                        color: K.textColor,
                        fontSize: 16,
                      ),
                    ),
                    IgnorePointer(
                      ignoring: false,
                      child: CupertinoButton(
                        onPressed: () {
                          bloc.showOTPScreen.value = false;
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ValueListenableBuilder(
                          valueListenable: bloc.loginLoading,
                          builder: (context, bool loading, _) {
                            if(loading) {
                              return const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2,),);
                            }
                            return const Text(
                              'Retry',
                              style: TextStyle(
                                color: K.themeColorPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              }
              return Align(
                alignment: Alignment.center,
                child: Text('(${DateFormat('mm:ss').format(DateFormat('s').parse(bloc.start.toString()))})'),
              );
            }),
        const SizedBox(height: 40),
        ValueListenableBuilder(
          valueListenable: bloc.verifyingOTP,
          builder: (context, bool verifying, _) {
            return AppButton(
              title: 'Verify',
              onTap: () {
                bloc.otpVerification(otp);
              },
              color: K.themeColorPrimary,
              margin: EdgeInsets.zero,
              loading: verifying,
            );
          },
        ),
      ],
    );
  }
}
