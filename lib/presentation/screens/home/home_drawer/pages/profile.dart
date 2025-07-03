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
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      ProfileImgAvatar(
                        imageUrl:
                            profile.photo != null && profile.photo!.isNotEmpty
                                ? profile.photo!
                                : 'assets/person.png',
                        size: 120,
                      ),
                      SizedBox(height: 20),
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
          // Always return a widget if none of the above conditions are met
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
