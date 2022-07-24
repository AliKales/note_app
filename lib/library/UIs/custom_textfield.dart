import 'package:flutter/material.dart';
import 'package:note_app/library/values.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.textEditingController,
    this.iconRight,
    this.label,
    this.maxLines = 1,
    this.iconLeft,
    this.onChanged, this.onRightButtonClicked,
  }) : super(key: key);

  final TextEditingController? textEditingController;
  final IconData? iconRight;
  final String? label;
  final int? maxLines;
  final IconData? iconLeft;
  final Function(String)? onChanged;
  final VoidCallback? onRightButtonClicked;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final _keyTextfield = GlobalKey();
  var _heightTextfiedl = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _heightTextfiedl = _keyTextfield.currentContext!.size!.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.iconRight == null) {
      return _textField(context);
    }
    return Row(
      children: [
        Expanded(
          child: _textField(context),
        ),
        Container(
          color: Colors.white,
          height: _heightTextfiedl,
          width: 1,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            color: Colors.grey,
          ),
        ),
        InkWell(
          onTap: widget.onRightButtonClicked,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(cRadius),
              ),
            ),
            height: _heightTextfiedl,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(widget.iconRight),
            ),
          ),
        ),
      ],
    );
  }

  TextField _textField(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      maxLines: null,
      controller: widget.textEditingController,
      key: _keyTextfield,
      style: Theme.of(context).textTheme.headline6,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: widget.iconLeft == null
            ? null
            : Icon(
                widget.iconLeft,
                size: 28,
                color: Colors.grey,
              ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.horizontal(
                left: const Radius.circular(cRadius),
                right: widget.iconRight == null
                    ? const Radius.circular(cRadius)
                    : Radius.zero),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
