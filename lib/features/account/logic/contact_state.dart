part of 'contact_cubit.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

final class ContactInitial extends ContactState {
  const ContactInitial();
}

final class ContactLoading extends ContactState {
  const ContactLoading();
}

final class ContactSuccess extends ContactState {
  final ContactInfoModel info;
  const ContactSuccess(this.info);

  @override
  List<Object?> get props => [info];
}

final class ContactError extends ContactState {
  final String message;
  const ContactError(this.message);

  @override
  List<Object?> get props => [message];
}
