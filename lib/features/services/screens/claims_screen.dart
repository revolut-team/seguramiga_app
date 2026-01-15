import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Reclamos y Siniestros
class ClaimsScreen extends StatefulWidget {
  const ClaimsScreen({super.key});

  @override
  State<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends State<ClaimsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reclamos'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey400,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Activos'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewClaim(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo reclamo'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Resumen
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.pending_actions,
                label: 'En proceso',
                value: '2',
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.hourglass_empty,
                label: 'En espera',
                value: '1',
                color: AppColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingLg),

        _ClaimCard(
          id: 'CLM-2024-0015',
          type: 'Accidente',
          description: 'Accidente de tránsito - Lesión en brazo',
          date: '10 Ene 2025',
          status: 'En investigación',
          progress: 0.4,
          amount: 2500.00,
          onTap: () => _showClaimDetails(context),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ClaimCard(
          id: 'CLM-2024-0014',
          type: 'Enfermedad',
          description: 'Hospitalización por neumonía',
          date: '5 Ene 2025',
          status: 'Documentación en revisión',
          progress: 0.6,
          amount: 8500.00,
          onTap: () => _showClaimDetails(context),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ClaimCard(
          id: 'CLM-2024-0013',
          type: 'Robo/Pérdida',
          description: 'Pérdida de equipaje en viaje',
          date: '28 Dic 2024',
          status: 'Pendiente de información',
          progress: 0.2,
          amount: 1200.00,
          hasWarning: true,
          warningMessage: 'Se requiere denuncia policial',
          onTap: () => _showClaimDetails(context),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Estadísticas
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resumen histórico', style: AppTextStyles.h6),
              const SizedBox(height: AppConstants.spacingMd),
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'Total reclamos',
                      value: '8',
                      color: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Aprobados',
                      value: '6',
                      color: AppColors.success,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Rechazados',
                      value: '2',
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total indemnizado',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '\$24,500.00',
                    style: AppTextStyles.h4.copyWith(color: AppColors.success),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        const SectionHeader(title: 'Historial completo'),
        const SizedBox(height: AppConstants.spacingMd),

        _HistoryClaimCard(
          id: 'CLM-2024-0012',
          type: 'Accidente',
          description: 'Caída en el hogar',
          date: '15 Nov 2024',
          status: 'Pagado',
          amount: 3200.00,
          paidAmount: 3200.00,
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryClaimCard(
          id: 'CLM-2024-0011',
          type: 'Enfermedad',
          description: 'Cirugía de apéndice',
          date: '1 Oct 2024',
          status: 'Pagado',
          amount: 12000.00,
          paidAmount: 10800.00,
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryClaimCard(
          id: 'CLM-2024-0010',
          type: 'Robo',
          description: 'Robo de celular',
          date: '15 Sep 2024',
          status: 'Rechazado',
          amount: 800.00,
          paidAmount: 0,
          rejectionReason: 'Fuera del periodo de cobertura',
          onTap: () {},
        ),
      ],
    );
  }

  void _showNewClaim(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nuevo reclamo', style: AppTextStyles.h5),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  children: [
                    // Tipo de siniestro
                    Text('Tipo de siniestro', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TypeChip(
                          icon: Icons.car_crash,
                          label: 'Accidente',
                          isSelected: true,
                        ),
                        _TypeChip(
                          icon: Icons.local_hospital,
                          label: 'Enfermedad',
                          isSelected: false,
                        ),
                        _TypeChip(
                          icon: Icons.security,
                          label: 'Robo/Pérdida',
                          isSelected: false,
                        ),
                        _TypeChip(
                          icon: Icons.flight,
                          label: 'Viaje',
                          isSelected: false,
                        ),
                        _TypeChip(
                          icon: Icons.more_horiz,
                          label: 'Otro',
                          isSelected: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Fecha del incidente
                    Text('Fecha del incidente', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: 'Seleccionar fecha',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Descripción
                    Text('Descripción del incidente', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Describe detalladamente lo ocurrido...',
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Monto estimado
                    Text('Monto estimado de la pérdida', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        hintText: '0.00',
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Documentos
                    Text('Documentos de soporte', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    _DocumentUpload(
                      title: 'Fotos del incidente',
                      subtitle: 'Hasta 5 imágenes',
                      icon: Icons.photo_library,
                      onUpload: () {},
                    ),
                    const SizedBox(height: 8),
                    _DocumentUpload(
                      title: 'Denuncia o reporte',
                      subtitle: 'PDF o imagen',
                      icon: Icons.description,
                      onUpload: () {},
                    ),
                    const SizedBox(height: 8),
                    _DocumentUpload(
                      title: 'Facturas o recibos',
                      subtitle: 'Comprobantes de gastos',
                      icon: Icons.receipt,
                      onUpload: () {},
                    ),
                    const SizedBox(height: 8),
                    _DocumentUpload(
                      title: 'Informes médicos',
                      subtitle: 'Si aplica',
                      icon: Icons.medical_information,
                      onUpload: () {},
                    ),

                    const SizedBox(height: AppConstants.spacingXl),
                    CustomButton(
                      text: 'Enviar reclamo',
                      onPressed: () => Navigator.pop(context),
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClaimDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CLM-2024-0015', style: AppTextStyles.h5),
                  StatusBadge(text: 'En investigación', type: StatusType.warning),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // Info del siniestro
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.car_crash, color: AppColors.warning, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Accidente', style: AppTextStyles.labelMedium),
                          Text(
                            'Accidente de tránsito - Lesión en brazo',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Timeline detallado
              Text('Progreso del reclamo', style: AppTextStyles.h6),
              const SizedBox(height: AppConstants.spacingMd),
              _DetailedTimeline(),
              const SizedBox(height: AppConstants.spacingLg),

              const Divider(),
              _DetailRow(label: 'Fecha del incidente', value: '10 Ene 2025'),
              const Divider(),
              _DetailRow(label: 'Fecha de reporte', value: '10 Ene 2025'),
              const Divider(),
              _DetailRow(label: 'Monto reclamado', value: '\$2,500.00'),
              const Divider(),
              _DetailRow(label: 'Analista asignado', value: 'Juan Méndez'),
              const Divider(),

              const SizedBox(height: AppConstants.spacingLg),
              Text('Documentos', style: AppTextStyles.h6),
              const SizedBox(height: AppConstants.spacingSm),
              _AttachedDocument(name: 'fotos_accidente.zip', size: '4.2 MB'),
              _AttachedDocument(name: 'reporte_policial.pdf', size: '890 KB'),
              _AttachedDocument(name: 'informe_medico.pdf', size: '1.1 MB'),

              const SizedBox(height: AppConstants.spacingLg),
              Text('Comunicaciones', style: AppTextStyles.h6),
              const SizedBox(height: AppConstants.spacingSm),
              _MessageBubble(
                sender: 'Analista',
                message: 'Hemos recibido su reclamo. Estamos revisando la documentación.',
                time: '10 Ene, 3:45 PM',
                isFromCompany: true,
              ),
              _MessageBubble(
                sender: 'Usted',
                message: 'Gracias, quedo atento a cualquier información adicional que requieran.',
                time: '10 Ene, 4:20 PM',
                isFromCompany: false,
              ),
              const SizedBox(height: AppConstants.spacingMd),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Escribir mensaje...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.h4.copyWith(color: color)),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  final String id;
  final String type;
  final String description;
  final String date;
  final String status;
  final double progress;
  final double amount;
  final bool hasWarning;
  final String? warningMessage;
  final VoidCallback onTap;

  const _ClaimCard({
    required this.id,
    required this.type,
    required this.description,
    required this.date,
    required this.status,
    required this.progress,
    required this.amount,
    this.hasWarning = false,
    this.warningMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(id, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      type,
                      style: AppTextStyles.caption.copyWith(color: _getTypeColor()),
                    ),
                  ),
                ],
              ),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: AppTextStyles.h5.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(description, style: AppTextStyles.bodyLarge),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: hasWarning ? AppColors.warning : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.grey200,
                        valueColor: AlwaysStoppedAnimation(
                          hasWarning ? AppColors.warning : AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasWarning && warningMessage != null) ...[
            const SizedBox(height: AppConstants.spacingSm),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, size: 16, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warningMessage!,
                      style: AppTextStyles.caption.copyWith(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Reportado: $date',
            style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case 'Accidente':
        return AppColors.emergency;
      case 'Enfermedad':
        return AppColors.secondary;
      case 'Robo/Pérdida':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }
}

class _HistoryClaimCard extends StatelessWidget {
  final String id;
  final String type;
  final String description;
  final String date;
  final String status;
  final double amount;
  final double paidAmount;
  final String? rejectionReason;
  final VoidCallback onTap;

  const _HistoryClaimCard({
    required this.id,
    required this.type,
    required this.description,
    required this.date,
    required this.status,
    required this.amount,
    required this.paidAmount,
    this.rejectionReason,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRejected = status == 'Rechazado';

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isRejected
                      ? AppColors.error.withValues(alpha: 0.1)
                      : AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isRejected ? Icons.cancel : Icons.check_circle,
                  color: isRejected ? AppColors.error : AppColors.success,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description, style: AppTextStyles.bodyMedium),
                    Text(
                      '$type • $date',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reclamado',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                  ),
                  Text('\$${amount.toStringAsFixed(2)}', style: AppTextStyles.bodyMedium),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isRejected ? 'Rechazado' : 'Pagado',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                  ),
                  Text(
                    isRejected ? '-' : '\$${paidAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: isRejected ? AppColors.error : AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (rejectionReason != null) ...[
            const SizedBox(height: AppConstants.spacingSm),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, size: 16, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rejectionReason!,
                      style: AppTextStyles.caption.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h4.copyWith(color: color)),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _TypeChip({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? AppColors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentUpload extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onUpload;

  const _DocumentUpload({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpload,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.add_circle_outline, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _DetailedTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimelineItem(
          title: 'Reclamo recibido',
          subtitle: '10 Ene 2025, 2:30 PM',
          isCompleted: true,
          isFirst: true,
        ),
        _TimelineItem(
          title: 'Documentación revisada',
          subtitle: '11 Ene 2025, 10:00 AM',
          isCompleted: true,
        ),
        _TimelineItem(
          title: 'En investigación',
          subtitle: 'Analista asignado',
          isCompleted: false,
          isCurrent: true,
        ),
        _TimelineItem(
          title: 'Resolución',
          subtitle: 'Pendiente',
          isCompleted: false,
        ),
        _TimelineItem(
          title: 'Pago',
          subtitle: 'Pendiente',
          isCompleted: false,
          isLast: true,
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isCurrent = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success
                    : isCurrent
                        ? AppColors.primary
                        : AppColors.grey200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                size: 14,
                color: isCompleted || isCurrent ? AppColors.white : AppColors.grey400,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.success : AppColors.grey200,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: isLast ? 0 : 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _AttachedDocument extends StatelessWidget {
  final String name;
  final String size;

  const _AttachedDocument({required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            name.endsWith('.pdf')
                ? Icons.picture_as_pdf
                : name.endsWith('.zip')
                    ? Icons.folder_zip
                    : Icons.image,
            color: name.endsWith('.pdf')
                ? AppColors.error
                : name.endsWith('.zip')
                    ? AppColors.warning
                    : AppColors.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodySmall),
                Text(size, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
          const Icon(Icons.download, size: 20, color: AppColors.grey400),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final String time;
  final bool isFromCompany;

  const _MessageBubble({
    required this.sender,
    required this.message,
    required this.time,
    required this.isFromCompany,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            isFromCompany ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isFromCompany ? AppColors.grey100 : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: AppTextStyles.caption.copyWith(
                    color: isFromCompany ? AppColors.textSecondary : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
