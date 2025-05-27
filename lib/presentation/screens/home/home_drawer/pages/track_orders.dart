import 'package:flutter/material.dart';

class TrackOrders extends StatelessWidget {
  const TrackOrders({super.key});

  final int currentStep = 4;

  final List<String> steps = const [
    'Order Processed',
    'Order Completed',
    'Order in Route',
    'Order Arrived',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/follow.png',height: 150,),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('Order ID: 143', style: TextStyle(color: Colors.green[700])),
                  const SizedBox(height: 4),
                  const Text('Date: 7/22/2024, 1:50:00 PM'),
                  const SizedBox(height: 8),
                  const Text(
                    'Assiut City, Almaktabat Street → Assiut City, Almaktabat Street',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Completed',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: List.generate(steps.length, (index) {
                        final isActive = index < currentStep;
                        final isLast = index == steps.length - 1;

                        return Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  if (index != 0)
                                    Expanded(
                                      child: Container(
                                        height: 3,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: isActive ? Colors.blue : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check, size: 18, color: Colors.white),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        height: 3,
                                        color: Colors.blue,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                steps[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.green[900] : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for rating
                      },
                      child: const Text("Rating"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
