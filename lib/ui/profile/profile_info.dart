import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/data/repo/profile_info_repository.dart';
import 'package:shop_project/data/user.dart';
import 'package:shop_project/ui/profile/bloc/profile_info_bloc.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({Key? key}) : super(key: key);

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  bool isComplete = false;
  StreamSubscription? subscription;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController overallHeightController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اطلاعات پروفایل'),
        centerTitle: false,
      ),
      body: BlocProvider<ProfileInfoBloc>(
        create: (context) {
          final bloc = ProfileInfoBloc(profileRepository);
          bloc.add(ProfileInfoStarted());
          subscription = bloc.stream.listen((event) {
            if (event is ProfileInfoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(event.appException.message)));
            } else if (event is ProfileInfoSuccess) {
              event.info.firstName != ''
                  ? isComplete = true
                  : isComplete = false;
              firstNameController.text = event.info.firstName;
              lastNameController.text = event.info.lastName;
              mobileController.text = event.info.mobile;
              addressController.text = event.info.address;
              postalCodeController.text = event.info.postalCode;
              overallHeightController.text = event.info.overallHeight == 0
                  ? ''
                  : '${event.info.overallHeight}';
              sizeController.text =
                  event.info.size == 0 ? '' : '${event.info.size}';
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // if (!isComplete)
              //   Text('برای تکمیل پروفایل تمامی اطلاعات را پر کنید'),
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(label: Text('نام')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(label: Text('نام خانوادگی')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(label: Text('شماره تماس')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(label: Text('کد پستی')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(label: Text('آدرس')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: sizeController,
                decoration: const InputDecoration(label: Text('سایز')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: overallHeightController,
                decoration: const InputDecoration(label: Text('قد کل')),
              ),
              const SizedBox(
                height: 12,
              ),
              BlocBuilder<ProfileInfoBloc, ProfileInfoState>(
                builder: (context, state) {
                  return state is ProfileInfoLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : SizedBox(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.secondary),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            onPressed: () {
                              BlocProvider.of<ProfileInfoBloc>(context).add(
                                ProfileInfoUpdated(
                                  UserEntity(
                                    "id",
                                    firstNameController.text,
                                    lastNameController.text,
                                    mobileController.text,
                                    addressController.text,
                                    postalCodeController.text,
                                    int.parse(overallHeightController.text),
                                    int.parse(sizeController.text),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                                isComplete ? 'بروزرسانی' : 'تکمیل پروفایل'),
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
