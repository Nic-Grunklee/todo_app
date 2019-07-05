class Preference {
  int id;
  String key;
  String value;

  Preference({
    this.id,
    this.key,
    this.value
  });

  factory Preference.fromMap(Map<String, dynamic> json) => new Preference(
    id: json['id'],
    key: json['key'],
    value: json['value']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'key': key,
    'value': value
  };
}