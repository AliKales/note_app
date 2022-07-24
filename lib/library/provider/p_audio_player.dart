import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:note_app/library/funcs.dart';
import 'package:note_app/library/values.dart';
import 'package:permission_handler/permission_handler.dart';

class PAudioPlayer with ChangeNotifier {
  MAudioPlayer mAudioPlayer = MAudioPlayer();

  FlutterSoundRecorder recorder = FlutterSoundRecorder();

  FlutterSoundPlayer player = FlutterSoundPlayer();

  changeAudioPlayer(MAudioPlayer audioPlayer) {
    mAudioPlayer = audioPlayer;

    notifyListeners();
  }

  Future startRecord() async {
    if (!await Funcs()
        .checkPermissions([Permission.microphone, Permission.storage])) return;

    await recorder.openRecorder();
    String path = "$pathToAppFolder/audios/${Funcs().getId()}.mp4";
    await recorder.startRecorder(toFile: path, codec: Codec.aacMP4);

    changeAudioPlayer(
        MAudioPlayer(isActive: true, audioStats: AudioStats.recording));
  }

  Future<String> stopRecord() async {
    String? path = await recorder.stopRecorder();
    await closeRecorder();

    return path ?? "";
  }

  Future closeRecorder() async {
    await recorder.closeRecorder();
    changeAudioPlayer(MAudioPlayer(isActive: false));
  }

  Future startPlayer(String path, int audioCounter) async {
    MAudioPlayer mAP = MAudioPlayer(
        isActive: true,
        audioCounter: audioCounter,
        path: path,
        audioStats: AudioStats.playing);
    changeAudioPlayer(mAP);
    if (!player.isOpen()) await player.openPlayer();
    await player.startPlayer(
      fromURI: path,
      whenFinished: () {
        mAudioPlayer.audioStats = AudioStats.pause;
        changeAudioPlayer(mAP);
      },
    );
  }

  Future pausePlayer() async {
    MAudioPlayer mAP = mAudioPlayer;
    mAP.audioStats = AudioStats.pause;
    await player.pausePlayer();

    changeAudioPlayer(mAP);
  }

  Future resumePlayer() async {
    MAudioPlayer mAP = mAudioPlayer;
    mAP.audioStats = AudioStats.playing;

    if (player.isStopped) {
      await startPlayer(mAP.path!, mAP.audioCounter!);

      return;
    }
    await player.resumePlayer();

    changeAudioPlayer(mAP);
  }

  Future closePlayer() async {
    if (player.isPlaying) {
      await player.stopPlayer();
    }
    changeAudioPlayer(MAudioPlayer(isActive: false));

    await player.closePlayer();
  }
}

class MAudioPlayer {
  bool isActive;
  int? audioCounter;
  AudioStats? audioStats;
  String? path;

  MAudioPlayer({
    this.isActive = false,
    this.audioCounter,
    this.audioStats,
    this.path,
  });
}

enum AudioStats {
  playing,
  pause,
  recording,
}
