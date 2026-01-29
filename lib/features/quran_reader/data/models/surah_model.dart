class SurahModel {
  final int number;
  final String name;
  final String frenchName;
  final String revelationType;
  final int numberOfAyahs;

  SurahModel({
    required this.number,
    required this.name,
    required this.frenchName,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'],
      name: json['name'],
      frenchName: json['frenchName'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
    );
  }
}
