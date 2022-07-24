import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/library/funcs.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch(
      {Key? key,
      this.dTExpiration,
      required this.valueBool,
      required this.onChanded, this.text, this.textStyle})
      : super(key: key);

  final DateTime? dTExpiration;
  final bool valueBool;
  final Function(bool) onChanded;
  final String? text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text??"", style:textStyle?? Theme.of(context).textTheme.headline6),
        CupertinoSwitch(
            value: valueBool, onChanged: (value) => onChanded.call(value)),
        if (dTExpiration != null)
          Text(
              Funcs().getDateTimeAsText(dTExpiration),
              style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}
