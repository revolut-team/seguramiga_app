# Plan de Implementación: Flujo de Registro y Contratación de Seguro

## Estado Actual del Proyecto

**Última actualización:** 2026-01-15

### ✅ Completado

**Phase 1 - Foundation (Models & Constants):**
- ✅ `lib/shared/models/insurance_plan_model.dart`
- ✅ `lib/shared/models/registration_data_model.dart`
- ✅ `lib/shared/models/payment_details_model.dart`
- ✅ `lib/core/constants/venezuela_data.dart`

**Phase 2 - Shared Widgets:**
- ✅ `lib/features/registration/widgets/progress_indicator.dart`
- ✅ `lib/features/registration/widgets/form_field_wrapper.dart`
- ✅ `lib/features/registration/widgets/document_input_field.dart`
- ✅ `lib/features/registration/widgets/date_picker_field.dart`

**Phase 3 - Registration Screens:**
- ✅ `lib/features/registration/screens/personal_info_screen.dart`
- ✅ `lib/features/registration/screens/contact_info_screen.dart`
- ✅ `lib/features/registration/screens/address_info_screen.dart`
- ✅ `lib/features/registration/screens/pin_setup_screen.dart` (con fix de TextEditingController)

**Phase 6 - Integration (Parcial):**
- ✅ Modificado `lib/features/auth/screens/login_screen.dart` - Link de registro agregado
- ✅ Modificado `lib/shared/navigation/app_router.dart` - Rutas de registro agregadas
- ✅ Creado `assets/images/logo_horizontal_clean.svg` - Logo con colores correctos

### 🚧 Pendiente

**Phase 4 - Plan Selection Widgets & Screen:**
- ⏳ `lib/features/registration/widgets/coverage_item.dart`
- ⏳ `lib/features/registration/widgets/plan_comparison_card.dart`
- ⏳ `lib/features/registration/screens/plan_selection_screen.dart`

**Phase 5 - Payment Flow:**
- ⏳ `lib/features/registration/screens/payment_checkout_screen.dart`
- ⏳ `lib/features/registration/screens/payment_success_screen.dart`

**Phase 6 - Integration (Falta):**
- ⏳ Agregar rutas `/plan-selection`, `/payment-checkout`, `/payment-success` a `app_router.dart`
- ⏳ Actualizar `lib/shared/models/user_insurance_model.dart` mock con datos de pago

---

## Problemas Resueltos Recientemente

