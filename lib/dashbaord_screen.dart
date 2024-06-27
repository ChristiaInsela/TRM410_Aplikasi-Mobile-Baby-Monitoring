import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  late AnimationController _animationController;
  late Animation<double> _temperatureAnimation;
  late Animation<double> _humidityAnimation;
  double _temperature = 0.0;
  double _humidity = 0.0;
  int _pirStatus = 0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _activateListeners();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _temperatureAnimation =
        Tween<double>(begin: 0.0, end: _temperature).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _humidityAnimation = Tween<double>(begin: 0.0, end: _humidity).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _activateListeners() {
    _listenToTemperatureChanges();
    _listenToHumidityChanges();
    _listenToPirStatusChanges();
  }

  void _listenToTemperatureChanges() {
    _databaseReference
        .child('sensor/dht11/temperature')
        .onValue
        .listen((event) {
      final Object? tempValue = event.snapshot.value;
      if (tempValue != null) {
        final double temp = double.parse(tempValue.toString());
        setState(() {
          _temperature = temp;
          _animationController.reset();
          _animationController.forward();
        });
      }
    });
  }

  void _listenToHumidityChanges() {
    _databaseReference.child('sensor/dht11/humidity').onValue.listen((event) {
      final Object? humValue = event.snapshot.value;
      if (humValue != null) {
        final double hum = double.parse(humValue.toString());
        setState(() {
          _humidity = hum;
          _animationController.reset();
          _animationController.forward();
        });
      }
    });
  }

  void _listenToPirStatusChanges() {
    _databaseReference.child('sensor/pir').onValue.listen((event) {
      final Object? statusValue = event.snapshot.value;
      if (statusValue != null) {
        final int status = int.parse(statusValue.toString());
        setState(() {
          _pirStatus = status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAnimatedInfoCard(
                'Temperature',
                '${_temperature.toStringAsFixed(2)} °C',
                _temperatureAnimation,
                Colors.orange),
            const SizedBox(height: 16),
            _buildAnimatedInfoCard(
                'Humidity',
                '${_humidity.toStringAsFixed(2)} %',
                _humidityAnimation,
                Colors.blue),
            const SizedBox(height: 16),
            _buildPirStatusCard(),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedInfoCard(
      String title, String value, Animation<double> animation, Color color) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          width: double.infinity,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 24,
                          color: color,
                        ),
                      ),
                      CircularProgressIndicator(
                        value: animation.value / 100,
                        color: color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPirStatusCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PIR Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _pirStatus == 1 ? 'Motion detected' : 'No motion',
                    style: TextStyle(
                      fontSize: 24,
                      color: _pirStatus == 1 ? Colors.green : Colors.red,
                    ),
                  ),
                  Icon(
                    _pirStatus == 1
                        ? Icons.motion_photos_on
                        : Icons.motion_photos_off,
                    color: _pirStatus == 1 ? Colors.green : Colors.red,
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to toggle PIR status here
                  },
                  child: Text(_pirStatus == 1
                      ? 'Gerakan Terdeteksi'
                      : 'Tidak Ada Gerakan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _pirStatus == 1 ? Colors.green : Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
