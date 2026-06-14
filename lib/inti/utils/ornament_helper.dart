class OrnamentHelper {
  static List<String> getOrnamentsForCategory(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('agama') || lowerTitle.contains('islam')) {
      return ['🕌', '📖', '🤲', '✨', '📿', '🌙', '👳'];
    } else if (lowerTitle.contains('indonesia') || lowerTitle.contains('indo')) {
      return ['🇮🇩', '🗣️', '📚', '✍️', '✒️', '📜', '📝'];
    } else if (lowerTitle.contains('matematika') || lowerTitle.contains('hitung')) {
      return ['📊', '✖️', '📏', '➖', '🧮', '➕', '➗', '🔢', '📐'];
    } else if (lowerTitle.contains('ipa') || lowerTitle.contains('alam')) {
      return ['🔭', '🦠', '🌋', '🌡️', '🪐', '🌱', '🧪', '🔬', '🧬', '🍃'];
    } else if (lowerTitle.contains('ips') || lowerTitle.contains('sosial')) {
      return ['📉', '🌐', '🏺', '👥', '🗺️', '🏛️', '🧭', '🗿'];
    } else if (lowerTitle.contains('ppkn') || lowerTitle.contains('pancasila') || lowerTitle.contains('pkn')) {
      return ['🧑‍⚖️', '✊', '🦅', '📜', '🤝', '🛡️', '🇮🇩', '⚖️'];
    } else if (lowerTitle.contains('inggris') || lowerTitle.contains('english')) {
      return ['🇺🇸', '🅰️', '📝', '🎧', '🇬🇧', '💬', '🔠'];
    } else {
      return ['🎈', '🎉', '💡', '📌', '🌟', '🚀', '🎯', '✨', '☁️', '⭐'];
    }
  }

  static String getMainCharacterForCategory(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('agama') || lowerTitle.contains('islam')) return '🕋';
    if (lowerTitle.contains('indonesia')) return '📖';
    if (lowerTitle.contains('matematika')) return '📐';
    if (lowerTitle.contains('ipa') || lowerTitle.contains('alam')) return '🧬';
    if (lowerTitle.contains('ips') || lowerTitle.contains('sosial')) return '🧭';
    if (lowerTitle.contains('ppkn') || lowerTitle.contains('pancasila')) return '⚖️';
    if (lowerTitle.contains('inggris')) return '🔠';
    return '🎓';
  }
}