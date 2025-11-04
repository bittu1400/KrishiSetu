// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'chat.dart';
// import 'tools.dart';
// import 'detector.dart';
// import 'experts.dart';
// import 'profile.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Crop Management',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         fontFamily: 'Roboto',
//       ),
//       home: const CropDashboard(),
//     );
//   }
// }

// class CropDashboard extends StatefulWidget {
//   final Map<String, dynamic>? userData;

//   const CropDashboard({
//     Key? key,
//     this.userData,
//   }) : super(key: key);

//   @override
//   State<CropDashboard> createState() => _CropDashboardState();
// }

// class _CropDashboardState extends State<CropDashboard> {
//   int _currentIndex = 0;

//   // Real-time backend data
//   String greeting = '';
//   String userName = '';
//   String userEmail = '';
//   String userPhone = '';
//   String city = '';
//   String date = '';
//   String temperature = '';
//   String humidity = '';
//   String wind = '';
//   String precipitation = '';
//   String weather = '';

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
    
//     // Store user info from userData
//     userName = widget.userData?['name'] ?? '';
//     userEmail = widget.userData?['email'] ?? '';
//     userPhone = widget.userData?['phone'] ?? '';
//     city = widget.userData?['city'] ?? 'Kathmandu';
    
//     // Fetch dashboard data using email
//     if (userEmail.isNotEmpty) {
//       fetchDashboardData(userEmail);
//     } else {
//       // If no email, set defaults
//       setState(() {
//         greeting = 'Hello';
//         userName = 'Farmer';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> fetchDashboardData(String email) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://127.0.0.1:8000/dashboard'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           greeting = data['greeting'] ?? 'Hello';
//           userName = data['name'] ?? userName;
//           city = data['city'] ?? city;
//           date = data['date'] ?? '';
//           temperature = data['temperature'] ?? '--°C';
//           humidity = data['humidity'] ?? '--%';
//           wind = data['wind'] ?? '-- m/s';
//           precipitation = data['precipitation'] ?? '-- mm';
//           weather = data['weather'] ?? '';
//           userEmail = data['email'] ?? userEmail;
//           userPhone = data['phone'] ?? userPhone;
//           isLoading = false;
//         });
//         print('✅ Dashboard data loaded successfully');
//       } else {
//         throw Exception('Failed to fetch data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Error fetching dashboard data: $e');
//       // Set default values on error
//       setState(() {
//         greeting = 'Hello';
//         if (userName.isEmpty) userName = 'Farmer';
//         if (city.isEmpty) city = 'Unknown';
//         isLoading = false;
//       });
//     }
//   }

//   void _onNavBarTap(int index) {
//     if (index == _currentIndex) return;
//     setState(() => _currentIndex = index);

