import 'package:streamvault/design_system/ds.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../shared/widgets/content_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.surfaceElevated,
                        child: const Icon(Icons.person, size: 40, color: Color(0xFF9090A0)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('User Name', style: AppTypography.titleLarge),
                  Text(
                    '@username',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bio goes here',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 36,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Edit Profile',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(value: '0', label: 'WATCHING'),
                        _StatItem(value: '12', label: 'WATCHLIST'),
                        _StatItem(value: '28', label: 'FOLLOWING'),
                        _StatItem(value: '142', label: 'FOLLOWERS'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TabBar(
                    tabs: const [
                      Tab(text: 'Watchlist'),
                      Tab(text: 'Uploads'),
                      Tab(text: 'Following'),
                    ],
                    labelColor: AppColors.textPrimary,
                    unselectedLabelColor: AppColors.textMuted,
                    indicatorColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  _WatchlistTab(),
                  _UploadsTab(),
                  _FollowingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}

class _WatchlistTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => ContentCard(
        title: 'Saved Movie',
        subtitle: '2024',
        duration: '2h',
      ),
    );
  }
}

class _UploadsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 48, color: Color(0xFF50505F)),
          SizedBox(height: 12),
          Text(
            'No uploads yet',
            style: TextStyle(color: Color(0xFF9090A0)),
          ),
        ],
      ),
    );
  }
}

class _FollowingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceElevated,
          child: const Icon(Icons.person, color: Color(0xFF9090A0)),
        ),
        title: Text('Creator Name', style: AppTypography.bodyLarge),
        subtitle: Text('24K followers', style: AppTypography.bodyMedium),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Following',
            style: AppTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
