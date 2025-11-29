import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  void _searchCep() {
    if (_formKey.currentState!.validate()) {
      context.read<AddressBloc>().add(GetAddressForCep(_cepController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _cepController,
            decoration: const InputDecoration(
              labelText: 'CEP',
              hintText: '00000-000',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
              _CepInputFormatter(),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite um CEP';
              }
              final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (cleanValue.length != 8) {
                return 'CEP deve conter 8 dígitos';
              }
              return null;
            },
            onFieldSubmitted: (_) => _searchCep(),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _searchCep,
            icon: const Icon(Icons.search),
            label: const Text('Buscar'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length <= 5) {
      return newValue;
    }

    final buffer = StringBuffer();
    buffer.write(text.substring(0, 5));
    buffer.write('-');
    buffer.write(text.substring(5));

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
