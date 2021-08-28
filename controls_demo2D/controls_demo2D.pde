// Intialise gains to be zeros 
float kp = 0.0; 
float ki = 0.0; 
float kd = 0.0; 

// Initialise other variables used in code
float errx = 0; 
float cum_errx = 0; 
float err_lastx = 0; 
float delta_errx = 0; 
float erry = 0; 
float cum_erry = 0; 
float err_lasty = 0; 
float delta_erry = 0; 


float actualx = width/2;
float actualy = height/2;
PFont f;
color b = #3C03FF;
color r = #F55719;


// Array list of dots for the leader and follower 
ArrayList<Point> points_lead;  // controlled by mouse
ArrayList<Point> points_follow; // controlled by PID 


// Set up the sketch
void setup() {
  size(600,800); 
  background(0); 
  frameRate(60); 
  f = createFont("Arial",16,true);
  points_follow = new ArrayList<Point>(); 
  points_lead = new ArrayList<Point>(); 
}


// Begin drawing function
void draw() {
  // Colour the follow ball green if its close to the target
  color ball_col = #F55719; 
  if(abs(actualy - mouseY) < 2 && mouseY > 5){
    ball_col = #7CDB86;
  }
  
  
// Don't allow negative gains 
  if(kp <= 0) kp = 0; 
  if(kd <= 0) kd = 0; 
  if(ki <= 0) ki = 0; 
  
  
// PID control for follow ball
  erry = mouseY - actualy;
  cum_erry += erry;
  delta_erry = erry - err_lasty;
  err_lasty = erry;
  actualy = (kp)*erry + (ki)*cum_erry + (kd)*delta_erry + height/2; 
  
  errx = mouseX - actualx;
  cum_errx += errx;
  delta_errx = errx - err_lastx;
  err_lastx = errx;
  actualx = (kp)*errx + (ki)*cum_errx + (kd)*delta_errx + width/2; 
  
  
// Actually draw things now  
  background(0); 
  fill(75,75,255); 
  stroke(255);
  //line(0,mouseY, width, mouseY); 
  //line(mouseX,0, mouseX, height); 
  noStroke(); 
  circle(mouseX, mouseY, 20);
  
  
  fill(ball_col); 
  circle(actualx, actualy, 20);
  points_follow.add(new Point(actualx, actualy, r)); 
  points_lead.add(new Point(mouseX, mouseY, b)); 
  
  
 // code to display two sets of tracer dots 
 
  
 for (int i = 0; i < points_lead.size()-1; i++){
    Point p = points_lead.get(i); 
    p.display(); 
    p.move();
    if(p.is_dead() == true) points_lead.remove(i); 
  }
  
     for (int i = 0; i < points_follow.size()-1; i++){
    Point p = points_follow.get(i); 
    p.display(); 
    p.move();
    if(p.is_dead() == true) points_follow.remove(i); 
  }

  
  // Print some text
  fill(255);
  textFont(f,16);  
  text("Kp = " + str(kp), 500, 700); 
  text("Ki =  " + str(ki), 500, 720); 
  text("Kd = " + str(kd), 500, 740); 
  text("Pess p/o, i/u, d/s to change gains", 200, height - 20); 

}


// Code to allow interaction with gians 
void keyPressed() {
  if(key == 'p') kp += 0.05;
  if(key == 'o') kp -= 0.05;
  if(key == 'i') ki += 0.05;
  if(key == 'u') ki -= 0.05;
  if(key == 'd') kd += 0.05;
  if(key == 's') kd -= 0.05;
}
  
