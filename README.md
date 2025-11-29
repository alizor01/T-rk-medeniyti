# T-rk-medeniyti
Türk kültürü buluşma noktasi
#!/usr/bin/env bash
set -euo pipefail

# CONFIG - düzenlemeye gerek yoksa olduğu gibi bırak
REPO_URL="https://github.com/alizor01/T-rk-medeniyti.git"
BRANCH="main"
GH_OWNER_REPO="alizor01/T-rk-medeniyti"  # gh komutları için owner/repo

# 1) Basit kontroller
if ! command -v git >/dev/null 2>&1; then
  echo "git bulunamadı. Lütfen git yükleyin ve tekrar çalıştırın."
  exit 1
fi

echo "Projeyi repo'ya hazırlıyorum: $REPO_URL"

# 2) Git init ve ilk commit (varsa mevcut repo korunur)
if [ ! -d ".git" ]; then
  git init
  git checkout -b "$BRANCH" || true
fi

git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

git add .
git commit -m "chore: initial commit - otomatik yükleme" || echo "No changes to commit"

# 3) Push (kullanıcının yetkisi gerektirir; SSH veya HTTPS credentials kullanılacak)
echo "Push yapılıyor -> $REPO_URL (branch: $BRANCH)"
git push -u origin "$BRANCH"

echo "Push tamam."

# 4) (Opsiyonel) GitHub CLI ile ek yapılandırmalar
if command -v gh >/dev/null 2>&1; then
  echo "gh CLI bulundu. GitHub üzerinde ek konfigürasyonlar yapılacak (secrets, workflow tetikleme, pages)."
  read -p "GitHub CLI ile oturumunuz açık mı? (y/n): " GHOK
  if [ "$GHOK" = "y" ] || [ "$GHOK" = "Y" ]; then
    # 4.a) Varsayılan sıra: secrets ekleme (kullanıcıdan giriş)
    echo "Secrets eklemek istersen ENTER ile onayla, atlamak için Ctrl+C"
    read -p "OPENWEATHER_KEY (boş bırakıp enter ile atla): " OPENWEATHER_KEY
    if [ -n "$OPENWEATHER_KEY" ]; then
      echo "$OPENWEATHER_KEY" | gh secret set OPENWEATHER_KEY -R "$GH_OWNER_REPO"
      echo "OPENWEATHER_KEY eklendi."
    fi
    read -p "HUGGINGFACE_INFERENCE_API_TOKEN (boş bırakıp enter ile atla): " HF
    if [ -n "$HF" ]; then
      echo "$HF" | gh secret set HUGGINGFACE_INFERENCE_API_TOKEN -R "$GH_OWNER_REPO"
      echo "HUGGINGFACE_INFERENCE_API_TOKEN eklendi."
    fi
    read -p "OPENAI_API_KEY (boş bırakıp enter ile atla): " OAI
    if [ -n "$OAI" ]; then
      echo "$OAI" | gh secret set OPENAI_API_KEY -R "$GH_OWNER_REPO"
      echo "OPENAI_API_KEY eklendi."
    fi

    # 4.b) İsteğe bağlı: workflow'ı manuel çalıştır
    echo "İstersen workflow'ı şimdi tetikleyebilirsin. Tetiklemek istiyor musun? (y/n)"
    read -p "> " RUNWF
    if [ "$RUNWF" = "y" ] || [ "$RUNWF" = "Y" ]; then
      # workflow dosya adını repo'da bulmaya çalışalım
      WF_NAME="content_updater.yml"
      gh workflow run ".github/workflows/$WF_NAME" -R "$GH_OWNER_REPO" || echo "Workflow tetiklenemedi. GH CLI ile workflow adını kontrol edin."
      echo "Workflow tetikleme isteği gönderildi."
    fi

    # 4.c) GitHub Pages (basit)
    echo "GitHub Pages kurulumunu gerçekleştirmek ister misin? (repo public olmalı) (y/n)"
    read -p "> " PAGES
    if [ "$PAGES" = "y" ] || [ "$PAGES" = "Y" ]; then
      # Not: gh pages setup komutu farklı sürümlerde değişebilir
      gh repo edit "$GH_OWNER_REPO" --default-branch "$BRANCH" || true
      echo "Sayfanız Pages üzerinden yayınlanacak. GitHub UI'dan Pages ayarlarını da kontrol edin."
    fi

    echo "gh işlemleri tamamlandı (veya atlandı)."
  else
    echo "gh CLI oturumunu açıp tekrar çalıştırarak secrets ve pages ayarlarını otomatik yapabilirsiniz."
  fi
else
  echo "gh CLI (GitHub CLI) bulunamadı — secrets ve Pages ayarları için gh CLI yükleyip oturum açmanız gerekiyor."
  echo "https://cli.github.com/ adresinden yönergeleri takip edin."
fi

echo "✅ Otomatik yükleme scripti tamamlandı. GitHub repo: $REPO_URL"
