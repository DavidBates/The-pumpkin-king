//Made with ❤ by magician.dev sourced from multiple projects and utilizes some great libraries. This code is of course CCSA 4.0 unless otherwise stated by library vendors. 
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "esp_system.h"
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "pumpkin_graphic.h"

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64

BLEServer* pServer = nullptr;
BLECharacteristic* pCharacteristic = nullptr;
bool deviceConnected = false;

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

const int buttonPin = 25;
#define SERVICE_UUID        "BF5CBE24-E475-4EF2-B3A4-B2B1E498EB94"
#define CHARACTERISTIC_UUID "B07488D0-BEDA-457F-8169-C7AA6AB8C6A8"

unsigned long lastCheck = 0;
unsigned long checkTime = 1000;
bool isPersonDetected = false;

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
        deviceConnected = false;
        esp_restart();
    }
};

void setup() {
  Serial.begin(115200);
  BLEDevice::init("Pumpkin King Human Detector");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ |
                      BLECharacteristic::PROPERTY_WRITE |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  pCharacteristic->addDescriptor(new BLE2902());
  pService->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();
  pinMode(buttonPin, INPUT);
  Wire.begin(5, 4);
  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C, false, false)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;);
  }
  delay(2000);
  updateDisplay("Waiting a client connection to notify...");
}

void updateDisplay(String txt){
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  Serial.println(txt);
  display.drawBitmap(0, 32, epd_bitmap_pumkin_king_oled, 41, 32, 1);
  display.setCursor(0,0);
  display.print(txt);
  display.display();
}

void loop() {
  if (deviceConnected) {
    
//    int reading = digitalRead(buttonPin);
      int reading = analogRead(buttonPin);
      
    if (reading < 3400){
      isPersonDetected = true;
    }
    Serial.println(reading);
    if ((millis() - lastCheck) > checkTime) {
                   
      if (isPersonDetected) {
        Serial.println("PERSON_DETECTED");
        updateDisplay("PERSON_DETECTED");
        pCharacteristic->setValue("PERSON_DETECTED");
        pCharacteristic->notify();
        isPersonDetected = false;
      } else {
        pCharacteristic->setValue("NO_PERSON");
        Serial.println("NO_PERSON");
        updateDisplay("NO_PERSON");
//        Didn't need to notify on no person but could. 
//        pCharacteristic->notify();
      }
      lastCheck = millis();
     }
    }
    delay(50);
  }
