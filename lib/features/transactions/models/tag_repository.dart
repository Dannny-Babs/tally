import 'transaction_model.dart';

/// A static list of default tags for quick selection.
/// Users can still create new custom tags with any emoji.
class TagRepository {
  // Predefined, built‐in tags
  static final List<Tag> defaultTags = [
    Tag(name: 'Subscriptions', emoji: '🔄', color: 'Colors.amber'),
    Tag(name: 'Movies', emoji: '🎬', color: 'Colors.blue'),
    Tag(name: 'Cinema', emoji: '🎥', color: 'Colors.green'),
    Tag(name: 'Games', emoji: '🎮', color: 'Colors.yellow'),
    Tag(name: 'Groceries', emoji: '🛒', color: 'Colors.purple'),
    Tag(name: 'Transport', emoji: '🚗', color: 'Colors.orange'),
    Tag(name: 'Dining', emoji: '🍽️', color: 'Colors.pink'),
    Tag(name: 'Shopping', emoji: '🛍️', color: 'Colors.brown'),
    Tag(name: 'Health', emoji: '💊', color: 'Colors.grey'),
    Tag(name: 'Entertainment', emoji: '🎯', color: 'Colors.teal'),
    Tag(name: 'Travel', emoji: '✈️', color: 'Colors.indigo'),
    Tag(name: 'Education', emoji: '📚', color: 'Colors.lime'),
    Tag(name: 'Bills', emoji: '📝', color: 'Colors.cyan'),
    Tag(name: 'Gifts', emoji: '🎁', color: 'Colors.red'),
    Tag(name: 'Investment', emoji: '📈', color: 'Colors.blue'),
  ];
} 