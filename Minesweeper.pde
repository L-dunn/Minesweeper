import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public static final int NUM_ROWS = 5;
public static final int NUM_COLS = 5;
public static final int NUM_MINES = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(800, 800);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    int minesSet = 0;
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i, j);
      }
    }
    
    setMines();
}
public void setMines()
{
  for(int i = 0; i < NUM_MINES; i++){
      int randRow = (int)(Math.random()*NUM_ROWS);
      int randCol = (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[randRow][randCol])){
        mines.add(buttons[randRow][randCol]);
        System.out.println("(" + randRow + ", " + randCol + ")");
      }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  for(int i = 0; i < mines.size(); i++){
    if(!mines.get(i).clicked){
      return false;
    }
  }
  for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        if(buttons[i][j].clicked == false){
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    System.out.println("u lost");
    for(int i = 0; i < mines.size(); i++){
      fill(200);
    }
    noLoop();
}
public void displayWinningMessage()
{
    System.out.println("u won");
    noLoop();
}
public boolean isValid(int r, int c)
{
    if((r >=0 && r < NUM_ROWS)&&(c >= 0 && c < NUM_COLS)){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //top 3 neighbors
    if(isValid(row-1, col-1) && mines.contains(buttons[row-1][col-1])){
      numMines++;
    }
    if(isValid(row-1, col) && mines.contains(buttons[row-1][col])){
      numMines++;
    }
    if(isValid(row-1, col+1) && mines.contains(buttons[row-1][col+1])){
      numMines++;
    }
    
    //left and right neighbor
    if(isValid(row, col-1) && mines.contains(buttons[row][col-1])){
      numMines++;
    }
    if(isValid(row, col+1) && mines.contains(buttons[row][col+1])){
      numMines++;
    }
    
    //bottom 3 neighbors
    if(isValid(row+1, col-1) && mines.contains(buttons[row+1][col-1])){
      numMines++;
    }
    if(isValid(row+1, col) && mines.contains(buttons[row+1][col])){
      numMines++;
    }
    if(isValid(row+1, col+1) && mines.contains(buttons[row+1][col+1])){
      numMines++;
    } 
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          if(flagged == false){
            clicked = false;
          }
        }else if (mines.contains(buttons[myRow][myCol])){
          displayLosingMessage();
        }else if(countMines(myRow, myCol) > 0){
          setLabel(countMines(myRow, myCol)+"");
        }else{
          //top 3 neighbors
          if(isValid(myRow-1, myCol-1) && !buttons[myRow-1][myCol-1].clicked){
            buttons[myRow-1][myCol-1].mousePressed();
          }
          if(isValid(myRow-1, myCol) && !buttons[myRow-1][myCol].clicked){
            buttons[myRow-1][myCol].mousePressed();
          }
          if(isValid(myRow-1, myCol+1) && !buttons[myRow-1][myCol+1].clicked){
            buttons[myRow-1][myCol+1].mousePressed();
          }
          
          //left and right neighbor
          if(isValid(myRow, myCol-1) && !buttons[myRow][myCol-1].clicked){
            buttons[myRow][myCol-1].mousePressed();
          }
          if(isValid(myRow, myCol+1) && !buttons[myRow][myCol+1].clicked){
            buttons[myRow][myCol+1].mousePressed();
          }
          
          //bottom 3 neighbors
          if(isValid(myRow+1, myCol-1) && !buttons[myRow+1][myCol-1].clicked){
            buttons[myRow+1][myCol-1].mousePressed();
          }
          if(isValid(myRow+1, myCol) && !buttons[myRow+1][myCol].clicked){
            buttons[myRow+1][myCol].mousePressed();
          }
          if(isValid(myRow+1, myCol+1) && !buttons[myRow+1][myCol+1].clicked){
            buttons[myRow+1][myCol+1].mousePressed();
          }
        }
 
    }
    public void draw () 
    {    
        if (flagged)
            fill(0, 255, 0);
       else if( clicked && mines.contains(this) ) 
           fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
