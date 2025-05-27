import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoriesLoaded extends CategoryEvent {}

class AddCategorySubmitted extends CategoryEvent {
  final String name;
  final String? description;
  final String? icon;

  const AddCategorySubmitted({
    required this.name,
    this.description,
    this.icon,
  });

  @override
  List<Object> get props => [name, description ?? '', icon ?? ''];
}

class DeleteCategorySubmitted extends CategoryEvent {
  final String categoryId;

  const DeleteCategorySubmitted(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class UpdateCategorySubmitted extends CategoryEvent {
  final String categoryId;
  final String name;
  final String? description;
  final String? icon;

  const UpdateCategorySubmitted({
    required this.categoryId,
    required this.name,
    this.description,
    this.icon,
  });

  @override
  List<Object> get props => [categoryId, name, description ?? '', icon ?? ''];
} 