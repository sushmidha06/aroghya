import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CommonWidgets {
  // Section Title Widget
  static Widget sectionTitle(String title, {double? fontSize}) {
    return Text(
      title,
      style: AppTheme.headingSmall.copyWith(
        fontSize: fontSize ?? AppTheme.headingSmall.fontSize,
      ),
    );
  }

  // Primary Button
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: AppTheme.primaryButtonStyle,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textOnPrimary),
                ),
              )
            : Icon(icon ?? Icons.arrow_forward),
        label: Text(text, style: AppTheme.bodyMedium.copyWith(color: AppTheme.textOnPrimary)),
      ),
    );
  }

  // Secondary Button
  static Widget secondaryButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: AppTheme.secondaryButtonStyle,
        icon: Icon(icon ?? Icons.arrow_forward),
        label: Text(text, style: AppTheme.bodyMedium),
      ),
    );
  }

  // Accent Button
  static Widget accentButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    IconData? icon,
    Color? backgroundColor,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: AppTheme.accentButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(backgroundColor ?? AppTheme.accentBlue),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textOnPrimary),
                ),
              )
            : Icon(icon ?? Icons.arrow_forward),
        label: Text(text, style: AppTheme.bodyMedium.copyWith(color: AppTheme.textOnPrimary)),
      ),
    );
  }

  // Status Card
  static Widget statusCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: AppTheme.cardDecoration,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingS),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.bodyLarge),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(subtitle, style: AppTheme.bodySmall),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right, color: AppTheme.textLight),
            ],
          ),
        ),
      ),
    );
  }

  // Info Card
  static Widget infoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    List<String>? items,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: AppTheme.cardDecoration.copyWith(
  border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(title, style: AppTheme.headingSmall.copyWith(color: color)),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(description, style: AppTheme.bodyMedium),
          if (items != null && items.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingS),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(top: AppTheme.spacingXS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(child: Text(item, style: AppTheme.bodySmall)),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  // Alert Card
  static Widget alertCard({
    required String title,
    required String message,
    required Color color,
    IconData? icon,
    VoidCallback? onDismiss,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
  color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
  border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.info, color: color, size: 24),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.bodyLarge.copyWith(color: color, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppTheme.spacingXS),
                Text(message, style: AppTheme.bodyMedium.copyWith(color: color)),
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close, color: color),
              iconSize: 20,
            ),
        ],
      ),
    );
  }

  // Progress Card
  static Widget progressCard({
    required String title,
    required String subtitle,
    required double progress,
    Color? progressColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.bodyLarge),
          const SizedBox(height: AppTheme.spacingXS),
          Text(subtitle, style: AppTheme.bodySmall),
          const SizedBox(height: AppTheme.spacingM),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? AppTheme.primaryColor,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            '${(progress * 100).toInt()}%',
            style: AppTheme.bodySmall.copyWith(
              color: progressColor ?? AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Metric Card
  static Widget metricCard({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color ?? AppTheme.primaryColor, size: 24),
              const Spacer(),
              if (subtitle != null)
                Text(subtitle, style: AppTheme.caption),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(value, style: AppTheme.headingMedium.copyWith(color: color ?? AppTheme.primaryColor)),
          const SizedBox(height: AppTheme.spacingXS),
          Text(title, style: AppTheme.bodySmall),
        ],
      ),
    );
  }

  // Loading Widget
  static Widget loading({String? message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          if (message != null) ...[
            const SizedBox(height: AppTheme.spacingM),
            Text(message, style: AppTheme.bodyMedium),
          ],
        ],
      ),
    );
  }

  // Empty State Widget
  static Widget emptyState({
    required String title,
    required String message,
    required IconData icon,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppTheme.textLight),
            const SizedBox(height: AppTheme.spacingL),
            Text(title, style: AppTheme.headingMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppTheme.spacingS),
            Text(message, style: AppTheme.bodyMedium, textAlign: TextAlign.center),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppTheme.spacingL),
              primaryButton(text: actionText, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }

  // Custom App Bar
  static PreferredSizeWidget customAppBar({
    required String title,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: AppTheme.textOnPrimary,
      elevation: AppTheme.elevationS,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
            )
          : null,
      actions: actions,
    );
  }

  // Severity Badge
  static Widget severityBadge(String severity) {
    final color = AppTheme.getSeverityColor(severity);
    IconData icon;
    
    switch (severity.toLowerCase()) {
      case 'mild':
      case 'low':
        icon = Icons.check_circle;
        break;
      case 'moderate':
      case 'medium':
        icon = Icons.warning;
        break;
      case 'severe':
      case 'high':
        icon = Icons.error;
        break;
      default:
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.textOnPrimary, size: 16),
          const SizedBox(width: AppTheme.spacingXS),
          Text(
            severity.toUpperCase(),
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Category Badge
  static Widget categoryBadge(String category) {
    final color = AppTheme.getCategoryColor(category);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
  color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
  border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        category.toUpperCase(),
        style: AppTheme.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Confidence Indicator
  static Widget confidenceIndicator(double confidence) {
    Color color;
    IconData icon;
    
    if (confidence >= 80) {
      color = AppTheme.successColor;
      icon = Icons.verified;
    } else if (confidence >= 60) {
      color = AppTheme.warningColor;
      icon = Icons.info;
    } else {
      color = AppTheme.textLight;
      icon = Icons.help;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Confidence: ${confidence.toInt()}%',
          style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: AppTheme.spacingXS),
        Icon(icon, color: color, size: 16),
      ],
    );
  }
}
