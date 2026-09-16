import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/account_repo.dart';
import '../data/models/contact_info_model.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit(this._repo) : super(const ContactInitial());

  final AccountRepo _repo;

  Future<void> getContactInfo() async {
    emit(const ContactLoading());
    try {
      final info = await _repo.getContactInfo();
      emit(ContactSuccess(info));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(ContactError(msg));
    }
  }

  Future<bool> sendMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      await _repo.sendContactMessage(
        name: name,
        email: email,
        subject: subject,
        message: message,
      );
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }
}
