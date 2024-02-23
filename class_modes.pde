public enum gamemode {GAME, MENU, GAMEOVER, LEADERBOARD};
public enum roundStatus {ALERT, EVASION, CAUTION};//it's a reference, chief
//ALERT = ENEMIES CURRENTLY SPAWNING, EVASION = ENEMIES FINISHED SPAWNING, CAUTION = FINISHED WAVE 


class Mode{
  gamemode mode;
  //changemode used as a flag to indicate the program needs to change state
  private boolean changeMode = false;
  
  //getter
  public boolean getChangeMode() {return this.changeMode;}
  
  public gamemode getMode() {return this.mode;}
  //placeholder for returning random integers used for returning money/time later, for leaderboard purposes
  public int getPlaceholderInteger1() {return 0;}
  public int getPlaceholderInteger2() {return 0;}
  
  //setter
  public void setMode(gamemode mode)
  {
    changeMode = true;
    this.mode = mode;
  }
  
  public void setChangeMode(boolean modechangevalue) {this.changeMode = modechangevalue;} 
  
  void update() {}
  void render() {}
}

class Menu extends Mode{
  protected ArrayList<textUIBox> textboxlist = new ArrayList<textUIBox>();
  protected ArrayList<clickBox> clickboxlist = new ArrayList<clickBox>();
  protected gamemode mode = gamemode.MENU;
  Menu()
  {
    clickBox gamestartButton = new clickBox(200, 50, 640, 300, "startGameButton", 27, "Start Game");
    clickboxlist.add(gamestartButton);
    
    clickBox leaderboardButton = new clickBox(200, 50, 640, 425, "leaderboardButton", 27, "Leaderboards");
    clickboxlist.add(leaderboardButton);
    
    clickBox quitButton = new clickBox(200, 50, 640, 550, "quitButton", 27, "Exit Game");
    clickboxlist.add(quitButton);
    
    textUIBox gametitle = new textUIBox(720, 200, width/2, 100, "TimerBox", 50,"untitled tower defence game");
    textboxlist.add(gametitle);
    
    textUIBox note = new textUIBox(100, 20, 100, 700, "BottomNote", 15,"placeholder note");
    textboxlist.add(note); 
  }
  void update()
  {
    for(clickBox clickbox: clickboxlist) {clickbox.update();}
    if (mousePressed && (mouseButton == LEFT))
    {
      for (clickBox clickable: clickboxlist)
      {
        if (clickable.getMouseover(mouseX,mouseY))
        {
          if(clickable.getUIName() == "startGameButton") {setMode(gamemode.GAME);}
          if(clickable.getUIName() == "leaderboardButton") {setMode(gamemode.LEADERBOARD);}
          if(clickable.getUIName() == "quitButton") {exit();}
        }
      }
    }
  }
  void render()
  {
    background(128,128,128);
    for(textUIBox textBox: textboxlist) {textBox.render();} 
    for(clickBox clickbox: clickboxlist) {clickbox.render();}
  }
}

class leaderboard extends Mode{
  String[] mapFile;
  ArrayList<uiBox> uiBoxList = new ArrayList<uiBox>();
  ArrayList<clickBox> buttonList = new ArrayList<clickBox>();
  leaderboard(String mappath)
  {
    mapFile = loadStrings(mappath);
    //setMode(gamemode.LEADERBOARD);
    //setChangeMode(false);
    //float sizeX, float sizeY, float posX, float posY, String name, float textSize, String text
    clickBox menuReturnButton = new clickBox(160,50,width/2,680,"MenuReturnButton",25,"Go Back");
    uiBoxList.add(menuReturnButton);
    buttonList.add(menuReturnButton);
    ArrayList<int[]> leaderboardData = decodeLeaderboardData(mapFile[0]);
    
    for(int i = 0 ; i < leaderboardData.size(); i++)
    {
     int[] data = leaderboardData.get(i);
     String message1 = String.format("Cash: $%s",str(data[0]));
     String message2 = String.format("Time: %ss",str(data[1]/60));
     textUIBox scoreBox = createLeaderboardEntry(300,50,480,i*52+75,i,message1);
     textUIBox timeBox = createLeaderboardEntry(225,50,750,i*52+75,i,message2);
     uiBoxList.add(scoreBox);
     uiBoxList.add(timeBox);
    }
  }
  
  //get
  
  //set
  
