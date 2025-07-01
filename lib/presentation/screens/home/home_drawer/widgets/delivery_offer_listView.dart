import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/presentation/cubit/offer_cubit/offer_cubit.dart';
import 'package:hatley/presentation/cubit/offer_cubit/offer_state.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hatley/core/local/token_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../core/routes_manager.dart';
import 'custom_order_button.dart';

class DeliveryOffersWidget extends StatefulWidget {
  final int? orderId;
  const DeliveryOffersWidget({super.key, this.orderId});

  @override
  State<DeliveryOffersWidget> createState() => _DeliveryOffersWidgetState();
}

class _DeliveryOffersWidgetState extends State<DeliveryOffersWidget> {
  final List<Map<String, dynamic>> _offers = [];
  late final HubConnection _hubConnection;
  final String _serverUrl = "https://hatley.runasp.net/NotifyNewOfferForUser";
  String? _userEmail;
  late final TokenStorage _tokenStorage;
  late Box _offersBox;

  Map<String, dynamic>? _pendingOfferToDelete;
  int? _pendingOfferIndexToDelete;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!Hive.isBoxOpen('delivery_offers')) {
      await Hive.initFlutter();
    }
    final prefs = await SharedPreferences.getInstance();
    _tokenStorage = TokenStorageImpl(prefs);
    _userEmail = await _tokenStorage.getEmail();
    _offersBox = await Hive.openBox('delivery_offers');

    final savedOffers = _offersBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .where(
          (offer) => widget.orderId == null || offer["order_id"] == widget.orderId,
    )
        .toList();

    setState(() {
      _offers.addAll(savedOffers);
    });

    await _startSignalRConnection();
  }

  Future<void> _startSignalRConnection() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl, options: HttpConnectionOptions(transport: HttpTransportType.WebSockets))
        .withAutomaticReconnect()
        .build();

    _hubConnection.onclose(({Exception? error}) {});
    _hubConnection.onreconnecting(({Exception? error}) {});

    try {
      await _hubConnection.start();
      _registerSignalRListeners();
    } catch (_) {
      print("Error connecting to SignalR for offers: ");
    }
  }

  void _registerSignalRListeners() {
    _hubConnection.on("NotifyNewOfferForUser", (arguments) {
      if (arguments != null && arguments.length == 2) {
        final offerData = arguments[0] as Map<dynamic, dynamic>;
        final checkData = arguments[1] as Map<dynamic, dynamic>;

        final checkEmail = checkData["email"];
        final checkType = checkData["type"];

        if (checkEmail == _userEmail && checkType == "User") {
          final orderId = offerData["order_id"] is int ? offerData["order_id"] : int.tryParse(offerData["order_id"].toString());
          if (orderId == null) return;

          final newOffer = {
            "order_id": orderId,
            "name": offerData["delivery_name"],
            "price": offerData["offer_value"].toString(),
            "rating": double.tryParse(offerData["delivery_avg_rate"].toString()) ?? 0.0,
            "image": offerData["delivery_photo"] ?? "",
            "delivery_email": offerData["delivery_email"],
            "offer_value": offerData["offer_value"],
          };
          _offersBox.add(newOffer);
          if (widget.orderId == null || newOffer["order_id"] == widget.orderId) {
            setState(() {
              _offers.add(newOffer);
            });
          }
        }
      }
    });
  }

  void _handleOfferResponse(int index, bool accepted) {
    final offer = _offers[index];
    final orderId = offer["order_id"] as int?;
    final deliveryEmail = offer["delivery_email"] as String?;
    final priceOfOffer = int.tryParse(offer["offer_value"].toString());

    _pendingOfferToDelete = offer;
    _pendingOfferIndexToDelete = index;

    if (accepted) {
      if (orderId != null && deliveryEmail != null && priceOfOffer != null) {
        context.read<OfferCubit>().acceptOffer(
          orderId,
          priceOfOffer,
          deliveryEmail,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing offer details to accept.'), backgroundColor: Colors.orange),
        );
        _pendingOfferToDelete = null;
        _pendingOfferIndexToDelete = null;
      }
    } else {
      if (orderId != null && deliveryEmail != null) {
        context.read<OfferCubit>().declineOffer(orderId, priceOfOffer ?? 0, deliveryEmail);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing offer details to decline.'), backgroundColor: Colors.orange),
        );
        _pendingOfferToDelete = null;
        _pendingOfferIndexToDelete = null;
      }
    }
  }

  void _removeOfferFromHive(Map<String, dynamic> offer) {
    final boxMap = _offersBox.toMap();
    dynamic keyToDelete;
    boxMap.forEach((key, value) {
      if (value is Map && value["order_id"] == offer["order_id"] && _mapsEqual(value, offer)) {
        keyToDelete = key;
      }
    });
    if (keyToDelete != null) {
      _offersBox.delete(keyToDelete);
    }
  }

  bool _mapsEqual(Map a, Map b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _hubConnection.stop();
    _offersBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_offers.isEmpty) {
      return const Center(child: Text("No offers received yet for this order."));
    }

    return BlocListener<OfferCubit, OfferState>(
      listener: (context, state) async {
        if (state is OfferAcceptedSuccess) {
          final int acceptedOrderId = state.orderId;
          _offers.removeWhere((offer) => offer["order_id"] == acceptedOrderId);
          final List<dynamic> keysToDelete = [];
          _offersBox.toMap().forEach((key, value) {
            if (value is Map && value["order_id"] == acceptedOrderId) {
              keysToDelete.add(key);
            }
          });
          for (final key in keysToDelete) {
            _offersBox.delete(key);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Offer accepted successfully! Redirecting to tracking...'), backgroundColor: Colors.green),
          );
          Navigator.of(context).pushReplacementNamed(
            RoutesManager.trakingRoute,
            arguments: acceptedOrderId,
          );
          _pendingOfferToDelete = null;
          _pendingOfferIndexToDelete = null;
        } else if (state is OfferDeclinedSuccess) {
          if (_pendingOfferToDelete != null && _pendingOfferIndexToDelete != null) {
            setState(() {
              _offers.removeAt(_pendingOfferIndexToDelete!);
            });
            _removeOfferFromHive(_pendingOfferToDelete!);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
          _pendingOfferToDelete = null;
          _pendingOfferIndexToDelete = null;
        } else if (state is OfferFailure) {
          _pendingOfferToDelete = null;
          _pendingOfferIndexToDelete = null;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to process offer: ${state.errorMessage}'), backgroundColor: Colors.red),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delivery Offers:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _offers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final offer = _offers[index];
                final imageUrl = offer["image"] as String;
                return Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.25), blurRadius: 5, spreadRadius: 2, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : const AssetImage("assets/images/default_user.png") as ImageProvider,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(offer["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber[700], size: 18),
                                    const SizedBox(width: 4),
                                    Text(offer["rating"].toString(), style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text("Offer Price: ${offer["price"]} EGP", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.green)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomOrderButton(onPressed: () => _handleOfferResponse(index, true), backgroundColor: Colors.blue, text: "Accept"),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomOrderButton(onPressed: () => _handleOfferResponse(index, false), backgroundColor: Colors.red, text: "Decline"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}