public enum projectileType {BULLET,PULSE,BOMB}

class Projectile extends ObjectMoveable{
  private int pierce,lifespan,growth,currentSprite;
  private int[] colourFill;
  private boolean pierceEnabled = false;
  private boolean lifespanEnabled = false;
  private boolean projectileGrowth = false;
  private float damage;
  private ArrayList<PImage> spriteList = projectileCircleImageList;
  private projectileType projType;
  Projectile(float size, float posX, float posY, float dX,float dY, float damage, int[] fill)
  {
    setSize(size); //size = radius
    setXY(posX,posY);
    setdXY(dX,dY);
    this.damage = damage;
    this.colourFill = fill;
    setActive(true);
    setObjectType(objectType.PROJECTILE);
  }
  //Getter Methods
  public float getDamage() {return this.damage;}
  public int getPierce() {return this.pierce;}
  public projectileType getProjectileType() {return this.projType;}
  public boolean getPierceEnabled() {return this.pierceEnabled;}
  public boolean getLifespanEnabled() {return this.lifespanEnabled;}
  
  //Setter Methods
  public void setDamage(float dmg) {this.damage = dmg;} 
  public void setPierce(int pierceNew) {this.pierce = pierceNew;}
  public void reducePierce(int reduction) {this.pierce -= reduction;}
  public void setPierceEnabled(boolean pierceenabled) {this.pierceEnabled = pierceenabled;}
  public void setLifespan(int lifespan) {this.lifespan = lifespan;}
  public void reduceLifespan(int decrement) {this.lifespan -= decrement;}
  public void setLifespanEnabled(boolean enabled){this.lifespanEnabled = enabled;}
  public void setProjectileGrowthRate(int i){this.growth = i;}
  public void setGrowthEnabled(boolean i){this.projectileGrowth = i;}
  public void setProjectileType(projectileType type) {this.projType = type;}

  //Checking methods here
  public void updateSpriteCounter()
  {
    if (this.currentSprite == this.spriteList.size()-1){this.currentSprite = 0;}
    if (this.currentSprite < this.spriteList.size()-1){this.currentSprite++;}
  }      
  
  //checks if the bullet is "outside" normal game boundaries, returns bool appropriately
  protected boolean checkOutOfBounds()
  {
    float[] xy = getXY();
    float size = getSize();
    if (xy[0] - size/2 > width+bulletMargin || xy[0] + size/2 < 0-bulletMargin) {return false;}
    if (xy[1] - size/2 > height+bulletMargin || xy[1] + size/2 < 0-bulletMargin) {return false;}
    else {return true;}
  }
  
  protected float[] calculateMovement()
  {
    float[] xy = getXY();
    float[] dXY = getdXY();
    float[] array = {xy[0]+dXY[0],xy[1]+dXY[1]};
    return array;
  }
  
  //loopable methods here
  public void update()
  {
    if (getActive())
    {
      if(this.lifespanEnabled){this.lifespan -= 1;}
      float[] mvArray = calculateMovement();
      setXY(mvArray[0],mvArray[1]);
      if (getPierce() < 0 && this.pierceEnabled) {setActive(false);}
      if (this.projectileGrowth) {setSize(getSize()+this.growth);}
      if (this.lifespan <= 0 && this.lifespanEnabled) {setActive(false);}
      if (getActive()){setActive(checkOutOfBounds());}
      updateSpriteCounter();
    }
  }
  
  public void render()
  {
    if (this.active)
    {
      float[] posXY = getXY();
      float[] verts = {posXY[0]-getSize(),posXY[1]-getSize(),posXY[0]+getSize(),posXY[1]+getSize()};
      PImage sprite = spriteList.get(currentSprite);
      if(this.colourFill.length == 4) {tint(this.colourFill[0],this.colourFill[1],this.colourFill[2],this.colourFill[3]);}
      else {tint(this.colourFill[0],this.colourFill[1],this.colourFill[2]);}
      imageMode(CORNERS);
      image(sprite,verts[0],verts[1],verts[2],verts[3]);
    }
  }
}


class Bullet extends Projectile{
  //protected int pierce;
  //protected float damage;
  //projectileType projType = projectileType.BULLET;
  
  Bullet(float size, float posX, float posY, float dX,float dY, int pierce, float damage,int[] fill)
  {
    super(size,posX,posY,dX,dY,damage,fill);
    setProjectileType(projectileType.BULLET);
    setPierce(pierce);
    setPierceEnabled(true);
  }
  
  //loopable methods here
}

class ShockwaveProj extends Projectile{
  //projectileType projType = projectileType.PULSE;
  ShockwaveProj(float size, float posX, float posY, float dX,float dY, float damage,int[] fill, int lifeSpan, boolean growthEnabled, int growthRate)
  {
    super(size,posX,posY,dX,dY,damage,fill);
    setProjectileType(projectileType.PULSE);
    setLifespan(lifeSpan);
    setLifespanEnabled(true);
    setObjName("ShockwaveProjectile");
    setProjectileGrowthRate(growthRate);
    setGrowthEnabled(growthEnabled);
  }
}

class Bomb extends Projectile{
  //projectileType projType = projectileType.PULSE;
  Bomb(float size, float posX, float posY, float dX,float dY, float damage,int[] fill)
  {
    super(size,posX,posY,dX,dY,damage,fill);
    setProjectileType(projectileType.BOMB);
    setObjName("BombProjectile");
    setPierceEnabled(true);
    setPierce(-1);
  }
  
    public void update()
  {
    if (getActive())
    {
      float[] mvArray = calculateMovement();
      setXY(mvArray[0],mvArray[1]);
      if (getPierce() < 0 && getPierceEnabled()) {setActive(false);}
      if (getActive()) {setActive(checkOutOfBounds());}
      updateSpriteCounter();
    }
  } 
}
