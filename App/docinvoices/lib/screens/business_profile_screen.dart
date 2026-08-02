import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/business_profile_repository.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<BusinessProfileScreen> createState() =>
      _BusinessProfileScreenState();
}

class _BusinessProfileScreenState
    extends State<BusinessProfileScreen> {
      @override
void initState() {
  super.initState();

  final profile = BusinessProfileRepository.instance.profile;

  businessNameController.text = profile.businessName;
  taglineController.text = profile.tagline;
  phoneController.text = profile.phone;
  emailController.text = profile.email;
  websiteController.text = profile.website;

  streetController.text = profile.street;
  cityController.text = profile.city;
  stateController.text = profile.state;
  zipController.text = profile.zip;

  if (profile.taxRate > 0) {
    taxRateController.text =
        profile.taxRate.toStringAsFixed(2);
  }

  logoPath =
      profile.logoPath.isEmpty ? null : profile.logoPath;
}
  final businessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();

  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();

  final taxRateController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  final taglineController = TextEditingController();

  String? logoPath;

  bool get isSpanish => widget.languageCode == 'es';

  Future<void> _chooseLogo() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      logoPath = image.path;
    });
  }

  Future<void> _takeLogoPhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      logoPath = image.path;
    });
  }

  Future<void> _saveProfile() async {
  final profile = BusinessProfileRepository.instance.profile;

  profile.businessName = businessNameController.text.trim();
  profile.tagline = taglineController.text.trim();
  profile.phone = phoneController.text.trim();
  profile.email = emailController.text.trim();
  profile.website = websiteController.text.trim();

  profile.street = streetController.text.trim();
  profile.city = cityController.text.trim();
  profile.state = stateController.text.trim();
  profile.zip = zipController.text.trim();

  profile.taxRate =
      double.tryParse(taxRateController.text.trim()) ?? 0.0;

  profile.logoPath = logoPath ?? '';
  await BusinessProfileRepository.instance.save();
if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isSpanish
            ? 'Perfil comercial guardado.'
            : 'Business profile saved.',
      ),
    ),
  );
}

  @override
  void dispose() {
    businessNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    taxRateController.dispose();
    taglineController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      appBar: AppBar(
        title: Text(
          isSpanish
              ? 'Perfil comercial'
              : 'Business Profile',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 760,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _card(
                    child: Column(
                      children: [
                        Text(
                          isSpanish
                              ? 'Logotipo comercial'
                              : 'Business Logo',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF101D2C),
                            border: Border.all(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: logoPath == null
                              ? const Icon(
                                  Icons.business_outlined,
                                  color: Colors.white54,
                                  size: 58,
                                )
                              : Image.file(
                                  File(logoPath!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _chooseLogo,
                              icon: const Icon(
                                Icons.photo_library_outlined,
                              ),
                              label: Text(
                                isSpanish
                                    ? 'Elegir de fotos'
                                    : 'Choose From Photos',
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _takeLogoPhoto,
                              icon: const Icon(
                                Icons.photo_camera_outlined,
                              ),
                              label: Text(
                                isSpanish
                                    ? 'Tomar foto'
                                    : 'Take Photo',
                              ),
                            ),
                          ],
                        ),
                        if (logoPath != null) ...[
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                logoPath = null;
                              });
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            label: Text(
                              isSpanish
                                  ? 'Eliminar logotipo'
                                  : 'Remove Logo',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        _sectionTitle(
                          isSpanish
                              ? 'Información comercial'
                              : 'Business Information',
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: businessNameController,
                          textCapitalization:
                              TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: isSpanish
                                ? 'Nombre comercial'
                                : 'Business Name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: taglineController,
                          decoration: InputDecoration(
                            labelText: isSpanish
                                ? 'Eslogan'
                                : 'Tagline',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: isSpanish
                                ? 'Número de teléfono'
                                : 'Phone Number',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: emailController,
                          keyboardType:
                              TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText:
                                isSpanish ? 'Correo' : 'Email',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: websiteController,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: isSpanish
                                ? 'Sitio web'
                                : 'Website',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        _sectionTitle(
                          isSpanish
                              ? 'Dirección comercial'
                              : 'Business Address',
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: streetController,
                          textCapitalization:
                              TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: isSpanish
                                ? 'Dirección'
                                : 'Street Address',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: cityController,
                          textCapitalization:
                              TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText:
                                isSpanish ? 'Ciudad' : 'City',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: stateController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                  labelText: isSpanish
                                      ? 'Estado'
                                      : 'State',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: zipController,
                                keyboardType:
                                    TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: isSpanish
                                      ? 'Código postal'
                                      : 'ZIP Code',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        _sectionTitle(
                          isSpanish
                              ? 'Configuración fiscal'
                              : 'Tax Settings',
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: taxRateController,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: isSpanish
                                ? 'Tasa de impuesto'
                                : 'Tax Rate',
                            suffixText: '%',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(
                        isSpanish
                            ? 'Guardar cambios'
                            : 'Save Changes',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _card({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1624),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: child,
    );
  }
}