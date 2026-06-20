class TimelineEvent {
  final String minute;
  final String type;
  final String? player;
  final String? team;
  final String? assist;
  final bool isHome;

  const TimelineEvent({
    required this.minute,
    required this.type,
    this.player,
    this.team,
    this.assist,
    this.isHome = true,
  });

  bool get isGoal => type == 'goal' || type == 'penalty' || type == 'own_goal';
  bool get isCard => type == 'yellow_card' || type == 'red_card' || type == 'second_yellow';
  bool get isSubstitution => type == 'substitution';
  bool get isMissedPenalty => type == 'missed_penalty';

  String get iconLabel {
    switch (type) {
      case 'goal':
        return '⚽';
      case 'penalty':
        return '⚽';
      case 'own_goal':
        return '⚽';
      case 'yellow_card':
        return '🟨';
      case 'red_card':
        return '🟥';
      case 'second_yellow':
        return '🟥';
      case 'substitution':
        return '🔄';
      case 'missed_penalty':
        return '❌';
      default:
        return '•';
    }
  }
}

List<TimelineEvent> generateTimeline(String homeTeam, String awayTeam, int? homeScore, int? awayScore) {
  final events = <TimelineEvent>[];
  final hScore = homeScore ?? 0;
  final aScore = awayScore ?? 0;
  final total = hScore + aScore;

  if (total == 0) return events;

  final minuteSlots = [12, 25, 34, 45, 51, 58, 63, 67, 73, 78, 82, 85, 90];

  var homeGoals = 0;
  var awayGoals = 0;
  var minuteIndex = 0;

  for (var i = 0; i < total && minuteIndex < minuteSlots.length; i++) {
    final isHomeGoal = homeGoals < hScore && (awayGoals >= aScore || (homeGoals < hScore && (i % 2 == 0 || awayGoals >= aScore)));
    events.add(TimelineEvent(
      minute: "${minuteSlots[minuteIndex]}'",
      type: 'goal',
      player: 'Player ${i + 1}',
      team: isHomeGoal ? homeTeam : awayTeam,
      isHome: isHomeGoal,
    ));
    if (isHomeGoal) homeGoals++; else awayGoals++;
    minuteIndex++;
  }

  return events;
}
