import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Exámenes Médicos
/// Lectura y carga de exámenes médicos
class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen>
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
        title: const Text('Exámenes Médicos'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey400,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Mis Exámenes'),
            Tab(text: 'Pendientes'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadOptions(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.upload_file),
        label: const Text('Subir examen'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyExamsTab(),
          _buildPendingTab(),
        ],
      ),
    );
  }

  Widget _buildMyExamsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Resumen de exámenes
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.folder,
                label: 'Total',
                value: '24',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.check_circle,
                label: 'Normales',
                value: '20',
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.warning,
                label: 'Atención',
                value: '4',
                color: AppColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingLg),

        const SectionHeader(
          title: 'Recientes',
          actionText: 'Ver todos',
        ),
        const SizedBox(height: AppConstants.spacingMd),

        _ExamCard(
          title: 'Hemograma Completo',
          category: 'Laboratorio',
          date: '10 Ene 2025',
          status: 'Normal',
          doctor: 'Dr. Luis Pérez',
          onTap: () => _showExamDetails(context),
          onDownload: () {},
          onShare: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ExamCard(
          title: 'Perfil Lipídico',
          category: 'Laboratorio',
          date: '10 Ene 2025',
          status: 'Atención',
          statusDetail: 'Colesterol elevado',
          doctor: 'Dr. Luis Pérez',
          onTap: () => _showExamDetails(context),
          onDownload: () {},
          onShare: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ExamCard(
          title: 'Radiografía de Tórax',
          category: 'Imagen',
          date: '5 Ene 2025',
          status: 'Normal',
          doctor: 'Dra. Carmen López',
          onTap: () => _showExamDetails(context),
          onDownload: () {},
          onShare: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ExamCard(
          title: 'Electrocardiograma',
          category: 'Cardiología',
          date: '3 Ene 2025',
          status: 'Normal',
          doctor: 'Dr. Carlos Rodríguez',
          onTap: () => _showExamDetails(context),
          onDownload: () {},
          onShare: () {},
        ),

        const SizedBox(height: AppConstants.spacingLg),
        const SectionHeader(title: 'Por categoría'),
        const SizedBox(height: AppConstants.spacingMd),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _CategoryCard(
              icon: Icons.science,
              label: 'Laboratorio',
              count: 15,
              color: AppColors.secondary,
              onTap: () {},
            ),
            _CategoryCard(
              icon: Icons.image,
              label: 'Imagen',
              count: 5,
              color: AppColors.accent,
              onTap: () {},
            ),
            _CategoryCard(
              icon: Icons.favorite,
              label: 'Cardiología',
              count: 3,
              color: AppColors.emergency,
              onTap: () {},
            ),
            _CategoryCard(
              icon: Icons.folder_special,
              label: 'Otros',
              count: 1,
              color: AppColors.accentOrange,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildPendingTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Info card
        CustomCard(
          gradient: LinearGradient(
            colors: [
              AppColors.info.withValues(alpha: 0.1),
              AppColors.infoLight.withValues(alpha: 0.3),
            ],
          ),
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.info, color: AppColors.info),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Exámenes ordenados', style: AppTextStyles.bodyLarge),
                    Text(
                      'Estos exámenes fueron solicitados por tus médicos',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        _PendingExamCard(
          title: 'Glucosa en ayunas',
          orderedBy: 'Dra. María González',
          orderedDate: '12 Ene 2025',
          dueDate: '26 Ene 2025',
          urgency: 'Normal',
          instructions: 'Ayuno de 8-12 horas antes del examen',
          onSchedule: () {},
          onViewLabs: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _PendingExamCard(
          title: 'TSH y T4 Libre',
          orderedBy: 'Dr. Carlos Rodríguez',
          orderedDate: '10 Ene 2025',
          dueDate: '24 Ene 2025',
          urgency: 'Prioritario',
          instructions: 'No requiere preparación especial',
          onSchedule: () {},
          onViewLabs: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _PendingExamCard(
          title: 'Ecografía Abdominal',
          orderedBy: 'Dra. María González',
          orderedDate: '8 Ene 2025',
          dueDate: '22 Ene 2025',
          urgency: 'Normal',
          instructions: 'Ayuno de 6 horas. Vejiga llena.',
          onSchedule: () {},
          onViewLabs: () {},
        ),
      ],
    );
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text('Subir examen', style: AppTextStyles.h5),
            const SizedBox(height: AppConstants.spacingLg),
            _UploadOption(
              icon: Icons.camera_alt,
              title: 'Tomar foto',
              subtitle: 'Fotografía el documento',
              onTap: () => Navigator.pop(context),
            ),
            _UploadOption(
              icon: Icons.photo_library,
              title: 'Galería',
              subtitle: 'Seleccionar de la galería',
              onTap: () => Navigator.pop(context),
            ),
            _UploadOption(
              icon: Icons.insert_drive_file,
              title: 'Archivo PDF',
              subtitle: 'Subir documento PDF',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppConstants.spacingMd),
          ],
        ),
      ),
    );
  }

  void _showExamDetails(BuildContext context) {
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
                  Text('Hemograma Completo', style: AppTextStyles.h5),
                  StatusBadge(text: 'Normal', type: StatusType.success),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Laboratorio • 10 Ene 2025',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Preview del documento
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf, size: 64, color: AppColors.error),
                      const SizedBox(height: 8),
                      Text('hemograma_enero_2025.pdf', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Información del examen
              const Divider(),
              _DetailRow(label: 'Médico solicitante', value: 'Dr. Luis Pérez'),
              const Divider(),
              _DetailRow(label: 'Laboratorio', value: 'Laboratorio Clínico Plus'),
              const Divider(),
              _DetailRow(label: 'Fecha de toma', value: '10 Ene 2025, 8:30 AM'),
              const Divider(),
              _DetailRow(label: 'Resultados', value: 'Dentro de rangos normales'),
              const Divider(),

              const SizedBox(height: AppConstants.spacingLg),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Descargar',
                      icon: Icons.download,
                      type: ButtonType.outline,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Compartir',
                      icon: Icons.share,
                      onPressed: () {},
                    ),
                  ),
                ],
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h4.copyWith(color: color)),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final String status;
  final String? statusDetail;
  final String doctor;
  final VoidCallback onTap;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  const _ExamCard({
    required this.title,
    required this.category,
    required this.date,
    required this.status,
    this.statusDetail,
    required this.doctor,
    required this.onTap,
    required this.onDownload,
    required this.onShare,
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
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getCategoryColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_getCategoryIcon(), color: _getCategoryColor(), size: 22),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyLarge),
                    Text(
                      '$category • $date',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                text: status,
                type: status == 'Normal' ? StatusType.success : StatusType.warning,
              ),
            ],
          ),
          if (statusDetail != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, size: 16, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Text(
                    statusDetail!,
                    style: AppTextStyles.caption.copyWith(color: AppColors.warning),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppConstants.spacingSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 14, color: AppColors.grey400),
                  const SizedBox(width: 4),
                  Text(
                    doctor,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.download, size: 20),
                    color: AppColors.grey500,
                    onPressed: onDownload,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, size: 20),
                    color: AppColors.grey500,
                    onPressed: onShare,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor() {
    switch (category) {
      case 'Laboratorio':
        return AppColors.secondary;
      case 'Imagen':
        return AppColors.accent;
      case 'Cardiología':
        return AppColors.emergency;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon() {
    switch (category) {
      case 'Laboratorio':
        return Icons.science;
      case 'Imagen':
        return Icons.image;
      case 'Cardiología':
        return Icons.favorite;
      default:
        return Icons.folder;
    }
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(label, style: AppTextStyles.bodyMedium),
            Text(
              '$count exámenes',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingExamCard extends StatelessWidget {
  final String title;
  final String orderedBy;
  final String orderedDate;
  final String dueDate;
  final String urgency;
  final String instructions;
  final VoidCallback onSchedule;
  final VoidCallback onViewLabs;

  const _PendingExamCard({
    required this.title,
    required this.orderedBy,
    required this.orderedDate,
    required this.dueDate,
    required this.urgency,
    required this.instructions,
    required this.onSchedule,
    required this.onViewLabs,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: AppTextStyles.bodyLarge)),
              StatusBadge(
                text: urgency,
                type: urgency == 'Prioritario' ? StatusType.warning : StatusType.info,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: AppColors.grey400),
              const SizedBox(width: 4),
              Text(
                'Ordenado por $orderedBy',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.grey400),
              const SizedBox(width: 4),
              Text(
                'Realizar antes del $dueDate',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    instructions,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewLabs,
                  child: const Text('Ver laboratorios'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSchedule,
                  child: const Text('Agendar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UploadOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
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
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
