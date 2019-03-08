// Config
final int SPEED = 1;
final int S = 20; // 22x22 @ 24px = 1080x1080
final int W = 22;
final int H = 22;
final color HEAD_CLR  = color(255,0,0);
final color STACK_CLR = color(102);
final color FILL_CLR  = color(255);
final Boolean RECORD  = false; // set to true to save out frames
final int START = 0;
final int GOAL  = W*H-1;

// Varaibles
Vertex[] graph = new Vertex[W * H];
IntList  stack = new IntList();
int finalFrame = -1;
int currentIndex = START;


// Vertex class for each square
class Vertex {
  int x, y, idx, edge;
  IntList neighbors = new IntList(); // list of neighbors

  Vertex( int _x, int _y ){
    // set position
    x = _x;
    y = _y;
    idx = _y * W + _x;
    edge = -1;

    // find valid neighbors
    if( y > 0 )   neighbors.append((y-1) * W + x); // north
    if( x < W-1 ) neighbors.append(y * W + (x+1)); // east
    if( y < H-1 ) neighbors.append((y+1) * W + x); // south
    if( x > 0 )   neighbors.append(y * W + (x-1)); // west

    // randomize neighbors
    neighbors.shuffle();
  }

  void show() {
    if( edge > -1 ){

      // determine vertex color
      if( idx == currentIndex && stack.size() > 0 ){
        fill( HEAD_CLR ); // highlight the current top of the stack
      }else if( stack.hasValue(idx) ){
        fill( STACK_CLR ); // still in the stack
      }else{
        fill( FILL_CLR ); // fully backtracked
      }

      int x1 = S + (S * 2 * x);
      int y1 = S + (S * 2 * y);
      rect( x1, y1, S, S );

      int x2 = S + (S * ( x + graph[edge].x ));
      int y2 = S + (S * ( y + graph[edge].y ));
      rect( x2, y2, S, S );

    }
  }
} 


void settings() {
  // Size based on width, height, and square size
  int wi = S + (2 * S * W);
  int hi = S + (2 * S * H);
  size( wi, hi, P2D );
}


void setup() {
  background(0);
  noStroke();

  // Initialize graph and edge arrays
  for( int x = 0; x < W; x++ ){
    for( int y = 0; y < H; y++ ){
      int v = y*W+x;
      graph[v] = new Vertex(x,y);
    }
  }

  // Start with the first point
  graph[START].edge = START;
  stack.append(START);

}


void update() {

  // get top of stack
  currentIndex = stack.get( stack.size() - 1 );
  Vertex v = graph[ currentIndex ];
  // pop it off the stack, we'll add it back on later if we need to
  stack.remove( stack.size() - 1 );
  
  // get all open neighbors of this vertex
  IntList openNeighbors = new IntList();
  for( int n = 0; n < v.neighbors.size(); n++ ){

    int neighborIndex = v.neighbors.get(n);

    // a neighbor is only open if it has no edge yet
    if( graph[ neighborIndex ].edge == -1 ) openNeighbors.appendUnique( neighborIndex );

  }
  

  if( currentIndex != GOAL && openNeighbors.size() > 0 ){
    
    // select random neighbor (already pre-shuffled in the vertex's neighbor intlist)
    int randomNeighborIndex =  openNeighbors.get(0);
    
    // push this vertex back on the stack, it's not done yet
    stack.append( currentIndex );
    
    // push neighbor on the stack
    stack.append( randomNeighborIndex );
    
    // mark the neighbor as coming from this vertex
    graph[ randomNeighborIndex ].edge = currentIndex;

  }

}


void draw() {

  // draw the maze
  background(0);
  for( int thisVertex = 0; thisVertex < W * H; thisVertex++ ){
    graph[thisVertex].show();
  }


  // save this frame if recording is set
  if( RECORD ){
    saveFrame("output/frame-####.png");
  }


  // keep running until the stack is empty
  for( int i = 0; i < min( SPEED, stack.size() ); i++ ){
    if( stack.size() > 0 ){
      update();
    }else{
      println("Done");
      noLoop();
    }
  }

}