import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomIconWidget({
    Key? key,
    required this.iconName,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map of icon names to Material Icons
    final iconMap = {
      // Navigation
      'arrow_back': Icons.arrow_back,
      'arrow_back_ios': Icons.arrow_back_ios,
      'arrow_forward': Icons.arrow_forward,
      'menu': Icons.menu,
      'close': Icons.close,
      'chevron_right': Icons.chevron_right,
      'chevron_left': Icons.chevron_left,
      'expand_more': Icons.expand_more,
      'expand_less': Icons.expand_less,
      'keyboard_arrow_up': Icons.keyboard_arrow_up,
      'keyboard_arrow_down': Icons.keyboard_arrow_down,
      
      // Communication
      'chat': Icons.chat,
      'send': Icons.send,
      'mic': Icons.mic,
      'mic_none': Icons.mic_none,
      'phone': Icons.phone,
      'phone_android': Icons.phone_android,
      'contacts': Icons.contacts,
      'email': Icons.email,
      'email_outlined': Icons.email_outlined,
      'message': Icons.message,
      
      // System & Settings
      'settings': Icons.settings,
      'settings_applications': Icons.settings_applications,
      'wifi': Icons.wifi,
      'wifi_off': Icons.wifi_off,
      'wifi_tethering': Icons.wifi_tethering,
      'wifi_1_bar': Icons.network_wifi_1_bar,
      'wifi_2_bar': Icons.network_wifi_2_bar,
      'wifi_0_bar': Icons.signal_wifi_0_bar,
      'bluetooth': Icons.bluetooth,
      'bluetooth_disabled': Icons.bluetooth_disabled,
      'airplanemode_active': Icons.airplanemode_active,
      'do_not_disturb': Icons.do_not_disturb,
      'volume_up': Icons.volume_up,
      'volume_off': Icons.volume_off,
      'location_on': Icons.location_on,
      'data_usage': Icons.data_usage,
      
      // Actions
      'add': Icons.add,
      'edit': Icons.edit,
      'delete': Icons.delete,
      'share': Icons.share,
      'search': Icons.search,
      'search_off': Icons.search_off,
      'refresh': Icons.refresh,
      'clear': Icons.clear,
      'download': Icons.download,
      'upload': Icons.upload,
      'copy': Icons.copy,
      'save': Icons.save,
      'restore': Icons.restore,
      
      // Status & Feedback
      'check': Icons.check,
      'check_circle': Icons.check_circle,
      'error': Icons.error,
      'error_outline': Icons.error_outline,
      'warning': Icons.warning,
      'info': Icons.info,
      'help': Icons.help,
      'priority_high': Icons.priority_high,
      
      // Media & Content
      'play_arrow': Icons.play_arrow,
      'pause': Icons.pause,
      'stop': Icons.stop,
      'skip_next': Icons.skip_next,
      'skip_previous': Icons.skip_previous,
      'record_voice_over': Icons.record_voice_over,
      'headphones': Icons.headphones,
      'speaker': Icons.speaker,
      'image': Icons.image,
      'video_call': Icons.video_call,
      
      // User & Profile
      'person': Icons.person,
      'person_outlined': Icons.person_outline,
      'account_circle': Icons.account_circle,
      'face': Icons.face,
      'group': Icons.group,
      
      // Time & Schedule
      'schedule': Icons.schedule,
      'alarm': Icons.alarm,
      'timer': Icons.timer,
      'access_time': Icons.access_time,
      'today': Icons.today,
      'event': Icons.event,
      'history': Icons.history,
      
      // Technology & AI
      'smart_toy': Icons.smart_toy,
      'psychology': Icons.psychology,
      'memory': Icons.memory,
      'computer': Icons.computer,
      'devices': Icons.devices,
      'code': Icons.code,
      'bug_report': Icons.bug_report,
      'security': Icons.security,
      
      // UI Elements
      'home': Icons.home,
      'dashboard': Icons.dashboard,
      'apps': Icons.apps,
      'category': Icons.category,
      'folder': Icons.folder,
      'file_copy': Icons.file_copy,
      'description': Icons.description,
      'title': Icons.title,
      'text_fields': Icons.text_fields,
      
      // Controls
      'radio_button_unchecked': Icons.radio_button_unchecked,
      'radio_button_checked': Icons.radio_button_checked,
      'checkbox': Icons.check_box,
      'checkbox_outline': Icons.check_box_outline_blank,
      'toggle_on': Icons.toggle_on,
      'toggle_off': Icons.toggle_off,
      'visibility': Icons.visibility,
      'visibility_off': Icons.visibility_off,
      'lock': Icons.lock,
      'lock_outlined': Icons.lock_outline,
      
      // Misc
      'circle': Icons.circle,
      'star': Icons.star,
      'favorite': Icons.favorite,
      'thumb_up': Icons.thumb_up,
      'thumb_down': Icons.thumb_down,
      'lightbulb': Icons.lightbulb,
      'flash_on': Icons.flash_on,
      'flash_off': Icons.flash_off,
      'battery_full': Icons.battery_full,
      'signal_cellular_4_bar': Icons.signal_cellular_4_bar,
      'watch': Icons.watch,
      'hourglass_empty': Icons.hourglass_empty,
    };

    final iconData = iconMap[iconName] ?? Icons.help_outline;

    return Icon(
      iconData,
      color: color,
      size: size,
    );
  }
}