//     switch (index) {
//       case 1:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ChatPage(),
//           ),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ExpertsPage(),
//           ),
//         );
//         break;
//       case 3:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ToolsPage(),
//           ),
//         );
//         break;
//       case 4:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ProfilePage(
//               userData: {
//                 'name': userName,
//                 'email': userEmail,
//                 'phone': userPhone,
//                 'city': city,
//               },
//             ),
//           ),
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.green))
//           : Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color(0xFF66BB6A), Color(0xFFF5F5F5)],
//                   stops: [0.0, 0.4],
//                 ),
//               ),
//               child: SafeArea(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildHeader(),
//                       const SizedBox(height: 20),
//                       _buildQuickActions(),
//                       const SizedBox(height: 20),
//                       _buildWeatherCard(),
//                       const SizedBox(height: 24),
//                       _buildActionButtons(context),
//                       const SizedBox(height: 24),
//                       _buildMyFields(),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//       bottomNavigationBar: _buildBottomNavBar(),
//     );
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(
//               greeting.isNotEmpty ? '$greeting, ${userName.split(' ')[0]}!' : "Hello, Farmer!",
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2E7D32),
//               ),
//             ),
//             const SizedBox(height: 4),
//             const Text(
//               'How can I help your crops today?',
//               style: TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               date.isNotEmpty ? date : '',
//               style: const TextStyle(fontSize: 12, color: Colors.black45),
//             ),
//           ]),
//           GestureDetector(
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => ProfilePage(
//                   userData: {
//                     'name': userName,
//                     'email': userEmail,
//                     'phone': userPhone,
//                     'city': city,
//                   },
//                 ),
//               ),
//             ),
//             child: CircleAvatar(
//               radius: 25,
//               backgroundColor: const Color(0xFF2E7D32),
//               child: Text(
//                 userName.isNotEmpty ? userName[0].toUpperCase() : 'K',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActions() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.0),
//       child: Row(children: [
//         Icon(Icons.flash_on, color: Color(0xFFFF6B6B), size: 20),
//         SizedBox(width: 8),
//         Text(
//           'Quick Actions',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget _buildWeatherCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(children: [
//             Row(children: [
//               const Icon(Icons.location_on, size: 20, color: Colors.black87),
//               const SizedBox(width: 8),
//               Text(
//                 city.isNotEmpty ? city : 'Unknown City',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const Spacer(),
//               Icon(Icons.cloud, size: 40, color: Colors.grey[400]),
//               const SizedBox(width: 8),
//               Text(
//                 temperature.isNotEmpty ? temperature : '--°C',
//                 style: const TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ]),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildWeatherDetail(Icons.thermostat, temperature, 'Temperature'),
//                 _buildWeatherDetail(Icons.water_drop, humidity, 'Humidity'),
//                 _buildWeatherDetail(Icons.air, wind, 'Wind'),
//                 _buildWeatherDetail(Icons.umbrella, precipitation, 'Precipitation'),
//               ],
//             ),
//           ]),
//         ),
//       ),
//     );
//   }

//   Widget _buildWeatherDetail(IconData icon, String value, String label) {
//     return Column(children: [
//       Icon(icon, size: 32, color: Colors.black54),
//       const SizedBox(height: 8),
//       Text(
//         value.isNotEmpty ? value : '--',
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//         ),
//       ),
//       const SizedBox(height: 4),
//       Text(
//         label,
//         style: const TextStyle(fontSize: 11, color: Colors.black54),
//       ),
//     ]);
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Row(children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => CropDiagnosisCamera(
//                   userData: {
//                     'name': userName,
//                     'email': userEmail,
//                     'phone': userPhone,
//                     'city': city,
//                   },
//                 ),
//               ),
//             ),
//             child: _buildActionCard(
//               Icons.camera_alt,
//               'Crop Diagnosis',
//               const Color(0xFF66BB6A),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: GestureDetector(
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => ExpertsPage()),
//             ),
//             child: _buildActionCard(
//               Icons.person,
//               'Book Expert',
//               const Color(0xFFFDD835),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget _buildActionCard(IconData icon, String label, Color borderColor) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(12),
//         border: Border(left: BorderSide(color: borderColor, width: 4)),
//       ),
//       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(icon, size: 40, color: Colors.black87),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget _buildMyFields() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Text(
//           'My Fields',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Container(
//           height: 180,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             image: const DecorationImage(
//               image: NetworkImage(
//                 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800',
//               ),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Stack(children: [
//             Positioned(left: 60, top: 60, child: _buildTractorIcon()),
//             Positioned(left: 140, top: 80, child: _buildTractorIcon()),
//             Positioned(right: 60, top: 70, child: _buildTractorIcon()),
//           ]),
//         ),
//       ]),
//     );
//   }

//   Widget _buildTractorIcon() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(Icons.agriculture, size: 24, color: Color(0xFF2E7D32)),
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           blurRadius: 10,
//           offset: const Offset(0, -2),
//         ),
//       ]),
//       child: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: const Color(0xFF2E7D32),
//         unselectedItemColor: Colors.grey,
//         currentIndex: _currentIndex,
//         onTap: _onNavBarTap,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Experts'),
//           BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
//           BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chat.dart';
import 'tools.dart';
import 'detector.dart';
import 'experts.dart';
import 'profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const CropDashboard(),
    );
  }
}

class CropDashboard extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const CropDashboard({
    Key? key,
    this.userData,
  }) : super(key: key);

  @override
  State<CropDashboard> createState() => _CropDashboardState();
}

class _CropDashboardState extends State<CropDashboard> {
  int _currentIndex = 0;

  // Real-time backend data
  String greeting = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String city = '';
  String date = '';
  String temperature = '';
  String humidity = '';
  String wind = '';
  String precipitation = '';
  String weather = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Store user info from userData
    userName = widget.userData?['name'] ?? '';
    userEmail = widget.userData?['email'] ?? '';
    userPhone = widget.userData?['phone'] ?? '';
    city = widget.userData?['city'] ?? 'Kathmandu';
    
