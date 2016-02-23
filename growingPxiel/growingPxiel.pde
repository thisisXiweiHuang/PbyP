float a;

void setup()
{
  size(500, 500);
  strokeWeight(0.1);
  stroke(180);
  frameRate(30);
}
void draw()
{
  //animate the ripple effect
  a -= 0.08;
  background(255);
  for (int x = -13; x < 13; x++) {
    for (int z = -13; z < 13; z++) {
      // int y = radius * cos(theta);
      // radius is the range.  multiply this by 24 to increase the cos va
      //theta is radians. An entire loop (circle) is 2pi radians, or roughly 6.283185.
      // variable istance makes the boxes of the same radius around the center similar--makes the circular effect
      //The distance ranges from 0 to 7, so 0.55 * distance will be between 0 and 3.85. This will make the highest and lowest

      int y = int(24 * cos(0.55 * distance(x, z, 0, 0) + a));

      // 4 different quadrants (+ and - for x, and + and - for z);
      //boxes are 17 pixels apart;
      //The 8.5 will determine half the width of the box ();
      float xm = x*10 -5;
      float xt = x*10 +5;
      float zm = z*10 -5;
      float zt = z*10 +5;

      int halfw = (int)width/2;
      int halfh = (int)height/2;

      //isometric formula: ((x - z) * cos(radians(30)) + width/2, (x + z) * sin(radians(30)) - y + height/2).
      //but Cosine of 30 degrees returns roughly 0.866, which i rounded to 1,
      //Sine of 30 returns 0.5.
      //quad vertexes
      int isox1 = int(xm - zm + halfw);
      int isoy1 = int((xm + zm) * 0.5 + halfh);
      int isox2 = int(xm - zt + halfw);
      int isoy2 = int((xm + zt) * 0.5 + halfh);
      int isox3 = int(xt - zt + halfw);
      int isoy3 = int((xt + zt) * 0.5 + halfh);
      int isox4 = int(xt - zm + halfw);
      int isoy4 = int((xt + zm) * 0.5 + halfh);

      //side quads;
      fill (50);
      quad(isox2, isoy2-y, isox3, isoy3-y, isox3, isoy3+40, isox2, isoy2+40);
      fill (130);
      quad(isox3, isoy3-y, isox4, isoy4-y, isox4, isoy4+40, isox3, isoy3+40);
      //top quads
      fill(200 + y * 0.05);
      quad(isox1, isoy1-y, isox2, isoy2-y, isox3, isoy3-y, isox4, isoy4-y);
    }
  }
}
//The distance formula
float distance(float x, float y, float cx, float cy) {
  return sqrt(sq(cx - x) + sq(cy - y));
}