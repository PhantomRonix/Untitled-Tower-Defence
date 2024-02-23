public enum uiType {UIBOX,UITEXT,UIBUTTON}

//no text, just ui box
class uiBox{
  private float[] size;
  private float posX,posY;
  private int[] fillColour,strokeColour;
  private boolean fillEnabled,strokeEnabled,active;
  private String name;
  private uiType type = uiType.UIBOX;
  
  //constructor for being lazy, and filling in damn near nothing
  uiBox(float sizeX, float sizeY, float posX, float posY, String name)
  {
    float[] size = {sizeX,sizeY};
    
    int[] white = {255,255,255};
    int[] black = {0,0,0};
    
    this.size = size;
    //posX & posY refers to center for consistency's sake
    this.posX = posX;
    this.posY = posY;
    this.name = name;
    this.fillEnabled = true;
    this.fillColour = white;
    this.strokeEnabled = true;
    this.strokeColour = black;
    this.active = true;
  }
  
  
  uiBox(float sizeX, float sizeY, float posX, float posY, String name, int[] fColour,int[] sColour)
  {
    float[] size = {sizeX,sizeY}; 
    this.size = size;
    //posX & posY refers to center for consistency's sake
    this.posX = posX;
    this.posY = posY;
    this.name = name;
    this.fillColour = fColour;
    this.strokeColour = sColour;
    this.fillEnabled = true;
    this.strokeEnabled = true;
    this.active = true;
  }
  
  //secondary constructor for specifying fill/stroke usage
  uiBox(float sizeX, float sizeY, float posX, float posY, String name, boolean fillEnabled, boolean strokeEnabled,int[] fColour,int[] sColour)
  {
    float[] size = {sizeX,sizeY}; 
    this.size = size;
    //posX & posY refers to center for consistency's sake
    this.posX = posX;
    this.posY = posY;
    this.name = name;
    setFillColour(fColour);
    setFillEnabled(fillEnabled);
    setStrokeColour(sColour);
    setStrokeEnabled(strokeEnabled);

    this.active = true;
  }
  
  //getters
  public uiType getUIType() {return this.type;}
  public String getUIName() {return this.name;}
  public int[] getFillColour() {return this.fillColour;}
  public int[] getStrokeColour() {return this.strokeColour;}
  public boolean getActive() {return this.active;}
  protected boolean getFillEnabled() {return this.fillEnabled;}
  protected boolean getStrokeEnabled() {return this.fillEnabled;}
  protected float[] getXY()
  {
    float[] array = {this.posX,this.posY};
    return array;
  }
  
  //returns TL and BR corners for easy rendering
  protected float[][] getCorners()
  {
    float[] tl = {this.posX-(this.size[0]/2),this.posY-(this.size[1]/2)};
    float[] br = {this.posX+(this.size[0]/2),this.posY+(this.size[1]/2)};
    float[][] corners = {tl,br};
    return corners;
  }
  
  //setters
  
  public void setActive(boolean active) {this.active = active;}
  public void setFillColour(int[] colour) {this.fillColour = colour;}
  public void setFillEnabled(boolean status) {this.fillEnabled = status;}
  public void setStrokeColour(int[] colour) {this.strokeColour = colour;}
  public void setStrokeEnabled(boolean status) {this.strokeEnabled = status;}
  protected void setUIName(String name) {this.name = name;}
  public void setUIType(uiType type) {this.type = type;}
  public void setXY(float x, float y)
  {
    this.posX = x;
    this.posY = y;
  }
  
  //empty function so I can update certain ui elements using arraylists
  void update() {}
  
  void render()
  {
    if(this.active)
    {
      rectMode(CORNERS);
      float[][] corners = getCorners();
      float[] tl = corners[0];
      float[] br = corners[1];
      if(fillEnabled) {fill(this.fillColour[0],this.fillColour[1],this.fillColour[2]);}
      else {fill(0,0,0,0);}
      if(strokeEnabled) {stroke(this.strokeColour[0],this.strokeColour[1],this.strokeColour[2]);}
      else {stroke(0,0,0,0);}
      rect(tl[0],tl[1],br[0],br[1]);
    }
  }
}

class textUIBox extends uiBox{
  protected float textSize;
  protected PFont font;
  private String text;
  private int[] textColour;
  
  textUIBox(float sizeX, float sizeY, float posX, float posY, String name, float textSize, String text)
  {
    super(sizeX, sizeY, posX, posY, name);
    setUIType(uiType.UITEXT);
    int[] boxFillColour = {0,0,0,0};
    int[] strokeColour = {0,0,0,0};
    setFillColour(boxFillColour);
    setStrokeColour(strokeColour);
    setFillEnabled(false);
    setStrokeEnabled(false);
    this.textColour = black;
    this.textSize = textSize;
    this.font = createFont("Fonts\\consola.ttf",textSize);
    this.text = text;
    
  }
  