  //create
  private textUIBox createLeaderboardEntry(float sizeX, float sizeY, float posX, float posY, int count, String message)
  {
    String title = "Leaderboard " + str(count);
    //float sizeX, float sizeY, float posX, float posY, String name, int[] fColour, int[] sColour, int[] tColour, float textSize, String fontname, String text
    textUIBox leaderboardEntry = new textUIBox(sizeX, sizeY, posX, posY, title, white, black, black, 35, "Fonts\\consola.ttf", message);
    return leaderboardEntry;
  }
  
  private ArrayList<int[]> decodeLeaderboardData(String leaderboard)
  {
   ArrayList<int[]> finalList = new ArrayList<int[]>();
   String[] leaderboardsplit = leaderboard.split(" ");
   for(String term : leaderboardsplit)
   {
     String[] termSplit = term.split(",");
     int[] termsConverted = {int(termSplit[0]),int(termSplit[1])};
     finalList.add(termsConverted);
   }
   return finalList;
  }
  
  void update()
  {
    for(clickBox clickable : buttonList)
    {
      clickable.update();
    }
    if (mousePressed && (mouseButton == LEFT))
    {
      for (clickBox clickable: buttonList)
      {
        if (clickable.getMouseover(mouseX,mouseY)){setMode(gamemode.MENU);}
      }
    }
  }
  
  void render()
  {
    background(128,128,128);
    for(uiBox renderable: uiBoxList){renderable.render();}
  }
  
}

class Game extends Mode{
  String map;
  gamemode mode = gamemode.GAME; 
  //game statistics
  private int waveCounter = 0;  
  private int waveCounterMax = 0;
  private int money = 0;
  private int moneyTotal = 0;
  private int lives = 25;
  private int killCounter = 0;
  private int waveTimer = 0;
  private int gameTimer = 0;
  private float difficultyMult = 1;
  private int enemySpawnDelay = 0;
  private roundStatus waveStatus = roundStatus.CAUTION; 
  private uiBox selectedBase;
  //other things
  
  Player playerObject;
  //data handling arraylists
  ArrayList<int[]> basePositions = new ArrayList<int[]>();
  ArrayList<int[]> route = new ArrayList<int[]>();
  String rawWaveData = "";
  ArrayList<int[]> waveData = new ArrayList<int[]>();
  ArrayList<Integer> currentWave = new ArrayList<Integer>();
  
  //object array lists
  ArrayList<ObjectMoveable> objectlist = new ArrayList<ObjectMoveable>();
  ArrayList<ObjectMoveable> objectRemovalList = new ArrayList<ObjectMoveable>();
  ArrayList<Enemy> enemylist = new ArrayList<Enemy>();
  ArrayList<Projectile> projectilelist = new ArrayList<Projectile>();
  ArrayList<Base> baselist = new ArrayList<Base>();
  ArrayList<Base> basePointer = new ArrayList<Base>();
  ArrayList<Base> turretList = new ArrayList<Base>();
  ArrayList<uiBox> uiList = new ArrayList<uiBox>();
  ArrayList<textUIBox> textList = new ArrayList<textUIBox>();
  ArrayList<clickBox> clickBoxList = new ArrayList<clickBox>();
  
  //vectors for player input and stuff
  PVector mouseVector = new PVector(mouseX,mouseY);
  PVector shootVector = new PVector();
  PVector center = new PVector(screenSize_x/2,screenSize_y/2);
  PVector playerPosition = new PVector();
  
  int[] playerCoords;

  Game(String map)
  {
    this.map = map;
    loadMapData(this.map);
    for(int[] baseData: basePositions) {baselist.add(createTowerBase(baseData[0],baseData[1],1));}
    loadWaveData();
    createUI();
    playerObject = new Player(playerCoords[0],playerCoords[1],unitScale/2,30);
    //float sizeX, float sizeY, float posX, float posY, String name, boolean fillEnabled, boolean strokeEnabled,int[] fColour,int[] sColour
    selectedBase = new uiBox(unitScale,unitScale,0,0,"SelectedBaseIndicator",true,false,white,white);
    selectedBase.setActive(false);
  }
  //get crap
  
  public roundStatus getRoundStatus() {return this.waveStatus;}
  public int getLives() {return this.lives;} 
  public int getPlaceholderInteger1() {return this.moneyTotal;}
  public int getPlaceholderInteger2() {return this.gameTimer;}
  
  //set/increase/reduce crap
  
  public void setRoundStatus(roundStatus newRound) {this.waveStatus = newRound;}
  public void increaseMoney(float increment) {this.money += increment;}
  public void increaseKills(int increment) {this.killCounter += increment;}
  private PVector calculateAimVector(PVector startposition, float aimX, float aimY, float mag)
  {
    //Calculate the vectors regarding player-projectile flight and the aim line for the player
    PVector returnvector = new PVector(aimX,aimY);
    returnvector.sub(startposition);
    returnvector.setMag(mag);
    return returnvector;
  }
  
