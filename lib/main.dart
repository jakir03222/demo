import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

const String API_KEY = '8da45cdc5a8c1679aeff';
const String API_CLUSTER = 'ap1';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  String? userId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pusher Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pusher Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("userId: ${userId ?? ""}"),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Initialize Pusher
                    await pusher.init(
                      apiKey: API_KEY,
                      cluster: API_CLUSTER,
                      onConnectionStateChange: onConnectionStateChange,
                      onError: onError,
                      onSubscriptionSucceeded: onSubscriptionSucceeded,
                      onEvent: onEvent,
                    );

                    // Subscribe to the desired channel and connect to Pusher
                    await pusher.subscribe(channelName: 'riderbookings');
                    await pusher.connect();
                  } catch (e) {
                    print("ERROR: $e");
                  }
                },
                child: Text('Connect to Pusher'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onEvent(PusherEvent event) {
    print("Received event: $event");

    // Extract relevant data from the event
    var eventData = event.data;
    var notificationText = eventData['notificationText'];
    var message = eventData['message'];

    print("notificationText: $notificationText");
    print("message: $message");

    // Example: Update UI or trigger actions based on the received event
    // For private or presence channels, check if the user_id matches
    if (event.channelName == 'riderbookings' &&
        event.eventName == 'RiderBookingConfirmed') {
      // Update UI or trigger actions based on the event
      setState(() {
        // Update state variables to reflect the received data
        // For example, update a text widget to display the notification text
        // and message from the event
      });
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("onSubscriptionSucceeded: $channelName data: $data");

    // Extract the user ID from the data
    var userId = data['userId'];
    print("User ID: $userId");

    // Save the user ID to the state or perform any other necessary actions
    setState(() {
      this.userId = userId;
    });
  }

  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection: $currentState");
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ChangeNotifierProvider(
//         create: (context) => FoodModel(),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Dropdown Button Example'),
//           ),
//           body: Center(
//             child: Consumer<FoodModel>(
//               builder: (context, foodModel, child) => Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextFormField(
//                     onChanged: (value) {
//                       foodModel.setProductPrice(double.tryParse(value) ?? 0);
//                     },
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'Product Price',
//                     ),
//                   ),
//                   const SizedBox(height: 0),
//                   MyDropDownButton(
//                     hint: foodModel.selectedItem ?? 'Enter a value',
//                     foodPrices: foodModel.foodPrices,
//                     onChanged: (String? selectedValue) {
//                       if (selectedValue != null) {
//                         final double? price =
//                             foodModel.foodPrices[selectedValue];
//                         if (price != null) {
//                           print('Selected item: $selectedValue, Price: $price');
//                         }
//                         foodModel.setSelectedItem(selectedValue);
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 0),
//                   MyDropDownButton(
//                     hint: foodModel.serviceAre ?? 'Select service area',
//                     foodPrices: foodModel.serviceAreList,
//                     onChanged: (String? selectedValue) {
//                       if (selectedValue != null) {
//                         final double? price =
//                             foodModel.serviceAreList[selectedValue];
//                         if (price != null) {
//                           print(
//                               'Selected service area: $selectedValue, Price: $price');
//                         }
//                         foodModel.setserviceAreItem(selectedValue);
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 0),
//                   TextFormField(
//                     onChanged: (value) {
//                       foodModel.setAdvanceTake(double.tryParse(value) ?? 0);
//                     },
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Advance Take',
//                     ),
//                   ),
//                   const SizedBox(height: 0),
//                   Text('Product Price: ${foodModel.productPrice}'),
//                   Text(
//                     'Price: ${foodModel.selectedItem != null ? foodModel.foodPrices[foodModel.selectedItem!] ?? 0 : 0}',
//                   ), // Display the price here

//                   Text('Total Price: ${foodModel.totalValue}'),
//                   Text('Advance Take: ${foodModel.advanceTake}'),
//                   Text('Due: ${foodModel.dueAmount}'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyDropDownButton extends StatelessWidget {
//   final String hint;
//   final Map<String, double> foodPrices;
//   final void Function(String?)? onChanged;

//   const MyDropDownButton({
//     Key? key,
//     required this.hint,
//     required this.foodPrices,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       hint: Text(hint),
//       items: foodPrices.entries.map((MapEntry<String, double> entry) {
//         return DropdownMenuItem<String>(
//           value: entry.key,
//           child: Text(entry.key),
//         );
//       }).toList(),
//       onChanged: onChanged,
//     );
//   }
// }

// class FoodModel extends ChangeNotifier {
//   String? _selectedItem;
//   String? _serviceAre;
//   double _productPrice = 0.0;
//   double _advanceTake = 0.0;

//   String? get selectedItem => _selectedItem;
//   String? get serviceAre => _serviceAre;

//   void setSelectedItem(String item) {
//     _selectedItem = item;
//     notifyListeners();
//   }

//   void setserviceAreItem(String item) {
//     _serviceAre = item;
//     notifyListeners();
//   }

//   void setProductPrice(double price) {
//     _productPrice = price;
//     notifyListeners();
//   }

//   void setAdvanceTake(double amount) {
//     _advanceTake = amount;
//     notifyListeners();
//   }

//   double get totalValue {
//     if (_selectedItem != null && _serviceAre != null) {
//       final double? price = foodPrices[_selectedItem!];
//       final double? serviceCharge = serviceAreList[_serviceAre!];

//       if (price != null && serviceCharge != null) {
//         double total = _productPrice + price;

//         if (_serviceAre == "Outside Town") {
//           total += 10; // Add extra 10 if outside town
//         }

//         return total;
//       }
//     }

//     return _productPrice;
//   }

//   double get advanceTake => _advanceTake;
//   double get productPrice => _productPrice;

//   double get dueAmount => totalValue - _advanceTake;

//   final Map<String, double> serviceAreList = {
//     "Inside Town": 0,
//     "Outside Town": 10,
//   };
//   final Map<String, double> foodPrices = {
//     "Soft Cake 1/2 P": 30,
//     "Soft Cake 1P": 40,
//     "Soft Cake 1.5P": 50,
//     "Soft Cake 2P": 50,
//     "Soft Cake 3P": 60,
//     "Soft Cake 4P": 80,
//     "Soft Cake 5 P": 100,
//     "Soft Cake 1/2 P + Food": 40,
//     "Soft Cake 1P + Food": 50,
//     "Soft Cake 2P + Food": 60,
//     "Soft Cake 3P + Food": 70,
//     "Soft Cake 4P + Food": 100,
//     "Soft Cake 5P + Food": 120,
//     "Food (1-10)Box": 30,
//     "Food (11-20)Box": 40,
//     "Food (21-30)Box": 60,
//     "Food (31-40)Box": 80,
//     "Food (41-50)Box": 100,
//     "Food (51-60)Box": 120,
//     "Food (61-70)Box": 140,
//     "Food (71-80)Box": 160,
//     "Food (81-90)Box": 180,
//     "Food (91-100)Box": 200,
//     "Frozen Item (1-5) KG": 30,
//     "Frozen Item (6-10)KG5": 50,
//     "Parcel (1KG/Packet)": 30,
//     "Parcel (2-5 KG/Packet)": 50,
//     "Parcel (6-10KG/Packet)": 70,
//     "Jar cake(1-4) PS": 30,
//     "Jar cake(5-10) PS": 40,
//     "Cup cake (4/6) PS": 30,
//     "Cup Cake ( 8/12) PS": 40,
//     "Milk (1-5) KG": 30,
//     "Milk (6-10)KG": 50,
//     "Pizza (6/8/10/12) Inch": 30,
//   };
// }
