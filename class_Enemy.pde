class Enemy extends ObjectMoveable {
  protected float speed,healthCurrent,healthMax;
  protected int routePos = 0;
  protected boolean killed;
  protected ArrayList<int[]> route;
  protected objectType objType = objectType.ENEMY;
  protected int[] destination,fillColourFade,fillColourCurrent;
  
  Enemy(float healthStart, float healthMax, ArrayList<int[]> route)
  {
    float[] startPos = coordsToXY(route.get(0)[0],route.get(0)[1]);
    setXY(startPos[0],startPos[1]);
    this.healthCurrent = healthStart;
    this.healthMax = healthMax;
    setObjectType(objectType.ENEMY);
    setActive(true);
    this.route = route; 
    int[] fillColourFade = {0,0,0};
    this.fillColourFade = fillColourFade;
    this.setSpritelist(enemySquareImageList);
  }
  //getters
  public boolean getPlaceholderBoolean(){return this.killed;}
  public boolean getKilled(){return this.killed;}
  private float[] getCurrentDestination()
  {
    int[] destinationCoords = this.route.get(this.routePos);
    float[] destinationXY = coordsToXY(destinationCoords[0],destinationCoords[1]);
    return destinationXY;
  }
  
  //setter
  public void setHealth(float healthNew) {this.healthCurrent = healthNew;}
  public void reduceHealth(float healthReduction) {this.healthCurrent -= healthReduction;}
  public void setKilled(boolean killed){this.killed = killed;}
  //other methods
  protected float[] calculateDirection()
  {
    float[] destination = getCurrentDestination();
    float[] posXY = getXY();
    float distanceToX = posXY[0] - destination[0];
    float distanceToY = posXY[1] - destination[1];
    float dX = 0;
    float dY = 0;
    if (this.speed > abs(distanceToX) && abs (distanceToX) > 0)
    {
      posXY[0] = destination[0];
      dX = 0;
    } 
    else if (abs(distanceToY) < this.speed && abs(distanceToY) > 0)
    {
      posXY[1] = destination[1];
      dY = 0;
    } 
    else if (abs(distanceToX) > 0)
    {
      if (distanceToX < 0) {dX = speed;}
      else {dX = -speed;}
    }
    else if (abs(distanceToY) > 0)
    {
      if (distanceToY < 0) {dY = speed;}
      else {dY = -speed;}
    }
    float[] finalarray = {dX,dY};
    return finalarray;
  }
  
  //checks if health is still in positives, if not 
  public boolean healthCheck()
  {
    if (healthCurrent <= 0) {return false;}
    else {return true;}
  }
  
  int[] calculateColour()
  {
    int[] fill = getObjFill();
    int r = int(map(healthCurrent,0,healthMax,fillColourFade[0],fill[0]));
    int g = int(map(healthCurrent,0,healthMax,fillColourFade[1],fill[1]));
    int b = int(map(healthCurrent,0,healthMax,fillColourFade[2],fill[2]));
    int[] array = {r,g,b};
    return array;
  }
  
  protected void updateRoutePos()
  {
  float[] destination = getCurrentDestination();
  float[] XY = getXY();
      if (XY[0] == destination[0] && XY[1] == destination[1])
      {
        if (this.routePos < this.route.size()-1) {this.routePos += 1;}
        else if (this.routePos == this.route.size()-1) {setActive(false);}
      }
  }
  
  void update()
  {
    if (getActive())
    {
      float[] dXY = getdXY();
      updateRoutePos();    
      float[] direction = calculateDirection();
      dXY[0] = direction[0];
      dXY[1] = direction[1];
      moveXY(dXY[0],dXY[1]);
      if (healthCurrent <= 0)
      {
        setActive(false);
        this.killed = true;
      }
    }
  }
  
  void render()
  {
    //use square function until I make sprites
    imageMode(CORNERS);
    float[][] vertices = getVertices();
    float[] topleft = vertices[0];
    float[] bottomright = vertices[3];
    fillColourCurrent = calculateColour();
    tint(fillColourCurrent[0],fillColourCurrent[1],fillColourCurrent[2]);
    image(getSprite(),topleft[0],topleft[1],bottomright[0],bottomright[1]);
    this.spriteIncrement(1);
  }
}

