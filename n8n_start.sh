#!/bin/bash

echo "🚀 SafeGuard AI - n8n Backend Başlatılıyor..."
echo ""

# Proje dizinine git
cd "$(dirname "$0")"

# Eski n8n process'lerini durdur
echo "📌 Eski n8n process'leri durduruluyor..."
pkill -f "npx n8n" 2>/dev/null || true
docker stop safeguard_n8n 2>/dev/null || true
docker rm safeguard_n8n 2>/dev/null || true

# Data klasörünü oluştur
echo "📁 Data klasörleri oluşturuluyor..."
mkdir -p n8n_data backend_backup

# Docker container'ı başlat
echo "🐳 Docker container başlatılıyor..."
docker-compose up -d

# Başlatma kontrolü
echo ""
echo "⏳ n8n başlatılıyor, lütfen bekleyin..."
sleep 5

# Durum kontrolü
if docker ps | grep -q safeguard_n8n; then
    echo ""
    echo "✅ n8n başarıyla başlatıldı!"
    echo ""
    echo "📡 n8n Dashboard: http://localhost:5678"
    echo "🔐 İlk girişte hesap oluşturmanız istenecek"
    echo ""
    echo "📊 Container Durumu:"
    docker ps | grep safeguard_n8n
    echo ""
    echo "📝 Logları görmek için: docker logs -f safeguard_n8n"
else
    echo ""
    echo "❌ n8n başlatılamadı! Docker loglarını kontrol edin:"
    echo "   docker logs safeguard_n8n"
fi


