# n8n JavaScript Code Updates for V2 Backend

## Code in JavaScript2 Node - Güncellenmiş Kod

n8n'deki "Code in JavaScript2" node'unun içine şu kodu yapıştırın:

```javascript
// Webhook'tan gelen veriyi al
const items = $input.all();
const request = items[0].json.body || items[0].json;

// Base64 image'ı decode et (email attachment için)
let imageBuffer = null;
let imageName = 'analysis.jpg';

if (request.image) {
  imageBuffer = Buffer.from(request.image, 'base64');
  imageName = request.imageName || 'analysis.jpg';
}

// V2 Backend: Flutter'dan gelen yeni format
// recipient artık tek bir string (array değil)
const recipient = request.recipient || '';
const recipients = recipient ? [recipient] : []; // Tek recipient'ı array'e çevir
const ccRecipients = request.ccRecipients || []; // V2'de CC yok ama eski kod uyumluluğu için

// V2: final_message kullan (eski analysis yerine)
let cleanAnalysis = request.final_message || request.analysis || '';
cleanAnalysis = cleanAnalysis.replace(/^(ÜKSEK|ÜŞÜK|YÜKSEK|DÜŞÜK|ORTA|HIGH|LOW|MEDIUM)\s+/gi, "").trim();
cleanAnalysis = cleanAnalysis.replace(/^\d+\.\s*/g, "").trim();
cleanAnalysis = cleanAnalysis.replace(/^(Risk|Risk Level|RİSK|RİSK SEVİYESİ):\s*\w+\s*/gi, "").trim();

// Risk seviyesine göre metin
let riskText = 'ORTA SEVİYE';
if (request.riskLevel === 'YÜKSEK' || request.riskLevel === 'HIGH') {
  riskText = 'YÜKSEK SEVİYE';
} else if (request.riskLevel === 'DÜŞÜK' || request.riskLevel === 'LOW') {
  riskText = 'DÜŞÜK SEVİYE';
}

// Formatlı tarih
const timestamp = request.timestamp ? new Date(request.timestamp) : new Date();
const formattedDate = timestamp.toLocaleDateString('tr-TR', {
  day: '2-digit',
  month: '2-digit',
  year: 'numeric',
  hour: '2-digit',
  minute: '2-digit'
});
const dateForFolder = timestamp.toISOString().split('T')[0]; // 2026-01-16 formatı

// HTML Body (Aynen korundu)
const htmlBody = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      font-family: 'Calibri', 'Arial', sans-serif;
      line-height: 1.8;
      color: #000000;
      margin: 0;
      padding: 0;
      background-color: #ffffff;
    }
    .email-container {
      max-width: 650px;
      margin: 0 auto;
      background-color: #ffffff;
      padding: 40px;
    }
    .header {
      margin-bottom: 30px;
      padding-bottom: 20px;
      border-bottom: 2px solid #000000;
    }
    .header h1 {
      margin: 0;
      font-size: 20px;
      font-weight: bold;
      color: #000000;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .greeting {
      font-size: 14px;
      margin-bottom: 20px;
    }
    .content {
      font-size: 14px;
      color: #000000;
      margin-bottom: 25px;
    }
    .section-title {
      font-weight: bold;
      font-size: 14px;
      margin: 25px 0 10px 0;
      text-transform: uppercase;
    }
    .analysis-text {
      font-size: 14px;
      line-height: 1.8;
      margin: 15px 0;
      color: #000000;
    }
    .risk-level {
      font-weight: bold;
      font-size: 14px;
      margin: 15px 0;
    }
    .actions-title {
      font-weight: bold;
      font-size: 14px;
      margin: 25px 0 10px 0;
    }
    .actions-list {
      margin: 10px 0;
      padding-left: 25px;
      font-size: 14px;
      line-height: 2;
    }
    .attachment-note {
      font-size: 14px;
      margin: 20px 0;
      font-style: italic;
    }
    .footer {
      margin-top: 40px;
      padding-top: 20px;
      border-top: 1px solid #cccccc;
      font-size: 12px;
      color: #666666;
    }
    .signature {
      font-weight: bold;
      margin: 15px 0 5px 0;
      font-size: 14px;
    }
  </style>
</head>
<body>
  <div class="email-container">
    <div class="header">
      <h1>İş Güvenliği Kontrol Raporu</h1>
    </div>
    
    <div class="greeting">Sayın İlgili,</div>
    
    <div class="content">
      ${formattedDate} tarihinde gerçekleştirilen iş güvenliği kontrolü kapsamında aşağıdaki tespitler yapılmıştır.
    </div>
    
    <div class="section-title">Tespit Edilen Durum</div>
    <div class="analysis-text">${cleanAnalysis.replace(/\n/g, '<br>')}</div>
    
    <div class="section-title">Risk Seviyesi</div>
    <div class="risk-level">${riskText}</div>
    
    ${request.riskLevel === 'YÜKSEK' || request.riskLevel === 'HIGH' ? `
    <div class="actions-title">Acil Yapılması Gerekenler</div>
    <ul class="actions-list">
      <li>İlgili alanın derhal kapatılması</li>
      <li>Çalışanların acilen bilgilendirilmesi</li>
      <li>Düzeltici aksiyonların ivedilikle başlatılması</li>
      <li>Yönetim ekibinin konu hakkında bilgilendirilmesi</li>
    </ul>
    ` : request.riskLevel === 'ORTA' || request.riskLevel === 'MEDIUM' ? `
    <div class="actions-title">Önerilen Aksiyonlar</div>
    <ul class="actions-list">
      <li>Durumun 24 saat içinde kontrol edilmesi</li>
      <li>Gerekli önlemlerin alınması</li>
      <li>İlgili personelin bilgilendirilmesi</li>
      <li>Takip raporunun hazırlanması</li>
    </ul>
    ` : ''}
    
    <div class="attachment-note">
      Detaylı Rapor ve Saha Görüntüsü ektedir.
    </div>
    
    <div class="footer">
      <div class="signature">Saygılarımızla,<br>SafeGuard AI Sistemi</div>
      <div style="margin-top: 15px;">
        İş Güvenliği ve Sağlığı Yönetim Sistemi
      </div>
      <div style="margin-top: 15px; font-style: italic;">
        Bu rapor otomatik olarak oluşturulmuştur.<br>
        Rapor Tarihi: ${formattedDate}
      </div>
    </div>
  </div>
</body>
</html>
`;

