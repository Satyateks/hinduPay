import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/saved_address.dart';
import '../bloc/address/address_bloc.dart';
import '../bloc/address/address_event.dart';
import '../bloc/address/address_state.dart';




// Note: Ensure your Bloc events and model (SavedAddress, EditAddressRequested, DeleteAddressRequested) match your project set up.

class SavedAddressPage extends StatelessWidget {
  const SavedAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF097939);
    return Scaffold(
      backgroundColor:const Color(0xFFFAFAFA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Saved delivery address',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state.status == AddressStatus.loading && state.addresses.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: primaryGreen),
            );
          }

          if (state.status == AddressStatus.failure && state.addresses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to load addresses',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please check your connection and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          
          if (state.addresses.isEmpty) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 60,
                      color: Color(0xFF3563E9),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Saved Addresses',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add your address for a faster and smoother checkout experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
 
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: state.addresses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              return Container(
                width: 374,
                height: 96,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2, right: 12),
                      child: Icon(Icons.home_outlined,color: Colors.grey,size: 24),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.name,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 20 / 14, // Line height: 20px
                                letterSpacing: 0,
                                color: Colors.black87,
                              ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${address.addressLine}, ${address.city}, ${address.state} ${address.pincode}',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 16 / 12, // Line height: 20px
                                letterSpacing: 0,
                                color: Color(0xDD666666),
                              ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            // context.read<AddressBloc>().add(EditAddressRequested(address));
                          },
                          child: const Icon(
                            Icons.edit_outlined,
                            color: primaryGreen,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            context.read<AddressBloc>().add(
                              DeleteAddressRequested(address.id),
                            );
                          },
                          child: const Icon(
                            Icons.delete_outline,
                            color: primaryGreen,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          width: double.infinity,
          height: 72,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: OutlinedButton(
            onPressed: () {
              context.pushNamed('add-address');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: primaryGreen, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: primaryGreen, size: 20),
                SizedBox(width: 6),
                Text(
                  'Add New Address',
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});
  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _flatController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _searchController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  final String _selectedLocationType = 'Home';
  final String _selectedAddressText = 'Plot No 17, Greater Noida W Rd, Tech Zone IV, Amrapali Dream Valley, Greater Noida, Uttar Pradesh 201318';
  bool _submitted = false;

  static const primaryGreen = Color(0xFF0C8346);
  static const lightGreenBg = Color(0xFFEDF7F1);

  @override
  void dispose() {
    _flatController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'Enter $label';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || !RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) return 'Enter a valid 10-digit mobile number';    
    return null;
  }
  String? _validatePincode(String? value) {
    if (value == null || !RegExp(r'^\d{6}$').hasMatch(value.trim())) return 'Enter a valid 6-digit pincode';
    return null;
  }


  void _saveAddress() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitted = true);

    context.read<AddressBloc>().add(
          AddAddressRequested(
            SavedAddress(
              id: '',
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              addressLine: '${_flatController.text.trim()}, $_selectedAddressText',
              // addressLine: _addressController.text.trim(),
              city: _cityController.text.trim(),
              state: _stateController.text.trim(),
              pincode: _pincodeController.text.trim(),
              type: _selectedLocationType,
              isDefault: false,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddressStatus.success && _submitted) {
          context.pop();
        }

        if (state.status == AddressStatus.failure && _submitted) {
          setState(() => _submitted = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Unable to save address'),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black87, size: 20),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Add new address',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // map preview container
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/400x200'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // search bar over map
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search by area, name, street',
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      // center pin
                      const Center(
                        child: Icon(
                          Icons.location_on,
                          color: primaryGreen,
                          size: 36,
                        ),
                      ),
                      // locate button
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.black87,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // select location heading
                const Text(
                  'Select location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // location preview card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: lightGreenBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: primaryGreen,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedLocationType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Change',
                                    style: TextStyle(
                                      color: primaryGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedAddressText,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // form fields container card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _inputField(
                        controller: _flatController,
                        label: 'Flat/House/building name',
                        hint: 'Enter Flat/House/building name',
                        validator: (v) => _required(v,'Flat/House/building name'),
                      ),
                      const SizedBox(height: 14),
                      _inputField(
                        controller: _nameController,
                        label: 'Full name',
                        hint: 'Enter Flat/House/building name',
                        validator: (v) => _required(v, 'Full name'),
                      ),
                      const SizedBox(height: 14),
                      _inputField(
                        controller: _phoneController,
                        label: '10 digit mobile number',
                        hint: '+91********',
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 14),
                      _inputField(
                        controller: _pincodeController,
                        label: '6 digit pin code',
                        hint: '*******',
                        keyboardType: TextInputType.phone,
                        maxLength: 6,
                        validator: _validatePincode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitted ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: _submitted
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryGreen),
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }
}




/*
class SavedAddressPage extends StatelessWidget {
  const SavedAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved delivery address')),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state.status == AddressStatus.loading &&
              state.addresses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AddressStatus.failure &&
              state.addresses.isEmpty) {
            return Center(
              child: Text(state.errorMessage ?? 'Unable to load addresses'),
            );
          }

          if (state.addresses.isEmpty) {
            return const Center(child: Text('No saved addresses'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final address in state.addresses)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(address.name),
                    subtitle: Text(
                      '${address.addressLine}, ${address.city}, '
                      '${address.state} - ${address.pincode}\n'
                      '${address.phone}',
                    ),
                    isThreeLine: true,
                    trailing: address.isDefault
                        ? const Chip(label: Text('Default'))
                        : TextButton(
                            onPressed: () {
                              context.read<AddressBloc>().add(
                                SelectAddressRequested(address.id),
                              );
                            },
                            child: const Text('Deliver here'),
                          ),
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  context.pushNamed('add-address');
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Address'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  String _type = 'Home';
  bool _makeDefault = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter $label';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || !RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || !RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  void _saveAddress() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitted = true);
    context.read<AddressBloc>().add(
      AddAddressRequested(
        SavedAddress(
          id: '',
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          addressLine: _addressController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          pincode: _pincodeController.text.trim(),
          type: _type,
          isDefault: _makeDefault,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddressStatus.success && _submitted) {
          context.pop();
        }

        if (state.status == AddressStatus.failure && _submitted) {
          setState(() => _submitted = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Unable to save address'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add New Address')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Contact Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                _field(
                  controller: _nameController,
                  label: 'Full Name',
                  validator: (v) => _required(v, 'your name'),
                  icon: Icons.person_outline,
                ),
                _field(
                  controller: _phoneController,
                  label: 'Mobile Number',
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                  icon: Icons.phone_outlined,
                  maxLength: 10,
                ),

                const SizedBox(height: 20),
                Text(
                  'Address Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                _field(
                  controller: _addressController,
                  label: 'House no., street, area',
                  validator: (v) => _required(v, 'your address'),
                  icon: Icons.location_on_outlined,
                ),
                _field(
                  controller: _cityController,
                  label: 'City',
                  validator: (v) => _required(v, 'city'),
                  icon: Icons.location_city_outlined,
                ),
                _field(
                  controller: _stateController,
                  label: 'State',
                  validator: (v) => _required(v, 'state'),
                  icon: Icons.map_outlined,
                ),
                _field(
                  controller: _pincodeController,
                  label: 'Pincode',
                  keyboardType: TextInputType.number,
                  validator: _validatePincode,
                  icon: Icons.markunread_mailbox_outlined,
                  maxLength: 6,
                ),

                const SizedBox(height: 16),
                Text(
                  'Save address as',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Home',
                      label: Text('Home'),
                      icon: Icon(Icons.home_outlined),
                    ),
                    ButtonSegment(
                      value: 'Work',
                      label: Text('Work'),
                      icon: Icon(Icons.work_outline),
                    ),
                    ButtonSegment(
                      value: 'Other',
                      label: Text('Other'),
                      icon: Icon(Icons.location_on_outlined),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (value) {
                    setState(() => _type = value.first);
                  },
                ),

                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _makeDefault,
                  onChanged: (value) {
                    setState(() => _makeDefault = value ?? false);
                  },
                  title: const Text('Make this my default address'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitted ? null : _saveAddress,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: _submitted
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Address'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          counterText: '',
        ),
      ),
    );
  }
}

*/


