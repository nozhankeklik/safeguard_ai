#!/bin/bash

echo "💾 n8n Workflow Backup Alınıyor..."
echo ""

# Tarih damgası
DATE=$(date +%Y%m%d_%H%M%S)

# Proje dizini
cd "$(dirname "$0")"

# Backup klasörlerini oluştur
mkdir -p backend_backup
mkdir -p ~/Documents/n8n_backups

echo "📋 Backup Bilgileri:"
echo "   Tarih: $DATE"
echo "   Lokasyon 1: ./backend_backup/"
echo "   Lokasyon 2: ~/Documents/n8n_backups/"
echo ""

# Database'i kopyala
if [ -f "n8n_data/database.sqlite" ]; then
    echo "📦 Database backup'ı alınıyor..."
    cp n8n_data/database.sqlite "backend_backup/database_backup_$DATE.sqlite"
    cp n8n_data/database.sqlite ~/Documents/n8n_backups/database_backup_$DATE.sqlite
    echo "   ✅ Database backup'ı tamamlandı"
else
    echo "   ⚠️  Database dosyası bulunamadı!"
fi

echo ""
echo "⚠️  NOT: Workflow JSON export'u için:"
echo "   1. http://localhost:5678 açın"
echo "   2. Workflow'unuzu açın"
echo "   3. Sağ üst menü (•••) → Download"
echo "   4. Dosyayı backend_backup/ klasörüne kaydedin"
echo ""
echo "💡 Workflow dosya adı önerisi:"
echo "   SafeGuard_AI_Workflow_$DATE.json"
echo ""


