import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/library/models/m_folder.dart';
import 'package:note_app/library/models/m_layers.dart';
import 'package:note_app/library/models/m_note.dart';
import 'package:note_app/library/provider/p_audio_player.dart';
import 'package:note_app/library/provider/p_layers.dart';
import 'package:note_app/library/provider/p_notes.dart';
import 'package:note_app/library/provider/provider_pages.dart';
import 'package:note_app/library/values.dart';
import 'package:note_app/pages/main_page/main_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;

  await Hive.initFlutter();

  Hive.registerAdapter(MNoteAdapter());
  Hive.registerAdapter(MFolderAdapter());
  Hive.registerAdapter(ItemTypeAdapter());
  Hive.registerAdapter(LayersAdapter());
  Hive.registerAdapter(LayerTextAdapter());
  Hive.registerAdapter(LayerTypeAdapter());
  Hive.registerAdapter(LayerImageAdapter());
  Hive.registerAdapter(LayerAudioAdapter());

  await Hive.openBox("firstNAFs");
  await Hive.openBox("NAFs");
  await Hive.openBox("database");

  // await Hive.box("firstNAFs").clear();
  // await Hive.box("NAFs").clear();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderPages>(create: (_) => ProviderPages()),
        ChangeNotifierProvider<PNotes>(create: (_) => PNotes()),
        ChangeNotifierProvider<PAudioPlayer>(create: (_) => PAudioPlayer()),
        ChangeNotifierProvider<PLayers>(create: (_) => PLayers()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      home: const MainPage(),
    );
  }
}
