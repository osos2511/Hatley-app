import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hatley/core/local/token_storage.dart';
import 'package:hive/hive.dart';
import 'custom_order_button.dart';

class DeliveryOffersWidget extends StatefulWidget {
  const DeliveryOffersWidget({super.key});

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
    final prefs = await SharedPreferences.getInstance();
    _tokenStorage = TokenStorageImpl(prefs);
    _userEmail = await _tokenStorage.getEmail();

    // فتح صندوق Hive للعروض
    _offersBox = await Hive.openBox('delivery_offers');

    // استرجاع العروض المخزنة مسبقاً
    final savedOffers = _offersBox.values
        .map((e) => Map<String, dynamic>.from(e))
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
      options: HttpConnectionOptions(
        transport: HttpTransportType.WebSockets,
      ),
    )
        .withAutomaticReconnect()
        .build();

    _hubConnection.onclose(({Exception? error}) {
      print("❗ SignalR connection closed: $error");
    });

    _hubConnection.onreconnecting(({Exception? error}) {
      print("♻️ SignalR reconnecting: $error");
    });

    await _hubConnection.start();
    print("✅ SignalR connection started");
    _registerSignalRListeners();
  }

  void _registerSignalRListeners() {
    _hubConnection.on("NotifyNewOfferForUser", (arguments) {
      print("📩 Received SignalR event: NotifyNewOfferForUser");
      if (arguments != null && arguments.length == 2) {
        final offerData = arguments[0] as Map<dynamic, dynamic>;
        final checkData = arguments[1] as Map<dynamic, dynamic>;

        final String? checkEmail = checkData["email"];
        final String? checkType = checkData["type"];

        if (checkEmail == _userEmail && checkType == "User") {
          setState(() {
            final newOffer = {
              "name": offerData["delivery_name"],
              "price": offerData["offer_value"].toString(),
              "rating": double.tryParse(offerData["delivery_avg_rate"].toString()) ?? 0.0,
              "image": offerData["delivery_photo"] ?? "",
            };

            _offers.add(newOffer);

            // حفظ العرض في Hive
            _offersBox.add(newOffer);

            print("✅ Offer added and saved locally.");
          });
        } else {
          print("❌ Offer rejected: email/type mismatch");
        }
      } else {
        print("⚠️ Invalid arguments received from SignalR");
      }
    });
  }

  // دالة لمسح كل العروض محلياً وعرضياً
  Future<void> _clearOffers() async {
    await _offersBox.clear();
    setState(() {
      _offers.clear();
    });
    print("🧹 All offers cleared locally.");
  }

  // دالة تناديها عند قبول أو رفض العرض
  void _handleOfferResponse(int index, bool accepted) {
    final offer = _offers[index];
    if (accepted) {
      print("✅ Accepted offer from ${offer["name"]}");
      // هنا ممكن تضيف كود إضافي مثلا إرسال قبول للـ backend
    } else {
      print("❌ Declined offer from ${offer["name"]}");
      // كود رفض العرض إذا تريد
    }

    // بعد الرد على العرض، نحذف العرض من القائمة والصندوق المحلي
    setState(() {
      _offers.removeAt(index);
    });

    // لازم نمسح العرض من Hive أيضًا
    // لان Hive تدعم حذف عنصر حسب المفتاح (key)
    // الصندوق يخزن القيم بدون مفتاح واضح، لذلك لازم نبحث المفتاح و نمسحه
    _removeOfferFromHive(offer);
  }

  // دالة لإزالة العرض من Hive حسب المحتوى
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
      print("🗑️ Offer removed from Hive.");
    }
  }

  // دالة للمقارنة بين خريطتين (Maps)
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
      return const Text("No offers received yet.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Offers:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
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
                              _handleOfferResponse(index, true); // قبول العرض
                            },
                            backgroundColor: Colors.blue,
                            text: "Accept",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomOrderButton(
                            onPressed: () {
                              _handleOfferResponse(index, false); // رفض العرض
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
