import 'transaction_model.dart';

/// A static list of default tags for quick selection.
/// Users can still create new custom tags with any emoji.
class TagRepository {
  // Predefined, built‐in tags
  static final List<Tag> defaultTags = [
    Tag(name: 'Subscriptions', emoji: '🔄'),
    Tag(name: 'Movies', emoji: '🎬'),
    Tag(name: 'Cinema', emoji: '🎥'),
    Tag(name: 'Games', emoji: '🎮'),
    Tag(name: 'Groceries', emoji: '🛒'),
    Tag(name: 'Transport', emoji: '🚗'),
    Tag(name: 'Dining', emoji: '🍽️'),
    Tag(name: 'Shopping', emoji: '🛍️'),
    Tag(name: 'Health', emoji: '💊'),
    Tag(name: 'Entertainment', emoji: '🎯'),
    Tag(name: 'Travel', emoji: '✈️'),
    Tag(name: 'Education', emoji: '📚'),
    Tag(name: 'Bills', emoji: '📝'),
    Tag(name: 'Gifts', emoji: '🎁'),
    Tag(name: 'Investment', emoji: '📈'),
  ];
} 