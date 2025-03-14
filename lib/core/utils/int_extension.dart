extension MinuteFormat on int {
  String toHoursAndMinutes() {
    int hours = this ~/ 60; // Diviziune întreagă pentru ore
    int minutes = this % 60; // Rămășița este minutul rămas

    return '${hours}h ${minutes.toString().padLeft(2, '0')}min';
  }
}

extension MinuteFormatWithSeconds on int {
  String toHoursMinutesAndSeconds() {
    int hours = this ~/ 3600; // Diviziune întreagă pentru ore
    int minutes = (this % 3600) ~/ 60; // Rămășița pentru minute
    int seconds = this % 60; // Rămășița pentru secunde

    return '${hours}h ${minutes.toString().padLeft(2, '0')}min ${seconds.toString().padLeft(2, '0')}sec';
  }
}

