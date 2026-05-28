import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioHelper {
  // Gunakan sistem "Pool" (kolam) dengan 5 AudioPlayer 
  // agar suara klik bisa bertumpuk (overlapping) tanpa patah-patah/stutter saat ditekan cepat
  static final List<AudioPlayer> _clickPlayers = List.generate(
    3, 
    (_) => AudioPlayer(),
  );
  static int _currentPlayerIndex = 0;
  static bool? _isSoundEnabled;

  static Future<void> playClick() async {
    try {
      if (_isSoundEnabled == null) {
        final prefs = await SharedPreferences.getInstance();
        _isSoundEnabled = prefs.getBool('pengaturan_suara') ?? true;
      }
      if (_isSoundEnabled!) {
        final player = _clickPlayers[_currentPlayerIndex];
        _currentPlayerIndex = (_currentPlayerIndex + 1) % _clickPlayers.length;
        
        await player.stop();
        await player.play(AssetSource('sounds/suara-click.mp3'));
      }
    } catch (e) {
      // Abaikan jika error
    }
  }

  static void updateSoundPreference(bool enabled) {
    _isSoundEnabled = enabled;
  }
}
