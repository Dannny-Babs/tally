import 'package:flutter/material.dart';
import 'package:hugeicons_pro/hugeicons.dart';

/// Utility class to map categories to their corresponding icons
class CategoryIcons {
  /// Get icon for expense category
  static IconData getExpenseIcon(String category) {
    switch (category.toLowerCase()) {
      // Food & Dining
      case 'food':
        return HugeIconsSolid.bread04;
      case 'dining':
      case 'restaurants':
        return HugeIconsSolid.restaurant02;
      case 'groceries':
        return HugeIconsSolid.store03;

      // Shopping & Personal
      case 'shopping':
        return HugeIconsSolid.shoppingCart01;
      case 'clothing':
        return HugeIconsSolid.shirt01;
      case 'school':
      case 'tuition':
        return HugeIconsSolid.school;
      case 'education':
      case 'books':
        return HugeIconsSolid.book01;
      case 'toys':
      case 'gifts & donations':
        return HugeIconsSolid.gift;
      case 'personal care':
      case 'hair':
      case 'beauty':
      case 'skincare':
        return HugeIconsSolid.userLock01;

      // Bills & Payments
      case 'credit cards':
      case 'subscriptions':
        return HugeIconsSolid.creditCard;
      case 'taxes':
        return HugeIconsSolid.taxes;
      case 'phone':
        return HugeIconsSolid.smartPhone01;

      // Entertainment & Hobbies
      case 'concerts/shows':
      case 'music':
      case 'music lessons':
        return HugeIconsSolid.musicNote01;
      case 'games':
        return HugeIconsSolid.gameController01;
      case 'hobbies':
        return HugeIconsSolid.canvas;
      case 'movies':
      case 'tv':
      case 'entertainment':
        return HugeIconsSolid.tv01;
      case 'sports':
        return HugeIconsSolid.footballPitch;

      // Personal Care & Subscriptions
      case 'laundry/dry cleaning':
      case 'laundry':
        return HugeIconsSolid.home01;

      // Technology
      case 'domains & hosting':
      case 'online services':
      case 'hardware':
      case 'software':
      case 'development':
        return HugeIconsSolid.developer;

      // Transportation
      case 'public transit':
        return HugeIconsSolid.metro;
      case 'ride hailing':
        return HugeIconsSolid.taxi;
      case 'transportation':
        return HugeIconsSolid.car01;

      // Travel
      case 'airfare':
      case 'travel':
        return HugeIconsSolid.airplane01;
      case 'hotels':
        return HugeIconsSolid.home01;

      // Housing
      case 'rent':
        return HugeIconsSolid.home02;
      case 'housing':
        return HugeIconsSolid.home01;

      // Other Categories
      case 'utilities':
        return HugeIconsSolid.invoice;
      case 'health & fitness':
        return HugeIconsSolid.health;
      case 'insurance':
        return HugeIconsSolid.shield01;
      case 'investments':
        return HugeIconsSolid.chart01;
      case 'kids':
        return HugeIconsSolid.baby01;
      case 'alcohol & bars':
        return HugeIconsSolid.drink;
      case 'miscellaneous':
        return HugeIconsSolid.tag02;

      default:
        return HugeIconsSolid.tag01;
    }
  }

  /// Get icon for income source
  static IconData getIncomeIcon(String source) {
    switch (source.toLowerCase()) {
      case 'freelance':
      case 'job':
      case 'job payment':
        return HugeIconsSolid.briefcase01;
      case 'design':
        return HugeIconsSolid.canvas;
      case 'development':
        return HugeIconsSolid.developer;
      case 'marketing':
        return HugeIconsSolid.megaphone01;
      case 'investment':
      case 'investments':
        return HugeIconsSolid.chart01;
      case 'family':
        return HugeIconsSolid.userGroup02;
      case 'refund':
        return HugeIconsSolid.cash02;
      case 'bonus':
        return HugeIconsSolid.tips;
      default:
        return HugeIconsSolid.money03;
    }
  }
} 