import 'package:streamvault/design_system/ds.dart';
import '../../shared/widgets/content_card.dart';

class TrendingRow extends StatelessWidget {
  const TrendingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => const SizedBox(
          width: 130,
          child: ContentCard(
            title: 'Trending Movie',
            subtitle: '2024',
            isPoster: true,
            duration: '2h 10m',
          ),
        ),
      ),
    );
  }
}
