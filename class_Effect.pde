//wanted to have hit-feedback effects (e.g. explosions, didn't have time)

class Particle{
  protected float posX,posY,sizeX,sizeY;
  protected int lifespan;
  protected objectType objType = objectType.PARTICLE;
  
  //getter
  public objectType getObjectType() {return this.objType;}
  
  //setter
  
  public void render() {}
  public void update() {}
}
