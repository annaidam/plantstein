class Species {
  final String name;
  final String homeland;
  final double perfectTemperature;
  final double perfectMoisture;
  final double perfectLight;
  final double perfectHumidity;
  final String bloomTime;
  final String botanicalName;
  final double maxHeight;

  const Species(
      {
      required this.name,
      required this.homeland,
      required this.perfectTemperature,
      required this.perfectLight,
      required this.perfectHumidity,
      required this.perfectMoisture,
      required this.bloomTime,
      required this.maxHeight,
      required this.botanicalName});

  factory Species.fromJson(Map<String, dynamic> json) => Species(
        name: json['name'],
        homeland: json['homeland'],
        maxHeight: json['maxHeight'],
        perfectTemperature: json['perfectTemperature'],
        perfectHumidity: json['perfectHumidity'],
        perfectLight: json['perfectLight'],
        perfectMoisture: json['perfectLight'],
        bloomTime: json['bloomTime'],
        botanicalName: json['botanicalName']
      );

  Map<String, dynamic> toJson() => {
        'title': name,
        'homeland': homeland,
        'perfectTemperature': perfectTemperature,
        'perfectLight': perfectLight,
        'perfectMoisture': perfectMoisture,
        'perfectHumidity': perfectHumidity,
        'bloomTime': bloomTime,
        'botanicalName': botanicalName,
        'maxHeight': maxHeight,
      };
}
