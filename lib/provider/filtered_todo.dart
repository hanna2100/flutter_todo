import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:todo_provider/provider/todo_filter.dart';
import 'package:todo_provider/provider/todo_search.dart';

import '../models/todo_model.dart';
import 'todo_list.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> filteredTodos;

  FilteredTodosState({required this.filteredTodos});

  factory FilteredTodosState.initial() {
    return FilteredTodosState(filteredTodos: []);
  }

  @override
  List<Object?> get props => [filteredTodos];

  @override
  bool get stringify => true;

  FilteredTodosState copyWith({
    List<Todo>? filteredTodos,
  }) {
    return FilteredTodosState(
      filteredTodos: filteredTodos ?? this.filteredTodos,
    );
  }
}

class FilteredTodos extends StateNotifier<FilteredTodosState>
    with LocatorMixin {
  FilteredTodos() : super(FilteredTodosState.initial());

  @override
  void update(Locator watch) {
    final List<Todo> todos = watch<TodoListState>().todos;
    final Filter filter = watch<TodoFilterState>().filter;
    final String searchTerm = watch<TodoSearchState>().searchTerm;

    List<Todo> _filteredTodos;

    switch (filter) {
      case Filter.active:
        _filteredTodos = todos.where((todo) => !todo.completed).toList();
        break;
      case Filter.complete:
        _filteredTodos = todos.where((todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = todos;
        break;
    }

    if (searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((todo) => todo.desc.toLowerCase().contains(searchTerm))
          .toList();
    }
    state = state.copyWith(filteredTodos: _filteredTodos);
    super.update(watch);
  }
}
