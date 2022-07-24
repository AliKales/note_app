import 'package:flutter/material.dart';

class CustomIconTextButton extends StatelessWidget {
  const CustomIconTextButton(
      {Key? key, this.iconData, this.color, required this.text, this.onTap})
      : super(key: key);

  final IconData? iconData;
  final Color? color;
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _widgets(context),
        ),
      ),
    );
  }

  Widget _widgets(context) {
    if (iconData == null) return _widgetText(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(iconData, color: Colors.black),
        ),
        _widgetText(context),
      ],
    );
  }

  Text _widgetText(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.headline6!.copyWith(color: color));
  }
}