  //create crap
  private Base createTowerBase(int xCoord, int yCoord, float margin)
  {
    Base createdbase = new Base(xCoord,yCoord,unitScale,margin);
    return createdbase;
  }
  
  private void constructTurret(towerType type, ArrayList<Base> selectedBase)
  {
    for (clickBox clickable : clickBoxList)
    {
      if(clickable.getUIName() != "waveStartButton"){clickable.setActive(false);}
    }
    Base base = selectedBase.get(0);
    this.baselist.remove(base);
    if(base.getBuildingType() != towerType.BASE)
    {
      this.turretList.remove(base);
    }
    int[] baseCoords = base.getBaseCoords();
    Base newTurret;
    switch(type)
    {
      case AUTO:
        this.money -= 75;
        newTurret = new Auto(baseCoords[0],baseCoords[1],unitScale,2.0);
        break;
      case GATLING:
        newTurret = new Gatling(baseCoords[0],baseCoords[1],unitScale,2.0);
        this.money -= 150;
        break;
      case SNIPER:
        newTurret = new Sniper(baseCoords[0],baseCoords[1],unitScale,2.0);
        this.money -= 200;
        break;
      case SHOCKWAVE:
        newTurret = new ShockwaveTower(baseCoords[0],baseCoords[1],unitScale,2.0);
        this.money -= 300;
        break;
      case CANNON:
        newTurret = new Cannon(baseCoords[0],baseCoords[1],unitScale,2.0);
        this.money -= 450;
        break;
      default:
        newTurret = new Base(baseCoords[0],baseCoords[1],unitScale,2.0);
        break;
    }
    this.baselist.add(newTurret);
    this.turretList.add(newTurret);
    this.basePointer.clear();
    this.selectedBase.setXY(0,0);
    this.selectedBase.setActive(false);
  }
  
  private void createEnemy(int enemyType)
  {
    Enemy newEnemy;
    switch(enemyType)
    {
      case 1:
        newEnemy = new BasicEnemy(250*difficultyMult,250*difficultyMult,route);
        break;
      case 2:
        newEnemy = new SpeedEnemy(150*difficultyMult,150*difficultyMult,route);
        break;
      case 3:
        newEnemy = new RegenEnemy(300*difficultyMult,300*difficultyMult,route);
        break;
      case 4:
        newEnemy = new TankEnemy(1000*difficultyMult,1000*difficultyMult,route);
        break;
      default:
        newEnemy = new BasicEnemy(1,1,route);
        break;
    }
    this.objectlist.add(newEnemy);
    this.enemylist.add(newEnemy);
  }
  
  private void addToUIList(uiBox obj) {this.uiList.add(obj);}
  private void addToUIList(textUIBox obj)
  {
    uiList.add(obj);
    textList.add(obj);
  }
  private void addToUIList(clickBox obj)
  {
    uiList.add(obj);
    clickBoxList.add(obj);
  }
  
