import 'package:flutter/material.dart';
import '../home/widgets/home_bottom_nav.dart';
import 'reminder_settings.dart';
import 'reminder_settings_storage.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _remindersEnabled = true;
  double _frequencyHours = 2;

  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietStart = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadReminderSettings();
  }

  Future<void> _loadReminderSettings() async {
    final settings = await ReminderSettingsStorage.load();

    if (!mounted) return;

    setState(() {
      _remindersEnabled = settings.remindersEnabled;
      _frequencyHours = settings.frequencyHours.toDouble();
      _startTime = _parseTime(settings.startTime);
      _endTime = _parseTime(settings.endTime);
      _quietStart = _parseTime(settings.quietStart);
      _quietEnd = _parseTime(settings.quietEnd);
      _isLoaded = true;
    });
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _toStorageTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickTime({
    required TimeOfDay initialTime,
    required ValueChanged<TimeOfDay> onSelected,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        onSelected(picked);
      });
    }
  }

  Future<void> _savePreferences() async {
    final settings = ReminderSettings(
      remindersEnabled: _remindersEnabled,
      frequencyHours: _frequencyHours.toInt(),
      startTime: _toStorageTime(_startTime),
      endTime: _toStorageTime(_endTime),
      quietStart: _toStorageTime(_quietStart),
      quietEnd: _toStorageTime(_quietEnd),
    );

    await ReminderSettingsStorage.save(settings);

    if (!mounted) return;
    Navigator.pop(context, 'Reminder preferences saved');
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Scaffold(
        backgroundColor: Color(0xFFAEDFEA),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFAEDFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFAEDFEA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'REMINDERS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const _NoStretchScrollBehavior(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                _SectionCard(
                  title: 'Reminder Settings',
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _remindersEnabled,
                        activeThumbColor: const Color(0xFF2F45FF),
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Enable Reminders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                        subtitle: const Text(
                          'Receive hydration reminders throughout the day',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _remindersEnabled = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Opacity(
                        opacity: _remindersEnabled ? 1 : 0.5,
                        child: IgnorePointer(
                          ignoring: !_remindersEnabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reminder frequency: every ${_frequencyHours.toInt()} hour${_frequencyHours.toInt() == 1 ? '' : 's'}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D3557),
                                ),
                              ),
                              Slider(
                                value: _frequencyHours,
                                min: 1,
                                max: 4,
                                divisions: 3,
                                label: '${_frequencyHours.toInt()}h',
                                onChanged: (value) {
                                  setState(() {
                                    _frequencyHours = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Reminder Hours',
                  child: Column(
                    children: [
                      _TimeTile(
                        label: 'Start reminders',
                        value: _formatTime(_startTime),
                        onTap: _remindersEnabled
                            ? () => _pickTime(
                                initialTime: _startTime,
                                onSelected: (value) => _startTime = value,
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _TimeTile(
                        label: 'End reminders',
                        value: _formatTime(_endTime),
                        onTap: _remindersEnabled
                            ? () => _pickTime(
                                initialTime: _endTime,
                                onSelected: (value) => _endTime = value,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Quiet Hours',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Set times when you do not want to receive notifications.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _TimeTile(
                        label: 'Quiet hours start',
                        value: _formatTime(_quietStart),
                        onTap: _remindersEnabled
                            ? () => _pickTime(
                                initialTime: _quietStart,
                                onSelected: (value) => _quietStart = value,
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _TimeTile(
                        label: 'Quiet hours end',
                        value: _formatTime(_quietEnd),
                        onTap: _remindersEnabled
                            ? () => _pickTime(
                                initialTime: _quietEnd,
                                onSelected: (value) => _quietEnd = value,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _savePreferences,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F45FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Save Reminder Preferences',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 4,
        onTap: (index) {
          if (index == 4) return;
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7FBFD),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D3557),
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: onTap == null ? Colors.black38 : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.access_time,
                color: onTap == null ? Colors.black38 : const Color(0xFF1D3557),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoStretchScrollBehavior extends ScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}