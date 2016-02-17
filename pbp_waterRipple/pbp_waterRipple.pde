int diameter = 10;
float noff = 0.0;//add noise to animate rotation;

void setup() {
  size(800, 1000, P3D);
}

void draw() {
  background(255);
  noff = noff+0.1;
  float pixelR = 255;
  float pixelG = 255;
  float pixelB = 255;
  //fill(pixelR, pixelG, pixelB);
  
  for (int x = 0; x<width; x +=diameter) {
    for (int y = 0; y <height; y +=diameter) {
      float distanceToMouse = dist (x, y, width/2, height/3);
      pushMatrix();
      translate(x, y);

      //ellipse
      rotateX((-distanceToMouse/60 +noff));
      noStroke();   
      fill(random(130), random(130), random(130),123);
      ellipse(0, 0, diameter, diameter);
      //rect
      rotateY((-distanceToMouse/80 +noff));
      fill(30);
      noStroke();
      rect(0, 0, diameter, diameter);

      popMatrix();
    }
  }
}