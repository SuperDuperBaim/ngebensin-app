class Station {
  final String id;
  final String name;
  final String mono;

  Station({required this.id, required this.name, required this.mono});
}

class Fuel {
  final String id;
  final String name;
  final int octane;
  final double price;
  final String type; // 'bensin' or 'diesel'
  final String ratingType; // 'RON' or 'CN'

  Fuel({
    required this.id,
    required this.name,
    required this.octane,
    required this.price,
    this.type = 'bensin',
    this.ratingType = 'RON',
  });
}

class Vehicle {
  final String id;
  final String name;
  final String type; // 'motor' or 'mobil'

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'motor',
    );
  }
}

class LogEntry {
  final String id;
  final String fuel;
  final String station;
  final double liters;
  final double total;
  final String date;
  final String vehicleId;

  LogEntry({
    required this.id,
    required this.fuel,
    required this.station,
    required this.liters,
    required this.total,
    required this.date,
    required this.vehicleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fuel': fuel,
      'station': station,
      'liters': liters,
      'total': total,
      'date': date,
      'vehicle_id': vehicleId,
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'],
      fuel: map['fuel'],
      station: map['station'],
      liters: (map['liters'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      date: map['date'],
      vehicleId: map['vehicle_id'] ?? 'v-legacy',
    );
  }
}

// Static Data
final List<Station> stations = [
  Station(id: 'pertamina', name: 'Pertamina', mono: 'PT'),
  Station(id: 'shell', name: 'Shell', mono: 'SH'),
  Station(id: 'vivo', name: 'Vivo', mono: 'VV'),
  Station(id: 'bp', name: 'BP', mono: 'BP'),
];

final Map<String, List<Fuel>> fuels = {
  'pertamina': [
    Fuel(id: 'pertalite', name: 'Pertalite', octane: 90, price: 10000, type: 'bensin', ratingType: 'RON'),
    Fuel(id: 'pertamax', name: 'Pertamax', octane: 92, price: 15950, type: 'bensin', ratingType: 'RON'),
    Fuel(id: 'pertamax-green', name: 'Pertamax Green 95', octane: 95, price: 16600, type: 'bensin', ratingType: 'RON'),
    Fuel(id: 'pertamax-turbo', name: 'Pertamax Turbo', octane: 98, price: 18300, type: 'bensin', ratingType: 'RON'),
    Fuel(id: 'biosolar', name: 'Bio Solar', octane: 48, price: 6800, type: 'diesel', ratingType: 'CN'),
    Fuel(id: 'dexlite', name: 'Dexlite', octane: 51, price: 19700, type: 'diesel', ratingType: 'CN'),
    Fuel(id: 'pertamina-dex', name: 'Pertamina Dex', octane: 53, price: 21150, type: 'diesel', ratingType: 'CN'),
  ],
  'shell': [
    Fuel(id: 'shell-vpower-diesel', name: 'Shell V-Power Diesel', octane: 51, price: 21910, type: 'diesel', ratingType: 'CN'),
  ],
  'vivo': [
    Fuel(id: 'revvo-90', name: 'Revvo 90', octane: 90, price: 15900, type: 'bensin', ratingType: 'RON'),
    Fuel(id: 'revvo-92', name: 'Revvo 92', octane: 92, price: 16130, type: 'bensin', ratingType: 'RON'),
    Fuel(id: 'revvo-95', name: 'Revvo 95', octane: 95, price: 16760, type: 'bensin', ratingType: 'RON'),
    Fuel(id: 'primus-diesel', name: 'Primus Plus Diesel', octane: 51, price: 21910, type: 'diesel', ratingType: 'CN'),
  ],
  'bp': [
    Fuel(id: 'bp-92', name: 'BP 92', octane: 92, price: 16130, type: 'bensin', ratingType: 'RON'),
    Fuel(id: 'bp-ultimate', name: 'BP Ultimate', octane: 95, price: 16760, type: 'bensin', ratingType: 'RON'),
    Fuel(id: 'bp-ultimate-diesel', name: 'BP Ultimate Diesel', octane: 51, price: 21910, type: 'diesel', ratingType: 'CN'),
  ],
};
