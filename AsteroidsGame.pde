BufferedReader br;
PrintWriter pw;
Spaceship player = new Spaceship(1);
ArrayList<Asteroid> asteroids;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Targeter> targeters;
Floater[] floaters = new Floater[100];
boolean left = false;
boolean right = false;
boolean up = false;
boolean down = false;
boolean shoot = false;
int numAsteroids = 20;
int bulletTimer = 0;
int bulletTimeLimit = 10;
boolean menu = true;
boolean paused = false;
int menuState = 1;
Button start, controls, exit, bClassic, bSpeed, bTank, resume, restart, exitGame;
int score = 0;
int highScore;
int scoreTimer;
Targeter targeter;
int shipType = 1;

void setup(){
  br = createReader("HighScore.txt");
  pw = createWriter("HighScore.txt");
  try {
    try {
      highScore = Integer.parseInt(br.readLine());
      br.close();
      //writeHighScore();
    } 
    catch (NumberFormatException n) {
      highScore = 0;
    }
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  size(1000, 600);
  start = new Button(100, 400, 300, 100, "Start", 50);
  controls = new Button(100, 275, 300, 100, "Controls", 50);
  exit = new Button(100, 425, 200, 75, "Exit", 50);
  bClassic = new Button(450, 425, 125, 75, "Classic", 30);
  bSpeed = new Button(625, 425, 125, 75, "Speed", 30);
  bTank = new Button(800, 425, 125, 75, "Tank", 30);
  resume = new Button(350, 150, 300, 100, "Resume", 50);
  restart = new Button(350, 275, 300, 100, "Restart", 50);
  exitGame = new Button(350, 400, 300, 100, "Exit", 50);
}
void draw(){
  if(menu){
    background(0);
    fill(50);
    rect(50, 50, width - 100, height - 100);
    textAlign(CENTER);
    textSize(100);
    fill(#0C9CE8);
    player.setX(500);
    player.setY(350);
    player.setDirection(0);
    if(menuState == 1){
      text("Asteroids", 500, 150);
      start.show();
      controls.show();
      bClassic.show();
      bSpeed.show();
      bTank.show();
      player.show();
      fill(#0C9CE8);
      textSize(40);
      text("Ship: " + player.getName(), 700, 350);
      text("Score: " + score, 350, 250);
      text("Highscore: " + highScore, 650, 250);
    }
    else if(menuState == 2){
      text("Game Over", 500, 150);
      start.show();
      controls.show();
      bClassic.show();
      bSpeed.show();
      bTank.show();
      player.show();
      fill(#0C9CE8);
      textSize(40);
      text("Score: " + score, 350, 250);
      text("Highscore: " + highScore, 650, 250);
    }
    else if(menuState == 3){
      text("Controls:", 500, 150);
      textSize(30);
      text("Accelerate: UP", 350, 225);
      text("Reverse: DOWN", 350, 275);
      text("Turn Left: LEFT", 350, 325);
      text("Turn Right: RIGHT", 350, 375);
      text("HyperSpace: SPACE", 650, 225);
      text("Shoot Bullets: S", 650, 275);
      text("Pause Game: J", 650, 325);
      exit.show();
    }
  }
  else{
    if(paused){
      fill(50);
      rect(300, 50, 400, 500);
      textSize(75);
      fill(#0C9CE8);
      text("Paused", width / 2, 125);
      resume.show();
      restart.show();
      exitGame.show();
    }
    else{
      background(0);
      for(int i = 0; i < floaters.length; i++){
        ((Star)floaters[i]).show();
      }
      moveBullets();
      player.move();
      collisions();
      controlShip();
      player.show();
      healthBar();
      trackScore();
      while(asteroids.size() < numAsteroids){
        addAsteroid();
      }
      for(int i = 0; i < targeters.size(); i++){
        Targeter t = (targeters.get(i));
        t.targetShip();
        t.moveShip();
        t.show();
      }
    }
  }
}
void keyPressed(){
  if(key == ' '){
    boolean collision = true;
    while(collision){
      player.hyperSpace();
      collision = false;
      for(int i = 0; i < asteroids.size(); i++){
        Asteroid a = asteroids.get(i);
        if(a.checkCollision((float)player.getX(), (float)player.getY())){
          collision = true;
        }
      }
    }
  }
  if(keyCode == RIGHT){
    right = true;
  }
  if(keyCode == LEFT){
    left = true;
  }
  if(keyCode == UP){
    up = true;
  }
  if(keyCode == DOWN){
    down = true;
  }
  if(key == 's'){
    shoot = true;
  }
  if(key == 'j'){
    paused = !paused;
  }
}
void keyReleased(){
  if(keyCode == RIGHT){
    right = false;
  }
  if(keyCode == LEFT){
    left = false;
  }
  if(keyCode == UP){
    up = false;
    player.setAccelerating(false);
  }
  if(keyCode == DOWN){
    down = false;
    player.setReversing(false);
  }
  if(key == 's'){
    shoot = false;
  }
}
void collisions(){
  double aa = atan2((float)player.getYspeed(), (float)player.getYspeed());
  double psi = (Math.sqrt(Math.pow(player.getXspeed(), 2) + Math.pow(player.getYspeed(), 2)));
  for(int i = 0; i < asteroids.size(); i++){
    Asteroid a = asteroids.get(i);
    a.move();
    a.show();
    double pa = atan2((float)a.getYspeed(), (float)a.getXspeed());
    if(a.checkCollision((float)player.getX(), (float)player.getY())){
      double asi = (Math.sqrt(Math.pow(a.getXspeed(), 2) + Math.pow(a.getYspeed(), 2)));
      double paDirection = (Math.atan2(player.getY() - a.getY(), player.getX() - a.getX()));
      double intrusion = (a.getSize()) - dist((float)player.getX(), (float)player.getY(), (float)a.getX(), (float)a.getY());
      player.unIntrude(intrusion, paDirection);
      a.calculateCollisionSpeed(psi, player.getMass(), aa);
      player.calculateCollisionSpeed(asi, a.getMass(), pa);
      if(a.getHealth() < 0){
        asteroids.remove(a);
      }
    }
    for(int s = 0; s < asteroids.size(); s++){
      Asteroid b = asteroids.get(s);
      if(b != a){
        if(a.checkCollision((float)b.getX(), (float)b.getY())){
          aa = atan2((float)b.getYspeed(), (float)b.getYspeed());
          double ba = atan2((float)a.getYspeed(), (float)a.getYspeed());
          double asi = (Math.sqrt(Math.pow(a.getXspeed(), 2) + Math.pow(a.getYspeed(), 2)));
          double bsi = (Math.sqrt(Math.pow(b.getXspeed(), 2) + Math.pow(b.getYspeed(), 2)));
          double baDirection = (Math.atan2(b.getY() - a.getY(), b.getX() - a.getX()));
          double intrusion = (a.getSize()) - dist((float)a.getX(), (float)a.getY(), (float)b.getX(), (float)b.getY());
          b.unIntrude(intrusion, baDirection);
          a.calculateCollisionSpeed(bsi, b.getMass(), aa);
          b.calculateCollisionSpeed(asi, a.getMass(), ba);
          if(a.getHealth() < 0){
            asteroids.remove(a);
          }
          if(b.getHealth() < 0){
            asteroids.remove(b);
          }
        }
      }
    }
  }
  for(int i = 0; i < targeters.size(); i++){
    Targeter t = targeters.get(i);
    if(dist((float)t.getX(), (float)t.getY(), (float)player.getX(), (float)player.getY()) <= 15){
      double ta = atan2((float)t.getXspeed(), (float)t.getYspeed());
      double tsi = (Math.sqrt(Math.pow(t.getXspeed(), 2) + (Math.pow(t.getYspeed(), 2))));
      double ptDirection = (Math.atan2(t.getY() - player.getY(), t.getX() - player.getX()));
      double intrusion = (15 - dist((float)player.getX(), (float)player.getY(), (float)t.getX(), (float)t.getY()));
      t.unIntrude(intrusion, ptDirection);
      player.calculateCollisionSpeed(tsi, t.getMass(), ta);
      t.calculateCollisionSpeed(psi, player.getMass(), aa);
      if(t.getHealth() < 0){
        targeters.remove(t);
      }
    }
  }
  for(int i = 0; i < bullets.size(); i++){
  Bullet a = bullets.get(i);
    for(int s = 0; s < asteroids.size(); s++){
      Asteroid b = asteroids.get(s);
      if(dist((float)a.getX(), (float)a.getY(), (float)b.getX(), (float)b.getY()) <= b.getSize()){
        b.setMass(-0.25);
        bullets.remove(a);
        if(b.getHealth() < 0){
          asteroids.remove(b);
        }
        score += 5;
      }
    }
  }
}
void controlShip(){
  if(right){
    player.turn(true);
  }
  if(left){
    player.turn(false);
  }
  if(up){
    player.accelerate(true);
  }
  if(down){
    player.accelerate(false);
  }
  if(shoot){
    if(bulletTimer == 0){
      bullets.add(new Bullet(player.getX(), player.getY(), player.getDirection()));
      bulletTimer = bulletTimeLimit;
    }
    else{
      bulletTimer--;
    }
  }
}
void moveBullets(){
  for(int i = 0; i < bullets.size(); i++){
    Bullet b = bullets.get(i);
    b.move();
    b.show();
    if(b.getOutOfBounds()){
      bullets.remove(b);
    }
  }
}
void healthBar(){
  fill(150, 150, 150, 100);
  rect(0, 0, 300, 50);
  fill(255, 0, 0, 75);
  rect(0, 0, (float)player.getHealthPercentage() * 300, 50);
  if(player.getHealth() <= 0){
    menu = true;
    menuState = 2;
    writeHighScore();
  }
}
void mousePressed(){
  if(menu){
    if(menuState == 1 || menuState == 2){
      if(start.checkClick()){
        initializeObjects();
        menu = false;
      }
      if(controls.checkClick()){
        menuState = 3;
      }
      if(bClassic.checkClick()){
        shipType = 1;
        player = new Spaceship(shipType);
      }
      if(bSpeed.checkClick()){
        shipType = 2;
        player = new Spaceship(shipType);
      }
      if(bTank.checkClick()){
        shipType = 3;
        player = new Spaceship(shipType);
      }
    }
    else if(menuState == 3){
      if(exit.checkClick()){
        menuState = 1;
      }
    }
  }
  else{
    if(paused){
      if(resume.checkClick()){
        paused = false;
      }
      if(restart.checkClick()){
        paused = false;
        initializeObjects();
        writeHighScore();
      }
      if(exitGame.checkClick()){
        menu = true;
        menuState = 2;
        writeHighScore();
      }
    }
  }
}
void initializeObjects(){
  player = new Spaceship(shipType);
  asteroids = new ArrayList<Asteroid>();
  targeters = new ArrayList<Targeter>();
  targeter = new Targeter(400, 400, 0, 4, player);
  targeters.add(targeter);
  for(int i = 0; i < floaters.length; i++){
    floaters[i] = new Star(Math.random() * 1000, (Math.random() * 800) + 50);
  }
  for(int i = 0; i < numAsteroids; i++){
    Asteroid a = new Asteroid(Math.random() * 1000, (Math.random() * 800) + 50, Math.random() * 2 * PI, 15, Math.random() * 2, Math.random() * 2);
    while(dist((float)a.getX(), (float)a.getY(), (float)player.getX(), (float)player.getY()) <= 50){
      a = new Asteroid(Math.random() * width, (Math.random() * height) + 50, Math.random() * 2 * PI, 15, Math.random() * 2, Math.random() * 2);
    }
    asteroids.add(a);
  }
  score = 0;
  paused = false;
}
void trackScore(){
  scoreTimer++;
  if(scoreTimer > 5){
    scoreTimer = 0;
    score++;
  }
  if(score > highScore){
    highScore = score;
  }
  if(score == 300){
    numAsteroids += 1;
  }
  if(score == 600){
    numAsteroids += 1;
  }
  textAlign(CENTER);
  textSize(40);
  fill(#0C9CE8);
  text("Score: " + score, 500, 30);
  text(" HighScore: " + highScore, 500, 60);
}
void addAsteroid(){
  int spawnSide = (int)(Math.random() * 4);
  Asteroid a;
  if(spawnSide == 0){
    a = new Asteroid(-20, Math.random() * height, Math.random() * 2 * PI, 10, Math.random() * 2, Math.random() * 2);
  }
  else if(spawnSide == 1){
    a = new Asteroid(width + 20, Math.random() * height, Math.random() * 2 * PI, 10, Math.random() * 2, Math.random() * 2);
  }
  else if(spawnSide == 2){
    a = new Asteroid(Math.random() * width, -20, Math.random() * 2 * PI, 10, Math.random() * 2, Math.random() * 2);
  }
  else{
    a = new Asteroid(Math.random() * width, height + 20 * height, Math.random() * 2 * PI, 10, Math.random() * 2, Math.random() * 2);
  }
  asteroids.add(a);
}
void writeHighScore(){
  pw.print(highScore);
  pw.flush();
  pw.close();
}
