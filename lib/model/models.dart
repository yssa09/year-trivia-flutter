class YearModel {
  late String text;
  late int number;

  YearModel(
    this.text,
    this.number,
  );

  YearModel.named(Map<String, dynamic> parsedJson) {
    text = parsedJson['text'];
    number = parsedJson['number'];
  }
}
