class TimeService {
  static Duration getTimeUntilEvent(DateTime eventTime) {
    return eventTime.difference(DateTime.now());
  }
}