  private void createUI()
  {
    uiBox uiBoxLeft = new uiBox(uiBorder_x-1, height-1, uiBorder_x/2, height/2, "ContainerLeft");
    addToUIList(uiBoxLeft);
    
    uiBox uiBoxRight = new uiBox(uiBorder_x, height, width-(uiBorder_x/2), height/2, "ContainerRight");
    addToUIList(uiBoxRight);
    
    //float sizeX, float sizeY, float posX, float posY, String name, int[] fColour,int[] sColour
    uiBox waveStatusIndicator = new uiBox(uiBorder_x-20, 15, uiBorder_x/2 , 675, "waveStatusIndicator", black,black);
    addToUIList(waveStatusIndicator);
    
    //float sizeX, float sizeY, float posX, float posY, String name, float textSize, String text
    textUIBox waveCounter = new textUIBox(uiBorder_x,30,uiBorder_x/2, 35, "WaveCounterBox",30,"");
    addToUIList(waveCounter);
    
    textUIBox livesUI = new textUIBox(uiBorder_x, 20, uiBorder_x/2, 75, "LivesText", 20,"");
    addToUIList(livesUI);
    
    textUIBox moneyUI = new textUIBox(uiBorder_x, 20, uiBorder_x/2, 100, "MoneyText",20,"");
    addToUIList(moneyUI);
    
    textUIBox gameTimerUI = new textUIBox(uiBorder_x, 20, uiBorder_x/2, 300, "GameTimerBox", 18, "");
    addToUIList(gameTimerUI);
    
    textUIBox roundTimerUI = new textUIBox(uiBorder_x, 20, uiBorder_x/2, 340, "RoundTimerBox", 18,"");
    addToUIList(roundTimerUI);

    textUIBox killCounterUI = new textUIBox(uiBorder_x,20,uiBorder_x/2, 500, "KillCounterBox",20,"");
    addToUIList(killCounterUI);
    
    //float sizeX, float sizeY, float posX, float posY, String name, boolean fillEnabled, boolean strokeEnabled,int[] fColour,int[] sColour, int[] tColour, float textSize, String fontname, String text
    textUIBox waveStatusTextUITop = new textUIBox(uiBorder_x,20,uiBorder_x/2, 610, "waveStatusTextTop",15,"ENEMY STATUS:");
    addToUIList(waveStatusTextUITop);
    
    textUIBox waveStatusTextUI = new textUIBox(uiBorder_x,40,uiBorder_x/2,650,"WaveStatusText",false,false,black,black,black,35,"Fonts\\consola.ttf","");
    addToUIList(waveStatusTextUI);  
    
    //float sizeX, float sizeY, float posX, float posY, String name, float textSize, String text
    clickBox waveStartButton = new clickBox(uiBorder_x-20,35,width-(uiBorder_x/2),100,"waveStartButton",20,"Begin Wave");
    addToUIList(waveStartButton);
    
    clickBox towerBuildAutoButton = new clickBox(uiBorder_x-10,40,width-(uiBorder_x/2),200,"AutoTowerButton",12,"Build Auto Turret\n$75");
    towerBuildAutoButton.setActive(false);
    addToUIList(towerBuildAutoButton);
    
    clickBox towerBuildGatlingButton = new clickBox(uiBorder_x-10,40,width-(uiBorder_x/2),250,"GatlingTowerButton",12,"Build Gatling Turret\n$150");
    towerBuildGatlingButton.setActive(false);
    addToUIList(towerBuildGatlingButton);
    
    clickBox towerBuildSniperButton = new clickBox(uiBorder_x-10,40,width-(uiBorder_x/2),300,"SniperTowerButton",12,"Build Sniper Turret\n$200");
    towerBuildSniperButton.setActive(false);
    addToUIList(towerBuildSniperButton);
    
    clickBox towerBuildShockwaveButton = new clickBox(uiBorder_x-10,40,width-(uiBorder_x/2),350,"ShockwaveTowerButton",12,"Build Shockwave Turret\n$300");
    towerBuildShockwaveButton.setActive(false);
    addToUIList(towerBuildShockwaveButton);
    
    clickBox towerBuildCannonButton = new clickBox(uiBorder_x-10,40,width-(uiBorder_x/2),400,"CannonTowerButton",12,"Build Cannon Turret\n$450");
    towerBuildCannonButton.setActive(false);
    addToUIList(towerBuildCannonButton);
  }
  
  //draw methods
  
  private void drawRouteIndicator(int[] colour)
  {
    stroke(colour[0],colour[1],colour[2]);
    for (int i = 0; i < route.size()-1; i++)
      {
        int[] position1 = route.get(i);
        int[] position2 = route.get(i+1);
        float[] routeXY = coordsToXY(position1[0],position1[1]);
        float[] routeXYDestination = coordsToXY(position2[0],position2[1]);
        line(routeXY[0],routeXY[1],routeXYDestination[0],routeXYDestination[1]);
      }
  }
  
  private void drawMouseHoverSquare(int[] colour)
  {
    float[] rectCenter = {(int(mouseX)/int(unitScale))*unitScale+unitScale/2,(int(mouseY)/int(unitScale))*unitScale+unitScale/2};
    rectMode(CENTER);
    fill(colour[0],colour[1],colour[2],128);
    stroke(0,0,0,0);
    rect(rectCenter[0],rectCenter[1],unitScale,unitScale);
  }
  
  //update crap
  
