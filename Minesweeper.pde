import de.bezier.guido.*;

//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private int NUM_ROWS = 20;
private int NUM_COLS = 20;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup(){
  size(400, 400);
  textAlign(CENTER,CENTER);
    
  // make the manager
  Interactive.make(this);
    
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
    
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }

  setMines();
}

public void setMines(){
  int NUM_MINES = 0;
  while (NUM_MINES < 30){
    int r = (int)(Math.random() * NUM_ROWS); 
    int c = (int)(Math.random() * NUM_COLS);
    
    if (!(mines.contains(buttons[r][c]))){
      mines.add(buttons[r][c]);
      System.out.println(r + ", " + c);
    }
    
    NUM_MINES++;
  }
}

public void draw (){
  background(0);
  
  if(isWon() == true){
    displayWinningMessage();
  }
}

public boolean isWon(){
  for(int i = 0; i < NUM_ROWS; i++){
    for(int j = 0; j < NUM_COLS; j++){
      if(!buttons[i][j].isClicked() && !mines.contains(buttons[i][j])){
        return false;
      } 
    }
  }
  return true;
}


public void displayLosingMessage(){
  for (int i = 0; i < NUM_ROWS; i++){
    for (int j = 0; j < NUM_COLS; j++){
      textSize(7);
      buttons[i][j].setLabel(">O<");
    }
  }
}

public void displayWinningMessage(){
  for (int i = 0; i < NUM_ROWS; i++){
    for (int j = 0; j < NUM_COLS; j++){
      textSize(7);
      buttons[i][j].setLabel(">U<");
    }
  }
}

public boolean isValid(int r, int c){
  if ((r >= 0) && (r < NUM_ROWS) && (c >= 0) && (c < NUM_COLS)) {
    return true;
  } else {
    return false;
  }
}

public int countMines(int row, int col){
  int numMines = 0;
  
  if ((isValid(row + 1, col - 1) == true) && (mines.contains(buttons[row + 1][col - 1]))) {
    numMines++;
  } 
  
  if ((isValid(row + 1, col) == true) && (mines.contains(buttons[row + 1][col]))) {
    numMines++;
  } 
  
  if ((isValid(row + 1, col + 1) == true) && (mines.contains(buttons[row + 1][col + 1]))) {
    numMines++;
  } 
  
  if ((isValid(row - 1, col) == true) && (mines.contains(buttons[row - 1][col]))) {
    numMines++;
  } 
  
  if ((isValid(row, col + 1) == true) && (mines.contains(buttons[row][col + 1]))) {
    numMines++;
  } 
  
  if ((isValid(row - 1, col - 1) == true) && (mines.contains(buttons[row - 1][col - 1]))) {
    numMines++;
  } 
  
  if ((isValid(row, col - 1) == true) && (mines.contains(buttons[row][col - 1]))) {
    numMines++;
  } 
  
  if ((isValid(row - 1, col + 1) == true) && (mines.contains(buttons[row - 1][col + 1]))) {
    numMines++;
  } 
  
  return numMines;
}

public class MSButton{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
    
  public MSButton (int row, int col){
    width = 400 / NUM_COLS;
    height = 400 / NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol * width;
    y = myRow * height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add(this); // register it with the manager
  }

  // called by manager
  public void mousePressed(){
    clicked = true;
    
    if (mouseButton == RIGHT) {
      if (flagged == true){
        flagged = clicked = false;
      } else {
        flagged = clicked = true;
      }
    } else if (mines.contains(buttons[myRow][myCol])) {
      for (int i = 0; i < mines.size(); i++){
         MSButton mine = mines.get(i);
         mine.drawMine();
      }
    
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      
      revealNeighbors(myRow + 1, myCol - 1);
      revealNeighbors(myRow + 1, myCol);
      revealNeighbors(myRow + 1, myCol + 1);
      revealNeighbors(myRow, myCol - 1);
      revealNeighbors(myRow, myCol + 1);
      revealNeighbors(myRow - 1, myCol - 1);
      revealNeighbors(myRow - 1, myCol);
      revealNeighbors(myRow - 1, myCol + 1);
    }
  }
  
  private void revealNeighbors(int row, int col) {
    if (isValid(row, col) && !buttons[row][col].clicked) {
      buttons[row][col].mousePressed();
    }
  }
    
  public void draw(){    
    if (flagged){
      fill(0);
    } else if(clicked && mines.contains(this)){ 
      fill(255,0,0);
    } else if(clicked){
      fill(0, 100, 100); 
    } else{ 
      fill(170, 200, 150); 
    }
    
    rect(x, y, width, height);
    fill(0);
    text(myLabel, x + width / 2, y + height / 2);
  }
    
  public void setLabel(String newLabel){
    myLabel = newLabel;
  }
    
  public void setLabel(int newLabel){
    myLabel = ""+ newLabel;
  }
    
  public boolean isFlagged(){
    return flagged;
  }
  
  public boolean isClicked() {
    return clicked;
  }
  
  public void drawMine() {
    fill(255, 0, 0); 
    rect(x, y, width, height);
    clicked = true; 
  }
}
