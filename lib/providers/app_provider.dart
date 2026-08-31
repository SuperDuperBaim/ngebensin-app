import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../database/db_helper.dart';

enum AppStep { splash, username, vehicle, home, station, fuel, unit, amount, success, history, settings, help, manageVehicles }
enum HistoryFilter { all, weekly, monthly }
enum HistorySort { newest, oldest, byStation }

class AppProvider extends ChangeNotifier {
  AppStep _currentStep = AppStep.splash;
  String _username = '';
  
  // Vehicles state
  List<Vehicle> _vehicles = [];
  String _selectedDashboardVehicleId = 'all';
  String _selectedHistoryVehicleId = 'all';
  String _activeLoggingVehicleId = '';

  Station? _selectedStation;
  Fuel? _selectedFuel;
  String _selectedUnit = 'rupiah';

  LogEntry? _lastEntry;
  List<LogEntry> _history = [];
  bool _isLoading = true;
  HistoryFilter _historyFilter = HistoryFilter.all;
  HistorySort _historySort = HistorySort.newest;

  // Getters
  AppStep get currentStep => _currentStep;
  String get username => _username;
  String get displayName => _username.isEmpty ? 'Kawan' : _username;
  
  List<Vehicle> get vehicles => _vehicles;
  String get selectedDashboardVehicleId => _selectedDashboardVehicleId;
  String get selectedHistoryVehicleId => _selectedHistoryVehicleId;
  String get activeLoggingVehicleId => _activeLoggingVehicleId;

  Vehicle? get activeVehicle {
    if (_vehicles.isEmpty) return null;
    final found = _vehicles.where((e) => e.id == _activeLoggingVehicleId);
    if (found.isEmpty) return _vehicles.first;
    return found.first;
  }

  // Backward compatibility with widgets reading legacy properties
  String? get vehicle => activeVehicle?.type;
  String get vehicleName => activeVehicle?.name ?? '';

  Station? get selectedStation => _selectedStation;
  Fuel? get selectedFuel => _selectedFuel;
  String get selectedUnit => _selectedUnit;
  LogEntry? get lastEntry => _lastEntry;
  List<LogEntry> get history => _history;
  bool get isLoading => _isLoading;
  HistoryFilter get historyFilter => _historyFilter;
  HistorySort get historySort => _historySort;

  // Dashboard logs filtered by chosen vehicle
  List<LogEntry> get dashboardLogs {
    if (_selectedDashboardVehicleId == 'all') {
      return _history;
    } else {
      return _history.where((e) => e.vehicleId == _selectedDashboardVehicleId).toList();
    }
  }

  double get totalSpent => dashboardLogs.fold(0, (sum, e) => sum + e.total);
  double get totalLiters => dashboardLogs.fold(0, (sum, e) => sum + e.liters);

  String? get firstLogDate {
    final list = dashboardLogs;
    if (list.isEmpty) return null;
    final oldest = list.last;
    try {
      final parsed = DateTime.parse(oldest.date);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return oldest.date;
    }
  }

  Map<String, int> get stationStats {
    final Map<String, int> counts = {};
    for (var entry in dashboardLogs) {
      counts[entry.station] = (counts[entry.station] ?? 0) + 1;
    }
    return counts;
  }

  Map<String, int> get fuelStats {
    final Map<String, int> counts = {};
    for (var entry in dashboardLogs) {
      counts[entry.fuel] = (counts[entry.fuel] ?? 0) + 1;
    }
    return counts;
  }

