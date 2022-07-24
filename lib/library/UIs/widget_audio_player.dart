import 'package:flutter/material.dart';
import 'package:note_app/library/models/m_layers.dart';
import 'package:note_app/library/provider/p_audio_player.dart';
import 'package:note_app/library/provider/p_layers.dart';
import 'package:provider/provider.dart';

import '../values.dart';

class WidgetAudioPlayer extends StatefulWidget {
  const WidgetAudioPlayer({
    Key? key,
    this.isRadiused = false,
  }) : super(key: key);
  final bool? isRadiused;
  @override
  State<WidgetAudioPlayer> createState() => _WidgetAudioPlayerState();
}

class _WidgetAudioPlayerState extends State<WidgetAudioPlayer> {
  late MAudioPlayer mAudioPlayer;

  @override
  Widget build(BuildContext context) {
    mAudioPlayer = context.watch<PAudioPlayer>().mAudioPlayer;

    if (!mAudioPlayer.isActive) return const SizedBox();

    return Theme(
      data: ThemeData.light().copyWith(
          iconTheme: const IconThemeData(size: 35, color: Colors.grey)),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: cAudioPlayerBackgroundColor,
          borderRadius: widget.isRadiused!
              ? const BorderRadius.all(
                  Radius.circular(cRadius),
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getIcon(),
            Expanded(
              child: Text("Audio ${mAudioPlayer.audioCounter}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            IconButton(
              onPressed: () {
                if (mAudioPlayer.audioStats == AudioStats.recording) {
                  Provider.of<PAudioPlayer>(context, listen: false)
                      .closeRecorder();
                } else {
                  Provider.of<PAudioPlayer>(context, listen: false)
                      .closePlayer();
                }
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }

  IconButton _getIcon() {
    switch (mAudioPlayer.audioStats) {
      case AudioStats.playing:
        return IconButton(onPressed: pause, icon: const Icon(Icons.pause));
      case AudioStats.pause:
        return IconButton(
            onPressed: resume, icon: const Icon(Icons.play_arrow));

      case AudioStats.recording:
        return IconButton(onPressed: stopRecord, icon: const Icon(Icons.stop));

      default:
        return IconButton(onPressed: () {}, icon: const Icon(Icons.music_note));
    }
  }

  //

  Future stopRecord() async {
    String path =
        await Provider.of<PAudioPlayer>(context, listen: false).stopRecord();

    Provider.of<PLayers>(context, listen: false)
        .addLayersNoteAddPage(LayerAudio(path: path));
  }

  Future pause() async {
    Provider.of<PAudioPlayer>(context, listen: false).pausePlayer();
  }

  Future resume() async {
    Provider.of<PAudioPlayer>(context, listen: false).resumePlayer();
  }
}
