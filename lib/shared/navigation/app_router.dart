import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/pin_screen.dart';
import '../../features/auth/screens/recover_pin_screen.dart';
import '../../features/registration/screens/personal_info_screen.dart';
import '../../features/registration/screens/contact_info_screen.dart';
import '../../features/registration/screens/address_info_screen.dart';
import '../../features/registration/screens/pin_setup_screen.dart';
import '../../features/registration/screens/plan_selection_screen.dart';
import '../../features/registration/screens/payment_checkout_screen.dart';
import '../../features/registration/screens/payment_success_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/services/screens/telemedicine_screen.dart';
import '../../features/services/screens/pharmacy_screen.dart';
import '../../features/services/screens/pharmacy_payment_methods_screen.dart';
import '../../features/services/screens/pharmacy_payment_process_screen.dart';
import '../../features/services/screens/pharmacy_payment_success_screen.dart';
import '../../features/services/screens/appointments_screen.dart';
import '../../features/services/screens/directory_screen.dart';
import '../../features/services/screens/exams_screen.dart';
import '../../features/services/screens/reimbursements_screen.dart';
import '../../features/services/screens/authorizations_screen.dart';
import '../../features/services/screens/claims_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/emergency/screens/emergency_screen.dart';
import '../../features/benefits/screens/benefits_screen.dart';
import '../../features/insurance/screens/insurance_details_screen.dart';
import '../../features/insurance/screens/qr_scanner_screen.dart';
import '../../features/insurance/screens/qr_scan_result_screen.dart';
import '../../shared/models/registration_data_model.dart';
import '../../shared/models/insurance_plan_model.dart';
import '../../shared/models/payment_details_model.dart';
import '../widgets/main_shell.dart';

