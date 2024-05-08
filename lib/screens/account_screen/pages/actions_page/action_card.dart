import 'package:flutter/material.dart';
import 'package:unityspace/screens/account_screen/pages/actions_page/custom_container.dart';

class ActionCard extends StatelessWidget {
  const ActionCard(
      {super.key,
      required this.title,
      required this.task,
      required this.time,
      this.isSelected = false});

  final String title;
  final String task;
  final String time;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomContainer(
      height: 96,
      hasBorder: true,
      borderColor: isSelected ? Colors.greenAccent : Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            task,
            style: textTheme.bodySmall,
          ),
          Text(
            time,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
