import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Tasa BCV oficial del día
/// TODO: En producción, obtener esta tasa desde una API
const double _tasaBCV = 336.45;

/// Formatea un monto en bolívares
String _formatBs(double amountUSD) {
  final bs = amountUSD * _tasaBCV;
  final formatter = NumberFormat('#,##0.00', 'es_VE');
  return 'Bs. ${formatter.format(bs)}';
}

/// Modelo para un item del carrito
class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

/// Pantalla de Farmacia
/// Incluye catálogo de medicamentos, carrito y seguimiento de pedidos
class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, CartItem> _cartItems = {};

  int get _cartItemCount => _cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  double get _cartTotal => _cartItems.values.fold(0.0, (sum, item) => sum + item.total);

  void _addToCart({
    required String id,
    required String name,
    required String description,
    required double price,
    String? imageUrl,
  }) {
    setState(() {
      if (_cartItems.containsKey(id)) {
        _cartItems[id]!.quantity++;
      } else {
        _cartItems[id] = CartItem(
          id: id,
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
        );
      }
    });
  }

  void _updateQuantity(String id, int delta) {
    setState(() {
      if (_cartItems.containsKey(id)) {
        _cartItems[id]!.quantity += delta;
        if (_cartItems[id]!.quantity <= 0) {
          _cartItems.remove(id);
        }
      }
    });
  }

  void _removeFromCart(String id) {
    setState(() {
      _cartItems.remove(id);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  void _proceedToPayment(BuildContext context) {
    // Convertir cartItems a formato serializable para pasar por router
    final cartItemsData = _cartItems.values.map((item) {
      return {
        'id': item.id,
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'quantity': item.quantity,
        'imageUrl': item.imageUrl,
      };
    }).toList();

    context.push(
      '/pharmacy/payment-methods',
      extra: {
        'totalAmount': _cartTotal,
        'cartItems': cartItemsData,
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Farmacia'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => _showCart(context),
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.emergency,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador de tasa BCV
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingXs,
              ),
              color: AppColors.primary.withValues(alpha: 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.currency_exchange,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Tasa BCV: Bs. ${_tasaBCV.toStringAsFixed(2)} / \$1 USD',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar medicamentos...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {},
                  ),
                ),
              ),
            ),

            // Banner de envío gratis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              child: CustomCard(
                gradient: AppColors.accentGradient,
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping, color: AppColors.white, size: 32),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Envío gratis',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'En compras mayores a \$50',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Categorías
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              child: const SectionHeader(title: 'Categorías'),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
                children: [
                  _CategoryChip(
                    icon: Icons.medication,
                    label: 'Medicamentos',
                    color: AppColors.secondary,
                    onTap: () {},
                  ),
                  _CategoryChip(
                    icon: Icons.favorite,
                    label: 'Vitaminas',
                    color: AppColors.accentGreen,
                    onTap: () {},
                  ),
                  _CategoryChip(
                    icon: Icons.face,
                    label: 'Cuidado personal',
                    color: AppColors.accent,
                    onTap: () {},
                  ),
                  _CategoryChip(
                    icon: Icons.child_care,
                    label: 'Bebés',
                    color: AppColors.accentOrange,
                    onTap: () {},
                  ),
                  _CategoryChip(
                    icon: Icons.medical_services,
                    label: 'Primeros auxilios',
                    color: AppColors.emergency,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Pedidos activos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              child: const SectionHeader(
                title: 'Pedidos activos',
                actionText: 'Ver todos',
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              child: _OrderTrackingCard(
                orderId: '#ORD-2024-001',
                status: 'En camino',
                estimatedTime: '30-45 min',
                progress: 0.7,
                onTap: () {},
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Productos frecuentes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              child: const SectionHeader(
                title: 'Tus productos frecuentes',
                actionText: 'Ver más',
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
                children: [
                  _ProductCard(
                    name: 'Ibuprofeno 400mg',
                    description: 'Caja x 20 tabletas',
                    price: 12.50,
                    originalPrice: 15.00,
                    imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200&h=200&fit=crop',
                    onAddToCart: () => _addToCart(
                      id: 'ibuprofeno-400',
                      name: 'Ibuprofeno 400mg',
                      description: 'Caja x 20 tabletas',
                      price: 12.50,
                      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200&h=200&fit=crop',
                    ),
                  ),
                  _ProductCard(
                    name: 'Vitamina C 1000mg',
                    description: 'Frasco x 60 cápsulas',
                    price: 18.00,
                    imageUrl: 'https://images.unsplash.com/photo-1556227702-d1e4e7b5c232?w=200&h=200&fit=crop',
                    onAddToCart: () => _addToCart(
                      id: 'vitamina-c-1000',
                      name: 'Vitamina C 1000mg',
                      description: 'Frasco x 60 cápsulas',
                      price: 18.00,
                      imageUrl: 'https://images.unsplash.com/photo-1556227702-d1e4e7b5c232?w=200&h=200&fit=crop',
                    ),
                  ),
                  _ProductCard(
                    name: 'Acetaminofén 500mg',
                    description: 'Caja x 24 tabletas',
                    price: 8.50,
                    imageUrl: 'https://images.unsplash.com/photo-1550572017-edd951aa8f72?w=200&h=200&fit=crop',
                    onAddToCart: () => _addToCart(
                      id: 'acetaminofen-500',
                      name: 'Acetaminofén 500mg',
                      description: 'Caja x 24 tabletas',
                      price: 8.50,
                      imageUrl: 'https://images.unsplash.com/photo-1550572017-edd951aa8f72?w=200&h=200&fit=crop',
                    ),
                  ),
                  _ProductCard(
                    name: 'Omeprazol 20mg',
                    description: 'Caja x 14 cápsulas',
                    price: 22.00,
                    originalPrice: 25.00,
                    imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=200&h=200&fit=crop',
                    onAddToCart: () => _addToCart(
                      id: 'omeprazol-20',
                      name: 'Omeprazol 20mg',
                      description: 'Caja x 14 cápsulas',
                      price: 22.00,
                      imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=200&h=200&fit=crop',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
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
                    Text('Carrito ($_cartItemCount)', style: AppTextStyles.h5),
                    if (_cartItems.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          setState(() => _clearCart());
                          Navigator.of(context).pop();
                        },
                        child: const Text('Vaciar'),
                      ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: _cartItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: AppColors.grey300,
                            ),
                            const SizedBox(height: AppConstants.spacingMd),
                            Text(
                              'Tu carrito está vacío',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(AppConstants.spacingMd),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems.values.toList()[index];
                          return _CartItem(
                            name: item.name,
                            description: item.description,
                            price: item.price,
                            quantity: item.quantity,
                            imageUrl: item.imageUrl,
                            onIncrement: () {
                              setState(() {
                                _updateQuantity(item.id, 1);
                              });
                              Navigator.of(context).pop();
                              _showCart(context);
                            },
                            onDecrement: () {
                              setState(() {
                                _updateQuantity(item.id, -1);
                              });
                              if (_cartItems.isNotEmpty) {
                                Navigator.of(context).pop();
                                _showCart(context);
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            onRemove: () {
                              setState(() {
                                _removeFromCart(item.id);
                              });
                              if (_cartItems.isNotEmpty) {
                                Navigator.of(context).pop();
                                _showCart(context);
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey300.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: AppTextStyles.h5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${_cartTotal.toStringAsFixed(2)}',
                                style: AppTextStyles.h4,
                              ),
                              Text(
                                _formatBs(_cartTotal),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      CustomButton(
                        text: 'Proceder al pago',
                        onPressed: _cartItems.isEmpty
                            ? null
                            : () {
                                Navigator.of(context).pop();
                                _proceedToPayment(context);
                              },
                        isFullWidth: true,
                      ),
                    ],
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

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderTrackingCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String estimatedTime;
  final double progress;
  final VoidCallback onTap;

  const _OrderTrackingCard({
    required this.orderId,
    required this.status,
    required this.estimatedTime,
    required this.progress,
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
              Text(orderId, style: AppTextStyles.bodyLarge),
              StatusBadge(text: status, type: StatusType.info),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.grey200,
              valueColor: const AlwaysStoppedAnimation(AppColors.accentGreen),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColors.grey400),
              const SizedBox(width: 4),
              Text(
                'Llegada estimada: $estimatedTime',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String? imageUrl;
  final VoidCallback onAddToCart;

  const _ProductCard({
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                ),
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.grey400,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(
                            Icons.medication,
                            size: 48,
                            color: AppColors.grey400,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.medication,
                          size: 48,
                          color: AppColors.grey400,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (originalPrice != null)
                              Text(
                                '\$${originalPrice!.toStringAsFixed(2)}',
                                style: AppTextStyles.caption.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textTertiary,
                                  fontSize: 10,
                                ),
                              ),
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              _formatBs(price),
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String? imageUrl;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItem({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.imageUrl,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.grey200,
              ),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.grey400,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.medication,
                        color: AppColors.grey400,
                        size: 28,
                      ),
                    )
                  : Icon(
                      Icons.medication,
                      color: AppColors.grey400,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Precio unitario y total
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)} c/u',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      _formatBs(subtotal),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Controles de cantidad
          Column(
            children: [
              // Botón eliminar
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 20,
              ),
              const SizedBox(height: 8),
              // Controles +/-
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Botón +
                    InkWell(
                      onTap: onIncrement,
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    // Cantidad
                    Container(
                      width: 32,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.grey300),
                          bottom: BorderSide(color: AppColors.grey300),
                        ),
                      ),
                      child: Text(
                        '$quantity',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Botón -
                    InkWell(
                      onTap: onDecrement,
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.remove,
                          size: 18,
                          color: quantity > 1 ? AppColors.primary : AppColors.grey400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
