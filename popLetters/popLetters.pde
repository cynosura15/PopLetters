/*
PopLetters has been created by cybermissia74 and cynosura.
Last version is 22032016.
*/

import ddf.minim.*;

int score = 0;
int vie = 3;
char[] letter = new char[2];   //tableau de char contenant la lettre active et la prochaine lettre
char[] letter2 = new char[2];
//toutes les lettres minuscules
char[] allLetter = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
float lX,lY, l2X, l2Y;  //position de la lettre
float vitesse = 3.5;
int limite1Up;

boolean l1 = true, l2 = true;

int temps;   //accelerer vitesse selon le temps

int tailleScore = 50;
int rayon= 100;

color colorL1, colorL2;

boolean spawnLetter = true, loose = false; //spawnLetter -> afficher une nouvelle lettre

PImage imageVie;

float angle = 0.0;

Minim minim;
AudioSample up;
AudioPlayer gameover;

void setup()
{
  size(600,400);
  frameRate(30);
  
  minim = new Minim(this);
  
  up = minim.loadSample("up.mp3");
  gameover = minim.loadFile("gameover.mp3");
  
  imageVie = loadImage("Coeur.png");
  
  limite1Up = height/4;
  
  int i = (int)random(0,25);
  int i2 = (int)random(0,25);
  int j = (int)random(0,25);
  int j2 = (int)random(0,25);
  
  letter[0] = allLetter[i];
  letter[1] = allLetter[i2];  
  
  letter2[0] = allLetter[j];
  letter2[1] = allLetter[j2];
}

void draw()
{
  temps++;
  background(255);
  fill(0);
  
  if(spawnLetter) {  //si on vient d'appuyer sur la bonne touche -> nouvelle lettre
    newLetter();
    spawnLetter = false;
  }
  if(temps/frameRate > 10) {
    vitesse++;
    temps = 0;
  }
  drawLetter();    //on affiche la lettre
  drawHUD();   //affiche score, vies, lettre suivante
  updateLetter();   //on bouge la lettre
  
  if(vie <= 0) loose();
  
}

void updateLetter()
{
  angle+=0.09;
  if(l1 && !loose) lY+=vitesse;  //la lettre descend
  if(l2 && !loose) l2Y+=vitesse;
  
  if(lY >= height-67 || l2Y >= height-67){
    spawnLetter = true;
    vie--;
  }
  
  if(!l1 && !l2){
    newLetter();
  }
}
void drawLetter()
{
  pushMatrix();
  translate(lX, lY);
  if(l1)rotate(angle);
  translate(-lX,-lY);
  
  textSize(30);
  textAlign(CENTER,CENTER);
  fill(colorL1);
  text(letter[0], lX, lY);
  
  popMatrix();
  pushMatrix();
  
  translate(l2X, l2Y);
  if(l2)rotate(angle);
  translate(-l2X, -l2Y);
  
  fill(colorL2);
  text(letter2[0], l2X, l2Y);
  
  popMatrix();
}

void newLetter(){
  l1 = true;
  l2= true;
  
  colorL1 = color(random(255),random(255),random(255));
  colorL2 = color(random(255),random(255),random(255));
  
  int i = (int)random(0,25);
  int i2 = (int)random(0,25);
  
  letter[0] = letter[1];
  letter[1] = allLetter[i];
  
  letter2[0] = letter2[1];
  letter2[1] = allLetter[i2];
  
  lX = (int)random(0,width-50);   //position de la nouvelle lettre
  lY = random(20, 100);
  lY*=-1;
  
  l2X = (int)random(0,width-50);   //position de la nouvelle lettre 2
  l2Y = random(20, 100);
  l2Y*=-1;
}

void drawHUD(){
  //Tableau bas
  fill(0,0,0,100);
  noStroke();
  rect(0, height-50, width, 50);
  
  //Affichage infos
  textAlign(0);
  textSize(20);
  fill(0);
  
  int j = 20;
  for(int i = 0;i < vie; i++){
    j+=27;
    image(imageVie,j,height-40,25,25);
  }
  if(!loose) text("Prochains : " + letter[1] + ", " + letter2[1], width-200, height-20);
  
  //Rond milieu
  stroke(200);
  fill(0,0,0,10); 
  ellipse(width/2,height/2-25,rayon,rayon);
  noStroke();
  
  fill(0,0,0,50);
  textAlign(CENTER,CENTER);
  textSize(tailleScore);
  text(score,width/2,height/2-30);
  
  if(!loose && vie < 5){
    stroke(100,100,100,100);
    line(0, limite1Up, width, limite1Up);
    textSize(15);
    text("+1Up",width-50,limite1Up-10);
  }
}

void loose(){
  loose = true;
  gameover.play();
  
  if(rayon < 200)
  {
    rayon+=10;
    tailleScore+=5;
  }
 
  else
  {
    textAlign(CENTER,CENTER);
    textSize(40);
    fill(255,0,0);
    text("PERDU", width/2, height/8);
    textSize(15);
    textAlign(0);
    fill(0,0,255);
    text("0 - 20   NUL",450,100);
    text("20 - 40  PAS MAL",450,130);
    text("40 - 80  BIEN", 450,160); 
    text("80+      ENORME", 450,190);
    textAlign(0);
    fill(0);
  }
}

void keyPressed(){
  if(key == letter[0] && !loose) 
  {
    if(lY < limite1Up && l1 == true && vie < 5) {
      vie++;
      up.trigger();
    }
    l1 = false;
    colorL1 = color(0, 0, 255);
    score++;
  }
  if(key == letter2[0] && !loose) 
  {
    if(l2Y < limite1Up && l2 == true && vie < 5) {
      vie++;
      up.trigger();
    }
    l2 = false;
    colorL2 = color(0, 0, 255);
    score++;
  }
}

void stop() {
  up.close();
  gameover.close();
  minim.stop();
  super.stop();
}