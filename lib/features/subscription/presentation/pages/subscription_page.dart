import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionBloc()..add(const FetchSubscription()),
      child: const _SubscriptionView(),
    );
  }
}

class _SubscriptionView extends StatelessWidget {
  const _SubscriptionView();

  void _openUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listenWhen: (prev, curr) =>
          curr is SubscriptionLoaded && curr.actionUrl != null,
      listener: (context, state) {
        if (state is SubscriptionLoaded && state.actionUrl != null) {
          _openUrl(state.actionUrl!);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const AppTopBar(showBack: true),
              Expanded(
                child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
                  builder: (context, state) {
                    if (state is SubscriptionLoading ||
                        state is SubscriptionInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is SubscriptionCancelled) {
                      return const Center(child: Text('Suscripción cancelada'));
                    }
                    if (state is SubscriptionError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is SubscriptionLoaded) {
                      return _buildContent(context, state);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SubscriptionLoaded state) {
    final data = state.data;
    final isActionLoading = state.isActionLoading;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mi Suscripción',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gestiona tu plan actual, historial de pagos y\n'
            'métodos de facturación.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grayText,
            ),
          ),
          const SizedBox(height: 24),
          _buildCurrentPlanCard(context, data, isActionLoading),
          const SizedBox(height: 16),
          _buildBillingPortalCTA(context, isActionLoading),
          const SizedBox(height: 16),
          _buildPaymentHistory(data),
        ],
      ),
    );
  }

  void _onChangePlan(BuildContext context) {
    context.read<SubscriptionBloc>().add(
      const ChangePlanRequested(planType: 'PremiumIndividual', billingCycle: 'monthly'),
    );
  }

  void _onCancelSubscription(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Suscripción'),
        content: const Text('¿Estás seguro de que deseas cancelar tu suscripción?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<SubscriptionBloc>().add(
                const CancelSubscriptionRequested(reason: 'Solicitud del usuario'),
              );
            },
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanCard(BuildContext context, dynamic data, bool isActionLoading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFBDDEFE),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: const Color(0x3342617D),
                  ),
                ),
                child: const Text(
                  'Plan Actual',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF43627E),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0x1A10B981),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: const Color(0x3310B981),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 8, color: AppColors.green),
                    const SizedBox(width: 4),
                    Text(
                      data.status == 'Active' ? 'Activo' : data.status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.planName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                  letterSpacing: -0.96,
                ),
              ),
            ],
          ),
          if (data.billingCycle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Ciclo: ${data.billingCycle}',
                style: const TextStyle(fontSize: 14, color: AppColors.grayText),
              ),
            ),
          const SizedBox(height: 24),
          ...data.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 12, color: AppColors.green),
                    const SizedBox(width: 12),
                    Text(
                      f,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF161C23),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isActionLoading
                        ? null
                        : () => _onChangePlan(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isActionLoading
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Cambiar Plan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.14,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: isActionLoading
                        ? null
                        : () => _onCancelSubscription(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancelar Suscripción',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onOpenPortal(BuildContext context) {
    context.read<SubscriptionBloc>().add(
      const OpenPortalRequested(returnUrl: 'electrolink://portal/back'),
    );
  }

  Widget _buildBillingPortalCTA(BuildContext context, bool isActionLoading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E3A59),
            Color(0xFF182442),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0x33FFFFFF),
              ),
            ),
            child: const Icon(
              Icons.credit_card,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Portal de Facturación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Actualiza tu método de pago, descarga\n'
            'facturas PDF o modifica tu información\n'
            'fiscal de forma segura a través de Stripe.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xCCFFFFFF),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: isActionLoading ? null : () => _onOpenPortal(context),
              icon: isActionLoading
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_forward, size: 16),
              label: const Text('Ir a Stripe'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.darkNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory(dynamic data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Historial de Pagos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNavy,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver todo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF42617D),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios,
                        size: 8, color: Color(0xFF42617D)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...data.payments.map((p) => _buildPaymentRow(p)),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(dynamic payment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGray.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fecha:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grayText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payment.date,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF161C23),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monto:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grayText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${payment.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF161C23),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estado:',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grayText,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x1A10B981),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: const Color(0x3310B981),
                  ),
                ),
                child: const Text(
                  'Pagado',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Icon(
              Icons.more_horiz,
              size: 16,
              color: AppColors.darkNavy,
            ),
          ),
        ],
      ),
    );
  }
}
