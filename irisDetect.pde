/*
 * irisDetect.pde
 * written by Michelle Sharer http://michellesh.com
 * 
 */


PImage img;
PImage dest;
pt[] blacks;
int num = 0;
int minradius = 55;
int maxradius = 60;
//int minradius = 21;
//int maxradius = 27;

class pt {
  int x;
  int y;
  pt( int nx, int ny ) {
    x = nx;
    y = ny;
  }
};

void setup() {
  img = loadImage("eye.JPG"); //load image file
  //img = loadImage("eyes-edges.png"); //load image file
  size(img.width,img.height); //set the size of processing sketch
  dest = createImage(img.width, img.height, RGB); //create blank destination image
  noLoop();
  blacks = new pt[width*height];
}

void draw() {
  
  for( int x = 1; x < width; x++ ) {
    for( int y = 0; y < height; y++ ) {
      
      //edge detection
      int loc = x + y*img.width;
      color pix = img.pixels[loc];
      int leftLoc = (x - 1) + y*img.width;
      color leftPix = img.pixels[leftLoc];
      float diff = abs(brightness(pix) - brightness(leftPix));
      dest.pixels[loc] = color(diff);
      
      //set point to either black or white
      if( abs( dest.get(x,y)) > 16500000 ) {
        dest.set(x, y, color(255,255,255) ); //white
      } else {
        dest.set(x, y, color(0,0,0) ); //black
        blacks[num] = new pt(x,y); //add to list of black points
        num++;
      }
    }
  }
  
  dest.updatePixels();
  image(dest,0,0);
  
  //iris detection
  int numBlacks = 0; //number of black pixels in common with fixed circle
  int maxBlacks = 0; //maximum number of black pixels in common
  int numPoints = 20; //number of points in circumference of fixed circle
  float xmax = 0; //x-coord of the center point of the best matched circle
  float ymax = 0; //y-coord of the center point of the best matched circle
  //int radius = 57; //radius estimation
  int rwin = 0; //best match radius
  int radius = 0; //initualize temporary radius
  float angle=TWO_PI/(float)numPoints;
 
  for( radius = minradius; radius < maxradius; radius++ ) { //try out different radiuses
    for( int x = 1; x < width; x++ ) {
      for( int y = 0; y < height; y++ ) {
        numBlacks = 0;
        for( int i = 0; i < numPoints; i++ ) {
          float circlex = x+radius*sin(angle*i);
          float circley = y+radius*cos(angle*i);
          if( dest.get( int( circlex ), int( circley ) ) == color(0,0,0) ) {
            numBlacks++;
          }
        }
        //keep track of the info for the best match circle (most black points)
        if( numBlacks > maxBlacks ) {
          maxBlacks = numBlacks;
          xmax = x; //center point x
          ymax = y; //center point y
          rwin = radius;
        }
      }
    }
  }
  
  //print out the best matching circle found
  strokeWeight(3); //thickness
  stroke(255,0,0); //red
  fill(0,0); //transparent fill
  ellipse(xmax,ymax,rwin*2,rwin*2);
  println("radius: "+rwin);
}










