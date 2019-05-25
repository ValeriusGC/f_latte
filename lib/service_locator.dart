import 'package:f_latte/text_manager.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt();

void setUpServiceLocator() {
  sl.registerSingleton<TextManager>(TextManager());
}
