import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/coin_model.dart';
import '../../../providers/providers.dart';
import '../../widgets/common/glass_container.dart';

class ExchangePage extends ConsumerStatefulWidget {
  const ExchangePage({super.key});

  @override
  ConsumerState<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends ConsumerState<ExchangePage> {
  bool _isBuyMode = true;
  CoinModel? _fromCoin;
  CoinModel? _toCoin;
  final _fromController = TextEditingController(text: '1.0');
  final _toController = TextEditingController();
  
  double get _exchangeRate {
    if (_fromCoin == null || _toCoin == null) return 0;
    final fromPrice = _fromCoin!.currentPrice ?? 0;
    final toPrice = _toCoin!.currentPrice ?? 0;
    if (toPrice == 0) return 0;
    return fromPrice / toPrice;
  }

  double get _estimatedFee => 0.015; // 1.5% fee

  @override
  void initState() {
    super.initState();
    _fromController.addListener(_updateToAmount);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _updateToAmount() {
    if (_fromCoin != null && _toCoin != null) {
      final fromAmount = double.tryParse(_fromController.text) ?? 0;
      final toAmount = fromAmount * _exchangeRate * (1 - _estimatedFee);
      _toController.text = toAmount.toStringAsFixed(8);
    }
  }

  void _swapCoins() {
    setState(() {
      final temp = _fromCoin;
      _fromCoin = _toCoin;
      _toCoin = temp;
      _updateToAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final coinsAsync = ref.watch(coinsProvider);

    // Set default coins if not set
    coinsAsync.whenData((coins) {
      if (_fromCoin == null && coins.isNotEmpty) {
        _fromCoin = coins.firstWhere(
          (c) => c.symbol.toLowerCase() == 'btc',
          orElse: () => coins.first,
        );
      }
      if (_toCoin == null && coins.length > 1) {
        _toCoin = coins.firstWhere(
          (c) => c.symbol.toLowerCase() == 'eth',
          orElse: () => coins[1],
        );
        _updateToAmount();
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F14),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildBuySellToggle(),
                      const SizedBox(height: 24),
                      _buildFromSection(coinsAsync),
                      _buildSwapButton(),
                      _buildToSection(coinsAsync),
                      const SizedBox(height: 24),
                      _buildExchangeDetails(),
                      const SizedBox(height: 24),
                      _buildExchangeButton(),
                      const SizedBox(height: 24),
                      _buildPriceInfo(),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Exchange',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildBuySellToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isBuyMode = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: _isBuyMode
                      ? LinearGradient(
                          colors: [
                            AppColors.success,
                            AppColors.success.withValues(alpha: 0.8),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isBuyMode
                      ? [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'BUY',
                    style: TextStyle(
                      color: _isBuyMode ? Colors.white : AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isBuyMode = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: !_isBuyMode
                      ? LinearGradient(
                          colors: [
                            AppColors.error,
                            AppColors.error.withValues(alpha: 0.8),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !_isBuyMode
                      ? [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'SELL',
                    style: TextStyle(
                      color: !_isBuyMode ? Colors.white : AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildFromSection(AsyncValue<List<CoinModel>> coinsAsync) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'From',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                'Balance: ${_fromCoin != null ? '10.5 ${_fromCoin!.symbol.toUpperCase()}' : '-'}',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: () => _showCoinSelector(context, coinsAsync, true),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (_fromCoin?.image != null)
                        ClipOval(
                          child: Image.network(
                            _fromCoin!.image!,
                            width: 28,
                            height: 28,
                            errorBuilder: (_, error, stack) => Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _fromCoin?.symbol[0].toUpperCase() ?? '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        _fromCoin?.symbol.toUpperCase() ?? 'Select',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _fromController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.0',
                    hintStyle: TextStyle(color: AppColors.textTertiary),
                  ),
                ),
              ),
            ],
          ),
          if (_fromCoin != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '≈ \$${Formatters.formatPrice((double.tryParse(_fromController.text) ?? 0) * (_fromCoin!.currentPrice ?? 0))}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildSwapButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _swapCoins,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.swap_vert,
            color: Colors.white,
            size: 24,
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1000.ms),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms).scale();
  }

  Widget _buildToSection(AsyncValue<List<CoinModel>> coinsAsync) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'To',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                'Balance: ${_toCoin != null ? '5.0 ${_toCoin!.symbol.toUpperCase()}' : '-'}',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: () => _showCoinSelector(context, coinsAsync, false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (_toCoin?.image != null)
                        ClipOval(
                          child: Image.network(
                            _toCoin!.image!,
                            width: 28,
                            height: 28,
                            errorBuilder: (_, error, stack) => Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _toCoin?.symbol[0].toUpperCase() ?? '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        _toCoin?.symbol.toUpperCase() ?? 'Select',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _toController,
                  readOnly: true,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.0',
                    hintStyle: TextStyle(color: AppColors.textTertiary),
                  ),
                ),
              ),
            ],
          ),
          if (_toCoin != null && _toController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '≈ \$${Formatters.formatPrice((double.tryParse(_toController.text) ?? 0) * (_toCoin!.currentPrice ?? 0))}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildExchangeDetails() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        children: [
          _buildDetailRow(
            'Exchange Rate',
            _fromCoin != null && _toCoin != null
                ? '1 ${_fromCoin!.symbol.toUpperCase()} = ${_exchangeRate.toStringAsFixed(8)} ${_toCoin!.symbol.toUpperCase()}'
                : '-',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'Network Fee',
            '\$2.50',
            valueColor: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'Exchange Fee (${(_estimatedFee * 100).toStringAsFixed(1)}%)',
            _fromCoin != null
                ? '\$${Formatters.formatPrice((double.tryParse(_fromController.text) ?? 0) * (_fromCoin!.currentPrice ?? 0) * _estimatedFee)}'
                : '-',
            valueColor: AppColors.warning,
          ),
          const Divider(color: AppColors.glassBorder, height: 24),
          _buildDetailRow(
            'You will receive',
            _toCoin != null
                ? '${_toController.text} ${_toCoin!.symbol.toUpperCase()}'
                : '-',
            isHighlighted: true,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 500.ms);
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isHighlighted ? 14 : 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? (isHighlighted ? AppColors.success : AppColors.textPrimary),
            fontSize: isHighlighted ? 16 : 14,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildExchangeButton() {
    final canExchange = _fromCoin != null && 
                        _toCoin != null && 
                        (double.tryParse(_fromController.text) ?? 0) > 0;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canExchange ? _performExchange : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: _isBuyMode ? AppColors.success : AppColors.error,
          disabledBackgroundColor: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          _isBuyMode ? 'BUY NOW' : 'SELL NOW',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
    );
  }

  Widget _buildPriceInfo() {
    if (_fromCoin == null || _toCoin == null) return const SizedBox();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Prices are indicative. Final rate will be confirmed at the time of exchange.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 700.ms);
  }

  void _showCoinSelector(
    BuildContext context,
    AsyncValue<List<CoinModel>> coinsAsync,
    bool isFrom,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Select ${isFrom ? 'From' : 'To'} Coin',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: coinsAsync.when(
                data: (coins) => ListView.builder(
                  itemCount: coins.length,
                  itemBuilder: (context, index) {
                    final coin = coins[index];
                    final isSelected = isFrom 
                        ? coin.id == _fromCoin?.id 
                        : coin.id == _toCoin?.id;
                    
                    return ListTile(
                      leading: coin.image != null
                          ? ClipOval(
                              child: Image.network(
                                coin.image!,
                                width: 40,
                                height: 40,
                                errorBuilder: (_, error, stack) => Container(
                                  width: 40,
                                  height: 40,
                                  color: AppColors.primary,
                                  child: Center(
                                    child: Text(
                                      coin.symbol[0].toUpperCase(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  coin.symbol[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                      title: Text(coin.name),
                      subtitle: Text(
                        '${coin.symbol.toUpperCase()} • \$${Formatters.formatPrice(coin.currentPrice ?? 0)}',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                      onTap: () {
                        setState(() {
                          if (isFrom) {
                            _fromCoin = coin;
                          } else {
                            _toCoin = coin;
                          }
                          _updateToAmount();
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performExchange() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Exchange Successful!',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You exchanged ${_fromController.text} ${_fromCoin?.symbol.toUpperCase()} for ${_toController.text} ${_toCoin?.symbol.toUpperCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _fromController.text = '1.0';
                  _updateToAmount();
                },
                child: const Text('DONE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
