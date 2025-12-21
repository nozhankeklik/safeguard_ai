# CLEAN ARCHITECTURE + BLoC MİGRASYON ANALİZİ

## 1. MEVCUT DOSYA YAPISI

### Aktif Dart Dosyaları (3 adet):

```
lib/
├── main.dart                                    (31 satır)
├── features/
│   ├── camera/
│   │   └── camera_screen.dart                  (382 satır)
│   └── analysis/
│       └── api_service.dart                    (24 satır)
```

### Boş Klasörler:

- `lib/config/`
- `lib/core/constants/`
- `lib/core/errors/`
- `lib/core/utils/`
- `lib/services/`

---

## 2. FONKSİYON ANALİZİ VE YENİ YAPIDA KULLANIM PLANI

### 2.1 `main.dart` - Uygulama Giriş Noktası

**Mevcut İçerik:**

- `SafeGuardApp` widget'ı
- MaterialApp yapılandırması
- Dark theme tanımları
- CameraScreen başlangıç ekranı

**Yeni Yapıda Kullanım:**

- ✅ **Theme yapılandırması** → `lib/core/theme/app_theme.dart`'a taşınacak
- ✅ **MaterialApp** → BLoC Provider ile sarmalanacak
- ✅ **Başlangıç ekranı** → Router yapılandırmasına taşınacak

**Kopyalanacak Kod:**

```dart
// Theme yapılandırması (satır 16-25)
ThemeData(
  colorScheme: ColorScheme.dark(...),
  scaffoldBackgroundColor: Colors.black,
  useMaterial3: true,
)
```

---

### 2.2 `camera_screen.dart` - Kamera Mantığı

#### ✅ **`_initializeCamera()` (Satır 28-73)**

**Ne Yapıyor:**

- Kamera izni kontrolü ve isteği
- Mevcut kameraları listeleme
- Arka kamera seçimi
- CameraController oluşturma ve başlatma

**Yeni Yapıda Kullanım:**

- 📍 **Domain Layer:** `CameraUseCase` içinde
- 📍 **Data Layer:** `CameraRepository` içinde
- 📍 **BLoC:** `CameraBloc` event'lerinde (InitializeCameraEvent)

**Kopyalanacak Mantık:**

```dart
// İzin kontrolü (satır 31-36)
final status = await Permission.camera.request();
if (!status.isGranted) return;

// Kamera seçimi (satır 39-56)
final cameras = await availableCameras();
CameraDescription? backCamera;
for (var camera in cameras) {
  if (camera.lensDirection == CameraLensDirection.back) {
    backCamera = camera;
    break;
  }
}
backCamera ??= cameras.first;

// Controller oluşturma (satır 59-62)
controller = CameraController(backCamera, ResolutionPreset.medium, enableAudio: false);
await controller!.initialize();
```

---

#### ✅ **`_killCamera()` (Satır 75-84)**

**Ne Yapıyor:**

- CameraController'ı güvenli şekilde dispose ediyor

**Yeni Yapıda Kullanım:**

- 📍 **BLoC:** `CameraBloc` dispose metodunda
- 📍 **Repository:** `CameraRepository.disposeCamera()`

**Kopyalanacak Mantık:**

```dart
// Dispose logic (satır 76-83)
if (controller != null) {
  try {
    await controller!.dispose();
  } catch (e) {
    print('Kamera dispose hatası: $e');
  }
}
controller = null;
```

---

#### ✅ **`_onTakePicture()` (Satır 156-214)**

**Ne Yapıyor:**

- Fotoğraf çekme
- **KRİTİK:** Kamera lifecycle yönetimi (shouldShowCamera = false → delay → dispose)
- API çağrısı tetikleme

**Yeni Yapıda Kullanım:**

- 📍 **BLoC Event:** `TakePictureEvent`
- 📍 **BLoC Logic:** `CameraBloc` içinde
- 📍 **UseCase:** `TakePictureUseCase`

**Kopyalanacak Mantık (KRİTİK SEQUENCE):**

