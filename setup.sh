#!/bin/bash
# وقتي Setup Script
# Run this after cloning: bash setup.sh

set -e

echo "⏰ إعداد مشروع وقتي..."
echo ""

# 1. Check Flutter
if ! command -v flutter &> /dev/null; then
  echo "❌ Flutter غير مثبّت. يرجى تثبيت Flutter أولاً:"
  echo "   https://docs.flutter.dev/get-started/install"
  exit 1
fi
echo "✅ Flutter: $(flutter --version | head -1)"

# 2. Install pub dependencies
echo ""
echo "📦 تثبيت الاعتماديات..."
flutter pub get

# 3. Download Cairo font
echo ""
echo "🔤 تحميل خط Cairo..."
mkdir -p assets/fonts

CAIRO_URL="https://github.com/google/fonts/raw/main/ofl/cairo"

download_font() {
  local name=$1
  local url=$2
  if [ ! -f "assets/fonts/$name" ]; then
    echo "   ⬇️  تحميل $name..."
    curl -fsSL "$url" -o "assets/fonts/$name" || {
      echo "   ⚠️  فشل التحميل التلقائي لـ $name"
      echo "   📥 يرجى تحميل Cairo من: https://fonts.google.com/specimen/Cairo"
      echo "      ووضع الملفات في مجلد assets/fonts/"
    }
  else
    echo "   ✅ $name موجود"
  fi
}

download_font "Cairo-Regular.ttf" "$CAIRO_URL/Cairo-Regular.ttf"
download_font "Cairo-Bold.ttf" "$CAIRO_URL/Cairo-Bold.ttf"
download_font "Cairo-ExtraBold.ttf" "$CAIRO_URL/Cairo-ExtraBold.ttf"

# Fallback: try downloading the zip
if [ ! -f "assets/fonts/Cairo-Regular.ttf" ]; then
  echo ""
  echo "🔄 محاولة تحميل بديلة..."
  TMPDIR=$(mktemp -d)
  curl -fsSL "https://fonts.gstatic.com/s/cairo/v28/SLXgc1nY6HkvangtZmpQdkhzfH5lkSscSS6j.ttf" \
    -o "assets/fonts/Cairo-Regular.ttf" 2>/dev/null || true
  curl -fsSL "https://fonts.gstatic.com/s/cairo/v28/SLXgc1nY6HkvangtZmpQdkhzfH5lkSs6RC6j.ttf" \
    -o "assets/fonts/Cairo-Bold.ttf" 2>/dev/null || true
  cp "assets/fonts/Cairo-Bold.ttf" "assets/fonts/Cairo-ExtraBold.ttf" 2>/dev/null || true
fi

# 4. Create placeholder assets if missing
echo ""
echo "🖼️  التحقق من الأصول..."
mkdir -p assets/images assets/audio

if [ ! -f "assets/images/app_icon.png" ]; then
  echo "   ℹ️  لا يوجد app_icon.png - سيُستخدم الأيقونة الافتراضية"
  echo "   💡 أضف أيقونتك إلى: assets/images/app_icon.png (1024x1024)"
fi

# 5. Flutter doctor check
echo ""
echo "🏥 فحص بيئة Flutter..."
flutter doctor --android-licenses 2>/dev/null || true

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║       ✅ الإعداد اكتمل بنجاح!            ║"
echo "╠══════════════════════════════════════════╣"
echo "║  تشغيل التطبيق:                          ║"
echo "║  $ flutter run                           ║"
echo "║                                          ║"
echo "║  بناء APK:                               ║"
echo "║  $ flutter build apk --release           ║"
echo "╚══════════════════════════════════════════╝"
