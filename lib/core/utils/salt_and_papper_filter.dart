class SaltAndPaperFilter {
  static List<double> applyFilter(List<double> list, double threshold) {
    if (list.isEmpty) return [];
    final avg = list.reduce((a, b) => a + b) / list.length;
    final filtered = list.where((value) => (value - avg).abs() <= threshold).toList();
    return filtered.isEmpty ? list : filtered;
  }
}
