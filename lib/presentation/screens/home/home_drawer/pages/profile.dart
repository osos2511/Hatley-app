import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/core/colors_manager.dart';
import 'package:hatley/core/routes_manager.dart';
import 'package:hatley/injection_container.dart';
import 'package:hatley/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:hatley/presentation/cubit/profile_cubit/profile_state.dart';
import 'package:hatley/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:hatley/presentation/cubit/statistics_cubit/statistics_state.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_button.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/profile_img_avatar.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/edit_profile_dialog.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProfileCubit>()..getProfileInfo()),
        BlocProvider(create: (_) => sl<StatisticsCubit>()..getAllStatistics()),
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          if (profileState.isLoadingProfile) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (profileState.errorMessage != null) {
            return Scaffold(
              body: Center(
                child: Text(
                  profileState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (profileState.profile == null) {
            return const Scaffold(
              body: Center(child: Text("No profile data available")),
            );
          }

          final profile = profileState.profile!;

          return BlocBuilder<StatisticsCubit, StatisticsState>(
            builder: (context, statsState) {
              Widget statsWidget;
              double rating = 0.0;

              if (statsState is StatisticsLoading) {
                statsWidget = const Center(child: CircularProgressIndicator());
              } else if (statsState is StatisticsLoaded) {
                final stats = statsState.statistics;
                rating = stats.rate;

                statsWidget = Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildStatItem(
                      'Total Orders',
                      stats.totalOrders.toString(),
                    ),
                    _buildStatItem(
                      'Complete Orders',
                      stats.completeOrders.toString(),
                    ),
                    _buildStatItem(
                      'Incomplete Orders',
                      stats.incompleteOrders.toString(),
                    ),
                    _buildStatItem('Pending', stats.pending.toString()),
                    _buildStatItem(
                      'Orders Last 30 Days',
                      stats.ordersLast30Days.toString(),
                    ),
                  ],
                );
              } else if (statsState is StatisticsError) {
                statsWidget = Center(
                  child: Text(
                    statsState.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                statsWidget = const SizedBox.shrink();
              }

              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
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
                              if (profileState.isUploadingImage)
                                const Positioned(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 35,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                rating.toStringAsFixed(2),
                                style: TextStyle(
                                  color: ColorsManager.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ProfileInfoTile(
                            label: 'Username',
                            value: profile.name,
                          ),
                          ProfileInfoTile(label: 'Email', value: profile.email),
                          ProfileInfoTile(label: 'Phone', value: profile.phone),
                          const SizedBox(height: 20),

                          statsWidget, // عرض الإحصائيات هنا

                          const SizedBox(height: 40),
                          CustomButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (dialogContext) => EditProfileDialog(
                                      currentName: profile.name,
                                      currentEmail: profile.email,
                                      currentPhone: profile.phone,
                                      onSave: (name, email, phone) {
                                        context
                                            .read<ProfileCubit>()
                                            .updateProfile(name, email, phone);
                                      },
                                    ),
                              );
                            },
                            text: 'Update Profile',

                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(RoutesManager.changePasswordRoute);
                            },
                            text: 'Change Password',

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: ColorsManager.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorsManager.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
