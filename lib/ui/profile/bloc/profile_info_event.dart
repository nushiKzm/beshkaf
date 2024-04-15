part of 'profile_info_bloc.dart';

abstract class ProfileInfoEvent extends Equatable {
  const ProfileInfoEvent();

  @override
  List<Object> get props => [];
}

class ProfileInfoStarted extends ProfileInfoEvent {}

class ProfileInfoUpdated extends ProfileInfoEvent {
  final UserEntity params;

  const ProfileInfoUpdated(this.params);
}