  private void updateUI()
  {
    String wavecountermessage = String.format("Wave %d",this.waveCounter);
    String roundtimermessage = String.format("Wave time: %s",str((this.waveTimer/60)));
    String gametimermessage = String.format("Game time: %s",str((this.gameTimer/60)));
    String killcountermessage = String.format("Kills: %d",this.killCounter);
    String moneymessage = String.format("Money: $%d",this.money);
    String livesmessage = String.format("Lives: %d",lives);
    String wavestatusmessage = "";
    
    int[] wavestatusfill = {0,0,0};
    int[] alert = {255,25,0};
    int[] evasion = {255,187,0};
    int[] caution = {0,255,75};
    switch(getRoundStatus())
    {
      case ALERT:
        wavestatusmessage = "ALERT";
        wavestatusfill = alert;
        break;
      case EVASION:
        wavestatusmessage = "EVASION";
        wavestatusfill = evasion;
        break;
      case CAUTION:
        wavestatusmessage = "CAUTION";
        wavestatusfill = caution;
        break;
    }
    
    for(textUIBox textElement: textList)
    {
      if (textElement.getUIName() == "WaveCounterBox") {textElement.setText(wavecountermessage);}
      else if (textElement.getUIName() == "RoundTimerBox") {textElement.setText(roundtimermessage);}
      else if (textElement.getUIName() == "GameTimerBox") {textElement.setText(gametimermessage);}
      else if (textElement.getUIName() == "MoneyText") {textElement.setText(moneymessage);}
      else if (textElement.getUIName() == "LivesText") {textElement.setText(livesmessage);}
      else if (textElement.getUIName() == "KillCounterBox") {textElement.setText(killcountermessage);}
      else if (textElement.getUIName() == "WaveStatusText")
      {
        textElement.setText(wavestatusmessage);
        textElement.setTextFill(wavestatusfill);
      }
    }
    for(uiBox uiElement: uiList)
    {
      if (uiElement.getUIName() == "waveStatusIndicator") {uiElement.setFillColour(wavestatusfill);}
    }
  }
  
  
  void updateButtons()
  {
    for(clickBox clickableElement: clickBoxList)
    {
      clickableElement.update();
      if(clickableElement.getMouseover(mouseX,mouseY))
      {
        if(clickableElement.getUIName() == "waveStartButton")
        {
          newWave();
          for(clickBox clickable: clickBoxList)
          {
            clickable.setActive(false);
          }
          this.selectedBase.setActive(false);
          this.selectedBase.setXY(0,0);
          this.basePointer.clear();
        }
        if(basePointer.size() > 0)
        {
          if(clickableElement.getUIName() == "AutoTowerButton" && this.money >= 75){constructTurret(towerType.AUTO,basePointer);}
          if(clickableElement.getUIName() == "GatlingTowerButton" && this.money >= 150){constructTurret(towerType.GATLING,basePointer);}
          if(clickableElement.getUIName() == "SniperTowerButton" && this.money >= 200){constructTurret(towerType.SNIPER,basePointer);}
          if(clickableElement.getUIName() == "ShockwaveTowerButton" && this.money >= 300){constructTurret(towerType.SHOCKWAVE,basePointer);}
          if(clickableElement.getUIName() == "CannonTowerButton" && this.money >= 450){constructTurret(towerType.CANNON,basePointer);}
        }
      }
    }
  }
  
  //file handling methods
  
  ArrayList<int[]> decodeCoordinateTextLine(String TextLine)
  {
    ArrayList<int[]> finalArray = new ArrayList<int[]>();
    String[] TextLineSplit1 = TextLine.split(" ");
    for (String TextLineSplit1Data: TextLineSplit1)
    {
      int[] array = int(TextLineSplit1Data.split(","));
      finalArray.add(array);
    }
    return finalArray;
  }
 
  private void loadMapData(String mapfilepath)
  {
    String[] rawMapData = loadStrings(mapfilepath);
    //unitsize, base placement, route, -scores?
    unitScale = int(rawMapData[1]);
    basePositions = decodeCoordinateTextLine(rawMapData[2]);
    this.route = decodeCoordinateTextLine(rawMapData[3]);
    playerCoords = int(rawMapData[4].split(","));
    playerPosition.set(coordsToXY(playerCoords[0],playerCoords[1]));
    rawWaveData = rawMapData[5];
  }

  private void loadWaveData()
  {
    String[] waves = rawWaveData.split(" ");
    this.waveCounterMax = waves.length;
    for(String data : waves)
    {
      int[] wavesSplit = int(data.split(","));
      this.waveData.add(wavesSplit);
    }
  }

  private void newWave()
  {
    this.waveTimer = 0;
    this.waveCounter += 1;
    if (waveCounter%5 == 0 && waveCounter > 1) {difficultyMult *= 1.625;}
    this.waveStatus = roundStatus.ALERT;
    int[] wave = this.waveData.get(waveCounter-1);
    this.enemySpawnDelay = wave[0];
    for(int i = 1; i < wave.length; i++)
    {
      currentWave.add(wave[i]);
    }
  }

