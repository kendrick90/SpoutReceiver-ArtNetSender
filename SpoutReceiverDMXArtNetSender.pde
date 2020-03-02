//
//             SpoutReceiver
//
//       Receive from a Spout sender
//
//             spout.zeal.co
//
//       http://spout.zeal.co/download-spout/
//

// IMPORT THE SPOUT LIBRARY
import spout.*;

//PGraphics pgr; // Canvas to receive a texture
PImage img; // Image to receive a texture

// DECLARE A SPOUT OBJECT
Spout spout;

//////////////////////////////////////
import ch.bildspur.artnet.*;
int numLeds=170*5;
ArtNetClient artnet;
byte[] ledData = new byte[numLeds*3];

byte[] universe0 = new byte[512];
byte[] universe1 = new byte[512];
byte[] universe2 = new byte[512];
byte[] universe3 = new byte[512];
byte[] universe4 = new byte[512];
byte[] universe5 = new byte[512];
byte[] universe6 = new byte[512];
byte[] universe7 = new byte[512];
byte[] universe8 = new byte[512];
byte[] universe9 = new byte[512];
byte[] universe10 = new byte[512];
byte[] universe11 = new byte[512];
byte[] universe12 = new byte[512];
byte[] universe13 = new byte[512];
byte[] universe14 = new byte[512];
byte[] universe15 = new byte[512];


//////////////////////////////////////
void setup() {
  frameRate(120);
  colorMode(RGB, 255, 255, 255);
  // Initial window size
  size(256, 256, P2D);

  // Needed for resizing the window to the sender size
  // Processing 3+ only
  surface.setResizable(true);

  // Create a canvas or an image to receive the data.
  //pgr = createGraphics(width, height, PConstants.P2D);
  img = createImage(width, height, RGB);

  // Graphics and image objects can be created
  // at any size, but their dimensions are changed
  // to match the sender that the receiver connects to.

  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);

  // OPTION : CREATE A NAMED SPOUT RECEIVER
  //
  // By default, the active sender will be detected
  // when receiveTexture is called. But you can specify
  // the name of the sender to initially connect to.
  // spout.createReceiver("Spout DX11 Sender");


  ////////////////////////////////////////////////
  // create artnet client without buffer (no receving needed)
  artnet = new ArtNetClient(null);
  artnet.start();

  ////////////////////////////////////////////////
} 

void draw() {

  //background(0);

  //
  // RECEIVE A SHARED TEXTURE
  //

  // OPTION 1: Receive and draw the texture
  //spout.receiveTexture();

  // OPTION 2: Receive into PGraphics texture
  //pgr = spout.receiveTexture(pgr);
  //image(pgr, 0, 0, width, height);

  // OPTION 3: Receive into PImage texture
  //img = spout.receiveTexture(img);
  //image(img, 0, 0, width, height);

  // OPTION 4: Receive into PImage pixels
  img = spout.receivePixels(img);
  image(img, 0, 0, width, height);

  // Optionally resize the window to match the sender
  spout.resizeFrame();

  //////////////////////////////////////
  // fill dmx array
  //for (int u =0; u < 5; u++)
  //{  
  loadPixels(); 
  img.loadPixels(); 
  for (int led = 0; led < numLeds; led++) {
    ledData[led*3] = (byte) red(img.pixels[led]);
    ledData[led*3+1] = (byte) green(img.pixels[led]);
    ledData[led*3+2] = (byte) blue(img.pixels[led]);
  }

  //int lastUniverseCutOff =ledData.length;
  for (int ch = 0; ch < 510; ch++)
  {
    universe0[ch]=ledData[ch];
    universe1[ch]=ledData[ch+(510*1)];
    universe2[ch]=ledData[ch+(510*2)];
    universe3[ch]=ledData[ch+(510*3)];
    universe4[ch]=ledData[ch+(510*4)];
    //universe5[ch]=ledData[ch+(510*5)];
    //universe6[ch]=ledData[ch+(510*6)];
    //universe7[ch]=ledData[ch+(510*7)];
    //universe8[ch]=ledData[ch+(510*8)];
    //universe9[ch]=ledData[ch+(510*9)];
    //universe10[ch]=ledData[ch+(510*10)];
    //universe11[ch]=ledData[ch+(510*11)];
    //universe12[ch]=ledData[ch+(510*12)];
    //universe13[ch]=ledData[ch+(510*13)];
    //universe14[ch]=ledData[ch+(510*14)];

    int lastUniverseIndex = ch + (510*4);
    if (lastUniverseIndex < numLeds*3) {
      universe4[ch]=ledData[lastUniverseIndex];
    } else {
      universe4[ch]=(byte) 0;
    }
  }

  // send dmx to localhost
  artnet.unicastDmx("192.168.11.102", 0, 0, universe0);
  artnet.unicastDmx("192.168.11.102", 0, 1, universe1);
  artnet.unicastDmx("192.168.11.102", 0, 2, universe2);
  artnet.unicastDmx("192.168.11.102", 0, 3, universe3);
  artnet.unicastDmx("192.168.11.102", 0, 4, universe4);
  //artnet.unicastDmx("192.168.11.102", 0, 5, universe5);
  //artnet.unicastDmx("192.168.11.102", 0, 6, universe6);
  //artnet.unicastDmx("192.168.11.102", 0, 7, universe7);
  //artnet.unicastDmx("192.168.11.102", 0, 8, universe8);
  //artnet.unicastDmx("192.168.11.102", 0, 9, universe9);
  //artnet.unicastDmx("192.168.11.102", 0, 10, universe10);
  //artnet.unicastDmx("192.168.11.102", 0, 11, universe11);
  //artnet.unicastDmx("192.168.11.102", 0, 12, universe12);
  //artnet.unicastDmx("192.168.11.102", 0, 13, universe13);
  //artnet.unicastDmx("192.168.11.102", 0, 14, universe14);
  //artnet.unicastDmx("192.168.11.102", 0, 15, universe15);


  //////////////////////////////////////
}

// SELECT A SPOUT SENDER
void mousePressed() {
  // RH click to select a sender
  if (mouseButton == RIGHT) {
    // Bring up a dialog to select a sender.
    // Spout installation required
    spout.selectSender();
  }
}
