import '../models/event.dart';

class EventData {
  static final List<Event> events = [
    Event(
      name: 'නව වසර උදාව',
      description:
          'අලුත් අවුරුද්ද උදාවන මොහොත. අලුත් අවුරුද්ද උදාවන මොහොත. අලුත් අවුරුද්ද උදාවන මොහොත. අලුත් අවුරුද්ද උදාවන මොහොත. අලුත් අවුරුද්ද උදාවන මොහොත.',
      startTime: DateTime(2025, 4, 3, 23, 15), // April 25, 2025, 3:00 PM
      imagePath: 'assets/images/new_year.png', // Example image path
    ),
    Event(
      name: 'අවුරුදු උත්සවය',
      description: 'අවුරුදු උත්සවය සමරමු.',
      startTime: DateTime(2025, 4, 26, 12, 0),
      imagePath: 'assets/images/festival.png',
    ),
    Event(
      name: 'සුභ නැකත',
      description: 'සුභ නැකතකින් ආරම්භය.',
      startTime: DateTime(2025, 4, 27, 9, 30),
      imagePath: 'assets/images/auspicious.png',
    ),
    Event(
      name: 'කිරි ඉතිරීම',
      description: 'කිරි ඉතිරීමේ චාරිත්‍රය.',
      startTime: DateTime(2025, 4, 27, 15, 0),
      imagePath: 'assets/images/milk_overflow.png',
    ),
    Event(
      name: 'අවුරුදු තෑගි',
      description: 'අවුරුදු තෑගි හුවමාරුව.',
      startTime: DateTime(2025, 4, 28, 10, 0),
      imagePath: 'assets/images/gifts.png',
    ),
  ];
}