    // Fetch dashboard data using email
    if (userEmail.isNotEmpty) {
      fetchDashboardData(userEmail);
    } else {
      // If no email, set defaults
      setState(() {
        greeting = 'Hello';
        userName = 'Farmer';
        isLoading = false;
      });
    }
  }

  Future<void> fetchDashboardData(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/dashboard'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          greeting = data['greeting'] ?? 'Hello';
          userName = data['name'] ?? userName;
          city = data['city'] ?? city;
          date = data['date'] ?? '';
          temperature = data['temperature'] ?? '--°C';
          humidity = data['humidity'] ?? '--%';
          wind = data['wind'] ?? '-- m/s';
          precipitation = data['precipitation'] ?? '-- mm';
          weather = data['weather'] ?? '';
          userEmail = data['email'] ?? userEmail;
          userPhone = data['phone'] ?? userPhone;
          isLoading = false;
        });
        print('✅ Dashboard data loaded successfully');
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching dashboard data: $e');
      // Set default values on error
      setState(() {
        greeting = 'Hello';
        if (userName.isEmpty) userName = 'Farmer';
        if (city.isEmpty) city = 'Unknown';
        isLoading = false;
      });
    }
  }

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExpertsPage(userEmail: userEmail), // ✅ FIXED: Added userEmail
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ToolsPage(),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(
              userData: {
                'name': userName,
                'email': userEmail,
                'phone': userPhone,
                'city': city,
              },
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF66BB6A), Color(0xFFF5F5F5)],
                  stops: [0.0, 0.4],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildQuickActions(),
                      const SizedBox(height: 20),
                      _buildWeatherCard(),
                      const SizedBox(height: 24),
                      _buildActionButtons(context),
                      const SizedBox(height: 24),
                      _buildMyFields(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              greeting.isNotEmpty ? '$greeting, ${userName.split(' ')[0]}!' : "Hello, Farmer!",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'How can I help your crops today?',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              date.isNotEmpty ? date : '',
              style: const TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ]),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(
                  userData: {
                    'name': userName,
                    'email': userEmail,
                    'phone': userPhone,
                    'city': city,
                  },
                ),
              ),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF2E7D32),
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'K',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(children: [
        Icon(Icons.flash_on, color: Color(0xFFFF6B6B), size: 20),
        SizedBox(width: 8),
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ]),
    );
  }

  Widget _buildWeatherCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Row(children: [
              const Icon(Icons.location_on, size: 20, color: Colors.black87),
              const SizedBox(width: 8),
              Text(
                city.isNotEmpty ? city : 'Unknown City',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(Icons.cloud, size: 40, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Text(
                temperature.isNotEmpty ? temperature : '--°C',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(Icons.thermostat, temperature, 'Temperature'),
                _buildWeatherDetail(Icons.water_drop, humidity, 'Humidity'),
                _buildWeatherDetail(Icons.air, wind, 'Wind'),
                _buildWeatherDetail(Icons.umbrella, precipitation, 'Precipitation'),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(children: [
      Icon(icon, size: 32, color: Colors.black54),
      const SizedBox(height: 8),
      Text(
        value.isNotEmpty ? value : '--',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.black54),
      ),
    ]);
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CropDiagnosisCamera(
                  userData: {
                    'name': userName,
                    'email': userEmail,
                    'phone': userPhone,
                    'city': city,
                  },
                ),
              ),
            ),
            child: _buildActionCard(
              Icons.camera_alt,
              'Crop Diagnosis',
              const Color(0xFF66BB6A),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExpertsPage(userEmail: userEmail), // ✅ FIXED: Added userEmail
              ),
            ),
            child: _buildActionCard(
              Icons.person,
              'Book Expert',
              const Color(0xFFFDD835),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildActionCard(IconData icon, String label, Color borderColor) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 40, color: Colors.black87),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ]),
    );
  }

  Widget _buildMyFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'My Fields',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(children: [
            Positioned(left: 60, top: 60, child: _buildTractorIcon()),
            Positioned(left: 140, top: 80, child: _buildTractorIcon()),
            Positioned(right: 60, top: 70, child: _buildTractorIcon()),
          ]),
        ),
      ]),
    );
  }

  Widget _buildTractorIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.agriculture, size: 24, color: Color(0xFF2E7D32)),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ]),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Experts'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}