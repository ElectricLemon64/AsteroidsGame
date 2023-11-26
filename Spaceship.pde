class Spaceship extends Floater{
  protected boolean accelerating, reversing, thrusters;
  protected double health, mass, acceleration, turning;
  protected int myDefaultColor, thrusterTimer, thrusterTimerRequirement, sHealth;
  protected String name;
  public Spaceship(){
    myCenterX = width / 2;
    myCenterY = height / 2;
    myPointDirection = 0;
    myColor = (#0C9CE8);
    myDefaultColor = myColor;
    myXspeed = 0;
    myYspeed = 0;
    accelerating = false;
    reversing = false;
    thrusters = true;
    thrusterTimer = 0;
    thrusterTimerRequirement = 5;
    name = "Classic";
    corners = 3;
    xCorners = new int[]{10, -10, -10};
    yCorners = new int[]{0, 5, -5};
    health = 350;
    mass = 1.2;
    acceleration = 0.20;
    turning = 1.6;
    sHealth = (int)health;
  }
  public Spaceship(int type){
    myCenterX = width / 2;
    myCenterY = height / 2;
    myPointDirection = 0;
    myColor = (#0C9CE8);
    myDefaultColor = myColor;
    myXspeed = 0;
    myYspeed = 0;
    accelerating = false;
    reversing = false;
    thrusters = true;
    thrusterTimer = 0;
    thrusterTimerRequirement = 5;
    if(type == 2){
      name = "Speed";
      corners = 4;
      xCorners = new int[]{10, -10, -5, -10};
      yCorners = new int[]{0, 5, 0, -5};
      health = 300;
      mass = 1;
      acceleration = 0.25;
      turning = 2;
    }
    else if(type == 3){
      name = "Tank";
      corners = 6;
      xCorners = new int[]{10, 0, -10, -5, -10, 0};
      yCorners = new int[]{0, 5, 5, 0, -5, -5};
      health = 600;
      mass = 2;
      acceleration = 0.15;
      turning = 1;
    }
    else{
      name = "Classic";
      corners = 3;
      xCorners = new int[]{10, -10, -10};
      yCorners = new int[]{0, 5, -5};
      health = 350;
      mass = 1.2;
      acceleration = 0.20;
      turning = 1.6;
    }
    sHealth = (int)health;
  }
  public void hyperSpace(){
    myXspeed = 0;
    myYspeed = 0;
    myPointDirection = Math.random() * 360;
    myCenterX = Math.random() * 500;
    myCenterY = Math.random() * 500;
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
  public String getName(){
    return name;
  }
  public double getDirection(){
    return myPointDirection;
  }
  public void setDirection(int d){
    myPointDirection = d;
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
  public void setAccelerating(boolean a){
    accelerating = a;
    if(thrusters == false){
      accelerating = false;
    }
  }
  public void setReversing(boolean r){
    reversing = r;
    if(thrusters == false){
      reversing = false;
    }
  }
  public double getHealth(){
    return health;
  }
  public double getHealthPercentage(){
    return health / sHealth;
  }
  public void setHealth(double h){
    health = h;
  }
  public void setThrusters(boolean b){
    thrusters = b;
  }
  public boolean getThrusters(){
    return thrusters;
  }
  public void accelerate(double amount){
    if(thrusters){
      super.accelerate(amount);
    }
  }
  public void setColor(int c){
    myColor = c;
  }
  public void setDefaultColor(){
    myColor = myDefaultColor;
  }
  public void show (){             
    fill(myColor);   
    stroke(myColor);    
    
    //translate the (x,y) center of the ship to the correct position
    translate((float)myCenterX, (float)myCenterY);

    //convert degrees to radians for rotate()     
    float dRadians = (float)(myPointDirection*(Math.PI/180));
    
    //rotate so that the polygon will be drawn in the correct direction
    rotate(dRadians);
    
    //draw the polygon
    beginShape();
    for (int nI = 0; nI < corners; nI++)
    {
      vertex(xCorners[nI], yCorners[nI]);
    }
    endShape(CLOSE);
    
    if(accelerating){
      fill(255, 0, 0);
      beginShape();
      vertex(-5, 0);
      vertex(-8, 3);
      vertex(-10, 0);
      vertex(-8, -3);
      vertex(-5, 0);
      endShape(CLOSE);
    }
    if(reversing){
      stroke(255, 0, 0);
      line(5, 3, 7, 4);
      line(5, -3, 7, -4);
      stroke(255);
    }

    //"unrotate" and "untranslate" in reverse order
    rotate(-1*dRadians);
    translate(-1*(float)myCenterX, -1*(float)myCenterY);
    stroke(0);
  }
  public void accelerate(boolean forward){
    if(forward){
      accelerating = true;
      super.accelerate(acceleration);
    }
    else{
      reversing = false;
      super.accelerate(-(acceleration * 1/3));
    }
  }
  public void turn(boolean clockwise){
    if(clockwise){
      super.turn(turning);
    }
    else{
      super.turn(-turning);
    }
  }
  public void move(){
    super.move();
    if(thrusters == false){
      thrusterTimer++;
      if(thrusterTimer % 2 != 0){
        myColor = #FF0000;
      }
      else{
        myColor = myDefaultColor;
      }
      if(thrusterTimer == thrusterTimerRequirement){
        thrusters = true;
        thrusterTimer = 0;
        myColor = myDefaultColor;
      }
    }
  }
  public void calculateCollisionSpeed(double others, double otherm, double dir){
    double msi = Math.sqrt(Math.pow(myXspeed, 2) + Math.pow(myYspeed, 2));
    double mso = ((mass - otherm)/(mass + otherm)) * msi + ((2 * otherm) / (mass + otherm)) * others;
    myXspeed = Math.cos(dir) * mso;
    myYspeed = Math.sin(dir) * mso;
    health -= (otherm * (msi + 1) * 2);
    thrusterTimer = 0;
    setThrusters(false);
  }
  public void unIntrude(double amount, double dir){
    myCenterX += amount * Math.cos(dir) * 1.10;
    myCenterY += amount * Math.sin(dir) * 1.10;
  }
}
