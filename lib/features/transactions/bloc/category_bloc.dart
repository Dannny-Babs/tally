import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_event.dart';
import 'category_state.dart';
import 'mock_categories.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<CategoriesLoaded>(_onCategoriesLoaded);
    on<AddCategorySubmitted>(_onAddCategorySubmitted);
    on<DeleteCategorySubmitted>(_onDeleteCategorySubmitted);
    on<UpdateCategorySubmitted>(_onUpdateCategorySubmitted);
  }

  Future<void> _onCategoriesLoaded(
    CategoriesLoaded event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final categories = _getMockCategories();

      if (categories.isEmpty) {
        emit(CategoryEmpty());
      } else {
        emit(CategoryLoaded(categories));
      }
    } catch (e) {
      emit(CategoryError('Failed to load categories'));
    }
  }

  Future<void> _onAddCategorySubmitted(
    AddCategorySubmitted event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;

      try {
        // TODO: Replace with actual API call
        await Future.delayed(const Duration(seconds: 1));

        final newCategory = Category(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: event.name,
          description: event.description,
          icon: event.icon,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        emit(currentState.copyWith(
          categories: [...currentState.categories, newCategory],
        ));
      } catch (e) {
        // Don't emit error state, just keep current state
      }
    }
  }

  Future<void> _onDeleteCategorySubmitted(
    DeleteCategorySubmitted event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;

      try {
        // TODO: Replace with actual API call
        await Future.delayed(const Duration(seconds: 1));

        final updatedCategories = currentState.categories
            .where((category) => category.id != event.categoryId)
            .toList();

        emit(currentState.copyWith(categories: updatedCategories));
      } catch (e) {
        // Don't emit error state, just keep current state
      }
    }
  }

  Future<void> _onUpdateCategorySubmitted(
    UpdateCategorySubmitted event,
    Emitter<CategoryState> emit,
  ) async {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;

      try {
        // TODO: Replace with actual API call
        await Future.delayed(const Duration(seconds: 1));

        final updatedCategories = currentState.categories.map((category) {
          if (category.id == event.categoryId) {
            return Category(
              id: category.id,
              name: event.name,
              description: event.description,
              icon: event.icon,
              createdAt: category.createdAt,
              updatedAt: DateTime.now(),
            );
          }
          return category;
        }).toList();

        emit(currentState.copyWith(categories: updatedCategories));
      } catch (e) {
        // Don't emit error state, just keep current state
      }
    }
  }

  List<Category> _getMockCategories() {
    return [
      Category(
        id: '1',
        name: 'Food & Dining',
        description: 'Restaurants, groceries, and food delivery',
        icon: 'food',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Category(
        id: '2',
        name: 'Transportation',
        description: 'Gas, public transit, and car maintenance',
        icon: 'car',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Category(
        id: '3',
        name: 'Housing',
        description: 'Rent, mortgage, and utilities',
        icon: 'home',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Category(
        id: '4',
        name: 'Entertainment',
        description: 'Movies, games, and subscriptions',
        icon: 'entertainment',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Category(
        id: '5',
        name: 'Shopping',
        description: 'Clothes, electronics, and other purchases',
        icon: 'shopping',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
  }
} 