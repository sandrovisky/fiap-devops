import 'package:flutter/material.dart';
import '../../domain/entities/address.dart';

class AddressDisplay extends StatelessWidget {
  final Address address;

  const AddressDisplay({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Endereço Encontrado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            _AddressField(label: 'CEP', value: _formatCep(address.cep)),
            const SizedBox(height: 12),
            _AddressField(label: 'Logradouro', value: address.logradouro),
            const SizedBox(height: 12),
            if (address.complemento.isNotEmpty) ...[
              _AddressField(label: 'Complemento', value: address.complemento),
              const SizedBox(height: 12),
            ],
            _AddressField(label: 'Bairro', value: address.bairro),
            const SizedBox(height: 12),
            _AddressField(label: 'Cidade', value: address.localidade),
            const SizedBox(height: 12),
            _AddressField(label: 'Estado', value: address.uf),
          ],
        ),
      ),
    );
  }

  String _formatCep(String cep) {
    if (cep.length == 8) {
      return '${cep.substring(0, 5)}-${cep.substring(5)}';
    }
    return cep;
  }
}

class _AddressField extends StatelessWidget {
  final String label;
  final String value;

  const _AddressField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? 'Não informado' : value,
          style: TextStyle(
            fontSize: 16,
            color: value.isEmpty ? Colors.grey : Colors.black87,
          ),
        ),
      ],
    );
  }
}
