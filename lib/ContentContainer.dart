import 'package:flutter/cupertino.dart';

class ContentContainer extends StatefulWidget {
  final Widget child;
  const ContentContainer({super.key, required this.child});

  @override
  State<ContentContainer> createState() => _ContentContainerState();
}

class _ContentContainerState extends State<ContentContainer> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
