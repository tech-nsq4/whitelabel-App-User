import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/content_page_model.dart';
import '../data/pages_repo.dart';

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit(this._repo) : super(const PageInitial());

  final PagesRepo _repo;

  Future<void> getPage(String slug) async {
    emit(const PageLoading());
    try {
      final page = await _repo.getPage(slug);
      emit(PageSuccess(page));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(PageError(msg));
    }
  }
}
