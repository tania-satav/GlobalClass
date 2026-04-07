class WaterEntry {
  final int? id;
  final int amount;
  final String date;
  final String time;

  WaterEntry({
    this.id,
    required this.amount,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'time': time,
    };
  }

  factory WaterEntry.fromMap(Map<String, dynamic> map) {
    return WaterEntry(
      id: map['id'],
      amount: map['amount'],
      date: map['date'],
      time: map['time'],
    );
  }
}