// HTML'i Binary Dosyaya Çevirme (Drive İçin)
const htmlBuffer = Buffer.from(htmlBody);

// Çıktıyı hazırla
const outputItem = {
  json: {
    to: recipient || '', // V2: Tek recipient
    cc: Array.isArray(ccRecipients) && ccRecipients.length > 0 
        ? ccRecipients.join(', ') 
        : '',
    subject: request.subject || request.emailSubject || 'İş Güvenliği Kontrol Raporu', // V2: subject
    body: htmlBody,
    folderName: `SafeGuard_Reports_${dateForFolder}`,
    reportFileName: `SafeGuard_Rapor_${new Date().getTime()}.html`,
    analysis: cleanAnalysis,
    riskLevel: request.riskLevel || 'ORTA',
  },
  binary: {
    data: {
        data: htmlBuffer.toString('base64'),
        mimeType: 'text/html',
        fileName: `SafeGuard_Rapor_${new Date().getTime()}.html`
    }
  }
};

// Binary data'yı doğru formatta ekle (image için)
if (imageBuffer) {
  outputItem.binary.image = {
    data: imageBuffer,
    mimeType: 'image/jpeg',
    fileName: imageName
  };
}

return [outputItem];
```

## Önemli Değişiklikler:

1. **`request.recipient`** (tek string) → `recipients` array'e çevrildi
2. **`request.final_message`** kullanılıyor (eski `request.analysis` fallback olarak)
3. **`request.subject`** kullanılıyor (eski `request.emailSubject` fallback olarak)
4. **Folder name**: `SafeGuard_Reports_YYYY-MM-DD` formatında

## İki Webhook Sorunu İçin Çözüm:

İki ayrı webhook yerine, tek bir workflow'da iki webhook'u birleştirebilirsiniz. Ancak bu durumda Flutter'dan iki ayrı request göndermeniz gerekir (biri analyze, biri send).

Alternatif olarak, analyze workflow'undan sonra send workflow'unu tetikleyebilirsiniz, ama bu durumda Flutter'dan sadece analyze request'i gönderirsiniz ve n8n içinde send işlemini de yaparsınız.
