import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_project/common/exceptions.dart';
import 'package:shop_project/data/repo/profile_info_repository.dart';
import 'package:shop_project/data/user.dart';

part 'profile_info_event.dart';
part 'profile_info_state.dart';

class ProfileInfoBloc extends Bloc<ProfileInfoEvent, ProfileInfoState> {
  final IProfileRepository repository;
  ProfileInfoBloc(this.repository) : super(ProfileInfoLoading()) {
    on<ProfileInfoEvent>((event, emit) async {
      if (event is ProfileInfoUpdated) {
        try {
          emit(ProfileInfoLoading());
          final info = await repository.updateInfo(event.params);
          emit(ProfileInfoSuccess(info));
        } catch (e) {
          emit(ProfileInfoError(AppException()));
        }
      } else if (event is ProfileInfoStarted) {
        try {
          emit(ProfileInfoLoading());
          final info = await repository.getInfo();
          emit(ProfileInfoSuccess(info));
        } catch (e) {
          emit(ProfileInfoError(AppException()));
        }
      }
    });
  }
}
