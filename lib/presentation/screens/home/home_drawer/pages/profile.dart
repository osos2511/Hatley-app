import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/core/colors_manager.dart';
import 'package:hatley/core/routes_manager.dart';
import 'package:hatley/injection_container.dart';
import 'package:hatley/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:hatley/presentation/cubit/profile_cubit/profile_state.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_button.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/profile_img_avatar.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/edit_profile_dialog.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..getProfileInfo(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          // عرض سبينر لو جاري تحميل بيانات البروفايل
          if (state.isLoadingProfile) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // عرض رسالة خطأ لو فيه مشكلة
          if (state.errorMessage != null) {
            return Scaffold(
              body: Center(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // عرض محتوى البروفايل لو البيانات متاحة
          if (state.profile != null) {
            final profile = state.profile!;
            return Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ProfileImgAvatar(
                            imageUrl:
                                profile.photo?.isNotEmpty == true
                                    ? profile.photo!
                                    : 'assets/person.png',
                            size: 120,
                          ),
                          // ✅ لو بيتم رفع الصورة دلوقتي اعرض سبينر صغير فوق الصورة
                          if (state.isUploadingImage)
                            const Positioned(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ProfileInfoTile(label: 'Username', value: profile.name),
                      ProfileInfoTile(label: 'Email', value: profile.email),
                      ProfileInfoTile(label: 'Phone', value: profile.phone),
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditProfileDialog(),
                          );
                        },
                        text: 'Update Profile',
                        bgColor: ColorsManager.blue,
                        foColor: ColorsManager.white,
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(RoutesManager.changePasswordRoute);
                        },
                        text: 'Change Password',
                        bgColor: ColorsManager.blue,
                        foColor: ColorsManager.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // لو مفيش بيانات ولا حالة تحميل ولا خطأ
          return const Scaffold(
            body: Center(child: Text("No profile data available")),
          );
        },
      ),
    );
  }
}