  private void deleteObjects(ObjectMoveable obj)
  {
    this.objectlist.remove(obj);
    switch(obj.getObjectType())
    {
      case ENEMY:
        //in this case refers to the enemy's killed status
        if(obj.getPlaceholderBoolean())
        {
        this.killCounter += 1;
        this.moneyTotal += 10;
        this.money += 10;
        }
        else
        {
          this.lives -= 1;
        }
        this.enemylist.remove(obj);
        break;
      case PROJECTILE:
        this.projectilelist.remove(obj);
        if(obj.getObjName() == "BombProjectile")
          {
            //float size, float posX, float posY, float dX,float dY, float damage,int[] fill, int lifeSpan, boolean growthEnabled, int growthRate
            ShockwaveProj explosion = new ShockwaveProj(75,obj.getXY()[0],obj.getXY()[1],0,0,25,red,5,true,5);
            objectlist.add(explosion);
            projectilelist.add(explosion);
          }
        break;
      case BUILDING:
      case PLAYER:
      case PARTICLE:
        break;
    }
  }
  
  public void update()
  {
    if (this.lives < 1) {setMode(gamemode.GAMEOVER);}
    mouseVector = calculateAimVector(playerPosition, mouseX,mouseY,screenXY);
    this.gameTimer+= 1;
    if(getRoundStatus() != roundStatus.CAUTION)
    {
    for(Base turret : turretList)
      {
        turret.update();
          if(turret.getAttackAvailable())
          {
            float targetdist = turret.getRange();
            PVector shootVector = new PVector();
            PVector turretPosition = new PVector(turret.getXY()[0],turret.getXY()[1]);
            PVector targetlocation = new PVector();
            boolean target = false;
            for(Enemy enemy : enemylist)
            {
              float[] enemyXY = enemy.getXY();
              if(targetdist > dist(turretPosition.x,turretPosition.y,enemyXY[0],enemyXY[1]))
              {
                targetdist = dist(turretPosition.x,turretPosition.y,enemyXY[0],enemyXY[1]);
                targetlocation.set(enemyXY);
                target = true;
              }
              else{continue;}
            }
            if(target)
            {
              shootVector = calculateAimVector(turretPosition,targetlocation.x,targetlocation.y,turret.getShotVelocity());
              shootVector.setMag(turret.getShotVelocity());
              turret.setVector(shootVector.setMag(targetdist));
              turret.resetAttackSpeed();
              Projectile newshot;
              switch(turret.getBuildingType())
              {
                case AUTO:
                  int[] autoColour = {128,128,128};
                  newshot = new Bullet(10,turretPosition.x,turretPosition.y,shootVector.x,shootVector.y,1,80,autoColour);
                  break;
                case GATLING:
                  int[] gatlingColour = {56,56,56};
                  newshot = new Bullet(5,turretPosition.x,turretPosition.y,shootVector.x,shootVector.y,0,30,gatlingColour);
                  break;
                case SNIPER:
                  newshot = new Bullet(15,turretPosition.x,turretPosition.y,shootVector.x,shootVector.y,10,300,black);
                  break;
                case SHOCKWAVE:
                  newshot = new ShockwaveProj(30,turretPosition.x,turretPosition.y,shootVector.x,shootVector.y,5,white,20,true,3);
                  break;
                case CANNON:
                  newshot = new Bomb(20,turretPosition.x,turretPosition.y,shootVector.x,shootVector.y,40,black);
                  break;
                default:
                  newshot = new Bullet(0,0,0,0,0,0,0,black);
                  break;
              }
              this.objectlist.add(newshot);
              this.projectilelist.add(newshot);
            }
          }
        }
      this.waveTimer += 1;
      if(getRoundStatus() == roundStatus.ALERT)
      {
        if(this.currentWave.size() == 0) {waveStatus = roundStatus.EVASION;}
        if(waveTimer%enemySpawnDelay == 0)
        {
          createEnemy(currentWave.get(0));
          currentWave.remove(0);
        }
      }
      else
      {
        if(enemylist.size() == 0)
        {
          if(this.waveCounter == this.waveCounterMax) {setMode(gamemode.GAMEOVER);}
          setRoundStatus(roundStatus.CAUTION);
          for(clickBox clickable: clickBoxList)
          {
            if(clickable.getUIName() == "waveStartButton")
            {
              clickable.setActive(true);
            }
          }
        }
      }
    }    
    //Calculate mouseEvents here:
    if (mousePressed && (mouseButton == LEFT))
    {
      if (getRoundStatus() != roundStatus.CAUTION)
      {
        if (playerObject.getAttackAvailable())
        {
          shootVector = mouseVector.copy();
          shootVector.setMag(40);
          //float size, float posX, float posY, float dX,float dY, int pierce, float damage,int[] fill
          Bullet playerBullet = new Bullet(10,playerPosition.x,playerPosition.y,shootVector.x,shootVector.y,2,100,black);
          objectlist.add(playerBullet);
          projectilelist.add(playerBullet);
          playerObject.resetAttackSpeed();
        }
      }
      else
      {
        if(mouseX > width-uiBorder_x || mouseX < uiBorder_x) {updateButtons();}
        else
        {
          this.selectedBase.setActive(false);
          this.selectedBase.setXY(0,0);
          for(clickBox clickable: clickBoxList)
          {
            if (clickable.getUIName() == "waveStartButton") {continue;}
            else {clickable.setActive(false);}
          }
          basePointer.clear();
          for(Base tower : baselist)
          {
            int[] mouseCoords = getCoords(mouseX,mouseY);
            if(mouseCoords[0] == tower.getBaseCoords()[0] && mouseCoords[1] == tower.getBaseCoords()[1])
            {
              basePointer.clear();
              float[] position = coordsToXY(tower.getBaseCoords()[0],tower.getBaseCoords()[1]);
              this.selectedBase.setXY(position[0],position[1]);
              this.selectedBase.setActive(true);
              basePointer.add(tower);
              for(clickBox clickable: clickBoxList)
              {
                clickable.setActive(true);
              }
              break;
            }
            else{continue;}
          }
        }
      }
    }

    for (ObjectMoveable obj: objectRemovalList) {deleteObjects(obj);}    
    objectRemovalList.clear();
    
    //call update funcs for objects here
    for (ObjectMoveable obj: objectlist)
    {
      if (obj.getActive() == false)
      {
        objectRemovalList.add(obj);
        continue;
      }
      if (obj.getActive() == true) {obj.update();}
    }
    for(clickBox clickableElement: clickBoxList)
    {
      clickableElement.update();
    }
    //calculate collisions
    for (Enemy enemy: enemylist)
    {
      for (Projectile proj: projectilelist)
      {
        // distance check added as optimization attempt
        if (dist(enemy.getXY()[0],enemy.getXY()[1],proj.getXY()[0],proj.getXY()[1]) <= 100)
        {
          if (proj.getPierce() >= 0 && proj.getPierceEnabled())
          {
            if(enemy.calculateCollisions(proj))
            {
              enemy.reduceHealth(proj.getDamage());
              proj.reducePierce(1);
            }
          }
          else if (proj.getLifespanEnabled())
          {
            enemy.reduceHealth(proj.getDamage());
          }
        }
      }
    }
    updateUI();
    playerObject.update();
  }
  
