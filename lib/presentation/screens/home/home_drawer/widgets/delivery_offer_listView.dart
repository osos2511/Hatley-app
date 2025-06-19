import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hatley/core/local/token_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'custom_order_button.dart';

class DeliveryOffersWidget extends StatefulWidget {
  final int? orderId; // Optional order ID
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

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize Hive if not already open
    if (!Hive.isBoxOpen('delivery_offers')) {
      await Hive.initFlutter();
    }
    final prefs = await SharedPreferences.getInstance();
    _tokenStorage = TokenStorageImpl(prefs);
    _userEmail = await _tokenStorage.getEmail();

    // Open Hive box for offers
    _offersBox = await Hive.openBox('delivery_offers');

    // Retrieve saved offers and filter by orderId if provided
    final List<Map<String, dynamic>> savedOffers = _offersBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .where((offer) => widget.orderId == null || offer["order_id"] == widget.orderId)
        .toList();

    setState(() {
      _offers.addAll(savedOffers);
    });

    await _startSignalRConnection();
  }

  Future<void> _startSignalRConnection() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
      _serverUrl,
      options: HttpConnectionOptions(transport: HttpTransportType.WebSockets),
    )
        .withAutomaticReconnect()
        .build();

    _hubConnection.onclose(({Exception? error}) {
      // Print statements removed
    });

    _hubConnection.onreconnecting(({Exception? error}) {
      // Print statements removed
    });

    try {
      await _hubConnection.start();
      // Print statements removed
      _registerSignalRListeners();
    } catch (e) {
      // Print statements removed
    }
  }

  void _registerSignalRListeners() {
    _hubConnection.on("NotifyNewOfferForUser", (arguments) {
      // Print statements removed
      if (arguments != null && arguments.length == 2) {
        final offerData = arguments[0] as Map<dynamic, dynamic>;
        final checkData = arguments[1] as Map<dynamic, dynamic>;

        final String? checkEmail = checkData["email"];
        final String? checkType = checkData["type"];

        if (checkEmail == _userEmail && checkType == "User") {
          final int? orderId = offerData["order_id"] is int
              ? offerData["order_id"]
              : int.tryParse(offerData["order_id"].toString());

          if (orderId == null) {
            // Print statements removed
            return;
          }

          setState(() {
            final newOffer = {
              "order_id": orderId,
              "name": offerData["delivery_name"],
              "price": offerData["offer_value"].toString(),
              "rating": double.tryParse(offerData["delivery_avg_rate"].toString()) ?? 0.0,
              "image": offerData["delivery_photo"] ?? "",
            };

            _offersBox.add(newOffer);

            // Add offer to displayed list only if it matches current orderId
            if (widget.orderId == null || newOffer["order_id"] == widget.orderId) {
              _offers.add(newOffer);
              // Print statements removed
            } else {
              // Print statements removed
            }
          });
        } else {
          // Print statements removed
        }
      } else {
        // Print statements removed
      }
    });
  }

  // Function called when an offer is accepted or declined
  void _handleOfferResponse(int index, bool accepted) {
    final offer = _offers[index];
    if (accepted) {
      // Print statements removed
      // Add backend acceptance logic here
    } else {
      // Print statements removed
      // Add backend decline logic here
    }

    setState(() {
      _offers.removeAt(index); // Remove offer from displayed list
    });
    _removeOfferFromHive(offer); // Remove offer from Hive
  }

  // Function to remove an offer from Hive based on its content
  void _removeOfferFromHive(Map<String, dynamic> offer) {
    final Map<dynamic, dynamic> boxMap = _offersBox.toMap();
    dynamic keyToDelete;
    boxMap.forEach((key, value) {
      if (_mapsEqual(value, offer)) {
        keyToDelete = key;
      }
    });
    if (keyToDelete != null) {
      _offersBox.delete(keyToDelete);
      // Print statements removed
    }
  }

  // Function to compare two maps
  bool _mapsEqual(Map a, Map b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _hubConnection.stop(); // Stop SignalR connection
    _offersBox.close(); // Close Hive box
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Message displayed if no offers
    if (_offers.isEmpty) {
      return const Text("No offers received yet for this order or user.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simplified title
        const Text(
          'Delivery Offers:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190, // Fixed height for horizontal offers list
          child: ListView.separated(
            scrollDirection: Axis.horizontal, // Horizontal scrolling
            itemCount: _offers.length, // Number of offers
            separatorBuilder: (_, __) => const SizedBox(width: 12), // Space between offers
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
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage("assets/images/default_user.png") as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer["name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber[700],
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    offer["rating"].toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Offer Price: ${offer["price"]} EGP",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomOrderButton(
                            onPressed: () {
                              _handleOfferResponse(index, true); // Accept offer
                            },
                            backgroundColor: Colors.blue,
                            text: "Accept",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomOrderButton(
                            onPressed: () {
                              _handleOfferResponse(index, false); // Decline offer
                            },
                            backgroundColor: Colors.red,
                            text: "Decline",
                          ),
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
    );
  }
}