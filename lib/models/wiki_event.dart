class WikiEvent {
  final int year;
  final String text;
  final String? pageUrl;
  final String? imageUrl;

  WikiEvent({
    required this.year,
    required this.text,
    this.pageUrl,
    this.imageUrl,
  });
}