  List<LogEntry> get filteredHistory {
    final now = DateTime.now();
    List<LogEntry> list;
    
    // Filter by vehicle
    if (_selectedHistoryVehicleId == 'all') {
      list = List.from(_history);
    } else {
      list = _history.where((e) => e.vehicleId == _selectedHistoryVehicleId).toList();
    }

    // Filter by period
    switch (_historyFilter) {
      case HistoryFilter.weekly:
        final weekAgo = now.subtract(const Duration(days: 7));
        list = list.where((e) {
          final date = DateTime.tryParse(e.date);
          return date != null && date.isAfter(weekAgo);
        }).toList();
        break;
      case HistoryFilter.monthly:
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        list = list.where((e) {
          final date = DateTime.tryParse(e.date);
          return date != null && date.isAfter(monthAgo);
        }).toList();
        break;
      case HistoryFilter.all:
        break;
    }

    // Sort
    switch (_historySort) {
      case HistorySort.newest:
        list.sort((a, b) => b.date.compareTo(a.date));
        break;
      case HistorySort.oldest:
        list.sort((a, b) => a.date.compareTo(b.date));
        break;
      case HistorySort.byStation:
        list.sort((a, b) {
          final cmp = a.station.toLowerCase().compareTo(b.station.toLowerCase());
          if (cmp != 0) return cmp;
          return b.date.compareTo(a.date);
        });
        break;
    }

    return list;
  }

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat Pagi';
    if (h < 15) return 'Selamat Siang';
    if (h < 19) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username') ?? '';

      // Load vehicles from DB
      _vehicles = await DBHelper().getVehicles();

      // Migrate from old SharedPreferences
      final legacyVehicleType = prefs.getString('vehicle');
      final legacyVehicleName = prefs.getString('vehicle_name');
      if (legacyVehicleType != null && _vehicles.isEmpty) {
        final legacyVehicle = Vehicle(
          id: 'v-legacy',
          name: legacyVehicleName ?? (legacyVehicleType == 'mobil' ? 'Mobil Utama' : 'Motor Utama'),
          type: legacyVehicleType,
        );
        await DBHelper().insertVehicle(legacyVehicle);
        _vehicles = [legacyVehicle];

        // Clean SharedPreferences legacy keys
        await prefs.remove('vehicle');
        await prefs.remove('vehicle_name');
      }

      if (_vehicles.isNotEmpty) {
        _activeLoggingVehicleId = _vehicles.first.id;
      }

