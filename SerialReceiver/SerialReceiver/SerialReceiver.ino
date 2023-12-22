//*********************************************
// Time-Series Signal Processing
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

int sampleRate = 100; //samples per second
int sampleInterval = 1000000/sampleRate; //Inverse of SampleRate
long timer = micros(); //timer


int ledOn = 0; //to control the LED.

void setup() {
  Serial.begin(115200); //serial
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
}

void loop() {
  if (micros() - timer >= sampleInterval) { //Timer: send sensor data in every 10ms
    timer = micros();
    getDataFromProcessing(); //Receive before sending out the signals
    //ledon = 1;

  }
}

void getDataFromProcessing() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == 'a') { //when an 'a' character is received.
      //ledOn = 1;
      //Serial.println("check");
      //digitalWrite(LED_BUILTIN, 1); //turn on the built in LED on Arduino Uno
      digitalWrite(2, 1); 
      digitalWrite(4, 1); 
      delay(5000); 
      digitalWrite(2, 0); 
      digitalWrite(4, 0); 
      //Serial.write("Check");
    }
    if (inChar == 'b') { //when an 'b' character is received.
      //ledOn = 0;
      //digitalWrite(LED_BUILTIN, 0); //turn on the built in LED on Arduino Uno
      digitalWrite(3, 1);
      delay(5000);
      digitalWrite(3, 0);
    }
  }
}
