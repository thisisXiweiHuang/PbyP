float d;
float red;
float green;
float blue;

int r =8;
void setup() {

  size(800, 800); 
  background(0);
   smooth();
}

void draw() {
  loadPixels();
  //loop to go through every pixel
  for (int y=0; y<height; y++) {
    for (int x=0; x<width; x++) {

      color c = pixels[y*width+x];
   
      red = c <<7 & 0xff;
      green = c << 4 & 0xaa;
      blue = c  & 0xff;

      d =dist(mouseX, mouseY, x, y)*.3;

      red += 50/d-r;
      green += 50/d-r;
      blue += 55/d-r;

 
      pixels[y*width+x]=color(red, green, blue);
    }
  }

  updatePixels();
}