      await loadHistory();
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    }

    if (_username.isNotEmpty && _vehicles.isNotEmpty) {
      _currentStep = AppStep.home;
    } else if (_username.isNotEmpty) {
      _currentStep = AppStep.vehicle;
    } else {
      _currentStep = AppStep.splash;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    try {
      _history = await DBHelper().getLogs();
    } catch (e) {
      debugPrint('Error loading history: $e');
      _history = [];
    }
    notifyListeners();
  }

  Future<void> deleteLog(String id) async {
    try {
      await DBHelper().deleteLog(id);
      await loadHistory();
    } catch (e) {
      debugPrint('Error deleting log: $e');
    }
  }

  Future<void> updateLog(LogEntry log) async {
    try {
      await DBHelper().updateLog(log);
      await loadHistory();
    } catch (e) {
      debugPrint('Error updating log: $e');
    }
  }

  void setStep(AppStep step) {
    _currentStep = step;
    notifyListeners();
  }

  void setHistoryFilter(HistoryFilter filter) {
    _historyFilter = filter;
    notifyListeners();
  }

  void setHistorySort(HistorySort sort) {
    _historySort = sort;
    notifyListeners();
  }

  Future<void> setUsername(String name) async {
    _username = name;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', name);
    } catch (e) {
      debugPrint('Error saving username: $e');
    }
    _currentStep = AppStep.vehicle;
    notifyListeners();
  }

  // Add vehicle CRUD operations
  Future<void> addVehicle(String name, String type) async {
    final newVehicle = Vehicle(
      id: 'v-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim().isEmpty ? (type == 'mobil' ? 'Mobil Baru' : 'Motor Baru') : name.trim(),
      type: type,
    );
    try {
      await DBHelper().insertVehicle(newVehicle);
      _vehicles = await DBHelper().getVehicles();
      _activeLoggingVehicleId = newVehicle.id;
      if (_currentStep == AppStep.vehicle) {
        _currentStep = AppStep.home;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding vehicle: $e');
    }
  }

  // Backward compatibility legacy setVehicle
  Future<void> setVehicle(String vehicleId, {String name = ''}) async {
    await addVehicle(name, vehicleId);
  }

  Future<void> updateVehicle(String id, String name) async {
    final vIndex = _vehicles.indexWhere((e) => e.id == id);
    if (vIndex == -1) return;
    final updated = Vehicle(
      id: id,
      name: name.trim().isEmpty ? _vehicles[vIndex].name : name.trim(),
      type: _vehicles[vIndex].type,
    );
    try {
      await DBHelper().updateVehicle(updated);
      _vehicles = await DBHelper().getVehicles();
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating vehicle: $e');
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      await DBHelper().deleteVehicle(id);
      _vehicles = await DBHelper().getVehicles();
      
      if (_activeLoggingVehicleId == id) {
        _activeLoggingVehicleId = _vehicles.isNotEmpty ? _vehicles.first.id : '';
      }
      if (_selectedDashboardVehicleId == id) {
        _selectedDashboardVehicleId = 'all';
      }
      if (_selectedHistoryVehicleId == id) {
        _selectedHistoryVehicleId = 'all';
      }
      
      await loadHistory();
    } catch (e) {
      debugPrint('Error deleting vehicle: $e');
    }
  }

  void setDashboardVehicleFilter(String vehicleId) {
    _selectedDashboardVehicleId = vehicleId;
    notifyListeners();
  }

  void setHistoryVehicleFilter(String vehicleId) {
    _selectedHistoryVehicleId = vehicleId;
    notifyListeners();
  }

  void setActiveLoggingVehicle(String vehicleId) {
    _activeLoggingVehicleId = vehicleId;
    notifyListeners();
  }

  String getVehicleName(String vehicleId) {
    if (vehicleId == 'v-legacy') return 'Motor Utama';
    final found = _vehicles.where((e) => e.id == vehicleId);
    if (found.isEmpty) return 'Kendaraan Lain';
    return found.first.name;
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('vehicle');
      await prefs.remove('vehicle_name');
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
    _username = '';
    _vehicles = [];
    _activeLoggingVehicleId = '';
    _selectedDashboardVehicleId = 'all';
    _selectedHistoryVehicleId = 'all';
    _currentStep = AppStep.splash;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await DBHelper().clearAllLogs();
      // Also clear all vehicles
      final db = await DBHelper().database;
      await db.delete('vehicles');
    } catch (e) {
      debugPrint('Error deleting account: $e');
    }
    _username = '';
    _vehicles = [];
    _activeLoggingVehicleId = '';
    _selectedDashboardVehicleId = 'all';
    _selectedHistoryVehicleId = 'all';
    _history = [];
    _lastEntry = null;
    _currentStep = AppStep.splash;
    notifyListeners();
  }

  void selectStation(Station station) {
    _selectedStation = station;
    _currentStep = AppStep.fuel;
    notifyListeners();
  }

  void selectFuel(Fuel fuel) {
    _selectedFuel = fuel;
    _currentStep = AppStep.unit;
    notifyListeners();
  }

  void selectUnit(String unit) {
    _selectedUnit = unit;
    _currentStep = AppStep.amount;
    notifyListeners();
  }

  Future<void> confirmEntry({required double liters, required double total, bool navigateToSuccess = false}) async {
    if (_selectedStation == null || _selectedFuel == null || _activeLoggingVehicleId.isEmpty) return;

    final entry = LogEntry(
      id: 'log-${DateTime.now().millisecondsSinceEpoch}',
      fuel: _selectedFuel!.name,
      station: _selectedStation!.name,
      liters: liters,
      total: total,
      date: DateTime.now().toIso8601String(),
      vehicleId: _activeLoggingVehicleId,
    );

    try {
      await DBHelper().insertLog(entry);
      await loadHistory();
    } catch (e) {
      debugPrint('Error saving entry: $e');
      _history = [entry, ..._history];
    }

    _lastEntry = entry;
    if (navigateToSuccess) {
      _currentStep = AppStep.success;
    }
    notifyListeners();
  }
}
