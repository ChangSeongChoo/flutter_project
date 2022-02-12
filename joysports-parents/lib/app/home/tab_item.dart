import 'package:flutter/material.dart';
import 'package:joysports/constants/keys.dart';
import 'package:joysports/constants/strings.dart';

enum TabItem { plays, light, jobs, entries, account}

class TabItemData {
  const TabItemData(
      {required this.key, required this.title, required this.icon});

  final String key;
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.plays: TabItemData(
        key: Keys.playsTab,
        title: Strings.plays,
        icon: Icons.tap_and_play
    ),
    TabItem.light: TabItemData(
      key: Keys.lightTab,
      title: Strings.light,
      icon: Icons.lightbulb,
    ),
    TabItem.jobs: TabItemData(
      key: Keys.jobsTab,
      title: Strings.jobs,
      icon: Icons.work,
    ),
    TabItem.entries: TabItemData(
      key: Keys.entriesTab,
      title: Strings.entries,
      icon: Icons.view_headline,
    ),
    TabItem.account: TabItemData(
      key: Keys.accountTab,
      title: Strings.account,
      icon: Icons.person,
    ),

  };
}
