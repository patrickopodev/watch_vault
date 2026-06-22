import 'package:streamvault/design_system/widgets.dart';
import '../../../domain/entities/movie.dart';
import '../../shared/widgets/content_card.dart';

class FreeToWatchGrid extends StatelessWidget {
  final List<Movie>? movies;

  const FreeToWatchGrid({super.key, this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies == null) {
      return const SizedBox(height: 200);
    }
    if (movies!.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No free content available')),
      );
    }
    final displayItems = movies!.take(6).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: displayItems.length,
      itemBuilder: (_, index) {
        final movie = displayItems[index];
        return ContentCard(
          imageUrl: movie.posterUrl,
          title: movie.title,
          subtitle: movie.runtime != null
              ? '${movie.runtime! ~/ 60}h ${movie.runtime! % 60}m'
              : movie.year,
          duration: 'Free',
        );
      },
    );
  }
}
