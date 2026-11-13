import 'package:flutter/material.dart';

class AgendaCard extends StatelessWidget {
  final String time;
  final String clientName;
  final String address;
  final String status; // 'En curso' o 'Pendiente'

  const AgendaCard({
    super.key,
    required this.time,
    required this.clientName,
    required this.address,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isEnCurso = status == 'En curso';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isEnCurso ? Icons.circle : Icons.radio_button_unchecked,
                    size: 12,
                    color: isEnCurso ? const Color(0xFF00BFA5) : const Color(0xFF1E2746),
                  ),
                  const SizedBox(width: 8),
                  Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isEnCurso ? const Color(0xFFE0F2F1) : const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isEnCurso ? const Color(0xFF00796B) : const Color(0xFF1E88E5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            // Corregido: sintaxis correcta para espaciado izquierdo
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(address, style: const TextStyle(color: Colors.grey, fontSize: 13))),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}