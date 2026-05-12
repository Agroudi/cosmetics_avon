import 'package:cosmetics_avon/features/auth/widgets/dialog.dart';
import 'package:cosmetics_avon/features/profile/data/models/user_profile_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../../auth/widgets/app_form_field.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../data/repo/profile_repo_impl.dart';
import '../data/services/profile_api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoadingShowing = false;

  void _safeShowLoading(BuildContext context) {
    if (!_isLoadingShowing) {
      _isLoadingShowing = true;
      AppLoading.show(context);
    }
  }

  void _safeHideLoading(BuildContext context) {
    if (_isLoadingShowing) {
      _isLoadingShowing = false;
      // Use small delay to ensure Ticker is safe to dispose
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        if (context.mounted) {
          AppLoading.hide(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileCubit(ProfileRepoImpl(ProfileApiService()))..getProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          final cubit = context.read<ProfileCubit>();
          if (state is LogoutLoading) {
            _safeShowLoading(context);
          } else {
            if (state is LogoutSuccess || state is LogoutError) {
              _safeHideLoading(context);
            }
          }

          if (state is ProfileLoading && cubit.currentUser != null) {
            _safeShowLoading(context);
          } else if (state is ProfileSuccess ||
              state is ProfileUpdateSuccess ||
              state is ProfileError ||
              state is LogoutSuccess ||
              state is LogoutError) {
            // Hide for ANY final state to prevent endless loading
            _safeHideLoading(context);
          }

          if (state is LogoutSuccess) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: Text(LocaleKeys.logout_success.tr()),
              autoCloseDuration: const Duration(seconds: 3),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          } else if (state is LogoutError || state is ProfileError) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              title: Text(
                state is ProfileError
                    ? state.message
                    : (state as LogoutError).message,
              ),
              autoCloseDuration: const Duration(seconds: 3),
            );
          } else if (state is ProfileUpdateSuccess) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: Text(LocaleKeys.profile_updated.tr()),
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          if (state is ProfileLoading && cubit.currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, state),
                  SizedBox(height: 16.h),
                  _buildProfileInfo(context, state),
                  _buildMenuItems(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileState state) {
    final cubit = context.read<ProfileCubit>();
    String photoUrl = cubit.currentUser?.profilePhotoUrl ?? "";

    if (state is ProfileSuccess) {
      photoUrl = state.user.profilePhotoUrl;
    } else if (state is ProfileUpdateSuccess) {
      photoUrl = state.user.profilePhotoUrl;
    }

    return SizedBox(
      height: 160.h + 56.r,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 160.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.Secondary.withValues(alpha: 0.03),
                  AppColors.ProfileBackground,
                ],
              ),
            ),
          ),
          Positioned(
            top: 160.h - 56.r,
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 56.r,
                    backgroundImage: photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : null,
                    backgroundColor: Colors.white,
                    child: photoUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 60.r,
                            color: AppColors.Secondary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4.r,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showPhotoPicker(context),
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: AppColors.Primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: SvgPicture.asset(
                            Assets.icons.editInfo,
                            width: 16.w,
                            height: 16.h,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, ProfileState state) {
    final cubit = context.read<ProfileCubit>();
    final user = cubit.currentUser;
    String name = "...";

    if (user != null) {
      name = user.username;
    } else if (state is ProfileSuccess) {
      name = state.user.username;
    } else if (state is ProfileUpdateSuccess) {
      name = state.user.username;
    }

    return Column(
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: AppTextStyle.txtStyle.copyWith(
            color: AppColors.Secondary,
            fontWeight: FontWeight.w700,
            fontSize: 22.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context, ProfileState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 30.h),
          _buildItem(
            icon: Assets.icons.editInfo,
            title: LocaleKeys.edit_info.tr(),
            onTap: () {
              final user = context.read<ProfileCubit>().currentUser;
              if (user != null) {
                _showEditInfoBottomSheet(context, user);
              }
            },
          ),
          SizedBox(height: 10.h),
          _buildItem(
            icon: Assets.icons.orderHistory,
            title: LocaleKeys.order_history.tr(),
            onTap: () {},
          ),
          SizedBox(height: 10.h),
          _buildItem(
            icon: Assets.icons.wallet,
            title: LocaleKeys.wallet.tr(),
            onTap: () {},
          ),
          SizedBox(height: 10.h),
          _buildItem(
            icon: Assets.icons.settings,
            title: LocaleKeys.settings.tr(),
            onTap: () {},
          ),
          SizedBox(height: 10.h),
          _buildItem(
            icon: Assets.icons.voucher,
            title: LocaleKeys.voucher.tr(),
            onTap: () {},
          ),
          SizedBox(height: 10.h),
          _buildItem(
            icon: Assets.icons.logout,
            title: LocaleKeys.logout_menu.tr(),
            color: AppColors.Error,
            showChevron: false,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<ProfileCubit>(),
                  child: SharedDialog(
                    title: LocaleKeys.logout_title.tr(),
                    description: LocaleKeys.logout_desc.tr(),
                    buttonText: LocaleKeys.logout_menu.tr(),
                    onPressed: () {
                      context.read<ProfileCubit>().logout();
                    },
                    secondButtonText: LocaleKeys.cancel.tr(),
                    onSecondPressed: () => Navigator.pop(context),
                    secondButtonColor: AppColors.Txt,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 17.h),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                color ?? AppColors.Secondary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: AppTextStyle.txtStyle.copyWith(
                color: color ?? AppColors.Secondary,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
            const Spacer(),
            if (showChevron)
              SvgPicture.asset(
                Assets.icons.goto,
                width: 12.w,
                height: 12.h,
                colorFilter: ColorFilter.mode(
                  AppColors.Secondary,
                  BlendMode.srcIn,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditInfoBottomSheet(BuildContext context, UserProfileModel user) {
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    final formKey = GlobalKey<FormState>();
    final profileCubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (context, setBottomSheetState) {
          bool isValid() {
            final username = usernameController.text.trim();
            final email = emailController.text.trim();

            final isUsernameValid =
                username.isNotEmpty &&
                username.length >= 3 &&
                username.length <= 20 &&
                RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username) &&
                !username.startsWith('_') &&
                !username.endsWith('_');

            final isEmailValid = RegExp(
              r'^[\w\.-]+@[\w\.-]+\.com$',
            ).hasMatch(email);

            return isUsernameValid && isEmailValid;
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
              left: 20.w,
              right: 20.w,
              top: 20.h,
            ),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.edit_profile.tr(),
                    style: AppTextStyle.txtStyle.copyWith(
                      color: AppColors.Secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  AppFormField(
                    controller: usernameController,
                    label: LocaleKeys.name_label.tr(),
                    onChanged: (_) => setBottomSheetState(() {}),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.user_required.tr();
                      }
                      if (value.length < 3) {
                        return LocaleKeys.user_min_characters.tr();
                      }
                      if (value.length > 20) {
                        return LocaleKeys.user_max_characters.tr();
                      }
                      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                        return LocaleKeys.allowed_char_user.tr();
                      }
                      if (value.startsWith('_') || value.endsWith('_')) {
                        return LocaleKeys.user_cant_start.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  AppFormField(
                    controller: emailController,
                    label: LocaleKeys.email_label.tr(),
                    onChanged: (_) => setBottomSheetState(() {}),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.email_required.tr();
                      }
                      if (!RegExp(
                        r'^[\w\.-]+@[\w\.-]+\.com$',
                      ).hasMatch(value)) {
                        return LocaleKeys.email_must_be.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.h),
                  AppButton(
                    txt: LocaleKeys.update_button.tr(),
                    onPressed: isValid()
                        ? () async {
                            if (formKey.currentState!.validate()) {
                              await profileCubit.updateProfile(
                                username: usernameController.text.trim(),
                                email: emailController.text.trim(),
                              );
                              if (bottomSheetContext.mounted) {
                                Navigator.pop(bottomSheetContext);
                              }
                            }
                          }
                        : null,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPhotoPicker(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    final profileCubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.pick_photo.tr(),
              style: AppTextStyle.txtStyle.copyWith(
                color: AppColors.Secondary,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 32.h),
            AppButton(
              txt: LocaleKeys.camera.tr(),
              onPressed: () async {
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  profileCubit.updatePhoto(image.path);
                }
                Navigator.pop(bottomSheetContext);
              },
            ),
            SizedBox(height: 16.h),
            AppButton(
              txt: LocaleKeys.gallery.tr(),
              color: AppColors.Txt, // Grey color for secondary action
              onPressed: () async {
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  profileCubit.updatePhoto(image.path);
                }
                Navigator.pop(bottomSheetContext);
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
