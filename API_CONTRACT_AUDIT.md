# 🔍 API Contract Audit - SafeGuard AI

## 📋 Flow 1: Analysis Flow (Image → Gemini)

### **REQUEST** (Flutter → n8n)

**Endpoint:** `POST /webhook-test/analyze`

**Content-Type:** `multipart/form-data`

**Request Body Structure:**
```json
{
  "data": <MultipartFile>
}
```

**Key Details:**
- **Image Key:** `data` (MultipartFile object)
- **Filename:** `upload.jpg` (hardcoded)
- **No prompt/text field** - Prompt n8n workflow içinde Gemini node'unda tanımlı

**Actual Request (FormData):**
```
FormData {
  'data': MultipartFile(
    path: '/path/to/image.jpg',
    filename: 'upload.jpg',
    contentType: image/jpeg
  )
}
```

**Code Reference:**
```dart
// lib/features/analysis/data/datasources/analysis_remote_datasource.dart:18-23
final formData = FormData.fromMap({
  'data': await MultipartFile.fromFile(
    imagePath,
    filename: 'upload.jpg',
  ),
});
```

---

### **RESPONSE** (n8n → Flutter)

**Expected JSON Structure:**
```json
{
  "success": true,
  "analysis": "Fotoğrafta, camın kırılmasına neden olan bir sert yumruk darbesi görülmektedir...",
  "risk_level": "YÜKSEK"
}
```

**Key Details:**
- ✅ **success:** `boolean` (required)
- ✅ **analysis:** `string` (required) - Analiz metni
- ✅ **risk_level:** `string` (required) - **SNAKE_CASE** (not camelCase!)

**Code Reference:**
```dart
// lib/features/analysis/data/models/analysis_response_model.dart:16-20
const factory AnalysisResponseModel({
  required bool success,
  required String analysis,
  @JsonKey(name: 'risk_level') required String riskLevel, // ⚠️ JSON'da 'risk_level'
}) = _AnalysisResponseModel;
```

**⚠️ CRITICAL:** n8n'den `risk_level` (snake_case) göndermelisiniz, `riskLevel` (camelCase) değil!

---

## 📋 Flow 2: Report Flow (Final Report → Mail/Drive)

### **REQUEST** (Flutter → n8n)

**Endpoint:** `POST /webhook-test/send`

**Content-Type:** `application/json`

**Request Body Structure:**
```json
{
  "image": "iVBORw0KGgoAAAANSUhEUgAA...",
  "final_message": "Fotoğrafta, camın kırılmasına neden olan bir sert yumruk darbesi görülmektedir. Kırık cam, kesici kenarları nedeniyle ciddi yaralanma riski oluşturur.",
  "riskLevel": "YÜKSEK",
  "recipient": "raporlama@sirket.com",
  "subject": "İş Güvenliği Kontrol Raporu - YÜKSEK RİSK"
}
```

**Key Details:**
- ✅ **image:** `string` (base64 encoded image)
- ✅ **final_message:** `string` (kullanıcının düzenlediği analiz metni)
- ✅ **riskLevel:** `string` (YÜKSEK, ORTA, DÜŞÜK) - **camelCase**
- ✅ **recipient:** `string` (tek bir email adresi, array değil!)
- ✅ **subject:** `string` (email başlığı)

**Code Reference:**
```dart
// lib/features/analysis/data/models/send_report_request.dart:21-35
Map<String, dynamic> toJson() {
  final imageFile = File(imagePath);
  final imageBytes = imageFile.readAsBytesSync();
  final base64Image = base64Encode(imageBytes);

  return {
    'image': base64Image,
    'final_message': finalMessage,
    'riskLevel': riskLevel,
    'recipient': recipient,
    'subject': subject,
  };
}
```

**⚠️ IMPORTANT NOTES:**
- Image **her seferinde tekrar gönderiliyor** (base64 string olarak)
- `recipient` tek bir string, array değil
- `final_message` (snake_case), `riskLevel` (camelCase) - karışık naming!

---

### **RESPONSE** (n8n → Flutter)

**Expected JSON Structure:**
```json
{
  "success": true,
  "emailSent": true,
  "driveFileCreated": true,
  "pdfGenerated": true,
  "driveFileUrl": "https://drive.google.com/file/d/xxx/view",
  "pdfUrl": "https://storage.googleapis.com/xxx/report.pdf",
  "message": "Rapor başarıyla gönderildi"
}
```

**Key Details:**
- ✅ **success:** `boolean` (required) - Ana başarı flag'i
- ✅ **emailSent:** `boolean` (default: false)
- ✅ **driveFileCreated:** `boolean` (default: false)
- ✅ **pdfGenerated:** `boolean` (default: false)
- ✅ **driveFileUrl:** `string?` (optional)
- ✅ **pdfUrl:** `string?` (optional)
- ✅ **message:** `string?` (optional)

**Success Criteria:**
- App `success: true` kontrolü yapıyor
- `emailSent`, `driveFileCreated`, `pdfGenerated` flag'leri UI'da gösteriliyor

**Code Reference:**
```dart
// lib/features/analysis/data/models/send_report_response.dart:21-31
factory SendReportResponse.fromJson(Map<String, dynamic> json) {
  return SendReportResponse(
    success: json['success'] ?? false,
    emailSent: json['emailSent'] ?? false,
    driveFileCreated: json['driveFileCreated'] ?? false,
    pdfGenerated: json['pdfGenerated'] ?? false,
    driveFileUrl: json['driveFileUrl'],
    pdfUrl: json['pdfUrl'],
    message: json['message'],
  );
}
```

---

## 🔑 Key Naming Summary

### Analysis Flow:
| Flutter Field | JSON Key (n8n → Flutter) | Type |
|--------------|---------------------------|------|
| success | `success` | boolean |
| analysisText | `analysis` | string |
| riskLevel | `risk_level` ⚠️ | string |

### Report Flow:
| Flutter Field | JSON Key (Flutter → n8n) | Type |
|--------------|---------------------------|------|
| image | `image` | string (base64) |
| finalMessage | `final_message` | string |
| riskLevel | `riskLevel` | string |
| recipient | `recipient` | string |
| subject | `subject` | string |

| Flutter Field | JSON Key (n8n → Flutter) | Type |
|--------------|---------------------------|------|
| success | `success` | boolean |
| emailSent | `emailSent` | boolean |
| driveFileCreated | `driveFileCreated` | boolean |
| pdfGenerated | `pdfGenerated` | boolean |
| driveFileUrl | `driveFileUrl` | string? |
| pdfUrl | `pdfUrl` | string? |
| message | `message` | string? |

---

## ⚠️ Critical Mismatches to Fix in n8n:

1. **Analysis Response:** n8n `risk_level` (snake_case) göndermeli, `riskLevel` değil
2. **Report Request:** n8n `final_message` ve `recipient` (tek string) beklemeli
3. **Report Request:** n8n `riskLevel` (camelCase) beklemeli, `risk_level` değil
