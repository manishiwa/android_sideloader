class AdbDevice {
  final String id;
  final String manufacturer;
  final String model;

  AdbDevice({
    required this.id,
    required this.manufacturer,
    required this.model,
  });

  @override
  String toString() {
    return 'AdbDevice(id: $id, manufacturer: $manufacturer, model: $model)';
  }

  @override
  bool operator ==(Object other) {
    if (other is! AdbDevice) {
      return false;
    }
    return id == other.id && manufacturer == other.manufacturer && model == other.model;
  }

  @override
  int get hashCode => Object.hash(id, manufacturer, model);
}
