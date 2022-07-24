import 'package:flutter/material.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/models/m_note.dart';
import 'package:note_app/library/values.dart';

class WidgetNotePicker extends StatelessWidget {
  const WidgetNotePicker({
    Key? key,
    required this.note,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  final MNote note;
  final Function() onTap;
  final Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
      onLongPress: () => onLongPress?.call(),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Funcs().checkExpiration(note.expirationDate)
              ? Colors.grey
              : Funcs().getRandomColor(),
          borderRadius: const BorderRadius.all(
            Radius.circular(cRadius),
          ),
        ),
        child: Row(
          children: [
            //Icon Lock
            if (note.password != null)
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(Icons.lock, color: Colors.white),
              ),
            // Title
            Expanded(
              child: Text(
                note.title ?? "",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 2,
              ),
            ),
            // widget that stands at right center with arrow
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              margin: const EdgeInsets.only(left: 5),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(cRadius))),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
