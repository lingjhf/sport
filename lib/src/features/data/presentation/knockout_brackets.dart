import 'package:flutter/material.dart';

//淘汰赛对阵图
class KnockoutBrackets extends StatelessWidget {
  const KnockoutBrackets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class KnockoutBracketsNode {
  const KnockoutBracketsNode({this.left, this.right});

  final KnockoutBracketsNode? left;

  final KnockoutBracketsNode? right;
}
