import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TokenValidatorWidget extends StatefulWidget {
  const TokenValidatorWidget({
    super.key,
    required this.child,
    this.token,
    this.vendedorID,
  });

  final Widget child;
  final String? token;
  final String? vendedorID;

  @override
  State<TokenValidatorWidget> createState() => _TokenValidatorWidgetState();
}

class _TokenValidatorWidgetState extends State<TokenValidatorWidget> {
  static bool _sessionVerified = false;
  // Set to true to bypass token validation completely, allowing direct access via ?vendedorID=
  static const bool _bypassValidation = true;
  
  bool _isLoading = true;
  bool _isValid = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (_bypassValidation) {
      _isLoading = false;
      _isValid = true;
    } else {
      _validateToken();
    }
  }

  Future<String> _getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('component_device_id');
    if (deviceId == null || deviceId.isEmpty) {
      final rand = math.Random.secure();
      final values = List<int>.generate(16, (i) => rand.nextInt(256));
      deviceId = values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      await prefs.setString('component_device_id', deviceId);
    }
    return deviceId;
  }

  Future<void> _validateToken() async {
    if (_sessionVerified) {
      setState(() {
        _isLoading = false;
        _isValid = true;
      });
      return;
    }

    try {
      final deviceId = await _getOrCreateDeviceId();

      final prefs = await SharedPreferences.getInstance();
      
      // Try to get token from widget parameter, Uri.base, or local storage
      String? token = widget.token;
      if (token == null || token.trim().isEmpty) {
        // Fallback to Uri.base (useful on web reloads)
        token = Uri.base.queryParameters['token'];
      }
      if (token == null || token.trim().isEmpty) {
        // Fallback to previously approved token in local storage
        token = prefs.getString('approved_token');
      }

      // If still no token is found, block access
      if (token == null || token.trim().isEmpty) {
        setState(() {
          _isLoading = false;
          _isValid = false;
          _errorMessage = 'Acceso no autorizado.\nPor favor, solicita un enlace de pedido personalizado a tu vendedor.';
        });
        return;
      }

      final cleanToken = token.trim();
      final tokenDocRef = FirebaseFirestore.instance.collection('tokens').doc(cleanToken);
      final tokenDoc = await tokenDocRef.get();

      if (!tokenDoc.exists) {
        // Clean invalid stored token
        await prefs.remove('approved_token');
        setState(() {
          _isLoading = false;
          _isValid = false;
          _errorMessage = 'Enlace de pedido no válido o expirado.\nPor favor, solicita uno nuevo a tu vendedor.';
        });
        return;
      }

      final data = tokenDoc.data();
      if (data == null) {
        setState(() {
          _isLoading = false;
          _isValid = false;
          _errorMessage = 'Error al cargar la información del enlace.';
        });
        return;
      }

      final String? registeredDeviceId = data['device_id'] as String?;
      final String? tokenEstado = data['estado'] as String?;

      if (tokenEstado == 'used') {
        await prefs.remove('approved_token');
        setState(() {
          _isLoading = false;
          _isValid = false;
          _errorMessage = 'Este enlace de pedido ya ha sido utilizado para realizar una compra y ya no está activo.';
        });
        return;
      }

      if (registeredDeviceId == null || registeredDeviceId.trim().isEmpty) {
        // First-use activation: Lock the token to this device
        await tokenDocRef.update({
          'device_id': deviceId,
          'estado': 'active',
          'fecha_activacion': FieldValue.serverTimestamp(),
        });
        await prefs.setString('approved_token', cleanToken);
        _sessionVerified = true;
        setState(() {
          _isLoading = false;
          _isValid = true;
        });
      } else if (registeredDeviceId == deviceId) {
        // Authorized device
        await prefs.setString('approved_token', cleanToken);
        _sessionVerified = true;
        setState(() {
          _isLoading = false;
          _isValid = true;
        });
      } else {
        // Device mismatch: Attempting to use a forwarded/shared link
        setState(() {
          _isLoading = false;
          _isValid = false;
          _errorMessage = 'Este enlace de pedido es de uso exclusivo y ya ha sido activado en otro dispositivo.';
        });
      }
    } catch (e) {
      debugPrint('Error validating token: $e');
      setState(() {
        _isLoading = false;
        _isValid = false;
        _errorMessage = 'Error de conexión al validar el enlace de pedido. Intenta nuevamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bypassValidation) {
      return widget.child;
    }
    if (_isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
      );
    }

    if (_isValid) {
      return widget.child;
    }

    // Error/Unauthorized Screen
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Enlace Exclusivo',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.lora(fontWeight: FontWeight.bold),
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 22,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.vollkornSc(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 15,
                        ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        final url = Uri.parse('https://www.instagram.com/component_yz');
                        if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          // successfully launched
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Visitar Instagram',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.vollkornSc(fontWeight: FontWeight.w600),
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
