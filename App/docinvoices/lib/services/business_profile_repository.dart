import '../models/business_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProfileRepository {
  BusinessProfileRepository._();

  static final BusinessProfileRepository instance =
      BusinessProfileRepository._();

  final BusinessProfile profile = BusinessProfile();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    profile.businessName =
        prefs.getString('businessName') ?? '';

    profile.tagline =
        prefs.getString('tagline') ?? '';

    profile.phone =
        prefs.getString('phone') ?? '';

    profile.email =
        prefs.getString('email') ?? '';

    profile.website =
        prefs.getString('website') ?? '';

    profile.street =
        prefs.getString('street') ?? '';

    profile.city =
        prefs.getString('city') ?? '';

    profile.state =
        prefs.getString('state') ?? '';

    profile.zip =
        prefs.getString('zip') ?? '';

    profile.taxRate =
        prefs.getDouble('taxRate') ?? 0.0;

    profile.logoPath =
        prefs.getString('logoPath') ?? '';
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'businessName',
      profile.businessName,
    );

    await prefs.setString(
      'tagline',
      profile.tagline,
    );

    await prefs.setString(
      'phone',
      profile.phone,
    );

    await prefs.setString(
      'email',
      profile.email,
    );

    await prefs.setString(
      'website',
      profile.website,
    );

    await prefs.setString(
      'street',
      profile.street,
    );

    await prefs.setString(
      'city',
      profile.city,
    );

    await prefs.setString(
      'state',
      profile.state,
    );

    await prefs.setString(
      'zip',
      profile.zip,
    );

    await prefs.setDouble(
      'taxRate',
      profile.taxRate,
    );

    await prefs.setString(
      'logoPath',
      profile.logoPath,
    );
  }
}