public void loadImages(String filepath)
{
  ArrayList<String> filepaths = new ArrayList<String>();
  String baseSquareFilepath = filepath + "\\baseSquare\\00";
  String enemySquareFilepath = filepath + "\\enemySquare\\00";
  String playerCircleFilepath = filepath + "\\playerCircle\\00";  
  String projectileCircle = filepath + "\\projectileCircle\\00";
  String temppath = "";
  int a = 0;
  filepaths.add(baseSquareFilepath);
  filepaths.add(enemySquareFilepath);
  filepaths.add(playerCircleFilepath);
  filepaths.add(projectileCircle);
  for(String path : filepaths)
  {
    for(int i = 1; i <= 20; i++)
    {
      temppath = path;
      if(i <= 9){temppath += "0";}
      temppath += str(i);
      temppath += ".png";
      PImage image = loadImage(temppath);
      if(a == 0) {this.baseSquareImageList.add(image);;}
      else if(a == 1) {this.enemySquareImageList.add(image);;}
      else if(a == 2) {this.playerCircleImageList.add(image);;}
      else if(a == 3) {this.projectileCircleImageList.add(image);;}
    }
    a += 1;
  }
}
