PImage img;
PGraphics ascii, res;
PFont font;
PShape shape;
PShader tex_sh;

int level = 2;
String letters = "#0NBKAE5wtr<!-. ";


void setup() {
  size(1536, 512, P2D);  
  img = loadImage("gato.png");
  
  font = createFont("Consolas", 10);
  /*
  ascii = createGraphics(500, 500, P2D);
  ascii.beginDraw();
  ascii.textFont(font, 1.4*scale);
  cols = img.width / scale;
  rows = img.height / scale;
  for(int i=0; i<cols; i++) {
    for(int j=0; j<rows; j++) {
      int x = i*scale;
      int y = j*scale;
      color c = img.pixels[x+img.width*y];
      color br = int((red(c)+green(c)+blue(c))/3);
      ascii.fill(0);
      ascii.text(letters.charAt(int(br/16)), x+1, y+1);
    }
  }
  
  PImage tex = ascii.get();
  ascii.endDraw();
  */
  textureMode(NORMAL);  
  shape = createShape();
  shape.beginShape(QUAD_STRIP);
  shape.noStroke();
  shape.texture(img);
  shape.vertex(0, 0, 0, 0);
  shape.vertex(512, 0, 1, 0);
  shape.vertex(0, 512, 0, 1);
  shape.vertex(512, 512, 1, 1);
  shape.endShape(CLOSE);
  
  tex_sh = loadShader("tex_frag.glsl", "tex_vert.glsl");
}

void draw() {
  
  background(255);
  image(img, 0, 0);
  
  res = createGraphics(500, 500, P2D);  
  res.beginDraw();
  res.shader(tex_sh);
  tex_sh.set("lod", float(level));
  res.shape(shape);
  res.endDraw();
  image(res, 512, 0);
   
  stringify(res.get());
}

void stringify (PImage mip) {
  textFont(font, 1.4*pow(2,level));
  colorMode(RGB, 255, 255, 255);
  mip.loadPixels();
  float cols = mip.width / (pow(2,level));
  float rows = mip.height / (pow(2,level));
  for(int i=0; i<cols; i++) {
    for(int j=0; j<rows; j++) {
      int x = int(i*pow(2,level));
      int y = int(j*pow(2,level));
      color c = img.pixels[x+img.width*y];
      fill(brightness(c)/16);
      text(letters.charAt(int(brightness(c)/16)), 1025+x, y);
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && level < 9) {
      level = level + 1;
    } 
    if (keyCode == DOWN && level > 1) {
      level = level - 1;
    }
  }
}
