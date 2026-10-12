import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/saved_address.dart';
import '../bloc/address/address_bloc.dart';
import '../bloc/address/address_event.dart';
import '../bloc/address/address_state.dart';

class SavedAddressPage extends StatelessWidget {
  const SavedAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Saved Addresses')),
        body: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state.status == AddressStatus.loading &&
                state.addresses.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
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
                  onPressed: () {context.pushNamed('add-address');},
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
      listenWhen: (previous, current) =>
          previous.status != current.status,
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
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          counterText: '',
        ),
      ),
    );
  }
}







