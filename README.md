# ⏰ وقتي — تعلّم قراءة الساعة للأطفال

<div align="center">

![وقتي Logo](https://img.shields.io/badge/وقتي-تعلّم_الوقت-1976D2?style=for-the-badge&logo=flutter&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)
![Android](https://img.shields.io/badge/Android-API_21+-3DDC84?style=for-the-badge&logo=android)
![Arabic RTL](https://img.shields.io/badge/Arabic-RTL-FF7043?style=for-the-badge)

**تطبيق أندرويد تعليمي للأطفال لتعلّم قراءة الساعة التناظرية بالعربية**

*مستوحى من [I Can Tell Time](https://icantelltime.com)*

</div>

---

## 📱 نظرة عامة

**وقتي** هو تطبيق أندرويد مجاني للأطفال من عمر 4–8 سنوات لتعلّم قراءة الساعة التناظرية بالعربية. يستخدم التطبيق نظام دروس متدرجة، نجوم، سلاسل يومية، وشخصية زيد الروبوت المشجعة لجعل التعلّم ممتعاً.

---

## ✨ الميزات

| الميزة | الوصف |
|--------|-------|
| 🎯 **5 وحدات تعليمية** | مسار تدريجي من الساعات الكاملة حتى أي دقيقة |
| ⭐ **نجوم وسلاسل** | نظام مكافآت يومية يشجع الأطفال على الاستمرار |
| 🤖 **زيد المشجع** | شخصية روبوت عربية محبوبة مع فقاعات حوار |
| 🕐 **اللعب الحر** | ساعة تفاعلية يمكن تحريكها بالإصبع |
| 🔄 **نوعان من الأسئلة** | اختيار متعدد + ضبط العقارب |
| 📊 **تتبع التقدم** | حفظ محلي بدون إنترنت |
| 🌙 **RTL كامل** | واجهة عربية من اليمين لليسار |
| 🚫 **بدون إعلانات** | تجربة نظيفة للأطفال |

---

## 📚 المنهج التعليمي

```
الوحدة 1 ⭐  — أبطال الساعة     (الساعات الكاملة: 1:00، 2:00...)     [مجاني]
الوحدة 2 🌙  — النصف الجميل    (والنصف: 3:30، 9:30...)
الوحدة 3 🌟  — مغامرة الربع    (والربع، إلا ربعًا: 3:15، 3:45)
الوحدة 4 🚀  — عدّ بالخمسة     (الدقائق بالخمسات: 3:05، 7:25...)
الوحدة 5 👑  — أسياد الوقت     (أي دقيقة: 11:43، 2:51...)
```

**المجموع: 24 درسًا، 100+ سؤال**

---

## 🛠️ المتطلبات التقنية

- **Flutter** 3.16+ 
- **Dart** 3.0+
- **Android SDK** API 21+ (Android 5.0 Lollipop)
- **Java** 11+

---

## 🚀 البدء السريع

### 1. استنساخ المستودع
```bash
git clone https://github.com/YOUR_USERNAME/waqti.git
cd waqti
```

### 2. تثبيت الاعتماديات
```bash
flutter pub get
```

### 3. إضافة الخطوط (مطلوب)

حمّل خطوط Cairo من Google Fonts وضعها في:
```
assets/fonts/
├── Cairo-Regular.ttf
├── Cairo-Bold.ttf
└── Cairo-ExtraBold.ttf
```

```bash
# تحميل سريع عبر pip
pip install gfonts
gfonts download Cairo --output assets/fonts/
```

أو من: https://fonts.google.com/specimen/Cairo

### 4. تشغيل التطبيق
```bash
# تشغيل على جهاز متصل
flutter run

# بناء APK للنشر
flutter build apk --release

# بناء APK لكل البنيات
flutter build apk --split-per-abi --release
```

ستجد الـ APK في:
```
build/app/outputs/flutter-apk/
├── app-arm64-v8a-release.apk   ← الأجهزة الحديثة
├── app-armeabi-v7a-release.apk ← الأجهزة القديمة
└── app-x86_64-release.apk      ← المحاكيات
```

---

## 📁 هيكل المشروع

```
lib/
├── main.dart                    # نقطة البداية + SplashScreen
├── theme/
│   └── app_theme.dart           # الألوان والخطوط والثيم
├── models/
│   ├── curriculum.dart          # البيانات: الوحدات، الدروس، الأسئلة
│   └── progress_provider.dart   # حالة التقدم (Provider)
├── screens/
│   ├── home_screen.dart         # الشاشة الرئيسية - مسار الوحدات
│   ├── lesson_screen.dart       # شاشة الدرس - الأسئلة والتقييم
│   └── free_play_screen.dart    # اللعب الحر بالساعة
└── widgets/
    ├── analog_clock.dart        # ساعة تناظرية + تفاعلية
    └── zaid_mascot.dart         # شخصية زيد الروبوت
```

---

## 🎨 التصميم

| العنصر | القيمة |
|--------|--------|
| اللون الأساسي | `#1976D2` (أزرق سماوي) |
| لون النجمة | `#FFC107` (ذهبي) |
| لون المرح | `#FF7043` (مرجاني) |
| خط الكتابة | Cairo (عربي) |
| الاتجاه | RTL (يمين لليسار) |

---

## 🔧 التخصيص

### تغيير اسم التطبيق
```yaml
# pubspec.yaml
name: waqti
```
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
android:label="وقتي"
```

### تغيير معرّف التطبيق
```groovy
// android/app/build.gradle
applicationId "com.daryne.waqti"  // غيّر إلى معرّفك
```

### إضافة دروس جديدة
في `lib/models/curriculum.dart`، أضف `Lesson` جديدة داخل أي `Unit`:
```dart
Lesson(
  id: 'u1l5',
  title: 'درسي الجديد',
  subtitle: 'الدرس الخامس',
  description: 'وصف الدرس',
  questions: [
    TimeQuestion(
      hour: 5, minute: 0,
      type: QuestionType.multipleChoice,
      prompt: 'كم الساعة؟'
    ),
  ],
),
```

---

## 📤 النشر على Google Play

1. **إنشاء keystore**:
```bash
keytool -genkey -v -keystore waqti-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias waqti
```

2. **إضافة ملف key.properties** (لا ترفعه على GitHub!):
```
# android/key.properties
storePassword=كلمة_المرور
keyPassword=كلمة_المرور
keyAlias=waqti
storeFile=../waqti-key.jks
```

3. **تعديل build.gradle** لاستخدام التوقيع:
```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

4. **بناء App Bundle**:
```bash
flutter build appbundle --release
```

---

## 🌐 GitHub Actions (CI/CD اختياري)

أنشئ `.github/workflows/build.yml`:
```yaml
name: Build APK

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: waqti-release
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🤝 المساهمة

المساهمات مرحّب بها! افتح Issue أو Pull Request.

---

## 📄 الترخيص

MIT License — استخدم بحرية وعدّل حسب احتياجك.

---

<div align="center">

صُنع بـ ❤️ للأطفال العرب

**⏰ وقتي — كل طفل يستحق أن يتعلّم الوقت بلغته**

</div>
