// import the beads library
import beads.*;

import spacebrew.*;

// create our AudioContext
AudioContext ac;

// declare our unit generators (Beads) since we will need to 
// access them throughout the program
WavePlayer wp1;
Glide frequencyGlide1;
WavePlayer wp2;
Glide frequencyGlide2;
WavePlayer wp3;
Glide frequencyGlide3;

Gain g;
//Glide gainGlide;

int inputX = 0;
int inputY = 0;
int inputZ = 0;

int incomingx = 0;
int incomingy = 0;
int incomingz = 0;

String server="sandbox.spacebrew.cc";
String name="Spacebrew_Synth";
String description ="This is an blank example client that publishes .... and also listens to ...";

Spacebrew sb;

void setup()
{
 size(400, 400);
 background(255);
 
 // instantiate the sb variable
  sb = new Spacebrew( this );

  // add each thing you publish to
  sb.addPublish( "inputX", "range", 0 ); 
  sb.addPublish( "inputY", "range", 0 );
  sb.addPublish( "inputZ", "range", 0 );

  // add each thing you subscribe to
  sb.addSubscribe( "inputX", "range" );
  sb.addSubscribe( "inputY", "range" );
  sb.addSubscribe( "inputZ", "range" );

  // connect to spacebrew
  sb.connect(server, name, description );

 // initialize our AudioContext
 ac = new AudioContext();
 
 // create frequency glide object
 // give it a starting value of 20 (Hz)
 // and a transition time of 50ms
 frequencyGlide1 = new Glide(ac, 20, 50);
 
 // create a WavePlayer, attach the frequency to 
 // frequencyGlide
 wp1 = new WavePlayer(ac, frequencyGlide1, Buffer.SINE);
 // create the second frequency glide and attach it to the 
 // frequency of a second sine generator
 
 frequencyGlide2 = new Glide(ac, 20, 50);
 wp2 = new WavePlayer(ac, frequencyGlide2, Buffer.SQUARE);
 // create a Gain object to make sure we don't peak
 g = new Gain(ac, 1, 0.5);
 
 // create third frequencyGlide and sine generator
  frequencyGlide3 = new Glide(ac, 50, 100);
  wp3 = new WavePlayer(ac, frequencyGlide3, Buffer.SAW);
 
 // connect both WavePlayers to the Gain input
 g.addInput(wp1);
 g.addInput(wp2);
 g.addInput(wp3);
 
 // connect the Gain output to the AudioContext
 ac.out.addInput(g);
 
 // connect the WavePlayer to the AudioContext
  ac.out.addInput(g);
 
 // start audio processing
 ac.start();
 
 background(255);
}
void draw()
{
  
//  inputX=mouseX; 
//  inputY=mouseY;
//  inputZ=pmouseX;
  
 // update the frequency based on the position of the mouse 
 // cursor within the Processing window
 //frequencyGlide1.setValue(mouseY);
 //frequencyGlide2.setValue(mouseX);
 //frequencyGlide3.setValue(pmouseX);
 frequencyGlide1.setValue(inputX);
 frequencyGlide2.setValue(inputY);
 frequencyGlide3.setValue(inputZ);
}

void onRangeMessage( String name, int value ) {
  println("got range message " + name + " : " + value);

  if (name.equals("inputX")) {
    incomingx = value;
  } 
  else if (name.equals("inputY")) {
    incomingy = value;
  } 
  else if (name.equals("inputZ")) {
    incomingz = value;
  }
}

void onBooleanMessage( String name, boolean value ) {
  println("got boolean message " + name + " : " + value);
}

void onStringMessage( String name, String value ) {
  println("got string message " + name + " : " + value);
}

void onCustomMessage( String name, String type, String value ) {
  println("got " + type + " message " + name + " : " + value);
}

