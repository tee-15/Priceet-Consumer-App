import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _useCurrentLocation() {
    setState(() => _addressController.text = 'Fetching location...');
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _addressController.text = '102 Main Street, Lagos, Nigeria');
      }
    });
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamed('/create-pin');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBackBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.greyBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/icon_home_address.svg',
                        width: 32,
                        height: 32,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Title
                    const Text(
                      'Set your home address',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandBlue,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Subtitle
                    const Text(
                      'This will be your default pickup and drop-off location',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Address field
                    AppTextField(
                      label: 'Home Address',
                      hint: 'Enter your home address',
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Please enter your home address' : null,
                    ),
                    const SizedBox(height: 16),

                    // Use current location
                    GestureDetector(
                      onTap: _useCurrentLocation,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icon_location_pin.svg',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Use Current Location',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.brandBlue,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Continue button
          Container(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomPadding),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: AppButton(
              label: 'Continue',
              isLoading: _isLoading,
              onPressed: _onContinue,
            ),
          ),
        ],
      ),
    );
  }
}
