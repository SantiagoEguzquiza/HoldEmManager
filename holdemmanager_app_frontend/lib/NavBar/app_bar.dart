import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final List<Widget>? actions;
  final bool showLeading;

  const CustomAppBar({
    super.key,
    this.backgroundColor = const Color.fromARGB(255, 27, 27, 27),
    this.actions,
    this.showLeading = true,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 53, 53, 53).withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: actions,
          automaticallyImplyLeading: showLeading,
        ),
      ),
    );
  }
}