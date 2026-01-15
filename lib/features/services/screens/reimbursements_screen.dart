import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Reembolsos
/// Subida de facturas y seguimiento de solicitudes
class ReimbursementsScreen extends StatefulWidget {
  const ReimbursementsScreen({super.key});

  @override
  State<ReimbursementsScreen> createState() => _ReimbursementsScreenState();
}

class _ReimbursementsScreenState extends State<ReimbursementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Reembolsos'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey400,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'En proceso'),
            Tab(text: 'Aprobados'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewReimbursement(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nueva solicitud'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInProgressTab(),
          _buildApprovedTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildInProgressTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Resumen de montos
        CustomCard(
          gradient: AppColors.primaryGradient,
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'En revisión',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '\$485.00',
                      style: AppTextStyles.h3.copyWith(color: AppColors.white),
                    ),
                    Text(
                      '2 solicitudes pendientes',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.hourglass_empty,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        _ReimbursementCard(
          id: 'RMB-2024-0012',
          concept: 'Consulta Médica General',
          provider: 'Centro Médico Plus',
          amount: 150.00,
          date: '10 Ene 2025',
          status: 'En revisión',
          progress: 0.5,
          onTap: () => _showReimbursementDetails(context),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ReimbursementCard(
          id: 'RMB-2024-0011',
          concept: 'Exámenes de Laboratorio',
          provider: 'Laboratorio Clínico',
          amount: 335.00,
          date: '8 Ene 2025',
          status: 'Documentación pendiente',
          progress: 0.25,
          hasWarning: true,
          warningMessage: 'Falta adjuntar receta médica',
          onTap: () => _showReimbursementDetails(context),
        ),
      ],
    );
  }

  Widget _buildApprovedTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        CustomCard(
          gradient: LinearGradient(
            colors: [
              AppColors.success.withValues(alpha: 0.1),
              AppColors.successLight.withValues(alpha: 0.3),
            ],
          ),
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pendiente de pago',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      '\$780.00',
                      style: AppTextStyles.h3.copyWith(color: AppColors.success),
                    ),
                    Text(
                      'Depósito estimado: 15-17 Ene',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        _ApprovedReimbursementCard(
          id: 'RMB-2024-0010',
          concept: 'Medicamentos',
          approvedAmount: 280.00,
          requestedAmount: 320.00,
          approvalDate: '5 Ene 2025',
          paymentDate: '15 Ene 2025',
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ApprovedReimbursementCard(
          id: 'RMB-2024-0009',
          concept: 'Consulta Especialista',
          approvedAmount: 500.00,
          requestedAmount: 500.00,
          approvalDate: '3 Ene 2025',
          paymentDate: '15 Ene 2025',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Resumen anual
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resumen 2024', style: AppTextStyles.h6),
              const SizedBox(height: AppConstants.spacingMd),
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'Total solicitado',
                      value: '\$3,450',
                      color: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Total reembolsado',
                      value: '\$2,980',
                      color: AppColors.success,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Solicitudes',
                      value: '12',
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        const SectionHeader(title: 'Historial completo'),
        const SizedBox(height: AppConstants.spacingMd),

        _HistoryReimbursementCard(
          id: 'RMB-2024-0008',
          concept: 'Hospitalización',
          amount: 1500.00,
          reimbursedAmount: 1350.00,
          date: '15 Dic 2024',
          status: 'Pagado',
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryReimbursementCard(
          id: 'RMB-2024-0007',
          concept: 'Terapia Física',
          amount: 200.00,
          reimbursedAmount: 160.00,
          date: '1 Dic 2024',
          status: 'Pagado',
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryReimbursementCard(
          id: 'RMB-2024-0006',
          concept: 'Consulta Dental',
          amount: 180.00,
          reimbursedAmount: 0,
          date: '20 Nov 2024',
          status: 'Rechazado',
          rejectionReason: 'Servicio no cubierto por el plan',
          onTap: () {},
        ),
      ],
    );
  }

  void _showNewReimbursement(BuildContext context) {
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
                    Text('Nueva solicitud', style: AppTextStyles.h5),
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
                    // Tipo de reembolso
                    Text('Tipo de gasto', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TypeChip(label: 'Consulta médica', isSelected: true),
                        _TypeChip(label: 'Medicamentos', isSelected: false),
                        _TypeChip(label: 'Laboratorio', isSelected: false),
                        _TypeChip(label: 'Hospitalización', isSelected: false),
                        _TypeChip(label: 'Terapias', isSelected: false),
                        _TypeChip(label: 'Otro', isSelected: false),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Monto
                    Text('Monto total', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        hintText: '0.00',
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Proveedor
                    Text('Proveedor de salud', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Nombre del centro o médico',
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Fecha
                    Text('Fecha del servicio', style: AppTextStyles.labelLarge),
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

                    // Documentos
                    Text('Documentos requeridos', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    _DocumentUploadCard(
                      title: 'Factura o recibo',
                      isRequired: true,
                      isUploaded: false,
                      onUpload: () {},
                    ),
                    const SizedBox(height: 8),
                    _DocumentUploadCard(
                      title: 'Receta médica',
                      isRequired: true,
                      isUploaded: false,
                      onUpload: () {},
                    ),
                    const SizedBox(height: 8),
                    _DocumentUploadCard(
                      title: 'Informe médico',
                      isRequired: false,
                      isUploaded: false,
                      onUpload: () {},
                    ),

                    const SizedBox(height: AppConstants.spacingXl),
                    CustomButton(
                      text: 'Enviar solicitud',
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

  void _showReimbursementDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
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
                  Text('RMB-2024-0012', style: AppTextStyles.h5),
                  StatusBadge(text: 'En revisión', type: StatusType.warning),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // Progreso
              _ProgressTimeline(),
              const SizedBox(height: AppConstants.spacingLg),

              const Divider(),
              _DetailRow(label: 'Concepto', value: 'Consulta Médica General'),
              const Divider(),
              _DetailRow(label: 'Proveedor', value: 'Centro Médico Plus'),
              const Divider(),
              _DetailRow(label: 'Fecha del servicio', value: '10 Ene 2025'),
              const Divider(),
              _DetailRow(label: 'Monto solicitado', value: '\$150.00'),
              const Divider(),

              const SizedBox(height: AppConstants.spacingLg),
              Text('Documentos adjuntos', style: AppTextStyles.h6),
              const SizedBox(height: AppConstants.spacingSm),
              _AttachedDocument(name: 'factura_consulta.pdf', size: '245 KB'),
              _AttachedDocument(name: 'receta_medica.jpg', size: '1.2 MB'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReimbursementCard extends StatelessWidget {
  final String id;
  final String concept;
  final String provider;
  final double amount;
  final String date;
  final String status;
  final double progress;
  final bool hasWarning;
  final String? warningMessage;
  final VoidCallback onTap;

  const _ReimbursementCard({
    required this.id,
    required this.concept,
    required this.provider,
    required this.amount,
    required this.date,
    required this.status,
    required this.progress,
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
              Text(id, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
              StatusBadge(
                text: status,
                type: hasWarning ? StatusType.error : StatusType.warning,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(concept, style: AppTextStyles.bodyLarge),
          Text(
            provider,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppConstants.spacingMd),
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
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: AppTextStyles.h5.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApprovedReimbursementCard extends StatelessWidget {
  final String id;
  final String concept;
  final double approvedAmount;
  final double requestedAmount;
  final String approvalDate;
  final String paymentDate;
  final VoidCallback onTap;

  const _ApprovedReimbursementCard({
    required this.id,
    required this.concept,
    required this.approvedAmount,
    required this.requestedAmount,
    required this.approvalDate,
    required this.paymentDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFullAmount = approvedAmount == requestedAmount;

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
              StatusBadge(
                text: isFullAmount ? 'Aprobado 100%' : 'Aprobado parcial',
                type: StatusType.success,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(concept, style: AppTextStyles.bodyLarge),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solicitado',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                    ),
                    Text('\$${requestedAmount.toStringAsFixed(2)}', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aprobado',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                    ),
                    Text(
                      '\$${approvedAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.h5.copyWith(color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.grey400),
              const SizedBox(width: 4),
              Text(
                'Depósito: $paymentDate',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryReimbursementCard extends StatelessWidget {
  final String id;
  final String concept;
  final double amount;
  final double reimbursedAmount;
  final String date;
  final String status;
  final String? rejectionReason;
  final VoidCallback onTap;

  const _HistoryReimbursementCard({
    required this.id,
    required this.concept,
    required this.amount,
    required this.reimbursedAmount,
    required this.date,
    required this.status,
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
                width: 40,
                height: 40,
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
                    Text(concept, style: AppTextStyles.bodyMedium),
                    Text(
                      '$id • $date',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isRejected)
                    Text(
                      '\$${reimbursedAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    isRejected ? 'Rechazado' : 'Pagado',
                    style: AppTextStyles.caption.copyWith(
                      color: isRejected ? AppColors.error : AppColors.success,
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
        Text(value, style: AppTextStyles.h5.copyWith(color: color)),
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
  final String label;
  final bool isSelected;

  const _TypeChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: isSelected ? AppColors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _DocumentUploadCard extends StatelessWidget {
  final String title;
  final bool isRequired;
  final bool isUploaded;
  final VoidCallback onUpload;

  const _DocumentUploadCard({
    required this.title,
    required this.isRequired,
    required this.isUploaded,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpload,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isUploaded ? AppColors.successLight : AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded ? AppColors.success : AppColors.grey200,
            style: isUploaded ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isUploaded ? Icons.check_circle : Icons.upload_file,
              color: isUploaded ? AppColors.success : AppColors.grey400,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTextStyles.bodyMedium),
                      if (isRequired) ...[
                        const SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AppColors.error)),
                      ],
                    ],
                  ),
                  Text(
                    isUploaded ? 'Archivo cargado' : 'Toca para subir',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimelineItem(
          title: 'Solicitud enviada',
          subtitle: '10 Ene 2025, 2:30 PM',
          isCompleted: true,
          isFirst: true,
        ),
        _TimelineItem(
          title: 'En revisión',
          subtitle: 'Verificando documentos',
          isCompleted: false,
          isCurrent: true,
        ),
        _TimelineItem(
          title: 'Aprobación',
          subtitle: 'Pendiente',
          isCompleted: false,
        ),
        _TimelineItem(
          title: 'Pago procesado',
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
            name.endsWith('.pdf') ? Icons.picture_as_pdf : Icons.image,
            color: name.endsWith('.pdf') ? AppColors.error : AppColors.secondary,
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
          IconButton(
            icon: const Icon(Icons.download, size: 20),
            color: AppColors.primary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