  public void render()
  {
    background(150,150,150);  
    //call render methods for objects here, single-line for space
    stroke(0,0,0);
    for (Base base: baselist) {base.render();}   
    if (getRoundStatus() == roundStatus.CAUTION) {drawMouseHoverSquare(white);}
    drawRouteIndicator(black);   
    stroke(0,0,0);
    for (ObjectMoveable obj: objectlist) {obj.render();}
    //call UI/text renders here
    if (getRoundStatus() == roundStatus.ALERT || getRoundStatus() == roundStatus.EVASION)
    {
      stroke(0,255,0,128);
      line(playerPosition.x,playerPosition.y,playerPosition.x+mouseVector.x,playerPosition.y+mouseVector.y);
      stroke(0,0,0);    
    }
    playerObject.render();
    for (uiBox uiElement: uiList)
    {
      uiElement.render();
    }
    this.selectedBase.render();
  }
}

class GameOver extends Mode{
  ArrayList<clickBox> clickBoxList = new ArrayList<clickBox>();
  int score,timer;
  
  gamemode mode = gamemode.GAMEOVER;
  
  GameOver(int score,int time)
  {
  stroke(0,0,0,0);
  fill(180,180,180,200);
  rect(0,0,width,height);
  
  this.score = score;
  this.timer = time;

  String scoreString = String.format("Money earned: $%d",this.score);
  //float sizeX, float sizeY, float posX, float posY, String name, float textSize, String text)
  textUIBox gameoverMessage = new textUIBox(500,200,width/2,200,"GameoverMessage",35,"Game Over");
  textUIBox scoreMessage = new textUIBox(500,200,width/2,245,"ScoreMessage",25,scoreString);
  
  clickBox mainMenuButton = new clickBox(200,50,width/2,400,"MainMenuButton",27,"Main Menu");
  clickBoxList.add(mainMenuButton);
  
  clickBox quitButton = new clickBox(200,50,width/2,500,"quitButton",27,"Quit Game");
  clickBoxList.add(quitButton);
  
  
  gameoverMessage.render();
  scoreMessage.render();
  
  ArrayList<int[]> leaderboard = getLeaderboard("Maps\\map.txt");

  if(checkLeaderboard(leaderboard))
  {
    IntList leaderboardScores = new IntList();
    IntList leaderboardTimes = new IntList();
    for(int i = 0 ; i < leaderboard.size(); i++)
    {
      int[] data = leaderboard.get(i);
      leaderboardScores.append(data[0]);
      leaderboardTimes.append(data[1]);
    }
    leaderboardScores.append(this.score);
    leaderboardScores.sortReverse();
    int overwriteKey = 0;
    for(int i = 0; i< leaderboardScores.size()-1; i++ )
    {
      if(leaderboardScores.get(i) == this.score)
      {
        overwriteKey = i;
        break;
      }
    }
    leaderboardScores.remove(10);
    IntList leaderboardTimesUpdated = new IntList();
    for(int i = 0; i <leaderboardTimes.size(); i++)
    {
      if(i == overwriteKey)
      {
        leaderboardTimesUpdated.append(this.timer);
        leaderboardTimesUpdated.append(leaderboardTimes.get(i));
      }
      else
      {
        leaderboardTimesUpdated.append(leaderboardTimes.get(i));
      }
    }

    leaderboardTimesUpdated.remove(10);
    String leaderboardWriteFile = "";
    String line = "";
    for (int i = 0 ; i < leaderboardScores.size() ; i++)
    {
      line = str(leaderboardScores.get(i));
      line += ",";
      line += str(leaderboardTimesUpdated.get(i));
      line += " ";
      leaderboardWriteFile += line;
    }
    
    leaderboardWriteFile = leaderboardWriteFile.substring(0, leaderboardWriteFile.length() - 1);
    updateLeaderboard("Maps\\map.txt",leaderboardWriteFile);
    textUIBox newHighScore = new textUIBox(500,200,width/2,275,"",18,"Score saved to leaderboard!");
    newHighScore.render(); 
  }
  }
  
  
  private ArrayList<int[]> getLeaderboard(String mapfilepath)
  {
    String[] rawMapData = loadStrings(mapfilepath);
    String leaderboardLine = rawMapData[0];
    String[] leaderboardSplit1 = leaderboardLine.split(" ");
    ArrayList<int[]> leaderboardSplit2 = new ArrayList<int[]>();
    for (String data : leaderboardSplit1)
    {
      String[] dataSplit = data.split(",");
      int[] dataSplitInt = new int[2];
      dataSplitInt[0] = int(dataSplit[0]);
      dataSplitInt[1] = int(dataSplit[1]);
      leaderboardSplit2.add(dataSplitInt);
    }
    return leaderboardSplit2;
  }
  
