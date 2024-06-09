#include <WiFi.h>
#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pwm;

const char* ssid = "ssid";
const char* password = "wifipassword";

WiFiServer server(80);
void turnmotor() {
  
  
      // Move servo from 0 to 45 degrees
      pwm.setPWM(0, 0, map(160, 0, 180, 150, 600)); // Adjust the values as needed
      delay(500); // Wait for 1 second

      // Move servo back from 45 to 0 degrees
      pwm.setPWM(0, 0, map(0, 0, 160, 150, 600));
      delay(500); // Wait for 1 second
  
  }
void setup() {
    Serial.begin(115200);
    delay(100);

    // Initialize PWM servo driver
    pwm.begin();
    pwm.setPWMFreq(60);  // Analog servos run at ~60 Hz updates
    
    // Connect to WiFi
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("");
    Serial.println("WiFi connected.");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());

    server.begin();
}

void loop() {
    WiFiClient client = server.available();
    if (!client) {
        return;
    }

    Serial.println("New client");
    while (!client.available()) {
        delay(1);
    }

    String request = client.readStringUntil('\r');
    client.flush();

    if (request.indexOf("/H") != -1) {
        turnmotor(); // Turn servo
    } else if (request.indexOf("/L") != -1) {
        digitalWrite(5, LOW); // Turn LED off
    }

    // Respond to the client
    client.println("HTTP/1.1 200 OK");
    client.println("Content-Type: text/html");
    client.println();
    client.println("<!DOCTYPE HTML>");
    client.println("<html>");
    client.println("<head></head><body>");
    client.println("Click <a href=\"/H\">here</a> to turn the servo motor.");
    client.println("Click <a href=\"/L\">here</a> to turn off the servo motor.");
    client.println("</body></html>");
    delay(1);
    Serial.println("Client disconnected");
}
