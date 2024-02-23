int screenSize_x = 1280;
int screenSize_y = 720;


//the size of 1 screen border for ui elements
int uiBorder_x = 160;
int bulletMargin = 200;
public int moneyScore = 0;
public int gameTotalTime = 0;

public int[] black = {0,0,0};
public int[] red = {255,0,0};
public int[] green = {0,255,0};
public int[] blue = {0,0,255};
public int[] white = {255,255,255};

public ArrayList<PImage> baseSquareImageList = new ArrayList<PImage>();
public ArrayList<PImage> enemySquareImageList = new ArrayList<PImage>();
public ArrayList<PImage> playerCircleImageList = new ArrayList<PImage>();
public ArrayList<PImage> projectileCircleImageList = new ArrayList<PImage>();


float screenXY = sqrt(sq(screenSize_x)+sq(screenSize_y));
  public float unitScale;


  //utility functions
  public int[] getCoords(float x,float y)
  {
    int coordX = ceil((x-uiBorder_x)/unitScale);
    int coordY = ceil(y/unitScale);
    int[] coords = {coordX,coordY};
    return coords;
  }
  
  public float[] coordsToXY(int coordX, int coordY)
  {
    float x = (coordX*unitScale-(unitScale/2))+uiBorder_x;
    float y = coordY*unitScale-(unitScale/2);
    float[] xy = {x,y};
    return xy;
  }




//object creation methods


//int[] randomColour()
//{
//  int[] colour = {
//  int(random(0,256)),
//  int(random(0,256)),
//  int(random(0,256))};
  
//  return colour;
//}

//main methods

void settings()
{
  size(screenSize_x,screenSize_y);
  loadImages("Sprites");
}

Mode gamemodeObject;

void setup()
{
  frameRate(60);
  gamemodeObject = new Menu();
}

void update()
{
  gamemodeObject.update();
  if (gamemodeObject.getChangeMode())
  {
    gamemodeObject.setChangeMode(false);
    switch(gamemodeObject.getMode())
    {
      case GAME:
        gamemodeObject = new Game("Maps\\map.txt");
        break;
      case MENU:
        gamemodeObject = new Menu();
        break;
      case LEADERBOARD:
        gamemodeObject = new leaderboard("Maps\\map.txt");
        break;
      case GAMEOVER:
        //placeholder int1 = total money earned during game, int2 = time taken
        moneyScore = gamemodeObject.getPlaceholderInteger1();
        gameTotalTime = gamemodeObject.getPlaceholderInteger2();
        gamemodeObject = new GameOver(moneyScore,gameTotalTime);
        break;
    }
  }
}

void draw()
{
  update();
  gamemodeObject.render();
}
