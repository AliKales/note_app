import 'package:flutter/material.dart';
import 'package:note_app/library/UIs/custom_button.dart';
import 'package:note_app/library/UIs/custom_textfield.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/values.dart';

class LockPage extends StatelessWidget {
  LockPage({Key? key, required this.password}) : super(key: key);

  final String password;

  final TextEditingController _tECPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: cBackgroundColor,
        appBar: _appBar(context),
        body: Padding(
          padding: const EdgeInsets.all(cPaddingPage),
          child: Column(
            children: [
              CustomTextField(
                label: "Password",
                textEditingController: _tECPassword,
              ),
              CustomButton(
                text: "Unlock",
                onTap: () {
                  if (password == _tECPassword.text.trim()) {
                    Navigator.pop(context);
                    return;
                  }
                  Funcs().showSnackBar(context, "Wrong Password!");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: cBackgroundColor,
      elevation: 0.3,
      automaticallyImplyLeading: false,
      title: Text(
        appName,
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
