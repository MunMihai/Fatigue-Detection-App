extension MinuteFormat on int {
  String toHoursAndMinutes() {
    int hours = this ~/ 60; // Diviziune întreagă pentru ore
    int minutes = this % 60; // Rămășița este minutul rămas

    return '${hours}h ${minutes.toString().padLeft(2, '0')}min';
  }
}
