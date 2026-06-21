import 'package:streamvault/design_system/widgets.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/discover')) return 1;
    if (location.startsWith('/sports')) return 2;
    if (location.startsWith('/live')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: Color(0xFF13131A),
          border: Border(
            top: BorderSide(color: Color(0xFF2A2A3D), width: 1),
          ),
        ),
        child: Row(
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'HOME',
              isActive: index == 0,
              onTap: () => context.go('/'),
            ),
            _NavItem(
              icon: Icons.search_outlined,
              activeIcon: Icons.search,
              label: 'DISCOVER',
              isActive: index == 1,
              onTap: () => context.go('/discover'),
            ),
            _NavItem(
              icon: Icons.sports_soccer_outlined,
              activeIcon: Icons.sports_soccer,
              label: 'SPORTS',
              isActive: index == 2,
              onTap: () => context.go('/sports'),
            ),
            _NavItem(
              icon: Icons.live_tv_outlined,
              activeIcon: Icons.live_tv,
              label: 'LIVE',
              isActive: index == 3,
              onTap: () => context.go('/live'),
            ),
            _NavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'PROFILE',
              isActive: index == 4,
              onTap: () => context.go('/profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isActive)
              Container(
                width: 36,
                height: 3,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFF7C3AED),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              )
            else
              const SizedBox(height: 9),
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? const Color(0xFF7C3AED) : const Color(0xFF50505F),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8,
                color: isActive ? const Color(0xFF7C3AED) : const Color(0xFF50505F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
