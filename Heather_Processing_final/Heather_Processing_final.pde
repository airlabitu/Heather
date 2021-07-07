// Code by: Mai Hartmann maih@itu.dk and AIR LAB (Victor Permild - vbpe@itu.dk & Halfdan Hauch Jensen - halj@itu.dk) 
// 
// This code receives sensor info from the arduino MPR21, plays a soundfile 
// and uses touchpads to manipulate volume, lowpass, pan and a vibration motor
// sensor 0 controls lowpass, sensor 1 controls volume, sensor 2 controls pan, sensor 3 controls vibe
import processing.serial.*;
import processing.sound.*;

// sound objects and manipulators
SoundFile file3;
// Sound sound; // Needed for forcing audio over 3.5 mm. jack, if HDMI display has audio

//Create a new lowpass filter object
LowPass lowpass;

//Serial stuff
int numberOfSensors = 4;

Serial sensorArduinoPort;   // The serial port
Serial vibeArduinoPort;
int[] serialInArray = new int[3];    // Where we'll put what we receive
int [] sensorValue = new int [numberOfSensors]; // initializes the sensor array with 5 spaces
int value = 0; //this value holds the sensor value
int channel; //this describes the sensor channel

//Declare varaiables to later control lowpass filter, volume & pan
float lowpass_value, pan_value, volume_value;

void setup() {
  size(200, 200);
  background(255);
  

  // Setting the right output device for 3.5 mm jack
  // --- only needed if running with HDMI display with audio, but still wanting audio over 3-5 mm. jack 
  //
  // Sound.list(); // get sound output device list printed in console
  // sound = new Sound(this); 
  // sound.outputDevice(3); // set the output sound device from the list
  
  
  //Inlcude Soundfile object
  //file3 = new SoundFile(this, "emeraldRush_mono.wav");
  //file3 = new SoundFile(this, "tests/Nautilus.wav");
  file3 = new SoundFile(this, "tests/livetest_mono.wav");

  //Loop the playback of the file
  file3.loop();

  //Start sound manipulators/filters
  //lowpass = new LowPass(this);
  //lowpass.process(file3);
  
  String portName1 = "/dev/ttyACM0", portName2 = "/dev/ttyACM1";
  for (int i = 0; i < Serial.list().length; i++) {
    //Prints each Serial port name and its index before that
    println(i + ": ", Serial.list()[i]);
  }
  //Set the sensor ports according to appropiate Serial connections we printed just before
  //String portName1 = Serial.list()[1];
  //String portName2 = Serial.list()[2];
  sensorArduinoPort = new Serial(this, portName1, 9600);
  vibeArduinoPort = new Serial(this, portName2, 9600);
}

void draw() {
  //the dynamic values we use to manipulate the sound
  //lowpass_value = constrain(map(sensorValue[0], 139.0, 20.0, 200.0, 5000.0), 200.0, 5000.0);
  volume_value = constrain(map(sensorValue[1], 114.0, 20.0, 0.15, 2.0), 0.15, 1.0);
  pan_value = constrain(map(sensorValue[2], 136, 36.0, -0.7, 0.7), -0.7, 0.7);
  
  // Effect settings
  //lowpass.freq(lowpass_value);
  file3.amp(volume_value);
  //file3.amp(1); // for testing max volume
  file3.pan(pan_value);
  //
  //Optional: Prints the sensor values in the console. 
  showSensorValues();

  //Write data to the Arduino that controls the vibe motor.
  //The vibe motor runs on a separate Arduino, to not interfere with the capacitance sensor
  writeToVibe();
}

void showSensorValues() {
  //Maily used for debugging. Prints all sensor values as well as values for lowpass, volume and pan
  println("S0", sensorValue[0]); 
  println("S1", sensorValue[1]); 
  println("S2", sensorValue[2]); 
  println("S3", sensorValue[3]);
  println();
  println("lowpass: ", lowpass_value, " | volume: ", volume_value, " | pan: ", pan_value);
  println();
}


void serialEvent(Serial thisPort) {
  //Reads Serial data from the MPR121-connected Arduino

  if (thisPort == sensorArduinoPort) {
    // read a byte from the serial port:
    int inByte = thisPort.read();
    if ((inByte>='0') && (inByte<='9')) {
      value = 10*value + inByte - '0';
    } else {
      if (inByte=='c') channel = value;
      else if (inByte=='w') {
        //println("Done reading", channel, value);
        if (channel == 0) sensorValue[0] = value;
        else if (channel ==1) sensorValue[1] = value;
        else if (channel ==2) sensorValue[2] = value;
        else if (channel ==3) sensorValue[3] = value;
        else if (channel ==4) sensorValue[4] = value;
      }
      value = 0;
    }
  }

  if (thisPort == vibeArduinoPort) {
    // get message till line break (ASCII > 13)
    String message = "";
    message = thisPort.readStringUntil(13);
    // just if there is data
    if (message != null) {
      println("message received: "+trim(message));
    }
  }
}

void writeToVibe() {
  //This
  int number = int(map(sensorValue[3], 36, 136, 180, 0));
  if (number < 30) {
    number = 0;
  }

  //Send value to the Arduino that controls the vibe motor
  vibeArduinoPort.write(number);

  //Only used for debug, delete if unwanted
  println("Now sending number: "+number, " to vibe Arduino");
}
