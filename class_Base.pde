public enum towerType {BASE,AUTO,GATLING,SNIPER,SHOCKWAVE,CANNON}

class Base {
  private int coordX,coordY,attackSpeedMax,attackSpeedCurrent,spriteCurrent; //coord refers to center of object
  private float size,margin,shotVelocity,range; //size = full square length
  private towerType buildingType = towerType.BASE;
  private objectType objType = objectType.BUILDING;
  private boolean attacker,useSprite;
  private int[] fillColour,aimColour;
  private PVector aimVector = new PVector();
  private ArrayList<PImage> spriteList = baseSquareImageList;
  
  Base(int coordX, int coordY, float size, float margin)
  {
    this.coordX = coordX;
    this.coordY = coordY;
    this.size = size;
    int[] grey = {68,68,68};
    this.useSprite = false;
    this.attackSpeedMax = 1;
    this.attackSpeedCurrent = 0;
    this.attacker = false;
    this.shotVelocity = 5;
    this.fillColour = grey;
    //margin creates a border around object of n size
    this.margin = margin;
    this.buildingType = towerType.BASE;
    this.aimVector.set(getXY()[0],getXY()[1]);
  }
  //getters
  public towerType getBuildingType() {return this.buildingType;}
  public objectType getObjectType() {return this.objType;}
  public float getShotVelocity() {return this.shotVelocity;}
  public float getRange() {return this.range;}
  public float getSize() {return size;}
  public boolean getAttacker() {return this.attacker;}
  public PVector getVector() {return this.aimVector;}
  public int[] getAimColour() {return this.aimColour;}
  public boolean getAttackAvailable()
  {
    if(this.attackSpeedCurrent <= 0){return true;}
    else {return false;}
  }
  
  //returns XY of all corners
  float[] getVertices()
  {  
    float[] xy = coordsToXY(this.coordX,this.coordY);
    float[] vertices = {
      //Top-left
      xy[0]-(size/2)+margin,xy[1]-(size/2)+margin,
      //Top-right
      xy[0]+(size/2)-margin,xy[1]-(size/2)+margin,
      //Bottom-left
      xy[0]-(size/2)+margin,xy[1]+(size/2)-margin,
      //Bottom-right
      xy[0]+(size/2)-margin-1,xy[1]+(size/2)-margin-1};
    return vertices;
  }
  public float[] getXY()
  {
    float[] xy = coordsToXY(this.coordX,this.coordY);
    return xy;
  }
  public int[] getBaseCoords()
  {
    int[] i = {this.coordX,this.coordY};
    return i;
  }
  //setters
  protected void setAttackSpeedMax(int aspd) {this.attackSpeedMax = aspd;}
  public void resetAttackSpeed() {this.attackSpeedCurrent = this.attackSpeedMax;}
  public void decreaseAttackCooldown(int d) {this.attackSpeedCurrent -= d;}
  public void setShotVelocity(float v) {this.shotVelocity = v;}
  protected void setAimColour(int[] c) {this.aimColour = c;}
  protected void useSprite(boolean u) {this.useSprite = u;}
  protected void setAttacker(boolean a) {this.attacker = a;}
  public void setColour(int[] colour) {this.fillColour = colour;}
  public void setBaseType(towerType i) {this.buildingType = i;}
  protected void setRange(float r) {this.range = r;}
  public void setVector(PVector vector){this.aimVector = vector;}
  protected void setSpriteList(ArrayList<PImage> s)
  {
    this.spriteList = s;
  }
  
  //loop functions
  public void update()
  {
    if(getAttackAvailable() != true && this.attacker){decreaseAttackCooldown(1);}
    if(this.spriteCurrent == this.spriteList.size()-1){spriteCurrent = 0;}
    if(this.spriteCurrent < this.spriteList.size()-1){spriteCurrent++;}
  }
  public void render()
  {
    if(useSprite)
    {
      float[] vertices = getVertices();
      tint(this.fillColour[0],this.fillColour[1],this.fillColour[2]);
      imageMode(CORNERS);
      PImage sprite = spriteList.get(spriteCurrent);
      image(sprite,vertices[0],vertices[1],vertices[6],vertices[7]);
    }
    if(useSprite != true){
    float[] vertices = getVertices();
    stroke(0,0,0);
    fill(this.fillColour[0],this.fillColour[1],this.fillColour[2]);
    rectMode(CORNERS);
    rect(
      vertices[0],
      vertices[1],
      vertices[6],
      vertices[7]);
    }
    if(this.attacker)
    {
      stroke(aimColour[0],aimColour[1],aimColour[2],aimColour[3]);
      line(getXY()[0],getXY()[1],aimVector.x+getXY()[0],aimVector.y+getXY()[1]);
    }    

  }
}

class Auto extends Base {
  Auto(int coordX, int coordY, float size, float margin)
  {
    //int coordX, int coordY, float size, float margin
    super(coordX,coordY,size,margin);
    int[] colour = {100,110,156};
    setColour(colour);
    useSprite(true);
    setBaseType(towerType.AUTO);
    setAttackSpeedMax(30);
    setShotVelocity(30);
    int[] laser = {0,0,255,150};
    setAimColour(laser);
    setRange(500);
    setAttacker(true);
  }
}

class Gatling extends Base {
  Gatling(int coordX, int coordY, float size, float margin)
  {
    //int coordX, int coordY, float size, float margin
    super(coordX,coordY,size,margin);
    int[] colour = {158,75,75};
    setColour(colour);
    useSprite(true);
    setBaseType(towerType.GATLING);
    setAttackSpeedMax(10);
    setShotVelocity(20);
    int[] laser = {255,255,0,150};
    setAimColour(laser);
    setRange(300);
    setAttacker(true);
  } 
}

class Sniper extends Base {
  Sniper(int coordX, int coordY, float size, float margin)
  {
    //int coordX, int coordY, float size, float margin
    super(coordX,coordY,size,margin);
    int[] colour = {43,120,43};
    setColour(colour);
    useSprite(true);
    setBaseType(towerType.SNIPER);
    setAttackSpeedMax(150);
    setShotVelocity(120);
    int[] laser = {255,0,0,150};
    setAimColour(laser);
    setRange(2000);
    setAttacker(true);
  }
}

class ShockwaveTower extends Base {
  ShockwaveTower(int coordX, int coordY, float size, float margin)
  {
    //int coordX, int coordY, float size, float margin
    super(coordX,coordY,size,margin);
    int[] colour = {200,200,200};
    setColour(colour);
    useSprite(true);
    setBaseType(towerType.SHOCKWAVE);
    setAttackSpeedMax(120);
    setShotVelocity(0);
    int[] laser = {100,0,255,150};
    setAimColour(laser);
    setRange(250);
    setAttacker(true);
  } 
}

class Cannon extends Base {
  Cannon(int coordX, int coordY, float size, float margin)
  {
    //int coordX, int coordY, float size, float margin
    super(coordX,coordY,size,margin);
    int[] colour = {200,78,166};
    setColour(colour);
    useSprite(true);
    setBaseType(towerType.CANNON);
    setAttackSpeedMax(90);
    setShotVelocity(50);
    int[] laser = {255,0,255,150};
    setAimColour(laser);
    setRange(400);
    setAttacker(true);
  }
}
