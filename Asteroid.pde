class Asteroid extends Floater{
  private int mySize, health, collisionTimer, collisionTimeLimit;
  private double mass, rotSpeed;
  boolean collision;
  public Asteroid(double x, double y, double dir, int c, double xSpeed, double ySpeed){
    rotSpeed = Math.random();
    mass = Math.random() * 3 + 2;
    mySize = (int)(mass * 10);
    health = (int)(mass * 100);
    myCenterX = x;
    myCenterY = y;
    myColor = 150;
    myPointDirection = dir;
    corners = c;
    myXspeed = xSpeed;
    myYspeed = ySpeed;
    xCorners = new int[c];
    yCorners = new int[c];
    randomGenerate();
    collisionTimer = 0;
    collisionTimeLimit = 5;
    collision = false;
  }
  boolean checkCollision(float cX, float cY){
   if(dist((float)myCenterX, (float)myCenterY, cX, cY) <= mySize){
      return true;
    }
    else{
      return false;
    }
  }
  public double getX(){
    return myCenterX;
  }
  public double getY(){
    return myCenterY;
  }
  public void setX(double x){
    myCenterX = x;
  }
  public void setY(double y){
    myCenterY = y;
  }
  public double getXspeed(){
    return myXspeed;
  }
  public double getYspeed(){
    return myYspeed;
  }
  public double getMass(){
    return mass;
  }
  public void setXspeed(double s){
    myXspeed = s;
  }
  public void setYspeed(double s){
    myYspeed = s;
  }
  public double getHealth(){
    return health;
  }
  public void setMass(double s){
    mass += s;
    health = (int)(mass * 100);
    mySize = (int)(mass * 10);
    randomGenerate();
  }
  public int getSize(){
    return mySize;
  }
  public void setCollision(){
    if(collision == false){
      mass -= (Math.random() / 10) * Math.sqrt(Math.pow(myXspeed, 2) + Math.pow(myYspeed, 2));
      mySize = (int)(mass * 10);
      health = (int)(mass * 100);
      randomGenerate();
    }
    collision = true;
  }
  public boolean getCollision(){
    return collision;
  }
  public void move(){
    if(collision){
      collisionTimer++;
      if(collisionTimer == collisionTimeLimit){
        collisionTimer = 0;
        collision = false;
      }
    }
    turn(rotSpeed);
    super.move();
  }
  public void calculateCollisionSpeed(double others, double otherm, double dir){
    double msi = Math.sqrt(Math.pow(myXspeed, 2) + Math.pow(myYspeed, 2));
    double mso = ((mass - otherm)/(mass + otherm)) * msi + ((2 * otherm) / (mass + otherm)) * others;
    myXspeed = Math.cos(dir) * mso;
    myYspeed = Math.sin(dir) * mso;
    setCollision();
  }
  public void unIntrude(double amount, double dir){
    myCenterX += amount * Math.cos(dir) * 1.15;
    myCenterY += amount * Math.sin(dir) * 1.15;
  }
  public void randomGenerate(){
    double rotation = 0;
    double moveRotation = (float)((360 / corners)*(Math.PI/180));
    xCorners[0] = 0;
    yCorners[0] = (int)((Math.random() * mySize/4) + mySize/2);
    for(int i = 1; i < corners; i++){
      rotation += moveRotation;
      xCorners[i] = (int)((Math.random() * mySize/4 + mySize/2) * Math.sin(rotation));
      yCorners[i] = (int)((Math.random() * mySize/4 + mySize/2) * Math.cos(rotation));
    }
  }
  //For debugging collisions
  /*void show(){
    super.show();
    fill(0, 0, 0, 0);
    stroke(255, 0 , 0);
    ellipse((float)myCenterX, (float)myCenterY, mySize, mySize);
  }*/
}
