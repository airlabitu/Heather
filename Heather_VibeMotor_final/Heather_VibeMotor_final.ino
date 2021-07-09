int value = 0;
int vibePin = 6;

void setup() {
  Serial.begin(57600);
  pinMode(vibePin, OUTPUT);
}

void loop() {
  // read serial-data, if available
  while (Serial.available()) {
    //value = 0;
    value = Serial.read();
    analogWrite(vibePin,value);
  }

}
