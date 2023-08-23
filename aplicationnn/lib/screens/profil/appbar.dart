import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppbarWidget extends StatefulWidget {
  const AppbarWidget({super.key});

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();
}

class _AppbarWidgetState extends State<AppbarWidget> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return SliverAppBar(
      pinned: true,
      centerTitle: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Text("Kubra")],
      ),
      actions: [
        Icon(Icons.notifications_active),
        Icon(Icons.mark_chat_read),
      ],
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}
