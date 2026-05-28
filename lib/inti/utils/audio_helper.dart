import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioHelper {
  static final AudioPlayer _clickPlayer = AudioPlayer();
  static bool? _isSoundEnabled;

  static Future<void> playClick() async {
    try {
      if (_isSoundEnabled == null) {
        final prefs = await SharedPreferences.getInstance();
        _isSoundEnabled = prefs.getBool('pengaturan_suara') ?? true;
      }
      if (_isSoundEnabled!) {
        await _clickPlayer.play(AssetSource('sounds/suara-click.mp3'));
      }
    } catch (e) {
      // Abaikan jika error
    }
  }

  static void updateSoundPreference(bool enabled) {
    _isSoundEnabled = enabled;
  }
}
