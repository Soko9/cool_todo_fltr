import 'package:flutter/material.dart';
import 'package:cool_todo/views/palette/styles.dart';
import 'package:get/get.dart';

class TInput extends StatelessWidget {
  final String title;
  final String hint;
  final bool extend;
  final double height;
  final TextEditingController? controller;
  final Widget? widget;

  const TInput({
    super.key,
    required this.title,
    required this.hint,
    this.extend = false,
    this.height = 0.0,
    this.controller,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: extend ? 16.0 : 12.0, horizontal: 0.0),
      child: extend
          ? SizedBox(
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.start,
                    style: Styles.regularTextStyle(
                      size: 18.0,
                      color: context.theme.backgroundColor,
                    ),
                  ),
                  widget!,
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: Styles.regularTextStyle(
                    size: 18.0,
                    color: context.theme.backgroundColor,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.only(left: 12.0),
                  height: 52.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.4,
                      color: extend
                          ? Colors.transparent
                          : context.theme.backgroundColor,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: widget == null ? false : true,
                          autocorrect: false,
                          autofocus: false,
                          cursorColor: context.theme.backgroundColor,
                          controller: controller,
                          style: Styles.regularTextStyle(
                            size: 18.0,
                            color: context.theme.backgroundColor,
                          ),
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: Styles.regularTextStyle(
                              size: 18.0,
                              color: context.theme.backgroundColor
                                  .withOpacity(0.6),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      widget ?? Container(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
