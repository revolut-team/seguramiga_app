import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Autorizaciones Médicas
class AuthorizationsScreen extends StatefulWidget {
  const AuthorizationsScreen({super.key});

  @override
  State<AuthorizationsScreen> createState() => _AuthorizationsScreenState();
}

class _AuthorizationsScreenState extends State<AuthorizationsScreen>
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
        title: const Text('Autorizaciones'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey400,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'Aprobadas'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewAuthorization(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nueva solicitud'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingTab(),
          _buildApprovedTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildPendingTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        _AuthorizationCard(
          id: 'AUT-2024-0034',
          type: 'Procedimiento quirúrgico',
          procedure: 'Artroscopia de rodilla',
          doctor: 'Dr. Pedro Ramírez',
          requestDate: '12 Ene 2025',
          status: 'En revisión',
          estimatedResponse: '2-3 días hábiles',
          onTap: () => _showAuthorizationDetails(context),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _AuthorizationCard(
          id: 'AUT-2024-0033',
          type: 'Estudio diagnóstico',
          procedure: 'Resonancia magnética cerebral',
          doctor: 'Dra. Carmen López',
          requestDate: '10 Ene 2025',
          status: 'Información adicional requerida',
          hasWarning: true,
          warningMessage: 'Falta justificación médica detallada',
          onTap: () => _showAuthorizationDetails(context),
        ),
      ],
    );
  }

  Widget _buildApprovedTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        _ApprovedAuthorizationCard(
          id: 'AUT-2024-0032',
          type: 'Consulta especialista',
          procedure: 'Evaluación cardiológica',
          doctor: 'Dr. Carlos Rodríguez',
          approvalDate: '8 Ene 2025',
          validUntil: '8 Feb 2025',
          authorizationCode: 'AC-2024-78945',
          onTap: () {},
          onDownload: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ApprovedAuthorizationCard(
          id: 'AUT-2024-0031',
          type: 'Laboratorio',
          procedure: 'Panel tiroideo completo',
          doctor: 'Dra. María González',
          approvalDate: '5 Ene 2025',
          validUntil: '5 Feb 2025',
          authorizationCode: 'AC-2024-78890',
          onTap: () {},
          onDownload: () {},
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        _HistoryAuthorizationCard(
          id: 'AUT-2024-0030',
          type: 'Hospitalización',
          procedure: 'Cirugía de vesícula',
          date: '20 Dic 2024',
          status: 'Utilizada',
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryAuthorizationCard(
          id: 'AUT-2024-0029',
          type: 'Medicamento especial',
          procedure: 'Tratamiento biológico',
          date: '15 Dic 2024',
          status: 'Rechazada',
          rejectionReason: 'No cumple criterios de cobertura',
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryAuthorizationCard(
          id: 'AUT-2024-0028',
          type: 'Procedimiento',
          procedure: 'Endoscopia digestiva',
          date: '1 Dic 2024',
          status: 'Utilizada',
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryAuthorizationCard(
          id: 'AUT-2024-0027',
          type: 'Estudio',
          procedure: 'Tomografía computarizada',
          date: '25 Nov 2024',
          status: 'Expirada',
          onTap: () {},
        ),
      ],
    );
  }

  void _showNewAuthorization(BuildContext context) {
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
                    Text('Nueva autorización', style: AppTextStyles.h5),
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
                    // Tipo de autorización
                    Text('Tipo de autorización', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TypeChip(label: 'Procedimiento', isSelected: true),
                        _TypeChip(label: 'Cirugía', isSelected: false),
                        _TypeChip(label: 'Estudio', isSelected: false),
                        _TypeChip(label: 'Hospitalización', isSelected: false),
                        _TypeChip(label: 'Medicamento', isSelected: false),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Procedimiento
                    Text('Procedimiento o servicio', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Nombre del procedimiento',
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Médico
                    Text('Médico solicitante', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar médico',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Diagnóstico
                    Text('Diagnóstico', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Descripción del diagnóstico',
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Documentos
                    Text('Documentos de soporte', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingSm),
                    _DocumentUpload(
                      title: 'Orden médica',
                      isRequired: true,
                      onUpload: () {},
                    ),
                    const SizedBox(height: 8),
                    _DocumentUpload(
                      title: 'Historia clínica',
                      isRequired: true,
                      onUpload: () {},
                    ),
                    const SizedBox(height: 8),
                    _DocumentUpload(
                      title: 'Exámenes previos',
                      isRequired: false,
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

  void _showAuthorizationDetails(BuildContext context) {
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
                  Text('AUT-2024-0034', style: AppTextStyles.h5),
                  StatusBadge(text: 'En revisión', type: StatusType.warning),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // Info principal
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.medical_services, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Procedimiento quirúrgico', style: AppTextStyles.labelMedium),
                              Text(
                                'Artroscopia de rodilla',
                                style: AppTextStyles.h6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Timeline de estado
              _StatusTimeline(),
              const SizedBox(height: AppConstants.spacingLg),

              const Divider(),
              _DetailRow(label: 'Médico solicitante', value: 'Dr. Pedro Ramírez'),
              const Divider(),
              _DetailRow(label: 'Especialidad', value: 'Traumatología'),
              const Divider(),
              _DetailRow(label: 'Fecha de solicitud', value: '12 Ene 2025'),
              const Divider(),
              _DetailRow(label: 'Tiempo estimado', value: '2-3 días hábiles'),
              const Divider(),

              const SizedBox(height: AppConstants.spacingLg),
              Text('Documentos adjuntos', style: AppTextStyles.h6),
              const SizedBox(height: AppConstants.spacingSm),
              _AttachedDoc(name: 'orden_medica.pdf'),
              _AttachedDoc(name: 'historia_clinica.pdf'),
              _AttachedDoc(name: 'radiografia_rodilla.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthorizationCard extends StatelessWidget {
  final String id;
  final String type;
  final String procedure;
  final String doctor;
  final String requestDate;
  final String status;
  final String? estimatedResponse;
  final bool hasWarning;
  final String? warningMessage;
  final VoidCallback onTap;

  const _AuthorizationCard({
    required this.id,
    required this.type,
    required this.procedure,
    required this.doctor,
    required this.requestDate,
    required this.status,
    this.estimatedResponse,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              type,
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(procedure, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: AppColors.grey400),
              const SizedBox(width: 4),
              Text(
                doctor,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
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
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Solicitado: $requestDate',
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),
              if (estimatedResponse != null)
                Text(
                  'Respuesta: $estimatedResponse',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApprovedAuthorizationCard extends StatelessWidget {
  final String id;
  final String type;
  final String procedure;
  final String doctor;
  final String approvalDate;
  final String validUntil;
  final String authorizationCode;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const _ApprovedAuthorizationCard({
    required this.id,
    required this.type,
    required this.procedure,
    required this.doctor,
    required this.approvalDate,
    required this.validUntil,
    required this.authorizationCode,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(id, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                ],
              ),
              StatusBadge(text: 'Aprobada', type: StatusType.success),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(procedure, style: AppTextStyles.bodyLarge),
          Text(
            type,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Código de autorización
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Código de autorización',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: 4),
                Text(
                  authorizationCode,
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.grey400),
              const SizedBox(width: 4),
              Text(
                'Válido hasta: $validUntil',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onDownload,
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Descargar autorización'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryAuthorizationCard extends StatelessWidget {
  final String id;
  final String type;
  final String procedure;
  final String date;
  final String status;
  final String? rejectionReason;
  final VoidCallback onTap;

  const _HistoryAuthorizationCard({
    required this.id,
    required this.type,
    required this.procedure,
    required this.date,
    required this.status,
    this.rejectionReason,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getStatusColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_getStatusIcon(), color: _getStatusColor(), size: 22),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(procedure, style: AppTextStyles.bodyMedium),
                Text(
                  '$type • $date',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                ),
                if (rejectionReason != null)
                  Text(
                    rejectionReason!,
                    style: AppTextStyles.caption.copyWith(color: AppColors.error),
                  ),
              ],
            ),
          ),
          StatusBadge(
            text: status,
            type: _getStatusType(),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case 'Utilizada':
        return AppColors.success;
      case 'Rechazada':
        return AppColors.error;
      case 'Expirada':
        return AppColors.grey400;
      default:
        return AppColors.info;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'Utilizada':
        return Icons.check_circle;
      case 'Rechazada':
        return Icons.cancel;
      case 'Expirada':
        return Icons.schedule;
      default:
        return Icons.info;
    }
  }

  StatusType _getStatusType() {
    switch (status) {
      case 'Utilizada':
        return StatusType.success;
      case 'Rechazada':
        return StatusType.error;
      case 'Expirada':
        return StatusType.neutral;
      default:
        return StatusType.info;
    }
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

class _DocumentUpload extends StatelessWidget {
  final String title;
  final bool isRequired;
  final VoidCallback onUpload;

  const _DocumentUpload({
    required this.title,
    required this.isRequired,
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
            const Icon(Icons.upload_file, color: AppColors.grey400),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Text(title, style: AppTextStyles.bodyMedium),
                  if (isRequired) ...[
                    const SizedBox(width: 4),
                    Text('*', style: TextStyle(color: AppColors.error)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _TimelineStep(label: 'Enviado', isCompleted: true, isFirst: true),
          Expanded(child: _TimelineLine(isCompleted: true)),
          _TimelineStep(label: 'En revisión', isCompleted: false, isCurrent: true),
          Expanded(child: _TimelineLine(isCompleted: false)),
          _TimelineStep(label: 'Respuesta', isCompleted: false, isLast: true),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isCurrent;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.label,
    required this.isCompleted,
    this.isCurrent = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
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
            size: 16,
            color: isCompleted || isCurrent ? AppColors.white : AppColors.grey400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isCurrent ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _TimelineLine extends StatelessWidget {
  final bool isCompleted;

  const _TimelineLine({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted ? AppColors.success : AppColors.grey200,
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

class _AttachedDoc extends StatelessWidget {
  final String name;

  const _AttachedDoc({required this.name});

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
          Expanded(child: Text(name, style: AppTextStyles.bodySmall)),
          const Icon(Icons.visibility, size: 20, color: AppColors.grey400),
        ],
      ),
    );
  }
}
