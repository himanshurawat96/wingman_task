import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class BarAction extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  const BarAction({Key? key, required this.title, required this.color, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color,),
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(
          fontWeight: FontWeight.w600,

        ),),
      ],
    );
  }
}
