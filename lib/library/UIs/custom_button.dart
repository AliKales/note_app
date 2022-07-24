import 'package:flutter/material.dart';
import 'package:note_app/library/values.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.text,
      this.onTap,
      this.margin,
      this.textColor,
      this.icon})
      : super(key: key);

  CustomButton.outlined(
      {Key? key,
      required this.textOutlined,
      this.onTap,
      this.margin,
      this.textColor,
      this.icon})
      : super(key: key);

  CustomButton.text(
      {Key? key,
      required this.textTextButton,
      this.onTap,
      this.margin,
      this.textColor,
      this.icon})
      : super(key: key);

  String? text;
  String? textOutlined;
  String? textTextButton;
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  Color? textColor;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          width: textTextButton == null ? double.maxFinite : null,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          margin:
              margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
          decoration: textTextButton != null
              ? null
              : BoxDecoration(
                  border: textOutlined != null
                      ? Border.all(color: cGradientColor1, width: 2)
                      : null,
                  gradient: textOutlined != null
                      ? null
                      : const LinearGradient(
                          colors: [cGradientColor1, cGradientColor2],
                        ),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(cRadius))),
          child: icon == null
              ? _text(context)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon!,
                    _text(context),
                  ],
                ),
        ),
      ),
    );
  }

  Text _text(BuildContext context) {
    return Text(
      text ?? textOutlined ?? textTextButton ?? "",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.w600,
            color:
                textColor ?? (textTextButton == null ? null : cGradientColor2),
          ),
    );
  }
}