  private String[] loadMapData(String mapfilepath)
  {
    String[] rawMapData = loadStrings(mapfilepath);
    return rawMapData;
  }
  
  //used to use i to identify position of replacable element but became obsolete
  private boolean checkLeaderboard(ArrayList<int[]> leaderboard)
  {
    for(int i = 0; i < leaderboard.size()-1 ; i++)
    {
      int[] data = leaderboard.get(i);
      if(this.score > data[0]) {return true;}
      else {continue;}
    }
    return false;
  }
  
  private void updateLeaderboard(String mapPath,String newLeaderboard)
  {
    String[] mapData = loadMapData(mapPath);
    mapData[0] = newLeaderboard;
    saveStrings("Maps\\map.txt", mapData);
  }
  
  public void update()
  {
    for(clickBox clickableElement: clickBoxList) {clickableElement.update();}
    if (mousePressed && (mouseButton == LEFT))
      for(clickBox clickableElement: clickBoxList)
      {
        clickableElement.update();
        if(clickableElement.getMouseover(mouseX,mouseY))
        {
          if(clickableElement.getUIName() == "MainMenuButton") {setMode(gamemode.MENU);}
          if(clickableElement.getUIName() == "quitButton") {exit();}
        }
    }
  }
  
  public void render()
  {
    for(uiBox clickableElement: clickBoxList) {clickableElement.render();}
  }
}
    
