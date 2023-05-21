import 'package:flutter/material.dart';
import 'package:wingman_task/utils/constants.dart';

class WebBGContainer extends StatelessWidget {
  final Widget child;
  const WebBGContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
