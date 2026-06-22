import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MatchTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  MatchTabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant MatchTabBarDelegate old) => false;
}
