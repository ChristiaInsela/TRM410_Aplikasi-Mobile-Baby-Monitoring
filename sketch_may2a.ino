#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <DHT.h>

// Definisi pin
#define DHTPIN D4
#define PIRPIN D5
#define BUZZERPIN D6

// Tipe sensor DHT
#define DHTTYPE DHT11

// Inisialisasi sensor DHT
DHT dht(DHTPIN, DHTTYPE);

// Konfigurasi WiFi
const char* ssid = "Xiaomi 13T";
const char* password = "uangseribuan";

// Konfigurasi Firebase
FirebaseConfig config;
FirebaseAuth auth;

FirebaseData firebaseData;

void setup() {
  Serial.begin(115200);
  dht.begin();
  
  pinMode(PIRPIN, INPUT);
  pinMode(BUZZERPIN, OUTPUT);

  // Koneksi ke WiFi
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.println("Connected to WiFi");

  // Konfigurasi Firebase
  config.host = "ivanfirebase-5f82c-default-rtdb.firebaseio.com";
  config.signer.tokens.legacy_token = "gpsXxkEvPG8Z1FvJFzEaM5fus4WFhQd3Zx4Xevz0";

  Firebase.begin(&config, &auth);
  
  if (Firebase.ready()) {
    Serial.println("Koneksi ke Firebase berhasil");
  } else {
    Serial.println("Koneksi ke Firebase gagal");
  }

  Serial.println("Sensor DHT11 dan PIR siap digunakan.");
}

void loop() {
  // Membaca data dari sensor DHT11
  float h = dht.readHumidity();
  float t = dht.readTemperature();

  // Periksa apakah pembacaan berhasil
  if (isnan(h) || isnan(t)) {
    Serial.println("Gagal membaca dari sensor DHT11!");
    return;
  }

  // Cetak data ke Serial Monitor
  Serial.print("Kelembaban: ");
  Serial.print(h);
  Serial.print(" %\t");
  Serial.print("Suhu: ");
  Serial.print(t);
  Serial.println(" *C");

  // Membaca status dari sensor PIR
  int pirVal = digitalRead(PIRPIN);

  // Menyimpan data ke Firebase
  if (Firebase.setFloat(firebaseData, "/sensor/dht11/humidity", h)) {
    Serial.println("Kelembaban berhasil dikirim ke Firebase");
  } else {
    Serial.println("Gagal mengirim kelembaban ke Firebase");
    Serial.println(firebaseData.errorReason());
  }

  if (Firebase.setFloat(firebaseData, "/sensor/dht11/temperature", t)) {
    Serial.println("Suhu berhasil dikirim ke Firebase");
  } else {
    Serial.println("Gagal mengirim suhu ke Firebase");
    Serial.println(firebaseData.errorReason());
  }


  if (Firebase.setInt(firebaseData, "/sensor/pir", pirVal)) {
    Serial.println("Status PIR berhasil dikirim ke Firebase");
    digitalWrite(BUZZERPIN, HIGH);
  } else {
    Serial.println("Gagal mengirim status PIR ke Firebase");
    Serial.println(firebaseData.errorReason());
  }

  if (pirVal == 1) {
    Serial.println(pirVal);
    digitalWrite(BUZZERPIN, HIGH);
  } else {
    Serial.println("Tidak ada gerakan.");
    digitalWrite(BUZZERPIN, LOW);
  }

  // Penundaan untuk stabilitas pembacaan
  delay(2000);
}
