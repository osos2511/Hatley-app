import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatley/core/colors_manager.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/custom_order_button.dart';
import '../../../../../core/routes_manager.dart';
import '../../../../../core/success_dialog.dart';
import '../../../../cubit/make_orders_cubit/make_order_state.dart';
import '../../../../cubit/make_orders_cubit/make_orders_cubit.dart';

void showConfirmOrderDialog(BuildContext context, MakeOrderState state) {
  final cubit = context.read<MakeOrderCubit>();
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColorApp
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Details:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                         SizedBox(height: 4.h),
                        Container(
                          padding:  REdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(state.details),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                       SizedBox(height: 4.h),
                      Text(
                        '${state.price} EGP',
                        style:  TextStyle(
                          fontSize: 18.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
               SizedBox(height: 12.h),
              Row(
                children: [
                  const Text(
                    'Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                   SizedBox(width: 8.w),
                  Text(state.selectedDate?.toString().split(' ').first ?? ''),
                ],
              ),
               SizedBox(height: 6.h),
              Row(
                children: [
                  const Text(
                    'Time:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                   SizedBox(width: 8.w),
                  Text(state.selectedTime?.format(context) ?? ''),
                ],
              ),
               SizedBox(height: 16.h),
              const Divider(),
               SizedBox(height: 8.h),
              const Text(
                'From:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${state.selectedGovernorateFrom ?? ''}, ${state.selectedCityFrom ?? ''}, ${state.selectedStateFrom ?? ''}',
              ),
               SizedBox(height: 8.h),
              const Text('To:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${state.selectedGovernorateTo ?? ''}, ${state.selectedCityTo ?? ''}, ${state.selectedStateTo ?? ''}',
              ),
               SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomOrderButton(
                    backgroundColor: ColorsManager.buttonColorApp,
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                  CustomOrderButton(
                    backgroundColor: ColorsManager.primaryColorApp,
                    text: 'Confirm',
                    onPressed: () {
                      Navigator.pop(context);

                      Future.delayed(const Duration(milliseconds: 300), () {
                        cubit.resetOrder();
                      });

                      showSuccessDialog(
                        context,
                        'thank you! send order has been successfully!',

                        nextRoute: RoutesManager.homeRoute,
                        arguments: 5,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
