import 'package:streamvault/design_system/widgets.dart';
import '../../../domain/entities/movie.dart';
import '../../shared/widgets/content_card.dart';

class TrendingRow extends StatelessWidget {
  final List<Movie>? movies;

  const TrendingRow({super.key, this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies == null) {
      return const SizedBox(height: 220);
    }
    if (movies!.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No trending movies')),
      );
    }
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final movie = movies![index];
          return SizedBox(
            width: 130,
            child: ContentCard(
              imageUrl: movie.posterUrl,
              title: movie.title,
              subtitle: movie.year,
              rating: movie.rating,
              isPoster: true,
              duration: movie.runtime != null
                  ? '${movie.runtime! ~/ 60}h ${movie.runtime! % 60}m'
                  : null,
            ),
          );
        },
      ),
    );
  }
}
