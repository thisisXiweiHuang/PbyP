import SimpleOpenNI.*;
SimpleOpenNI simpleOpenNI;

// IMAGES
PImage maskImage;
PImage rgbImage;
PImage depthImage;

// KINECT DEPTH VALUES
int[] depthValues;
PVector[] realWorldMap;

//THRESHOLD
int min = 50;
int max = 720;

// CANVAS SIZE
int canvasWidth  = 1240;
int canvasHeight = 840;

//KINECT SIZE
int kinectWidth  = 1240;
int kinectHeight = 840;


//[-------------------------------]//
float        zoomF =0.5f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
// the data from openni comes upside down
float        rotY = radians(0);

int         steps           = 6; // to speed up the drawing, draw every third point
float       strokeW         = 0.6;

PVector   s_rwp = new PVector(); // standarized realWorldPoint;
int       kdh;
int       kdw;
int       max_edge_len = 50;
float     strokeWgt = 0.4;
int       i00, i01, i10, i11; // indices
PVector   p00, p10, p01, p11; // points
PVector   k_rwp; // kinect realWorldPoint;

//texture
PImage doggyTexture;
float a =0;

void setup() {
  size(canvasWidth, canvasHeight, OPENGL);
  initKinect();

  kdh = simpleOpenNI.depthHeight();
  kdw = simpleOpenNI.depthWidth();
  smooth();
  stroke(0);
  perspective(radians(45), float(width)/float(height), 10, 150000);

  maskImage = loadImage("doggy.jpg");
  maskImage.resize(100, 100);
} 

void initKinect() {
  // NEW OPENNI CONTEXT INSTANCE
  simpleOpenNI = new SimpleOpenNI(this);
  // MIRROR THE KINECT IMAGE
  simpleOpenNI.setMirror(true);

  // ENABLE THE DEPTH MAP
  if (simpleOpenNI.enableDepth() == false)
  { // COULDN'T ENABLE DEPTH MAP
    println("Can't open the depthMap, maybe the Kinect is not connected!"); 
    exit();
    return;
  }
  // ENABLE THE RGB IMAGE
  if (simpleOpenNI.enableRGB() == false)
  { // COULDN'T ENABLE DEPTH MAP
    println("Can't open the Kinect cam, maybe the Kinect is not connected!"); 
    exit();
    return;
  }
  // ALIGN DEPTH DATA TO IMAGE DATA
  simpleOpenNI.alternativeViewPointDepthToImage();
} 

void draw() {
  translate(width/2, height/2, 200);
  scale(mouseX/100.0);
  rotateY(a);
  translate(-width/2, -height/2, 200);
  background(0);
  lights();
  simpleOpenNI.update();  
  rgbImage = simpleOpenNI.rgbImage();
  mesh();
  a += 0.0075f;
}

void keyPressed() {
  if (keyCode==UP) {
    steps += 1;
  }
  if (keyCode==DOWN) {
    steps -= 1;
  }
  if (keyCode == ENTER) {
    saveFrame("mesh/#####.png");
  }
}

void mesh() {
  realWorldMap = simpleOpenNI.depthMapRealWorld();
  //set the scene pos
  translate(width/2, height/2, 200);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);

  if (strokeWgt == 0) noStroke();
  else strokeWeight(strokeWgt);
  for (int y=0; y < kdh-steps; y+=steps)
  {
    int y_steps_kdw = (y+steps)*kdw;
    int y_kdw = y * kdw;
    for (int x=0; x < kdw-steps; x+=steps)
    {
      i00 = x + y_kdw;
      i01 = x + y_steps_kdw;
      i10 = (x + steps) + y_kdw;
      i11 = (x + steps) + y_steps_kdw;

      p00 = realWorldMap[i00];
      p01 = realWorldMap[i01];
      p10 = realWorldMap[i10];
      p11 = realWorldMap[i11];
      beginShape(TRIANGLES);  
      texture(maskImage); // fill the triangle with the rgb texture
      if ((p00.z > min && p00.z < max) && (p01.z > min&& p00.z < max) && (p10.z > min&& p00.z < max) && // check for non valid values
      (abs(p00.z-p01.z) < max_edge_len) && (abs(p10.z-p01.z)< max_edge_len)) { // check for edge length
        vertex(p00.x, p00.y, p00.z, 0, 0); // x,y,x,u,v   position + texture reference
        vertex(p01.x, p01.y, p01.z, 0, 100);
        vertex(p10.x, p10.y, p10.z, 100, 0);
      }
      if ((p11.z >  min && p11.z < max) && (p01.z > min && p01.z < max) && (p10.z > min && p10.z < max) &&
        (abs(p11.z-p01.z) < max_edge_len) && (abs(p10.z-p01.z) < max_edge_len)) {
        vertex(p01.x, p01.y, p01.z, 0, 100);
        vertex(p11.x, p11.y, p11.z, 100, 100);
        vertex(p10.x, p10.y, p10.z, 100, 0);
      }
      endShape();
    }
  }
}

//void keyPressed() {
//  if (keyCode == ENTER) {
//    saveFrame("mesh/#####.png");
//  }
//}

