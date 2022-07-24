import 'package:flutter/material.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/provider/provider_pages.dart';
import 'package:note_app/library/values.dart';
import 'package:provider/provider.dart';

import '../provider/p_audio_player.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.currentPage,
  }) : super(key: key);

  final int currentPage;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<_ModelChild> _childeren = [
    _ModelChild(index: 0, iconData: Icons.note),
    _ModelChild(index: 1, iconData: Icons.note_add_rounded),
    _ModelChild(index: 2, iconData: Icons.create_new_folder),
    _ModelChild(index: 3, iconData: Icons.person_sharp),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      height: kBottomNavigationBarHeight,
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(color: cGradientColor1, width: 2),
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(cRadius),
        ),
      ),
      child: Row(
        children: List.generate(
            _childeren.length, (index) => _child(_childeren[index])),
      ),
    );
  }

  Widget _child(_ModelChild modelChild) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (context.read<PAudioPlayer>().mAudioPlayer.isActive) return;

          Provider.of<ProviderPages>(context, listen: false)
              .changePage(modelChild.index);
        },
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.currentPage == modelChild.index
                    ? Funcs().getRandomColor()
                    : Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(cRadius),
              ),
            ),
            child: Icon(modelChild.iconData),
          ),
        ),
      ),
    );
  }
}

class _ModelChild {
  final int index;
  final IconData iconData;

  _ModelChild({required this.index, required this.iconData});
}
