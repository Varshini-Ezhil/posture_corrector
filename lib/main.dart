import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Posture corrector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 156, 29, 29)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Posture corrector'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Replace with your Render URL
  static const String url = 'https://your-app-name.onrender.com/command';
  final TextEditingController _degreeController = TextEditingController();

  final Map<String, bool> buttonStates = {
    'Temperature Left': false,
    'Temperature Right': false,
    'Temperature Both': false,
    'Vibration Left': false,
    'Vibration Right': false,
    'Vibration Both': false,
  };

  Future<void> sendValueToServer(String command) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'command': command,
          'degree': _degreeController.text, // Send the degree value
        },
      );
      if (response.statusCode == 200) {
        print('Command sent successfully: $command with degree: ${_degreeController.text}');
        print('Server response: ${response.body}');
      } else {
        print('Failed to send command: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending command: $e');
    }
  }

  void toggleButton(String label) {
    setState(() {
      buttonStates[label] = !buttonStates[label]!;
      String command;
      switch (label) {
        case 'Temperature Left':
          command = buttonStates[label]! ? 'tl' : 'TL';
          break;
        case 'Temperature Right':
          command = buttonStates[label]! ? 'tr' : 'TR';
          break;
        case 'Temperature Both':
          command = buttonStates[label]! ? 'tb' : 'TB';
          // Also update individual temperature buttons
          buttonStates['Temperature Left'] = buttonStates[label]!;
          buttonStates['Temperature Right'] = buttonStates[label]!;
          break;
        case 'Vibration Left':
          command = buttonStates[label]! ? 'vl' : 'VL';
          break;
        case 'Vibration Right':
          command = buttonStates[label]! ? 'vr' : 'VR';
          break;
        case 'Vibration Both':
          command = buttonStates[label]! ? 'vb' : 'VB';
          // Also update individual vibration buttons
          buttonStates['Vibration Left'] = buttonStates[label]!;
          buttonStates['Vibration Right'] = buttonStates[label]!;
          break;
        default:
          command = '';
      }
      sendValueToServer(command);
    });
  }

  Widget _buildToggleButton(String label) {
    return SizedBox(
      width: 300,
      height: 80,
      child: ElevatedButton(
        onPressed: () => toggleButton(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonStates[label]! ? Colors.green : const Color.fromARGB(189, 237, 27, 12),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 169, 131, 234),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _degreeController,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter Temperature (°C)',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Enter value between 0-100',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.thermostat,
                          color: Theme.of(context).primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
                _buildToggleButton('Temperature Left'),
                const SizedBox(height: 20),
                _buildToggleButton('Temperature Right'),
                const SizedBox(height: 20),
                _buildToggleButton('Temperature Both'),
                const SizedBox(height: 20),
                _buildToggleButton('Vibration Left'),
                const SizedBox(height: 20),
                _buildToggleButton('Vibration Right'),
                const SizedBox(height: 20),
                _buildToggleButton('Vibration Both'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}