import 'package:flutter/material.dart';

class LeagueFilterBar extends StatelessWidget {
  final String selectedSport;
  final void Function(String sport) onSportSelected;

  const LeagueFilterBar({
    super.key,
    this.selectedSport = 'all',
    required this.onSportSelected,
  });

  static const sports = [
    _SportItem('All', null, Icons.star),
    _SportItem('Football', 'football', Icons.sports_soccer),
    _SportItem('Basketball', 'basketball', Icons.sports_basketball),
    _SportItem('Tennis', 'tennis', Icons.sports_tennis),
    _SportItem('Rugby', 'rugby', Icons.sports_rugby),
    _SportItem('Cricket', 'cricket', Icons.sports_cricket),
    _SportItem('MMA', 'mma', Icons.sports_mma),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = sports[index];
          final isSelected = (item.sportKey == null && selectedSport == 'all') ||
              item.sportKey == selectedSport;
          return GestureDetector(
            onTap: () => onSportSelected(item.sportKey ?? 'all'),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2D1B69)
                        : const Color(0xFF1C1C26),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF2A2A3D),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    color: isSelected
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFF9090A0),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? const Color(0xFFA78BFA)
                        : const Color(0xFF9090A0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SportItem {
  final String name;
  final String? sportKey;
  final IconData icon;
  const _SportItem(this.name, this.sportKey, this.icon);
}
