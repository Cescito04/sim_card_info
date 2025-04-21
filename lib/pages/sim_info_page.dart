import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class SimInfoPage extends StatefulWidget {
  const SimInfoPage({super.key});

  @override
  State<SimInfoPage> createState() => _SimInfoPageState();
}

class _SimInfoPageState extends State<SimInfoPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<SimCard> _simCards = [];
  String? _phoneNumber;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _initSimCards();
    _controller.forward();
  }

  Future<void> _initSimCards() async {
    try {
      final phoneStatus = await Permission.phone.request();
      if (!phoneStatus.isGranted) {
        setState(() {
          _error = 'Permission d\'accès au téléphone refusée';
          _loading = false;
        });
        return;
      }

      MobileNumber.listenPhonePermission((isPermissionGranted) {
        if (isPermissionGranted) {
          _fetchSimInfo();
        } else {
          setState(() {
            _error = 'Permission refusée';
            _loading = false;
          });
        }
      });

      await _fetchSimInfo();
    } catch (e) {
      setState(() {
        _error = 'Erreur: $e';
        _loading = false;
      });
    }
  }

  Future<void> _fetchSimInfo() async {
    try {
      _phoneNumber = await MobileNumber.mobileNumber;
      _simCards = await MobileNumber.getSimCards ?? [];
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors de la récupération des informations: $e';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informations Carte SIM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(
                    child: Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _error,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FadeTransition(
                          opacity: _animation,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Numéro de téléphone',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    margin: const EdgeInsets.only(left: 32),
                                    child: Text(
                                      _phoneNumber ?? 'Non disponible',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _phoneNumber != null
                                            ? Colors.black87
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_simCards.isEmpty)
                          FadeTransition(
                            opacity: _animation,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.sim_card_alert,
                                      color: Colors.orange,
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Aucune carte SIM détectée',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          ..._simCards.map(
                            (sim) => FadeTransition(
                              opacity: _animation,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.sim_card,
                                              color: Theme.of(context).colorScheme.primary,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'SIM ${sim.slotIndex ?? "Inconnu"}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          margin: const EdgeInsets.only(left: 32),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildSimInfoRow(
                                                Icons.phone_android,
                                                'Numéro',
                                                sim.number,
                                              ),
                                              _buildSimInfoRow(
                                                Icons.business,
                                                'Opérateur',
                                                sim.carrierName,
                                              ),
                                              _buildSimInfoRow(
                                                Icons.flag,
                                                'Code pays',
                                                sim.countryIso,
                                              ),
                                              _buildSimInfoRow(
                                                Icons.call,
                                                'Préfixe téléphonique',
                                                sim.countryPhonePrefix,
                                              ),
                                              _buildSimInfoRow(
                                                Icons.sim_card,
                                                'Code opérateur',
                                                sim.displayName,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ).toList(),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildSimInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: value ?? 'Non disponible',
                    style: TextStyle(
                      color: value != null ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
