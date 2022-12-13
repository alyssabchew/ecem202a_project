/*
  This is a deriverative work based on these sources: 
  https://github.com/arduino/ArduinoCore-mbed/tree/master/libraries/MLC/examples
 WIFININA (arduino library) examples, WifiPing
 NTPClient(arduino library)/examples/basic
 LSM6DSOXsensor examples 
 X_NUCLEO_IKS01A3_LSM6DSOX_MLC.ino by SRA
 
*/

// Includes
#include <NTPClient.h>
#include <WiFiNINA.h>
#include <WiFiUdp.h>
#include <LSM6DSOXSensor.h>
#include "testfin.h"
#include <SPI.h>
//#include "time.h"


#define INT_1 INT_IMU

WiFiClient client;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP);
int acc_stat = 1;
char server[] = "maker.ifttt.com";
char ssid[] = "UCLA_RES_IOT";        // your network SSID (name)
char pass[] = "Iphone#1999";    // your network password (use for WPA, or use as key for WEP)
int status = WL_IDLE_STATUS;     // the WiFi radio's status
char ntpServer[] = "tick.ucla.edu";
const long  gmtOffset_sec = 0;
const int   daylightOffset_sec = 0;
int sec = 0;
int lcount = 0;
//Interrupts.
volatile int mems_event = 0;

// Components
LSM6DSOXSensor AccGyr(&Wire, LSM6DSOX_I2C_ADD_L);

// MLC
ucf_line_t *ProgramPointer;
int32_t LineCounter;
int32_t TotalNumberOfLine;

void INT1Event_cb();
void printMLCStatus(uint8_t status);

void setup()
{
  uint8_t mlc_out[8];
  // Led.
  pinMode(LEDB, OUTPUT);
  pinMode(LEDG, OUTPUT);
  pinMode(LEDR, OUTPUT);
  digitalWrite(LEDB, LOW);
  digitalWrite(LEDG, LOW);
  digitalWrite(LEDR, LOW);

  // Initialize serial for output.
  Serial.begin(115200);
  // Initialize I2C bus.
  Wire.begin();

  AccGyr.begin();
  AccGyr.Enable_X();
  AccGyr.Enable_G();
  AccGyr.Set_X_ODR(104.0f);
  AccGyr.Set_X_FS(2);

  /* Feed the program to Machine Learning Core */
  /* Motion Intensity Default program */
  ProgramPointer = (ucf_line_t *)testfin;
  TotalNumberOfLine = sizeof(testfin) / sizeof(ucf_line_t);
  Serial.println("Motion Intensity for LSM6DSOX MLC");
  Serial.print("UCF Number Line=");
  Serial.println(TotalNumberOfLine);

  for (LineCounter = 0; LineCounter < TotalNumberOfLine; LineCounter++) {
    if (AccGyr.Write_Reg(ProgramPointer[LineCounter].address, ProgramPointer[LineCounter].data)) {
      Serial.print("Error loading the Program to LSM6DSOX at line: ");
      Serial.println(LineCounter);
      while (1) {
        // Led blinking.
        digitalWrite(LED_BUILTIN, HIGH);
        delay(250);
        digitalWrite(LED_BUILTIN, LOW);
        delay(250);
      }
    }
  }

  Serial.println("Program loaded inside the LSM6DSOX MLC");


 
  //AccGyr.Set_G_ODR(104.0f);
  //AccGyr.Set_G_FS(2000);

  //Interrupts.
  pinMode(INT_1, INPUT);
  attachInterrupt(INT_1, INT1Event_cb, RISING);
  delay(3000);
  AccGyr.Get_MLC_Output(mlc_out);
  printMLCStatus(mlc_out[0],1);
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    // don't continue
    while (true);
  }
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
    status = WiFi.begin(ssid, pass);

    // wait 10 seconds for connection:
    delay(10000);
  }
  Serial.println("Connected to WiFi");
//   timeClient.begin();
  printWifiStatus();
digitalWrite(LEDG, HIGH);
delay(1000);
}

void loop()
{
  lcount +=1;
  
  if (mems_event) {
    mems_event = 0;
    LSM6DSOX_MLC_Status_t status;
    AccGyr.Get_MLC_Status(&status);
    //Serial.println("debug");
    if (status.is_mlc1) {
      uint8_t mlc_out[8];
      AccGyr.Get_MLC_Output(mlc_out);

      printMLCStatus(mlc_out[0], acc_stat);
      if (mlc_out[0] == uint8_t(0) || lcount > 500) { 
        lcount = 0;
        digitalWrite(LEDG, HIGH);
        acc_stat = 0;
      } else{
      acc_stat = 1;
    }
    }
  }
}

void INT1Event_cb()
{
  mems_event = 1;
}

void printMLCStatus(uint8_t status, int acc_stats)
{
  String urlstart = "POST /trigger/test/with/key/b0P9Uu_Dc-4YuGZ8AA_Ddo?value1=";
  String urlstop = " HTTP/1.1\r\nHost: maker.ifttt.com\r\n";
  String finalurl = "";
  switch (status) {
    case 0:
      // Reset leds status
      digitalWrite(LEDB, LOW);
      digitalWrite(LEDG, LOW);
      digitalWrite(LEDR, LOW);
      // LEDB On
      digitalWrite(LEDB, HIGH);
      Serial.println("idle");

      break;
          case 1:
      // Reset leds status
      digitalWrite(LEDB, LOW);
      digitalWrite(LEDG, LOW);
      digitalWrite(LEDR, LOW);
      // LEDB On
      digitalWrite(LEDB, HIGH);
      Serial.println("idle");

      break;
      /**
   case 4:
      // Reset leds status
      digitalWrite(LEDB, LOW);
      digitalWrite(LEDG, LOW);
      digitalWrite(LEDR, LOW);
      // LEDG On
      digitalWrite(LEDG, HIGH);
                   timeClient.update();
       sec = timeClient.getSeconds() + 1;
       Serial.println(sec);
      Serial.println("walk");
      break;
     **/
    case 4:
      // Reset leds status
      digitalWrite(LEDB, LOW);
      digitalWrite(LEDG, LOW);
      digitalWrite(LEDR, LOW);
      // LEDR On
      digitalWrite(LEDR, HIGH);
       timeClient.update();
       sec = timeClient.getSeconds() + 1;
       Serial.print(sec);
      Serial.println(" side"); 
       if(acc_stats == 0) {
         if (client.connect(server, 80)){
          finalurl = urlstart + String(sec) + urlstop ;
          client.println(finalurl);
          client.println("Connection: close");
          client.println();
          digitalWrite(LEDG, HIGH);
        }      
      } else {
        Serial.println("push skipped");
      }
 
      break;
    case 8: 
     digitalWrite(LEDB, LOW);
      digitalWrite(LEDG, LOW);
      digitalWrite(LEDR, LOW);
      // LEDR On
      digitalWrite(LEDG, HIGH);
       timeClient.update();
       sec = (timeClient.getSeconds() - 2)%61;
        Serial.print(sec);
        Serial.println(" wing"); 
         if(acc_stats == 0) {
           if (client.connect(server, 80)){
            finalurl = urlstart + String(sec) + urlstop ;
            client.println(finalurl);
            client.println("Connection: close");
            client.println();
           }
       } else {
        Serial.println("push skipped");
      }
      break;
    default:
      // Reset leds status
      digitalWrite(LEDB, LOW);
      digitalWrite(LEDG, LOW);
      digitalWrite(LEDR, LOW);
      Serial.println("sting");

      break;
  }
}

void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}
