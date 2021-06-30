import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_cubit_cg.freezed.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit({required Page initialPage})
      : super(NavigationState(pages: [initialPage]));

  void push(Page page) {
    emit(state.copyWith(pages: [...state.pages, page]));
  }

  void popNAndPush(Page page, {required int n}) {
    assert(n > 0);
    emit(
      state.copyWith(
        pages: [...state.pages.take(state.pages.length - n), page],
      ),
    );
  }

  void replace(Page page) => emit(
        state.copyWith(
          pages: [...state.pages.take(state.pages.length - 1), page],
        ),
      );

  void pop() {
    if (state.pages.length > 1) {
      emit(
        state.copyWith(
          // skip(1) to make sure pages is never empty
          pages: state.pages.take(state.pages.length - 1).toList(),
        ),
      );
    } else {
      throw RangeError('Can\'t call pop on NavigationState.pages of length 1!');
    }
  }
}

@freezed
class NavigationState with _$NavigationState {
  const NavigationState._();
  const factory NavigationState({required List<Page> pages}) = _NavigationState;

  Page get currentPage => pages.last;
}
