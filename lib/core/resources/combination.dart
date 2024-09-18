class Combination {
  int s1;
  int s2;
  int s3;
  int s4;

  Combination(this.s1, this.s2, this.s3, this.s4);

  factory Combination.fromJson(Map<String, dynamic> json) {
    return Combination(
      json['s1'],
      json['s2'],
      json['s3'],
      json['s4'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      's1': s1,
      's2': s2,
      's3': s3,
      's4': s4,
    };
  }

  List<int> toList() {
    return [s1, s2, s3, s4];
  }

  Map<String, int> toMap() {
    return {
      's1': s1,
      's2': s2,
      's3': s3,
      's4': s4,
    };
  }

  fromMap(Map<String, int> map) {
    s1 = map['s1']!;
    s2 = map['s2']!;
    s3 = map['s3']!;
    s4 = map['s4']!;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Combination &&
          other.runtimeType == Combination &&
          s1 == other.s1 &&
          s2 == other.s2 &&
          s3 == other.s3 &&
          s4 == other.s4;

  @override
  int get hashCode => s1.hashCode ^ s2.hashCode ^ s3.hashCode ^ s4.hashCode;
}
