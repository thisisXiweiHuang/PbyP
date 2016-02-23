PVector [] pts;
int radius = 400, d = 15, num =0;

void setup() {
  size (900, 900);
  smooth();
  pts = new PVector[3]; //cannot go over 360 degree;
  for (int i=0; i <3; i++) {//    i=0,1,2;
    pts[i] = new PVector(sin(radians(i*120+180))*radius, cos(radians(i*120+180))*radius);
  }
 }

void draw() {
  background(0);
  translate(width/2, height/2);
  for (int i =0; i<3; i++) {
    pts[i] = new PVector(sin(radians(i*120+num))*radius, cos(radians(i*120+num))*radius);
  }

  for (int x=-radius; x<radius; x+=d) {
    for (int y=-radius; y<radius-100; y+=d) {
      if (inTriangle(new PVector(x, y))) {
        float distToMouseX = map(mouseX, 0,width,0,255);
        float distToMouseY = map(mouseY, 0,height,0,255);
        fill(distToMouseX,130,distToMouseY); 
        rect(x, y, d/1.2, d/1.2);
        //rotateY(20);
      } else {
        fill(200,80);
        rect(x, y, d/1.2, d/1.2);
      }
    }
  }
  //num += 1.5;//animate itself;
  //radians of degree 120 = 2.0944; therefore num fails into -4 to 4; 
num += map(mouseX,0,width,4,-4);

}
//follow the link below to test whether a specifi point lies in a triangular area
//-->http://totologic.blogspot.fr/2014/01/accurate-point-in-triangle-test.html
//x = a*x1+ b*x2 +c*x3;
//y = a*y1+ b*y2 +c*y3;
//c=1-a-b;
//return 0<=a/b/c=1;


boolean inTriangle ( PVector mouseX) {

  PVector p1= pts[0];
  PVector p2= pts[1];
  PVector p3= pts[2];
  //denominator;
  //((y2 - y3)*(x1 - x3) + (x3 - x2)*(y1 - y3))
  float d=((p2.y - p3.y)*(p1.x - p3.x) + (p3.x - p2.x)*(p1.y - p3.y));
  //a
  //((y2 - y3)*(x - x3) + (x3 - x2)*(y - y3)) / 
  float a= ((p2.y - p3.y)*(mouseX.x - p3.x) + (p3.x - p2.x)*(mouseX.y - p3.y))/d;
  //b
  //((y3 - y1)*(x - x3) + (x1 - x3)*(y - y3))
  float b= ((p3.y - p1.y)*(mouseX.x - p3.x) + (p1.x - p3.x)*(mouseX.y - p3.y))/d;

  float c= 1-a-b;

  return 0 <= a && a <= 1 && 0 <= b && b <= 1 && 0 <= c && c <= 1;
}