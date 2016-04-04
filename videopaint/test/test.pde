// The world pixel by pixel 2016
// Daniel Rozin
// displacing pixels without flicker by placing random values into an array
import processing.video.*;
Capture ourVideo;                                 // variable to hold the video object
int [][]randoms = new int[640][720];       // 3D array to hold our random values (2 values for every x, y)
void setup() {
  size(640, 720);
  frameRate(30);
  ourVideo = new Capture(this, width, height);    // open the capture in the size of the window
  ourVideo.start();
}

void draw() {
  if (ourVideo.available())  ourVideo.read();           // get a fresh frame as often as we can
  ourVideo.loadPixels();                               // load the pixels array of the video                             // load the pixels array of the window  
  loadPixels(); 
  for (int x = 0; x<width; x++) {     
    for (int y = 0; y<height/3; y++) {                              
      int sourceX = randoms[320][120];              // add the random value to ur X and Y
      int sourceY = randoms[320][120];
      sourceX= constrain(sourceX, 0, width-1);          // making sure we are not outside the image
      sourceY= constrain(sourceY, 0, height-1);
      PxPGetPixel(sourceX, sourceY, ourVideo.pixels, width);     // note that we ae getting from sourceX and sourceY
      PxPSetPixel(x, y, R, G, B, 255, pixels, width);           // set the RGB of our to screen
    }
  }

  for (int x = 0; x<width; x++) {     
    for (int y = height/3; y<2*height/3; y++) {                              
      int sourceX =  randoms[320][360];              // add the random value to ur X and Y
      int sourceY = randoms[320][360];
      sourceX= constrain(sourceX, 0, width-1);          // making sure we are not outside the image
      sourceY= constrain(sourceY, 0, height-1);
      PxPGetPixel(sourceX, sourceY, ourVideo.pixels, width);     // note that we ae getting from sourceX and sourceY
      PxPSetPixel(x, y, R, G, B, 255, pixels, width);           // set the RGB of our to screen
    }
  }

  for (int x = 0; x<width; x++) {     
    for (int y = 2*height/3; y<height; y++) {                              
      int sourceX = randoms[320][600];              // add the random value to ur X and Y
      int sourceY =  randoms[320][600];
      sourceX= constrain(sourceX, 0, width-1);          // making sure we are not outside the image
      sourceY= constrain(sourceY, 0, height-1);
      PxPGetPixel(sourceX, sourceY, ourVideo.pixels, width);     // note that we ae getting from sourceX and sourceY
      PxPSetPixel(x, y, R, G, B, 255, pixels, width);           // set the RGB of our to screen
    }
  }

  updatePixels();
}

void mouseMoved() {                                 // this only happens when the mouse moves so it doesnt flicker when the mouse isnt moving
  for (int x = 0; x<width; x++) {     
    for (int y = 0; y<height; y++) {   
      randoms[x][y]= (int)random(-mouseX, mouseX);        // put random values for every x and y
      randoms[x][y]= (int)random(-mouseX, mouseX);
    }
  }
}



// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}