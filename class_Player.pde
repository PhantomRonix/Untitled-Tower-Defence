//this specifies the object which the player controls
class Player{
  int coordX,coordY,attackSpeedMax,attackSpeedCurrent,currentSprite;
  float size;
  boolean active;
  ArrayList<PImage> spriteList;
  objectType objType = objectType.PLAYER;
  
  Player(int coordX, int coordY, float size, int attackSpeed) {
    this.coordX = coordX;
    this.coordY = coordY;
    this.size = size;
    spriteList = playerCircleImageList;
    this.currentSprite = 0;
    //record attackspeed in frames
    this.attackSpeedMax = attackSpeed;
    this.attackSpeedCurrent = 0;    
    
    this.active = true;
  }
  
  //getters
  boolean getAttackAvailable()
  {
    if (attackSpeedCurrent > 0 ) {return false;}
    else {return true;}
  }
  
  int getAttackSpeedMax() {return attackSpeedMax;}
  
  //setters
  
  public void setActive(boolean activevalue) {this.active = activevalue;} 

  public void setAttackSpeedCurrent(int i) {attackSpeedCurrent = i;}
  public void resetAttackSpeed() {attackSpeedCurrent = attackSpeedMax;}
  
  void update()
  {
    if (attackSpeedCurrent > 0)
    {
      attackSpeedCurrent --;
    }
    if(this.currentSprite == this.spriteList.size()-1){currentSprite = 0;}
    else{currentSprite++;}
  }
  
  void render()
  {
    if (this.active){
      tint(0,100,255);
      //stroke(0,0,0);
      float[] position = coordsToXY(this.coordX,this.coordY);
      float[] TLBR = {position[0]-size,position[1]-size,position[0]+size,position[1]+size};
      PImage sprite = spriteList.get(currentSprite);
      //ellipseMode(RADIUS);
      imageMode(CORNERS);
      image(sprite,TLBR[0],TLBR[1],TLBR[2],TLBR[3]);
      //circle(position[0],position[1],size);
    }
  }
}
