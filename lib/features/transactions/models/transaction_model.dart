import 'package:equatable/equatable.dart';

/// A small helper class that holds a single "tag" (name + emoji).
class Tag extends Equatable {
  final String name;   // e.g. "Movies"
  final String emoji;  // e.g. "🎬"

  const Tag({required this.name, required this.emoji});

  @override
  List<Object?> get props => [name, emoji];

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'] as String,
      emoji: json['emoji'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'emoji': emoji,
      };
}

/// Enum for mood — you can add more as needed.
enum Mood { happy, sad, neutral, stressed, excited }

extension MoodExtension on Mood {
  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊';
      case Mood.sad:
        return '😢';
      case Mood.neutral:
        return '😐';
      case Mood.stressed:
        return '😣';
      case Mood.excited:
        return '🤩';
    }
  }

  String get name {
    return toString().split('.').last; // "happy", "sad", etc.
  }
}

class Transaction extends Equatable {
  final String id;
  final String source;
  final String description;
  final String date;     // YYYY-MM-DD
  final String time;     // HH:mm
  final double amount;
  final bool isIncome;
  final String category;       // E.g. ["Food", "Bills"]
  final List<Tag> tags;               // List of Tag objects
  final String? payeeName;            
  final bool taxable;
  final bool recurring;
  final String? frequency;            
  final List<String> receiptImages;   
  final String? notes;
  final String? paymentMethod;
  final String? incomeType;
  final Mood? mood;                   // New field

  const Transaction({
    required this.id,
    required this.source,
    required this.description,
    required this.date,
    required this.time,
    required this.amount,
    required this.isIncome,
    required this.category,
    this.tags = const [],
    this.payeeName,
    this.taxable = false,
    this.recurring = false,
    this.frequency,
    this.receiptImages = const [],
    this.notes,
    this.paymentMethod,
    this.incomeType,
    this.mood,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      source: json['source'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      amount: (json['amount'] as num).toDouble(),
      isIncome: json['isIncome'] as bool,
      category: json['category'] as String,
      tags: (json['tags'] as List?)
              ?.map((t) => Tag.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      payeeName: json['payeeName'] as String?,
      taxable: json['taxable'] as bool? ?? false,
      recurring: json['recurring'] as bool? ?? false,
      frequency: json['frequency'] as String?,
      receiptImages:
          List<String>.from(json['receiptImages'] as List? ?? const []),
      notes: json['notes'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      incomeType: json['incomeType'] as String?,
      mood: json['mood'] != null
          ? Mood.values.firstWhere(
              (m) => m.toString().split('.').last == (json['mood'] as String),
              orElse: () => Mood.neutral)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'description': description,
      'date': date,
      'time': time,
      'amount': amount,
      'isIncome': isIncome,
      'category': category,
      'tags': tags.map((t) => t.toJson()).toList(),
      'payeeName': payeeName,
      'taxable': taxable,
      'recurring': recurring,
      'frequency': frequency,
      'receiptImages': receiptImages,
      'notes': notes,
      'paymentMethod': paymentMethod,
      'incomeType': incomeType,
      'mood': mood?.name,
    };
  }

  @override
  List<Object?> get props => [
        id,
        source,
        description,
        date,
        time,
        amount,
        isIncome,
        category,
        tags,
        payeeName,
        taxable,
        recurring,
        frequency,
        receiptImages,
        notes,
        paymentMethod,
        incomeType,
        mood,
      ];
} 