#include <Explora.h>

// Definimos los pines del joystick
const int joyXPin = A0;  // Pin analógico para el eje X
const int joyYPin = A1;  // Pin analógico para el eje Y
const int buttonPin = 2; // Pin digital para el botón

// Crea un objeto Explora
Explora explora;

void setup() {
  // Inicializamos la comunicación serial
  Serial.begin(9600);
  
  // Configuramos el pin del botón como entrada con resistencia de pull-up interna
  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
  // Leemos los valores de los ejes X e Y del joystick
  int joyXValue = analogRead(joyXPin);
  int joyYValue = analogRead(joyYPin);
  
  // Leemos el estado del botón
  int buttonState = digitalRead(buttonPin);

  // Enviamos los valores por el puerto serial usando Explora
  explora.send("X", joyXValue);
  explora.send("Y", joyYValue);
  explora.send("Button", buttonState);

  // Esperamos un momento antes de la siguiente lectura
  delay(100);
}
