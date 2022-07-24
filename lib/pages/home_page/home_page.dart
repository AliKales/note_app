import 'package:flutter/material.dart';
import 'package:note_app/library/UIs/appbar_clipper.dart';
import 'package:note_app/library/UIs/custom_textfield.dart';
import 'package:note_app/library/provider/p_notes.dart';
import 'package:note_app/library/values.dart';
import 'package:note_app/pages/home_page/home_page_body.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //this is the top part of page
        Expanded(
          child: Stack(
            children: [
              // Widget that stands ad gradient container
              widgetTop(),
              //these are the widgets on tap bar
              widgetTopAppBarWidgets(context),
            ],
          ),
        ),
        //this is the body part of page
        body(),
      ],
    );
  }

  Widget body() {
    return const HomePageBody();
  }

  SafeArea widgetTopAppBarWidgets(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Here Your Notes",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextField(
              onChanged: (value) {
                Provider.of<PNotes>(context, listen: false)
                    .searchByTitle(value);
              },
              iconRight: Icons.sort_rounded,
              iconLeft: Icons.search,
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetTop() {
    return ClipPath(
      clipper: AppBarClipper(),
      child: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cGradientColor1,
              cGradientColor2,
            ],
          ),
        ),
      ),
    );
  }
}