class BasicEnemy extends Enemy
{  
  BasicEnemy(
  float healthStart,
  float healthMax,  
  ArrayList<int[]> route)
  {
    super(healthStart,healthMax,route);
    this.speed = 2.5;
    setSize(unitScale*3/4);
    int[] fillColour = {255,0,0};
    setObjectType(objectType.ENEMY);
    setObjFill(fillColour); 
  }
}  

class SpeedEnemy extends Enemy {
  SpeedEnemy(
  float healthStart,
  float healthMax,
  ArrayList<int[]> route)
  {
    super(healthStart,healthMax,route);
    this.speed = 4;
    setSize(unitScale*1/2);    
    int[] fillColour = {0,150,255};
    setObjFill(fillColour);
  }
}
class RegenEnemy extends Enemy {
  int regenDelayMax, regenDelayCurrent;
  float regen;
  boolean regenActive;
  RegenEnemy(float healthStart, float healthMax, ArrayList<int[]> route)
  {
    super(healthStart,healthMax,route);    
    this.speed = 2;
    setSize(unitScale*3/4);
    this.regenDelayMax = 90;
    this.regenDelayCurrent = 0;
    this.regen = 2.5;
    this.regenActive = false;
    int[] fillColour = {0,255,50};
    setObjFill(fillColour);
  }
  //calculates if regen bool should be enabled
  boolean checkRegen()
  {
    //turn off regen at max hp
    if (this.healthCurrent >= this.healthMax)
    {
      this.healthCurrent = this.healthMax;
      this.regenDelayCurrent = this.regenDelayMax;
      return false;
    }
    //if regen delay has ended, return regen value, update function is reponsible for adding it to current health
    else if (regenDelayCurrent == 0) {return true;}
    //if health regen has not kicked in, tick delay down and return no regen
    else if (healthCurrent != healthMax)
    {
      regenDelayCurrent -= 1;
      return false;
    }
    return false;
  }
  
    void reduceHealth(float healthReduction)
  {
    this.regenDelayCurrent = this.regenDelayMax;
    this.healthCurrent -= healthReduction;
  }
  
  void update()
  {
    if (this.active)
    {
      float[] dXY = getdXY();
      updateRoutePos();
      float[] direction = calculateDirection();
      dXY[0] = direction[0];
      dXY[1] = direction[1];
      moveXY(dXY[0],dXY[1]);
      if (healthCurrent <= 0)
      {
        setActive(false);
        setKilled(true);
      }
      if (this.regenActive || checkRegen()) {this.healthCurrent += this.regen;}
    }
  }
}
class TankEnemy extends Enemy {
  int regenDelayMax, regenDelayCurrent;
  float regen;
  boolean regenActive;
  TankEnemy(float healthStart, float healthMax, ArrayList<int[]> route)
  {
    super(healthStart,healthMax,route);    
    this.speed = 1;
    setSize(unitScale*7/8);
    this.regenDelayMax = 1;
    this.regenDelayCurrent = 0;
    this.regen = 0.1;
    this.regenActive = false;
    int[] fillColour = {70,70,70};
    setObjFill(fillColour);
  }
  //calculates if regen bool should be enabled
  boolean checkRegen()
  {
    //turn off regen at max hp
    if (this.healthCurrent >= this.healthMax)
    {
      this.healthCurrent = this.healthMax;
      this.regenDelayCurrent = this.regenDelayMax;
      return false;
    }
    //if regen delay has ended, return regen value, update function is reponsible for adding it to current health
    else if (regenDelayCurrent == 0) {return true;}
    //if health regen has not kicked in, tick delay down and return no regen
    else if (healthCurrent != healthMax)
    {
      regenDelayCurrent -= 1;
      return false;
    }
    return false;
  }
  
    void reduceHealth(float healthReduction)
  {
    this.regenDelayCurrent = this.regenDelayMax;
    this.healthCurrent -= healthReduction;
  }
  
  void update()
  {
    if (this.active)
    {
      float[] dXY = getdXY();
      updateRoutePos();
      float[] direction = calculateDirection();
      dXY[0] = direction[0];
      dXY[1] = direction[1];
      moveXY(dXY[0],dXY[1]);
      if (healthCurrent <= 0)
      {
        setActive(false);
        setKilled(true);
      }
      if (this.regenActive || checkRegen()) {this.healthCurrent += this.regen;}
    }
  }
}
