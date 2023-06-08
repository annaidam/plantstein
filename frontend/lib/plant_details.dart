class PlantDetails {
  final String plantNickname;
  final String? moisture;
  final bool? moistureIsOk;
  final double? brightness;
  final double? perfectBrightness;
  final bool? brightnessIsOk;
  final double? temperature;
  final double? perfectTemperature;
  final bool? tempeartureIsOk;
  final double? humidity;
  final double? perfectHumidity;
  final bool? humidityIsOk;

  const PlantDetails(
      {required this.plantNickname,
      this.brightness,
      this.moisture,
      this.temperature,
      this.humidity,
      this.perfectTemperature,
      this.perfectHumidity,
      this.perfectBrightness,
      this.brightnessIsOk,
      this.humidityIsOk,
      this.moistureIsOk,
      this.tempeartureIsOk});

  factory PlantDetails.fromJson(Map<String, dynamic> json) {
    String moisture;
    switch (json['moisture']) {
      case 'TOO_DRY':
        moisture = 'Too Dry';
        break;
      case 'TOO_WET':
        moisture = 'Too wet';
        break;
      case 'OKAY':
        moisture = 'Okay';
        break;
      default:
        moisture = 'No Data';
    }
    return PlantDetails(
      plantNickname: json['plantNickname'],
      brightness: json['brightness'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      perfectTemperature: json['perfectTemperature'],
      perfectHumidity: json['perfectHumidity'],
      perfectBrightness: json['perfectBrightness'],
      tempeartureIsOk: json['temperatureIsOk'],
      humidityIsOk: json['humidityIsOk'],
      brightnessIsOk: json['brightnessIsOk'],
      moistureIsOk: json['moistureIsOk'],
      moisture: moisture,
    );
  }
}