  textUIBox(float sizeX, float sizeY, float posX, float posY, String name, int[] fColour, int[] sColour, int[] tColour, float textSize, String fontname, String text)
  {
    super(sizeX, sizeY, posX, posY, name, fColour, sColour);
    setUIType(uiType.UITEXT);
    this.textSize = textSize;
    this.textColour = tColour;
    this.font = createFont(fontname,textSize);
    this.text = text;
    setFillColour(fColour);
    setFillEnabled(true);
    setStrokeColour(sColour);
    setFillEnabled(true);
  }
  
  textUIBox(float sizeX, float sizeY, float posX, float posY, String name, boolean fillEnabled, boolean strokeEnabled,int[] fColour,int[] sColour, int[] tColour, float textSize, String fontname, String text)
  {
    super(sizeX, sizeY, posX, posY, name, fillEnabled, strokeEnabled, fColour, sColour);
    setUIType(uiType.UITEXT);
    this.textSize = textSize;
    this.textColour = tColour;
    this.font = createFont(fontname,textSize);
    this.text = text;
    this.textColour = tColour;
  }
  //getter
  
  public String getText() {return this.text;}
  public int[] getTextFill() {return this.textColour;}
  
  //setter
  public void setText(String text) {this.text = text;}
  public void setTextFill(int[] colour) {this.textColour = colour;}
  
  void update() {}
  
  void render()
  {
    rectMode(CORNERS);
    float[][] corners = getCorners();
    float[] tl = corners[0];
    float[] br = corners[1];
    float[] pos = getXY();
    int[] fill = getFillColour();
    int[] stroke = getStrokeColour();

    if(getFillEnabled()) {fill(fill[0],fill[1],fill[2]);}
    else {fill(0,0,0,0);}
    if(getStrokeEnabled()) {stroke(stroke[0],stroke[1],stroke[2]);}
    else {stroke(0,0,0,0);}

    rect(tl[0],tl[1],br[0],br[1]);
    
    fill(this.textColour[0],this.textColour[1],this.textColour[2]);
    textFont(font);
    textAlign(CENTER);
    text(this.text,pos[0],pos[1]);
 }
}

class clickBox extends textUIBox{
  private int[] fadeColour;
  private boolean mouseOver = false;
  private boolean clicked = false;
  private boolean textFill = true;
  clickBox(float sizeX, float sizeY, float posX, float posY, String name, int[] fColour, int[] sColour, int[] tColour, int[] fadeColour, float textSize, String fontname, String text)
  {
    super(sizeX,sizeY,posX,posY,name,fColour,sColour,tColour,textSize,fontname,text);
    setUIType(uiType.UIBUTTON);
    this.fadeColour = fadeColour;
  }
  
  clickBox(float sizeX, float sizeY, float posX, float posY, String name, float textSize, String text)
  {
    super(sizeX,sizeY,posX,posY,name,textSize,text);
    setUIType(uiType.UIBUTTON);
    int[] fadegrey = {192,192,192};
    setFillColour(white);
    setStrokeColour(black);
    setTextFill(black);
    this.textFill = true;
    this.fadeColour = fadegrey;
    
    setFillEnabled(true);
    setStrokeEnabled(true);
  }
  //getter
  public boolean getMouseover(float x,float y)
  {
    float[][] corners = getCorners();
    float[] tl = corners[0];
    float[] br = corners[1];
    if (x > tl[0] && x < br[0])
    {
      if (y > tl[1] && y < br[1]) {return true;}
      else {return false;}
    }
    else {return false;}
  }
  
  public boolean getClicked() {return this.clicked;}
  //setter
  public void setClicked(boolean click) {this.clicked = click;}
  public void setTextEnabled(boolean enabled) {this.textFill = enabled;}
  
  void update()
  {
    if(getActive())
    {
      this.mouseOver = getMouseover(mouseX,mouseY);
    }
  }
  
  void render()
  {
    if(getActive())
    {
      rectMode(CORNERS);
      float[][] corners = getCorners();
      float[] tl = corners[0];
      float[] br = corners[1];
      float[] pos = getXY();
      
      int[] fill = getFillColour();
      int[] stroke = getStrokeColour();
      int[] textC = getTextFill();
  
      if(mouseOver) {fill(this.fadeColour[0],this.fadeColour[1],this.fadeColour[2]);}
      else {fill(fill[0],fill[1],fill[2]);}
      if(getStrokeEnabled()) {stroke(stroke[0],stroke[1],stroke[2]);}
      else {stroke(0,0,0,0);}
      
      rect(tl[0],tl[1],br[0],br[1]);
      
      if(textFill) {fill(textC[0],textC[1],textC[2]);}
      else {fill(0,0,0,0);}
      //textSize(textSize);
      textFont(font);
      textAlign(CENTER);
      text(getText(),pos[0],pos[1]);
    }
  }
}