/// Configuración del router de la aplicación
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      // Rutas de autenticación (sin shell)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/pin',
        builder: (context, state) => const PinScreen(),
      ),
      GoRoute(
        path: '/recover-pin',
        builder: (context, state) => const RecoverPinScreen(),
      ),

      // Rutas de registro (sin shell)
      GoRoute(
        path: '/register/personal',
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: '/register/contact',
        builder: (context, state) {
          final registrationData = state.extra as RegistrationData;
          return ContactInfoScreen(registrationData: registrationData);
        },
      ),
      GoRoute(
        path: '/register/address',
        builder: (context, state) {
          final registrationData = state.extra as RegistrationData;
          return AddressInfoScreen(registrationData: registrationData);
        },
      ),
      GoRoute(
        path: '/register/pin-setup',
        builder: (context, state) {
          final registrationData = state.extra as RegistrationData;
          return PinSetupScreen(registrationData: registrationData);
        },
      ),

      // Rutas de selección de plan y pago (sin shell)
      GoRoute(
        path: '/plan-selection',
        builder: (context, state) {
          final registrationData = state.extra as RegistrationData?;
          return PlanSelectionScreen(registrationData: registrationData);
        },
      ),
      GoRoute(
        path: '/payment-checkout',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PaymentCheckoutScreen(
            plan: extra['plan'] as InsurancePlan,
            isAnnual: extra['isAnnual'] as bool,
            registrationData: extra['registrationData'] as RegistrationData?,
          );
        },
      ),
      GoRoute(
        path: '/payment-success',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PaymentSuccessScreen(
            paymentDetails: extra['paymentDetails'] as PaymentDetails,
            registrationData: extra['registrationData'] as RegistrationData?,
          );
        },
      ),

      // Shell con navegación inferior
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),

          // Servicios
          GoRoute(
            path: '/services',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ServicesListScreen(),
            ),
          ),

          // Actividad/Historial
          GoRoute(
            path: '/activity',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ActivityScreen(),
            ),
          ),

          // Perfil
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Pantallas de servicios (con animación de push)
      GoRoute(
        path: '/telemedicine',
        builder: (context, state) => const TelemedicineScreen(),
      ),
      GoRoute(
        path: '/pharmacy',
        builder: (context, state) => const PharmacyScreen(),
      ),
      GoRoute(
        path: '/pharmacy/payment-methods',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PharmacyPaymentMethodsScreen(
            totalAmount: extra['totalAmount'] as double,
            cartItems: extra['cartItems'] as List<Map<String, dynamic>>,
          );
        },
      ),
      GoRoute(
        path: '/pharmacy/payment-process',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PharmacyPaymentProcessScreen(
            paymentMethod: extra['paymentMethod'] as PaymentMethod,
            totalAmount: extra['totalAmount'] as double,
            cartItems: extra['cartItems'] as List<Map<String, dynamic>>,
          );
        },
      ),
      GoRoute(
        path: '/pharmacy/payment-success',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PharmacyPaymentSuccessScreen(
            orderId: extra['orderId'] as String,
            reference: extra['reference'] as String,
            totalAmount: extra['totalAmount'] as double,
            paymentMethod: extra['paymentMethod'] as String,
          );
        },
      ),
      GoRoute(
        path: '/appointments',
        builder: (context, state) => const AppointmentsScreen(),
      ),
      GoRoute(
        path: '/directory',
        builder: (context, state) => const DirectoryScreen(),
      ),
      GoRoute(
        path: '/exams',
        builder: (context, state) => const ExamsScreen(),
      ),
      GoRoute(
        path: '/reimbursements',
        builder: (context, state) => const ReimbursementsScreen(),
      ),
      GoRoute(
        path: '/authorizations',
        builder: (context, state) => const AuthorizationsScreen(),
      ),
      GoRoute(
        path: '/claims',
        builder: (context, state) => const ClaimsScreen(),
      ),

      // Otras pantallas
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/emergency',
        builder: (context, state) => const EmergencyScreen(),
      ),
      GoRoute(
        path: '/benefits',
        builder: (context, state) => const BenefitsScreen(),
      ),
      GoRoute(
        path: '/insurance-details',
        builder: (context, state) => const InsuranceDetailsScreen(),
      ),
      GoRoute(
        path: '/qr-scanner',
        builder: (context, state) => const QRScannerScreen(),
      ),
      GoRoute(
        path: '/qr-result',
        builder: (context, state) {
          final qrData = state.extra as String? ?? '';
          return QRScanResultScreen(qrData: qrData);
        },
      ),

      // Rutas de perfil
      GoRoute(
        path: '/plan-details',
        builder: (context, state) => const PlanDetailsScreen(),
      ),
      GoRoute(
        path: '/personal-data',
        builder: (context, state) => const PersonalDataScreen(),
      ),
      GoRoute(
        path: '/dependents',
        builder: (context, state) => const DependentsScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/payment-methods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/digital-card',
        builder: (context, state) => const DigitalCardScreen(),
      ),
      GoRoute(
        path: '/certificates',
        builder: (context, state) => const CertificatesScreen(),
      ),
      GoRoute(
        path: '/notification-settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/security-settings',
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
    ],
  );
}

/// Pantalla temporal de lista de servicios
class ServicesListScreen extends StatelessWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Servicios')),
    );
  }
}

/// Pantalla temporal de actividad
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Actividad')),
    );
  }
}

/// Pantalla temporal de detalles del plan
class PlanDetailsScreen extends StatelessWidget {
  const PlanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Detalles del Plan')),
    );
  }
}

/// Pantalla temporal de datos personales
class PersonalDataScreen extends StatelessWidget {
  const PersonalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Datos Personales')),
    );
  }
}

/// Pantalla temporal de dependientes
class DependentsScreen extends StatelessWidget {
  const DependentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Dependientes')),
    );
  }
}

/// Pantalla temporal de historial
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Historial de Uso')),
    );
  }
}

/// Pantalla temporal de métodos de pago
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Métodos de Pago')),
    );
  }
}

/// Pantalla temporal de carnet digital
class DigitalCardScreen extends StatelessWidget {
  const DigitalCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Carnet Digital')),
    );
  }
}

/// Pantalla temporal de certificados
class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Certificados')),
    );
  }
}

/// Pantalla temporal de configuración de notificaciones
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Configuración de Notificaciones')),
    );
  }
}

/// Pantalla temporal de configuración de seguridad
class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Seguridad')),
    );
  }
}

/// Pantalla temporal de soporte
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Ayuda y Soporte')),
    );
  }
}

/// Pantalla temporal de privacidad
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Privacidad')),
    );
  }
}
