import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dashboard_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState
    extends State<SubscriptionScreen> {
  static const String _productId =
      'com.docinvoices.app.monthly';

  InAppPurchase? _inAppPurchase;

  StreamSubscription<List<PurchaseDetails>>?
      _purchaseSubscription;

  ProductDetails? _product;

  bool _storeAvailable = false;
  bool _loading = true;
  bool _purchasePending = false;

  String? _errorMessage;

  bool get isSpanish =>
      widget.languageCode == 'es';

  @override
  void initState() {
    super.initState();
if (kIsWeb ||
    !(defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.macOS)) {
  _loading = false;
  _storeAvailable = false;
  _errorMessage =
      'Subscriptions are available on iPhone and Android devices.';
  return;
}

_inAppPurchase = InAppPurchase.instance;
    _purchaseSubscription =
        _inAppPurchase!.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () {
        _purchaseSubscription?.cancel();
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _purchasePending = false;
          _errorMessage = error.toString();
        });
      },
    );

    _initializeStore();
  }

  Future<void> _initializeStore() async {
    try {
      final available =
          await _inAppPurchase!.isAvailable();

      if (!mounted) return;

      if (!available) {
        setState(() {
          _storeAvailable = false;
          _loading = false;
          _errorMessage = isSpanish
              ? 'La App Store no está disponible.'
              : 'The App Store is not available.';
        });

        return;
      }

      final response =
          await _inAppPurchase!.queryProductDetails(
        {_productId},
      );

      if (!mounted) return;

      if (response.error != null) {
        setState(() {
          _loading = false;
          _errorMessage =
              response.error!.message;
        });

        return;
      }

      if (response.productDetails.isEmpty) {
        setState(() {
          _loading = false;
          _storeAvailable = true;
          _errorMessage = isSpanish
              ? 'La suscripción aún no está disponible.'
              : 'The subscription is not available yet.';
        });

        return;
      }

      setState(() {
        _storeAvailable = true;
        _product =
            response.productDetails.first;
        _loading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _subscribe() async {
    final product = _product;

    if (product == null ||
        !_storeAvailable ||
        _purchasePending) {
      return;
    }

    setState(() {
      _purchasePending = true;
      _errorMessage = null;
    });

    final purchaseParam = PurchaseParam(
      productDetails: product,
    );

    try {
      await _inAppPurchase!.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _purchasePending = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _restorePurchases() async {
    if (_purchasePending) return;

    setState(() {
      _purchasePending = true;
      _errorMessage = null;
    });

    try {
      await _inAppPurchase!.restorePurchases();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _purchasePending = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchases,
  ) async {
    for (final purchase in purchases) {
      if (purchase.productID != _productId) {
        continue;
      }

      if (purchase.status ==
          PurchaseStatus.pending) {
        if (!mounted) return;

        setState(() {
          _purchasePending = true;
        });

        continue;
      }

      if (purchase.status ==
          PurchaseStatus.error) {
        if (!mounted) return;

        setState(() {
          _purchasePending = false;
          _errorMessage =
              purchase.error?.message ??
                  (isSpanish
                      ? 'No se pudo completar la compra.'
                      : 'The purchase could not be completed.');
        });
      }

      if (purchase.status ==
              PurchaseStatus.purchased ||
          purchase.status ==
              PurchaseStatus.restored) {
        await _unlockSubscription();
      }

      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase!.completePurchase(
          purchase,
        );
      }
    }
  }

  Future<void> _unlockSubscription() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'subscriptionActive',
      true,
    );

    if (!mounted) return;

    setState(() {
      _purchasePending = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          languageCode:
              widget.languageCode,
        ),
      ),
      (route) => false,
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final price =
        _product?.price ?? '\$49.00';

    return Scaffold(
      backgroundColor:
          const Color(0xFF050B14),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('DocInvoices'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 520,
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/docinvoices_logo.png',
                    width: 120,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    isSpanish
                        ? 'DocInvoices Mensual'
                        : 'DocInvoices Monthly',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '$price / ${isSpanish ? 'mes' : 'month'}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    isSpanish
                        ? 'Acceso completo a todas las funciones de DocInvoices.'
                        : 'Full access to all DocInvoices features.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _feature(
                    Icons.description_outlined,
                    isSpanish
                        ? 'Órdenes de trabajo, estimados y facturas'
                        : 'Work orders, estimates & invoices',
                  ),

                  _feature(
                    Icons.calendar_month_outlined,
                    isSpanish
                        ? 'Programación y tareas'
                        : 'Scheduling & tasks',
                  ),

                  _feature(
                    Icons.receipt_long_outlined,
                    isSpanish
                        ? 'Recibos y seguimiento de pagos'
                        : 'Receipts & payment tracking',
                  ),

                  _feature(
                    Icons.bar_chart_outlined,
                    isSpanish
                        ? 'Reportes e historial de trabajos'
                        : 'Reports & job history',
                  ),

                  const SizedBox(height: 30),

                  if (_loading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        onPressed:
                            _purchasePending
                                ? null
                                : _subscribe,
                        child: _purchasePending
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                isSpanish
                                    ? 'Suscribirse'
                                    : 'Subscribe',
                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: _purchasePending
                        ? null
                        : _restorePurchases,
                    child: Text(
                      isSpanish
                          ? 'Restaurar compras'
                          : 'Restore Purchases',
                    ),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  Text(
                    isSpanish
                        ? 'La suscripción se renueva automáticamente cada mes hasta que se cancele.'
                        : 'Subscription automatically renews monthly until canceled.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _openUrl(
                            'https://docinvoices.com/privacy.html',
                          );
                        },
                        child: Text(
                          isSpanish
                              ? 'Privacidad'
                              : 'Privacy Policy',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _openUrl(
                            'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
                          );
                        },
                        child: Text(
                          isSpanish
                              ? 'Términos'
                              : 'Terms of Use',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _feature(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}