import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/core/reusable_order_form.dart';
import 'package:hatley/domain/entities/order_entity.dart';
import 'package:hatley/injection_container.dart';
import 'package:hatley/presentation/cubit/edit_order_cubit/edit_order_cubit.dart';
import 'package:hatley/presentation/cubit/governorate_cubit/governorate_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';
import 'package:hatley/presentation/cubit/zone_cubit/zone_cubit.dart';
import '../../../../cubit/make_orders_cubit/make_orders_cubit.dart';

void showEditOrderDialog(
  BuildContext context,
  MakeOrderCubit makeOrderCubit,
  OrderEntity order,
) {
  makeOrderCubit.loadOrderForEdit(order);

  showDialog(
    context: context,
    builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: makeOrderCubit),
          BlocProvider(create: (_) => sl<EditOrderCubit>()),
          BlocProvider(
            create: (_) => sl<GovernorateCubit>()..fetchGovernorates(),
          ),
          BlocProvider(create: (_) => sl<ZoneCubit>()),
        ],
        child: BlocConsumer<EditOrderCubit, OrderState>(
          listener: (context, state) {
            if (state is OrderSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تعديل الطلب بنجاح')),
              );
            } else if (state is OrderFailure) {
              print("خطأ أثناء التعديل: ${state.error}");
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: SingleChildScrollView(
                child: ReusableOrderForm(
                  isEdit: true,
                  orderId: order.orderId,
                  submitButtonText: 'Save Changes',
                  onSubmit: () {},
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