```dart
// Step 1: Fotoğraf çek (satır 164)
final XFile file = await controller!.takePicture();

// Step 2: UI'dan kaldır (satır 167-170)
setState(() {
  shouldShowCamera = false;
});

// Step 3: Hardware buffer release (satır 174)
await Future.delayed(const Duration(milliseconds: 200));

// Step 4: Dispose (satır 177)
await _killCamera();

// Step 5: State güncelle (satır 181-184)
setState(() {
  capturedImage = File(file.path);
  isAnalyzing = true;
});
```

**⚠️ ÖNEMLİ:** Bu sequence Android'de kamera crash'lerini önlemek için kritik. BLoC'da da aynı sırayı koruyun!

---

#### ✅ **`_parseGeminiResponse()` (Satır 86-154)**

**Ne Yapıyor:**

- Gemini AI yanıtını parse ediyor
- İç içe JSON yapısını ayrıştırıyor
- Markdown code block'ları temizliyor
- Risk ve öneri çıkarıyor

**Yeni Yapıda Kullanım:**

- 📍 **Data Layer:** `AnalysisRemoteDataSource` içinde
- 📍 **Domain Layer:** `AnalysisResult` entity'sine map edilecek
- 📍 **Mapper:** `AnalysisResponseMapper` class'ı

**Kopyalanacak Mantık:**

```dart
// Tüm parse logic (satır 86-154)
// Bu fonksiyonun tamamı mapper class'ına taşınacak
Map<String, String> parseGeminiResponse(dynamic responseData) {
  // Step 1-5: Tüm parse logic'i
  // ...
  return {'risk': risk, 'oneri': oneri};
}
```

**Yeni Yapı:**

```dart
// lib/features/analysis/data/mappers/analysis_response_mapper.dart
class AnalysisResponseMapper {
  static AnalysisResult fromGeminiResponse(dynamic responseData) {
    // Mevcut _parseGeminiResponse logic'i buraya
  }
}
```

---

#### ✅ **`_handleDialogClose()` (Satır 216-225)**

**Ne Yapıyor:**

- Dialog kapatıldığında state'i temizliyor
- Kamerayı yeniden başlatıyor

**Yeni Yapıda Kullanım:**

- 📍 **BLoC Event:** `ResetCameraEvent`
- 📍 **BLoC Logic:** State'i sıfırla ve kamera başlat

**Kopyalanacak Mantık:**

```dart
// State temizleme ve kamera restart (satır 218-224)
setState(() {
  capturedImage = null;
  shouldShowCamera = true;
});
await _initializeCamera();
```

---

#### ⚠️ **`_showResultDialog()` ve `_showErrorDialog()` (Satır 227-294)**

**Ne Yapıyor:**

- AlertDialog gösteriyor
- UI logic içeriyor

**Yeni Yapıda Kullanım:**

- 📍 **Presentation Layer:** Widget olarak ayrılacak
- 📍 **BLoC:** State değişikliğine göre dialog gösterilecek
- 📍 **Widget:** `lib/features/analysis/presentation/widgets/analysis_result_dialog.dart`

**Kopyalanacak Mantık:**

- Dialog UI yapısı (satır 231-267, 271-293)
- Mesaj formatları

---

### 2.3 `api_service.dart` - API Mantığı

#### ✅ **`uploadImage()` (Satır 12-22)**

**Ne Yapıyor:**

- Multipart form data oluşturuyor
- Dio ile POST isteği yapıyor
- Hata yönetimi (try-catch)

**Yeni Yapıda Kullanım:**

- 📍 **Data Layer:** `AnalysisRemoteDataSource.uploadImage()`
- 📍 **Repository:** `AnalysisRepository.analyzeImage()`
- 📍 **UseCase:** `AnalyzeImageUseCase`

**Kopyalanacak Mantık:**

```dart
// FormData oluşturma (satır 14)
final formData = FormData.fromMap({
  'data': await MultipartFile.fromFile(
    imagePath,
    filename: 'upload.jpg'
  )
});

// POST isteği (satır 16)
final response = await _dio.post('', data: formData);
```

**Yeni Yapı:**

```dart
// lib/features/analysis/data/datasources/analysis_remote_datasource.dart
class AnalysisRemoteDataSource {
  final Dio dio;

  Future<Map<String, dynamic>> uploadImage(String imagePath) async {
    // Mevcut uploadImage logic'i buraya
  }
}
```

---

