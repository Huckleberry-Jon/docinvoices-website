import 'package:flutter/material.dart';
import '../services/business_profile_repository.dart';
import 'choose_industry_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  InputDecoration _fieldStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFF1E252F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.orange,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = languageCode == 'es';
    final profile = BusinessProfileRepository.instance.profile;

String businessName = profile.businessName;
String phone = profile.phone;
String email = profile.email;
String street = profile.street;
String city = profile.city;
String state = profile.state;
String zip = profile.zip;
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.storefront_outlined,
                    color: Colors.orange,
                    size: 70,
                  ),
                  const SizedBox(height: 24),
                  Text(
  isSpanish
      ? 'Información de la empresa'
      : 'Business Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
Text(
  isSpanish
      ? 'Cuéntenos sobre su empresa.'
      : 'Tell us about your business.',
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: Colors.white70,
    fontSize: 18,
  ),
),
const SizedBox(height: 36),
TextFormField(
  initialValue: businessName,
  onChanged: (value) => businessName = value,
  decoration: _fieldStyle(
    isSpanish ? 'Nombre de la empresa' : 'Business Name',
    Icons.business_outlined,
  ),
),
const SizedBox(height: 18),
TextFormField(
  initialValue: phone,
  onChanged: (value) => phone = value,
  keyboardType: TextInputType.phone,
  decoration: _fieldStyle(
    isSpanish ? 'Teléfono de la empresa' : 'Business Phone',
    Icons.phone_outlined,
  ),
),
const SizedBox(height: 18),
TextFormField(
  initialValue: email,
  onChanged: (value) => email = value,
  keyboardType: TextInputType.emailAddress,
  decoration: _fieldStyle(
    isSpanish
        ? 'Correo electrónico de la empresa'
        : 'Business Email',
    Icons.email_outlined,
  ),
),
const SizedBox(height: 18),
TextFormField(
  initialValue: street,
  onChanged: (value) => street = value,
  decoration: _fieldStyle(
    isSpanish ? 'Dirección' : 'Street Address',
    Icons.location_on_outlined,
  ),
),
const SizedBox(height: 18),
Row(
  children: [
    Expanded(
      flex: 2,
      child: TextFormField(
        initialValue: city,
        onChanged: (value) => city = value,
        decoration: _fieldStyle(
          isSpanish ? 'Ciudad' : 'City',
          Icons.location_city_outlined,
        ),
      ),
    ),
    const SizedBox(width: 14),
    Expanded(
      child: TextFormField(
        initialValue: state,
        onChanged: (value) => state = value,
        textCapitalization: TextCapitalization.characters,
        decoration: _fieldStyle(
          isSpanish ? 'Estado' : 'State',
          Icons.map_outlined,
        ),
      ),
    ),
  ],
),
const SizedBox(height: 18),
TextFormField(
  initialValue: zip,
  onChanged: (value) => zip = value,
  keyboardType: TextInputType.number,
  decoration: _fieldStyle(
    isSpanish ? 'Código postal' : 'ZIP Code',
    Icons.markunread_mailbox_outlined,
  ),
),
                  
                  const SizedBox(height: 34),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                     onPressed: () async {
  profile.businessName = businessName.trim();
  profile.phone = phone.trim();
  profile.email = email.trim();
  profile.street = street.trim();
  profile.city = city.trim();
  profile.state = state.trim();
  profile.zip = zip.trim();

  await BusinessProfileRepository.instance.save();
  final prefs = await SharedPreferences.getInstance();

await prefs.setBool(
  'setupComplete',
  true,
);

await prefs.setString(
  'languageCode',
  languageCode,
);

  if (!context.mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => ChooseIndustryScreen(
        languageCode: languageCode,
      ),
    ),
  );
},
                      
                      child: Text(
  isSpanish ? 'Continuar' : 'Continue',
  style: const TextStyle(fontSize: 20),
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