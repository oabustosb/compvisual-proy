PImage img;
PShape map, zoom;
PGraphics Map, Zoom;
PShader mshader, zshader;

float up = 0; 
float down = 0.5; 
float left = 0; 
float right = 0.5;
float level = 2;
float zoomlod = 3;
final float maplod = 3;

void setup() {
  size(1034, 512, P2D);  
  img = loadImage("earth4096.jpg");
  
  textureMode(NORMAL);  
  map = createShape();
  zoom = createShape();
  
  map.beginShape(QUAD_STRIP);
  map.noStroke();
  map.texture(img);
  map.vertex(0, 0, 0, 0);
  map.vertex(512, 0, 1, 0);
  map.vertex(0, 512, 0, 1);
  map.vertex(512, 512, 1, 1);
  map.endShape(CLOSE);
    
  Map = createGraphics(512, 512, P2D);
  mshader = loadShader("map_frag.glsl", "tex_vert.glsl");
  mshader.set("maplod", maplod);
  Map.shader(mshader);
  
  Zoom = createGraphics(512, 512, P2D);
  zshader = loadShader("zoom_frag.glsl", "tex_vert.glsl");
  Zoom.shader(zshader);
}

void draw() {
  background(250);
  
  zoom.beginShape(QUAD_STRIP);
  zoom.noStroke();
  zoom.texture(img);
  zoom.vertex(0, 0, left, up);
  zoom.vertex(512, 0, right, up);
  zoom.vertex(0, 512, left, down);
  zoom.vertex(512, 512, right, down);
  zoom.endShape(CLOSE);
  
  Map.beginDraw();
  Map.shape(map);
  Map.endDraw();
  
  Zoom.beginDraw();
  zshader.set("zoomlod", zoomlod);
  Zoom.shape(zoom);
  Zoom.endDraw();
  
  image(Map, 0, 0);
  image(Zoom, 522, 0);
  
  stroke(10, 240, 10);
  fill(10, 240, 10, 64);
  rect(left*512, up*512, 512/level, 512/level);
}

void keyPressed () {
  switch (key) {
    case '4':
      if (left > 0) {
        left = left - 1/level;
        right = right - 1/level;
      }
      break;
    case '6':
      if (right < 1) {
        left = left + 1/level;
        right = right + 1/level;
      }
      break;
    case '8':
      if (up > 0) {
        up = up - 1/level;
        down = down - 1/level;
      }
      break;
    case '2':
      if (down < 1) {
        up = up + 1/level;
        down = down + 1/level;
      }
      break;
      
    case '+':
      if (level < 64) {
        level = level*2;
        if (zoomlod > 0) zoomlod = zoomlod - 1;
        down = down - 1/level;
        right = right - 1/level;
      }
      break;
    case '-':
      if (level > 2) {
        down = down + 1/level;
        right = right + 1/level;
        level = level/2;
        zoomlod = zoomlod + 1;
      }
      break;
  }
}