### 1. Logo sin color en Login Screen
**Problema:** El SVG original tenía efectos de filtro complejos que no se renderizaban correctamente.
**Solución:** Se creó `logo_horizontal_clean.svg` sin filtros, mostrando los colores correctamente (azul #1f4a7e y verde #71a433).

### 2. Layout crampeado en Login Screen
**Problema:** Espaciado insuficiente entre elementos.
**Solución:** Se mejoró el spacing usando `symmetric padding` y aumentando el tamaño del logo.

### 3. Error de TextEditingController en PIN Setup
**Problema:** `FlutterError (A TextEditingController was used after being disposed)`
**Solución:** Se implementaron tres capas de protección:
- Flag `_isNavigating` para prevenir actualizaciones durante navegación
- Limpiar controladores con `.clear()` antes de navegar
- Try-catch en el método `dispose()`
- Agregar `enabled: !_isNavigating` a los campos PIN

---

## Arquitectura del Flujo

```
Flujo de Registro (4 pantallas): ✅ COMPLETO
/register/personal → /register/contact → /register/address → /register/pin-setup

Flujo de Contratación (3 pantallas): ⏳ PENDIENTE
/plan-selection → /payment-checkout → /payment-success

Integración:
✅ Login screen tiene link "Crear cuenta"
✅ Al completar PIN setup → navega a selección de plan
⏳ Después de pago exitoso → navega a /home con plan activo
```

---

## Próximos Pasos para Tu Compañero

### 1. Continuar con Phase 4 - Plan Selection

Crear los siguientes archivos:

**`lib/features/registration/widgets/coverage_item.dart`**
- Widget simple que muestra un ítem de cobertura
- Row con ícono circular + nombre + límite
- Usar estilos de InfoCard

**`lib/features/registration/widgets/plan_comparison_card.dart`**
- Tarjeta vertical para mostrar un plan
- Badge "Recomendado" condicional
- Precio destacado (numberLarge style)
- Lista de features con checkmarks
- CustomButton "Seleccionar este plan"
- Border highlight si está seleccionado
- Toggle mensual/anual

**`lib/features/registration/screens/plan_selection_screen.dart`**
- Mostrar 3 planes: Básico, Estándar (recomendado), Premium
- Cada plan en una PlanComparisonCard
- State: `_selectedPlan` y `_isAnnual`
- Al seleccionar → push `/payment-checkout` con plan en extra

### 2. Datos de los Planes (Mock)

```dart
Plan Básico (Bs. 250/mes = ~$7.50):
- Consultas médicas ilimitadas
- Telemedicina 24/7
- Farmacia con 20% descuento
- Exámenes básicos
- Red nacional limitada

Plan Estándar (Bs. 500/mes = ~$15) [RECOMENDADO]:
- Todo lo del básico +
- Red nacional completa
- Descuento farmacia 40%
- Exámenes especializados
- Atención prioritaria
- Reembolsos hasta Bs. 3,000

Plan Premium (Bs. 850/mes = ~$25):
- Todo lo del estándar +
- Red internacional
- Descuento farmacia 60%
- Todos los exámenes incluidos
- Sin copagos
- Reembolsos hasta Bs. 10,000
- Servicio VIP
```

### 3. Phase 5 - Payment Flow

Crear:
- `payment_checkout_screen.dart` - Resumen del plan + datos personales + términos
- `payment_success_screen.dart` - Confirmación con número de orden

### 4. Agregar Rutas Faltantes

En `lib/shared/navigation/app_router.dart`, agregar:
```dart
GoRoute(
  path: '/plan-selection',
  name: 'plan-selection',
  builder: (context, state) => PlanSelectionScreen(
    registrationData: state.extra as RegistrationData?,
  ),
),
GoRoute(
  path: '/payment-checkout',
  name: 'payment-checkout',
  builder: (context, state) => PaymentCheckoutScreen(
    plan: (state.extra as Map)['plan'] as InsurancePlan,
    registrationData: (state.extra as Map)['registrationData'] as RegistrationData,
  ),
),
GoRoute(
  path: '/payment-success',
  name: 'payment-success',
  builder: (context, state) => PaymentSuccessScreen(
    paymentDetails: state.extra as PaymentDetails,
  ),
),
```

---

## Testing Manual Flow

Para verificar todo el flujo:

1. Abrir app → tap "Regístrate" en LoginScreen
2. Completar formulario Personal Info → verificar validaciones
3. Completar Contact Info → verificar email/teléfono
4. Completar Address Info → verificar dropdown de estados
5. Crear PIN → verificar match validation (el error de dispose está resuelto)
6. ⏳ Ver planes → seleccionar plan estándar
7. ⏳ Revisar checkout → marcar términos → procesar pago
8. ⏳ Ver confirmación → ir al inicio
9. ⏳ Verificar HomePage muestra plan activo

---

## Comandos Útiles

```bash
# Obtener los últimos cambios
git pull origin master

# Ver el estado del proyecto
flutter pub get
flutter analyze

# Ejecutar la app
flutter run

# Ver archivos modificados
git status

# Crear un commit
git add .
git commit -m "feat: implementar selección de planes"
git push origin master
```

---

## Patrones y Convenciones del Proyecto

### Navegación
- Usar GoRouter: `context.push()`, `context.go()`, `context.pushReplacement()`
- Pasar datos entre pantallas usando `extra` parameter

### State Management
- Actualmente usando StatefulWidget
- Provider está instalado pero no integrado aún

### Design System
**Colores:**
- Primary: `AppColors.primary` (#1A365D - azul oscuro)
- Secondary: `AppColors.secondary`
- Accent: `AppColors.accent`

**Typography:**
- Títulos: `AppTextStyles.h2`, `AppTextStyles.h3`, `AppTextStyles.h4`
- Body: `AppTextStyles.bodyMedium`
- Labels: `AppTextStyles.labelLarge`

**Spacing:**
- XS: `AppConstants.spacingXs` (12px)
- SM: `AppConstants.spacingSm` (16px)
- MD: `AppConstants.spacingMd` (24px)
- LG: `AppConstants.spacingLg` (32px)
- XL: `AppConstants.spacingXl` (40px)

**Widgets Reutilizables:**
- `CustomButton` - Botones con diferentes variantes
- `CustomCard` - Cards con shadow
- `InfoCard` - Cards informativos
- `StatusBadge` - Badges de estado
- `LoadingOverlay` - Overlay de carga

### Validaciones
- Usar GlobalKey<FormState> con TextFormField
- Validar en tiempo real con `onChanged`
- Mostrar errores con `validator`

### Widget Lifecycle
- Siempre verificar `mounted` antes de `setState()` en callbacks async
- Usar try-catch en `dispose()` para controladores
- Agregar flag `_isNavigating` para prevenir updates durante navegación

---

## Contacto y Dudas

Para cualquier duda sobre el código o el plan:
1. Revisar este archivo `PLAN.md`
2. Revisar `CLAUDE.md` para instrucciones generales del proyecto
3. Consultar los archivos ya implementados como referencia
4. El plan completo detallado está en el archivo de plan de Claude (si necesitas más detalles)

**Estructura de archivos relevantes:**
- Modelos: `lib/shared/models/`
- Pantallas de registro: `lib/features/registration/screens/`
- Widgets de registro: `lib/features/registration/widgets/`
- Navegación: `lib/shared/navigation/app_router.dart`
- Design system: `lib/core/theme/` y `lib/core/constants/`
