import 'transaction_model.dart';

/// A static list of default tags for quick selection.
/// Users can still create new custom tags with any emoji.
class TagRepository {
  // Predefined, built‐in tags
  static final List<Tag> defaultTags = [
    const Tag(name: 'Subscriptions', emoji: '🔄', color: 'Colors.amber'),
    const Tag(name: 'Movies', emoji: '🎬', color: 'Colors.blue'),
    const Tag(name: 'Cinema', emoji: '🎥', color: 'Colors.green'),
    const Tag(name: 'Games', emoji: '🎮', color: 'Colors.yellow'),
    const Tag(name: 'Groceries', emoji: '🛒', color: 'Colors.purple'),
    const Tag(name: 'Transport', emoji: '🚗', color: 'Colors.orange'),
    const Tag(name: 'Dining', emoji: '🍽️', color: 'Colors.pink'),
    const Tag(name: 'Shopping', emoji: '🛍️', color: 'Colors.brown'),
    const Tag(name: 'Health', emoji: '💊', color: 'Colors.grey'),
    const Tag(name: 'Entertainment', emoji: '🎯', color: 'Colors.teal'),
    const Tag(name: 'Travel', emoji: '✈️', color: 'Colors.indigo'),
    const Tag(name: 'Education', emoji: '📚', color: 'Colors.lime'),
    const Tag(name: 'Bills', emoji: '📝', color: 'Colors.cyan'),
    const Tag(name: 'Gifts', emoji: '🎁', color: 'Colors.red'),
    const Tag(name: 'Investment', emoji: '📈', color: 'Colors.blue'),
  ];
} 