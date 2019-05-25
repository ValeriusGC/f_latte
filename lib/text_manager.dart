import 'package:rx_command/rx_command.dart';

class TextManager {

  final RxCommand<String, String> txtCmd;

  TextManager() : txtCmd = RxCommand.createSync<String, String>((v) => v);
}