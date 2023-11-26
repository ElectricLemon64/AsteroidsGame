class Targeter extends Spaceship{
  private Spaceship target;
  private double mySpeed;
  private int maxRotation;
  public Targeter(int x, int y, int dir, int c, Spaceship t){
    myCenterX = x;
    myCenterY = y;
    myPointDirection = dir;
    myColor = 255;
    myDefaultColor = myColor;
    corners = c;
    myXspeed = 0;
    myYspeed = 0;
    xCorners = new int[]{10, -10, -5, -10};
    yCorners = new int[]{0, 5, 0, -5};
    accelerating = false;
    reversing = false;
    health = 300;
    target = t;
    mySpeed = 1;
    maxRotation = 1;
    thrusterTimer = 0;
    thrusterTimerRequirement = 10;
  }
  public void targetShip(){
    double targetDirection = Math.toDegrees(Math.atan2(target.getY() - myCenterY, target.getX() - myCenterX));
    boolean playerBehind = myCenterX - target.getX() > 0;
    stroke(255, 255, 255);
    line((float)myCenterX, (float)myCenterY, (float)(myCenterX + 1000*Math.cos(Math.toRadians(targetDirection))), (float)(myCenterY + 1000*Math.sin(Math.toRadians(targetDirection))));
    stroke(0);
    if(targetDirection > 180){targetDirection -= 180;}
    if(targetDirection < -180){targetDirection += 180;}
    if(playerBehind){
      if(targetDirection >= 0){
        targetDirection = 180 - targetDirection;
      }
      else{
        targetDirection = -180 - targetDirection;
      }
      if(myPointDirection >= 0){
       myPointDirection = 180 - myPointDirection;
      }
      else{
        myPointDirection = -180 - myPointDirection;
      }
    }
    if(Math.abs(targetDirection - myPointDirection) <= maxRotation){
      myPointDirection = targetDirection;
    }
    else if(targetDirection - myPointDirection > maxRotation){
        myPointDirection += maxRotation;
    }
    else if(targetDirection - myPointDirection < -maxRotation){
        myPointDirection -= maxRotation;
    }
    if(playerBehind){
      if(myPointDirection >= 0){
       myPointDirection = 180 - myPointDirection;
      }
      else{
        myPointDirection = -180 - myPointDirection;
      }
    }
    if(myPointDirection > 180){myPointDirection -= 180;}
    if(myPointDirection < -180){myPointDirection += 180;}
  }
  public void moveShip(){
    if(thrusters){
      setAccelerating(true);
      double dRadians =myPointDirection*(Math.PI/180);  
      myXspeed = mySpeed * Math.cos(dRadians);
      myYspeed = mySpeed * Math.sin(dRadians);
    }
    move();
  }
  public Spaceship getTarget(){
    return target;
  }
}
