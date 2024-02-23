public enum objectType {ENEMY,PROJECTILE,BUILDING,PLAYER,PARTICLE};

class ObjectMoveable{
  private float posX,posY,dX,dY,size;
  protected boolean active;
  private int[] fillColour, lineColour;
  private int spriteCounter,spriteCurrent;
  private ArrayList<PImage> spriteList;
  private String name = "";
  private objectType objType;
  protected ArrayList<ObjectMoveable> ignoredColliders = new ArrayList<ObjectMoveable>();
  
  //getters
  public boolean getActive() {return active;}
  public ArrayList<PImage> getSpritelist() {return this.spriteList;}
  public String getObjName() {return this.name;}
  public int getSpriteCounter() {return this.spriteCounter;}
  public int getCurrentSpriteIndex() {return this.spriteCurrent;}
  public PImage getSprite() {return this.spriteList.get(this.getCurrentSpriteIndex());}
  public int[] getObjFill() {return this.fillColour;}
  public int[] getObjStroke() {return this.lineColour;}
  public float getSize() {return this.size;}
  public float[] getXY()
  {
    float[] array = {posX,posY};
    return array;
  }
  public float[] getdXY()
  {
    float[] array = {this.dX,this.dY};
    return array;
  }
  
  //used for returning a placeholder boolean, used with enemies
  public boolean getPlaceholderBoolean() {return false;}
  public objectType getObjectType() {return this.objType;}
  public float[][] getVertices()
  {
    float[] topleft = {posX-size/2,posY-size/2};
    float[] topright = {posX+size/2,posY-size/2};
    float[] bottomleft = {posX-size/2,posY+size/2};
    float[] bottomright = {posX-1+size/2,posY-1+size/2};
    float[][] array = {topleft,topright,bottomleft,bottomright};
    return array;
  }
  public float[] getTopLeft()
  {
    float[] topleft = {posX-size/2,posY-size/2};
    return topleft;
  }
  public float[] getBottomRight()
  {
    float[] bottomright = {posX-1+size/2,posY-1+size/2};
    return bottomright;
  }
  
  //setters
  
  public void setObjName(String n) {this.name = n;}
  public void setSize(float s) {this.size = s;}
  public void setSpritelist(ArrayList<PImage> s)
  {
    this.spriteList = s;
    this.spriteCounter = s.size()-1;
  }
  public void setSpriteCurrentIndex(int n){this.spriteCurrent = n;}
  public void spriteIncrement(int i)
  {
    if(this.spriteCurrent == this.spriteCounter) {this.spriteCurrent = 0;}
    else{this.spriteCurrent += i;}
  }
  public void setObjFill(int[] f) {this.fillColour = f;}
  public void setObjStroke(int[] s) {this.lineColour = s;}
  public void setActive(boolean active) {this.active = active;}
  public void setObjectType(objectType objType) {this.objType = objType;}
  public void setXY(float newX, float newY)
  {
  this.posX = newX;
  this.posY = newY;
  }
  public void setdXY(float dx, float dy)
  {
  this.dX = dx;
  this.dY = dy;
  }
  //misc.
  
  public void moveXY(float dX, float dY)
  {
  this.posX += dX;
  this.posY += dY;
  }
 
  public boolean calculateCollisions(ObjectMoveable collider)
  {
    if (this.ignoredColliders.contains(collider)) {return false;}
    else
    {
      float[] selfvertexTL = getTopLeft();
      float[] selfvertexBR = getBottomRight();
      
      float[] colliderTL = collider.getTopLeft();
      float[] colliderBR = collider.getBottomRight();
      
      if (colliderTL[0] > selfvertexTL[0] && colliderTL[0] < selfvertexBR[0] || colliderBR[0] > selfvertexTL[0] && colliderBR[0] < selfvertexBR[0])
      {
        if (colliderTL[1] > selfvertexTL[1] && colliderTL[1] < selfvertexBR[1] || colliderBR[1] > selfvertexTL[1] && colliderBR[1] < selfvertexBR[1])
        {
          this.ignoredColliders.add(collider);
          return true; 
        }
        else {return false;}
      }
      else {return false;}
    }
  }
  
  public void update() {}
  public void render() {}
  }
