import 'package:streamvault/design_system/ds.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'injection/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Supabase.initialize(
    url: 'https://gkufowjkbgzqwlnksqjl.supabase.co',
    publishableKey: 'sb_publishable_juuRffjX_WAym-nzsemkNQ_cZz1tdr0',
  );

  await initDependencies();

  runApp(const StreamVaultApp());
}
