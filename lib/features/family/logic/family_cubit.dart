import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/family_repo.dart';
import '../data/models/family_member_model.dart';

part 'family_state.dart';

class FamilyCubit extends Cubit<FamilyState> {
  FamilyCubit(this._repo) : super(const FamilyInitial());

  final FamilyRepo _repo;

  Future<void> getFamilyMembers() async {
    emit(const FamilyLoading());
    try {
      final members = await _repo.getFamilyMembers();
      emit(FamilySuccess(members));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(FamilyError(msg));
    }
  }

  /// Adds a member and refreshes the list on success. Deliberately doesn't
  /// touch [FamilyState] on failure (only shows the error overlay) — an
  /// add-member error shouldn't blank out an already-loaded list behind the
  /// sheet. The add-member sheet drives its own submit-button spinner off
  /// this method's return value instead of off [state].
  Future<bool> addFamilyMember({
    required String name,
    required String dateOfBirth,
    required String phone,
    required String idNumber,
    List<XFile> medicalFiles = const [],
  }) async {
    try {
      await _repo.addFamilyMember(
        name: name,
        dateOfBirth: dateOfBirth,
        phone: phone,
        idNumber: idNumber,
        medicalFiles: medicalFiles,
      );
      await getFamilyMembers();
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  /// Same fire/refresh/return-bool contract as [addFamilyMember], for
  /// editing an existing member from `MemberScreen`.
  Future<bool> updateFamilyMember({
    required int id,
    required String name,
    required String dateOfBirth,
    required String phone,
    required String idNumber,
    List<XFile> medicalFiles = const [],
  }) async {
    try {
      await _repo.updateFamilyMember(
        id: id,
        name: name,
        dateOfBirth: dateOfBirth,
        phone: phone,
        idNumber: idNumber,
        medicalFiles: medicalFiles,
      );
      await getFamilyMembers();
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }
}
