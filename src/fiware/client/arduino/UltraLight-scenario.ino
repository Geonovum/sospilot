#include <utility/debug.h>
#include <avr/wdt.h>
#include <Adafruit_CC3000.h>
#include <ccspi.h>
#include <SPI.h>
#include <DHT.h>
#include <UltraLight2.h>
#include "Network.h"
#include "DustSensor.h"

#define DHT_PIN         (6)
#define DHT_TYPE        (DHT22)
#define LED_PIN         (7)
#define PM25_PIN        (8)
#define PM10_PIN        (9)
#define WIFI_IRQ_PIN    (3)  // MUST be an interrupt pin!
#define WIFI_VBAT_PIN   (5)
#define WIFI_CS_PIN     (10)
#define WLAN_SSID       "KIBI"  // cannot be longer than 32 characters!
#define WLAN_PASS       "welkom123"
#define WLAN_SECURITY   WLAN_SEC_WPA2

const char* host = "sensors.geonovum.nl";
const int   port = 8000;
const char* deviceName = "Dust13";
const char* temperatureAttrib = "temperature";
const char* humidityAttrib = "humidity";
const char* pm25Attrib = "pm2.5";
const char* pm10Attrib = "pm10";

Adafruit_CC3000 cc3000 = Adafruit_CC3000(WIFI_CS_PIN, WIFI_IRQ_PIN, WIFI_VBAT_PIN, SPI_CLOCK_DIVIDER);
DHT dht(DHT_PIN, DHT_TYPE);
DustSensor dustSensor(PM25_PIN, PM10_PIN);

Device device(deviceName);
HttpPublisher *wifiPublisher;


void setup() {
  Serial.begin(115200);
  Serial.print(F("RAM:")); Serial.println(getFreeRam(), DEC);
  pinMode(LED_PIN, OUTPUT);   // We blink a LED for every succesful send

  blinkLED(1, LED_PIN);
  connectAcessPoint(cc3000, WLAN_SSID, WLAN_PASS, WLAN_SECURITY);

  ultraLightDebugging = true; // True: outputs debug info on Serial

  device.addStaticAttribute("position", 52.35, 4.93);
  device.addFloatAttribute(temperatureAttrib);
  device.addFloatAttribute(humidityAttrib);
  device.addFloatAttribute(pm25Attrib);
  device.addFloatAttribute(pm10Attrib);

  dht.begin();
  wdt_enable(WDTO_8S);  // Enable watchdog 8 seconds. WIFI commands can hang on the CC3300...

  blinkLED(2, LED_PIN);
  getHostIP(cc3000, host);

  blinkLED(3, LED_PIN);
  Adafruit_CC3000_Client connection = cc3000.connectTCP(ipHost, port);
  if (connection.connected()) {
    wifiPublisher = new HttpPublisher(&connection, &device);
    printResponse(connection);
    connection.close();
  }
  else {
    Serial.println(F("Could not register the device"));
  }
}


void loop(void) {
  wdt_reset();
  Serial.print(F("RAM:")); Serial.println(getFreeRam(), DEC);

  float humidity = dht.readHumidity(); wdt_reset();
  float temperature = dht.readTemperature(); wdt_reset();
  DustInfo dust = dustSensor.measure(3000); wdt_reset();

  Observation observation = device.createObservation();
  observation.setAttribute(humidityAttrib, humidity);
  observation.setAttribute(temperatureAttrib, temperature);
  observation.setAttribute(pm25Attrib, dust.pm25);
  observation.setAttribute(pm10Attrib, dust.pm10);

  Adafruit_CC3000_Client connection = cc3000.connectTCP(ipHost, port);
  if (connection.connected()) {
    wifiPublisher->send(&connection, &observation);
    printResponse(connection);
    connection.close();

    blinkLED(1, LED_PIN);
  }
  else {
    Serial.println(F("Couldn't connect!"));
  }
}

