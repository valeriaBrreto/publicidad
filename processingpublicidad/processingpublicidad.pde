import processing.video.*;
import processing.serial.*;

Serial myPort;  // El objeto Serial
int currentVideoIndex = 0;
Movie[] videos = new Movie[3];
Movie currentMovie;

void setup() {
  // Configura el puerto serie
  String portName = "COM3";  // Cambia esto al puerto de tu Arduino
  myPort = new Serial(this, portName, 9600);

  // Carga los videos
  videos[0] = new Movie(this, "video1.mp4");
  videos[1] = new Movie(this, "video2.mp4");
  videos[2] = new Movie(this, "video3.mp4");
  currentMovie = videos[currentVideoIndex];
  
  // Prepara el reproductor de video
  currentMovie.loop();  // Comienza a reproducir el primer video en bucle
}

void draw() {
  // Lee los datos del puerto serie
  if (myPort.available() > 0) {
    String command = myPort.readStringUntil('\n');
    if (command != null) {
      command = command.trim();
      println("Received: " + command);
      
      // Procesa el comando
      String[] tokens = command.split(",");
      if (tokens.length == 2) {
        String key = tokens[0];
        int value;
        try {
          value = Integer.parseInt(tokens[1]);
        } catch (NumberFormatException e) {
          return;  // Si el valor no es un entero, ignorar el comando
        }
        
        if (key.equals("X")) {
          if (value > 800) {  // Ajusta este umbral según sea necesario
            currentVideoIndex = (currentVideoIndex + 1) % videos.length;
            currentMovie.stop();  // Detiene el video actual
            currentMovie = videos[currentVideoIndex];
            currentMovie.loop();  // Reproduce el siguiente video en bucle
            delay(1000);  // Espera para evitar cambios rápidos
          }
        }
      }
    }
  }
  
  // Dibuja el video en la ventana de Processing
  background(0);
  image(currentMovie, 0, 0, width, height);
}

void movieEvent(Movie m) {
  m.read();  // Necesario para que el video se reproduzca
}
