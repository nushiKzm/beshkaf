part of 'profile_info_bloc.dart';

abstract class ProfileInfoState extends Equatable {
  const ProfileInfoState();

  @override
  List<Object> get props => [];
}

class ProfileInfoLoading extends ProfileInfoState {}

class ProfileInfoError extends ProfileInfoState {
  final AppException appException;
  const ProfileInfoError(this.appException);
  @override
  List<Object> get props => [appException];
}

class ProfileInfoSuccess extends ProfileInfoState {
  final UserEntity info;
  const ProfileInfoSuccess(this.info);
  @override
  List<Object> get props => [info];
}

// class ProfileInfoUpdateSuccess extends ProfileInfoState {
//   final UserEntity info;
//   const ProfileInfoUpdateSuccess(this.info);
//   @override
//   List<Object> get props => [info];
// }
