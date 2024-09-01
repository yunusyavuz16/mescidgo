import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/constants/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool titleCentered;

  CustomAppBar({
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.titleCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: FaIcon(FontAwesomeIcons.chevronLeft,
                  color: Colors.white), // Chevron ikonu
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      title: Text(
        title,
        style: Styles.titleTextStyle.copyWith(color: Colors.white),
        textAlign: titleCentered ? TextAlign.center : TextAlign.start,
      ),
      backgroundColor: AppColors.primaryGreen,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