#### ⚠️ **Dio Yapılandırması (Satır 4-10)**

**Ne Yapıyor:**

- Dio instance oluşturuyor
- Base URL ve timeout ayarları

**Yeni Yapıda Kullanım:**

- 📍 **Core/Config:** `lib/core/config/api_config.dart`
- 📍 **Dependency Injection:** GetIt veya BLoC Provider
- 📍 **Constants:** `lib/core/constants/api_constants.dart`

**Kopyalanacak Değerler:**

```dart
baseUrl: 'http://localhost:5678/webhook/analyze'
connectTimeout: Duration(seconds: 20)
receiveTimeout: Duration(seconds: 20)
```

---

## 3. YENİ YAPIDA KULLANIM HARİTASI

### Clean Architecture + BLoC Yapısı:

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart              ← main.dart theme (satır 16-25)
│   ├── config/
│   │   └── api_config.dart            ← Dio yapılandırması
│   └── constants/
│       └── api_constants.dart         ← URL, timeout değerleri
│
├── features/
│   ├── camera/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── camera_state.dart
│   │   │   └── usecases/
│   │   │       ├── initialize_camera_usecase.dart  ← _initializeCamera()
│   │   │       └── take_picture_usecase.dart        ← _onTakePicture()
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── camera_repository_impl.dart      ← _killCamera()
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── camera_bloc.dart                 ← State management
│   │       └── screens/
│   │           └── camera_screen.dart               ← UI only
│   │
│   └── analysis/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── analysis_result.dart
│       │   └── usecases/
│       │       └── analyze_image_usecase.dart
│       ├── data/
│       │   ├── datasources/
│       │   │   └── analysis_remote_datasource.dart  ← uploadImage()
│       │   ├── mappers/
│       │   │   └── analysis_response_mapper.dart    ← _parseGeminiResponse()
│       │   └── repositories/
│       │       └── analysis_repository_impl.dart
│       └── presentation/
│           ├── bloc/
│           │   └── analysis_bloc.dart
│           └── widgets/
│               └── analysis_result_dialog.dart     ← _showResultDialog()
```

---

## 4. ÖNEMLİ NOTLAR

### ⚠️ KRİTİK: Kamera Lifecycle Sequence

```dart
// Bu sıra DEĞİŞTİRİLMEMELİ:
1. shouldShowCamera = false
2. Future.delayed(200ms)
3. controller.dispose()
```

Bu sequence Android'de crash'leri önler. BLoC'da da aynı sırayı koruyun.

### ✅ Güvenle Kopyalanabilir Fonksiyonlar:

1. `_initializeCamera()` - Kamera başlatma mantığı
2. `_killCamera()` - Dispose mantığı
3. `_parseGeminiResponse()` - Parse mantığı
4. `uploadImage()` - API çağrısı mantığı

### ⚠️ Refactor Edilmesi Gerekenler:

1. `_onTakePicture()` - BLoC event/state'e dönüştürülecek
2. `_showResultDialog()` - Widget'a ayrılacak
3. `_showErrorDialog()` - Widget'a ayrılacak
4. Dio yapılandırması - Config class'ına taşınacak

### 📝 Hardcoded Değerler (Constants'a taşınacak):

- `'http://localhost:5678/webhook/analyze'` → `ApiConstants.baseUrl`
- `Duration(seconds: 20)` → `ApiConstants.timeout`
- `ResolutionPreset.medium` → `CameraConstants.resolution`
- `Duration(milliseconds: 200)` → `CameraConstants.disposeDelay`

---

## 5. MİGRASYON ÖNCELİK SIRASI

1. **Yedekleme** ✅ (komut aşağıda)
2. **Constants oluştur** (hardcoded değerleri taşı)
3. **API Service → Data Source** (uploadImage mantığını taşı)
4. **Parse Logic → Mapper** (\_parseGeminiResponse'u taşı)
5. **Camera Logic → UseCase/Repository** (\_initializeCamera, \_killCamera)
6. **BLoC yapısını kur** (State management)
7. **UI refactor** (Dialog'ları widget'a ayır)

---

**Sonraki Adım:** Yedekleme komutunu çalıştırın ve ardından Clean Architecture + BLoC yapısını kurmaya başlayın.
