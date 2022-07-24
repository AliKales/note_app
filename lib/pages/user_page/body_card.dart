part of 'user_page.dart';

class _BodyCard extends StatelessWidget {
  const _BodyCard({Key? key, this.iconData, this.text, this.onTap})
      : super(key: key);

  final IconData? iconData;
  final String? text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(cRadius),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                iconData,
                color: Colors.black,
              ),
            ),
            Text(
              text ?? "",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
