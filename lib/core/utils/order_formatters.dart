/// Utilities for formatting dates, times, and distances for worker orders.
library;

/// Formats a past DateTime as a relative human-readable string:
/// "Hace 5 min", "Hace 20 min", "Hace 1 h", etc.
String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.isNegative || difference.inMinutes < 1) {
    return 'Hace un momento';
  }
  if (difference.inMinutes < 60) {
    return 'Hace ${difference.inMinutes} min';
  }
  if (difference.inHours < 24) {
    return 'Hace ${difference.inHours} h';
  }
  if (difference.inDays < 7) {
    return 'Hace ${difference.inDays} d';
  }
  final weeks = (difference.inDays / 7).floor();
  if (weeks < 4) {
    return 'Hace $weeks sem';
  }
  final months = (difference.inDays / 30).floor();
  if (months < 12) {
    return 'Hace $months m';
  }
  return 'Hace ${(difference.inDays / 365).floor()} a';
}

/// Formats the schedule / urgency of a service request:
/// Returns "Lo antes posible" if null.
/// Otherwise returns "Hoy por la tarde", "Mañana 10:00", etc.
String formatRequestSchedule(DateTime? scheduledFor) {
  if (scheduledFor == null) {
    return 'Lo antes posible';
  }

  final now = DateTime.now();
  final scheduledLocal = scheduledFor.toLocal();
  final isToday = scheduledLocal.year == now.year &&
      scheduledLocal.month == now.month &&
      scheduledLocal.day == now.day;

  final tomorrow = now.add(const Duration(days: 1));
  final isTomorrow = scheduledLocal.year == tomorrow.year &&
      scheduledLocal.month == tomorrow.month &&
      scheduledLocal.day == tomorrow.day;

  final hour = scheduledLocal.hour;
  final minute = scheduledLocal.minute.toString().padLeft(2, '0');

  if (isToday) {
    if (hour >= 12 && hour < 19) {
      return 'Hoy por la tarde';
    } else if (hour >= 6 && hour < 12) {
      return 'Hoy por la mañana';
    } else if (hour >= 19) {
      return 'Hoy por la noche';
    } else {
      return 'Hoy $hour:$minute';
    }
  }

  if (isTomorrow) {
    return 'Mañana $hour:$minute';
  }

  return '${scheduledLocal.day}/${scheduledLocal.month} $hour:$minute';
}

/// Formats distance in kilometers or meters:
/// e.g. "0.8 km", "1.4 km", "800 m".
String formatDistance(double distanceKm) {
  if (distanceKm < 0.1) {
    final meters = (distanceKm * 1000).round();
    return '$meters m';
  }
  return '${distanceKm.toStringAsFixed(1)} km';
}
