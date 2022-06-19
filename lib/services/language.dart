import 'package:flutter/material.dart';

enum PickedLanguage {
  english,
  russian,
  kazakh,
}

PickedLanguage currentLanguage = PickedLanguage.english;

class Language {

  static String loginButtonText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Login";
      case PickedLanguage.russian:
        return "Войти";
      case PickedLanguage.kazakh:
        return "Кіру";
    }
  }

  static String titleText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Title";
      case PickedLanguage.russian:
        return "Называние";
      case PickedLanguage.kazakh:
        return "Аты";
    }
  }

  static BottomSheetLanguage bottomSheetLanguage = BottomSheetLanguage();
  static NavBarLanguage navBarLanguage = NavBarLanguage();
  static AssetsLanguage assetsLanguage = AssetsLanguage();
  static AttentionLanguage attentionLanguage = AttentionLanguage();

}

class AttentionLanguage {

  String attentionText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Attention";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

  String firstLineText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "You can add markers by tapping on map";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

  String secondLineText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "And click on a marker to see more details.";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

  String thirdLineText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "To see list of the markers, tap on button on the top left corner.";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

  String doNowShowAgainText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Do not show again";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

}

class BottomSheetLanguage {

  String gateText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Gate";
      case PickedLanguage.russian:
        return "Граница";
      case PickedLanguage.kazakh:
        return "Шекара";
    }
  }
}

class NavBarLanguage {

  String assetsText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Assets";
      case PickedLanguage.russian:
        return "Активы";
      case PickedLanguage.kazakh:
        return "Активтер";
    }
  }

  String notificationText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Notification";
      case PickedLanguage.russian:
        return "Уведомление";
      case PickedLanguage.kazakh:
        return "Хабарландыру";
    }
  }

  String settingsText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Settings";
      case PickedLanguage.russian:
        return "Настройки";
      case PickedLanguage.kazakh:
        return "Параметрлер";
    }
  }

  String logoutText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "log out";
      case PickedLanguage.russian:
        return "Выйти";
      case PickedLanguage.kazakh:
        return "Шығу";
    }
  }
}

class AssetsLanguage {

  String lastActiveText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Last active";
      case PickedLanguage.russian:
        return "Последний в сети";
      case PickedLanguage.kazakh:
        return "Сонғы";
    }
  }

  String generalStatusText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "General status";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

  String latitudeText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Latitude";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

  String longitudeText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Longitude";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

  String deviceTypeText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Device type";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

  String locateButtonText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Locate on map";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

  String batteryText() {
    switch (currentLanguage) {
      case PickedLanguage.english:
        return "Battery";
      case PickedLanguage.russian:
        return "";
      case PickedLanguage.kazakh:
        return "";
    }
  }

}