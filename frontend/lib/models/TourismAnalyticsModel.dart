class TourismAnalytics {
  final int totalVisitors;
  final double totalVisitorsGrowth;
  final int monthlyVisitors;
  final double monthlyVisitorsGrowth;
  final int topLocationsCount;
  final double locationsGrowth;
  final List<double> chartData;

  TourismAnalytics({
    required this.totalVisitors,
    required this.totalVisitorsGrowth,
    required this.monthlyVisitors,
    required this.monthlyVisitorsGrowth,
    required this.topLocationsCount,
    required this.locationsGrowth,
    required this.chartData,
  });

  factory TourismAnalytics.fromJson(Map<String, dynamic> json) {
    return TourismAnalytics(
      totalVisitors: json['total_visitors'],
      totalVisitorsGrowth: json['total_growth'],
      monthlyVisitors: json['monthly_visitors'],
      monthlyVisitorsGrowth: json['monthly_growth'],
      topLocationsCount: json['top_locations'],
      locationsGrowth: json['locations_growth'],
      chartData: List<double>.from(json['chart_data']),
    );
  }
}