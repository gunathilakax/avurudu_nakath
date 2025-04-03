class Event {
  final String name;
  final String description;
  final DateTime startTime;
  final String imagePath; // New field for image path

  Event({
    required this.name,
    required this.description,
    required this.startTime,
    required this.imagePath,
  });
}