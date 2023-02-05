
import 'package:memo/provider/database_provider.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => DatabaseProvider()),
  ChangeNotifierProvider(create: (_) => SettingsProvider()),
];