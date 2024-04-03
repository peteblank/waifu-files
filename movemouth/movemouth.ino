#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pwm;

void setup() {
  Serial.begin(9600); // Initialize serial communication
  pwm.begin();
  pwm.setPWMFreq(60); // Set PWM frequency to 60Hz
}

void loop() {
  if (Serial.available()) {
    char input = Serial.read(); // Read user input

    if (input == '1') {
      // Move servo from 0 to 45 degrees
      pwm.setPWM(0, 0, map(160, 0, 180, 150, 600)); // Adjust the values as needed
      delay(500); // Wait for 1 second

      // Move servo back from 45 to 0 degrees
      pwm.setPWM(0, 0, map(0, 0, 160, 150, 600));
      delay(500); // Wait for 1 second
    }
  }
}