import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.indigo.withOpacity(0.2),
          child: const Icon(PhosphorIcons.house_bold, color: Colors.indigo,),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Home", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
              Text("25 Sept 2022", style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Row(
          children: const [
            Text('AED 550', style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),),
            const SizedBox(width: 10),
            Icon(PhosphorIcons.arrow_up_right_bold, color: Colors.red,)
          ],
        )
      ],
    );
  }
}
