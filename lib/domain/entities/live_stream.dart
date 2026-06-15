class LiveStream {
  final String id;
  final String creatorId;
  final String creatorName;
  final String? creatorAvatar;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String category;
  final bool isLive;
  final int viewerCount;
  final DateTime startedAt;

  const LiveStream({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    this.creatorAvatar,
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.category = 'general',
    this.isLive = false,
    this.viewerCount = 0,
    required this.startedAt,
  });
}
