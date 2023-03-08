import 'package:cool_todo/views/palette/themes.dart';
import 'package:flutter/material.dart';
import 'package:cool_todo/views/palette/styles.dart';

class TButton extends StatelessWidget {
  final GestureTapCallback? ontap;
  final String label;
  final Color color;

  const TButton({
    super.key,
    required this.ontap,
    required this.label,
    this.color = Themes.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 0.0, color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: Styles.regularTextStyle(
            size: 20.0,
            color: Themes.darkBack,
          ),
        ),
      ),
    );
  }
}
