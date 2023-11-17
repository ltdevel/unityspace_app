import 'package:flutter/material.dart';
import 'package:unityspace/screens/widgets/tabs_list/tab_button.dart';

class TabsListRow extends StatelessWidget {
  final List<TabButton> children;

  const TabsListRow({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 16),
          ...children.expand((tab) => [tab, const SizedBox(width: 8)]),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
