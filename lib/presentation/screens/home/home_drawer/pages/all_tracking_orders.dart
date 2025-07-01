import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:hatley/presentation/cubit/tracking_cubit/tracking_state.dart';
import 'package:hatley/data/model/traking_response.dart';
import 'package:hatley/core/local/token_storage.dart';
import 'package:hatley/injection_container.dart';
import '../../../../cubit/tracking_cubit/tracking_cubit.dart';
import '../widgets/track_order_widget.dart';

class AllTrackingOrdersScreen extends StatefulWidget {
  const AllTrackingOrdersScreen({super.key});

  @override
  State<AllTrackingOrdersScreen> createState() => _AllTrackingOrdersScreenState();
}

class _AllTrackingOrdersScreenState extends State<AllTrackingOrdersScreen> {
  HubConnection? hubConnection; // ✅ تعريف HubConnection هنا
  bool _isSignalRInitialized = false; // ✅ تعريف flag

  @override
  void initState() {
    super.initState();
    context.read<TrackingCubit>().getTrackingData();
    _initializeSignalR(); // ✅ استدعاء تهيئة SignalR هنا
  }

  @override
  void dispose() {
    hubConnection?.stop(); // ✅ إيقاف اتصال SignalR عند التخلص من الشاشة
    super.dispose();
  }

  Future<void> _initializeSignalR() async {
    if (_isSignalRInitialized) return;

    final hubUrl = "https://hatley.runasp.net/NotifyChangeStatusForUser";
    final TokenStorage tokenStorage = sl<TokenStorage>();
    final userToken = await tokenStorage.getToken();
    final userEmail = await tokenStorage.getEmail(); // يجب التأكد من وجود userEmail

    if (userToken == null) {
      print("Error: User token is null. Cannot initialize SignalR.");
      return;
    }

    hubConnection = HubConnectionBuilder().withUrl(
      hubUrl,
      options: HttpConnectionOptions(accessTokenFactory: () => Future.value(userToken)),
    ).build();

    hubConnection?.on('NotifyChangeStatusForUser', (arguments) {
      if (arguments != null && arguments.length >= 3) {
        try {
          final int status = arguments[0] as int;
          final int receivedOrderId = arguments[1] as int;
          final Map<String, dynamic> checkData = arguments[2] as Map<String, dynamic>;
          final String receivedUserEmail = checkData['email'] as String;
          final String userType = checkData['type'] as String;

          print('SignalR Update Received (AllOrdersScreen): OrderID=$receivedOrderId, Status=$status, UserType=$userType, Email=$receivedUserEmail');

          // ✅ هنا تحديث الـ Cubit المشترك
          if (userType == "User" && receivedUserEmail == userEmail) {
            context.read<TrackingCubit>().updateOrderStatus(
              orderId: receivedOrderId, newStatus: status, userEmail: receivedUserEmail, userType: userType,
            );
          } else {
            print('SignalR (AllOrdersScreen): Update ignored. UserType/Email mismatch.');
          }
        } catch (e) {
          print("Error parsing SignalR arguments (AllOrdersScreen): $e, arguments: $arguments");
        }
      } else {
        print("SignalR received insufficient arguments (AllOrdersScreen): $arguments");
      }
    });

    try {
      await hubConnection?.start();
      print("SignalR Connected to $hubUrl (from AllOrdersScreen)");
      _isSignalRInitialized = true;
    } catch (e) {
      print("Error connecting to SignalR Hub at $hubUrl (from AllOrdersScreen): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TrackingCubit, TrackingState>(
        listener: (context, state) {
          if (state is TrackingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TrackingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrackingLoaded) {
            if (state.trackingData.isEmpty) {
              return const Center(child: Text("You have no orders to track."));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.trackingData.length,
              itemBuilder: (context, index) {
                final TrakingResponse order = state.trackingData[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TrackOrderWidget(orderId: order.orderId),
                );
              },
            );
          } else if (state is TrackingError) {
            return Center(child: Text("Failed to load orders: ${state.message}. Please try again."));
          }
          return const Center(child: Text("Welcome! Loading your orders..."));
        },
      ),
    );
  }
}