// Config
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


// Vertex class for each square
class Vertex {
  int x, y; // position of the vertex  
  int edge; // edge, if any this node is best connected from
  IntList neighbors = new IntList(); // list of neighbors

  Vertex( int _x, int _y ){
    // set position
    x = _x;
    y = _y;
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
    rect( S + x * S * 2, S + y * S * 2, S, S );
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


void draw() {

  background(0);
  
  // draw the maze
  for( int thisVertex = 0; thisVertex < W * H; thisVertex++ ){
    
    if( graph[thisVertex].edge > -1 ){
      if( stack.hasValue( thisVertex ) ){
        fill( STACK_CLR ); // still in the stack
      }else{
        fill( FILL_CLR ); // fully backtracked
      }
      Vertex v1 = graph[thisVertex];
      Vertex v2 = graph[v1.edge];
      // draw an edge between both vertexes
      int x = S + (S * (v1.x + v2.x));
      int y = S + (S * (v1.y + v2.y));
      v1.show();
      rect( x, y, S, S );
    }
  }

  if( stack.size() > 0 ){
    
    // get top of stack
    int currentIndex = stack.get( stack.size() - 1 );

    // show the current top of the stack
    fill( HEAD_CLR );
    graph[currentIndex].show();
    
    // pop it off the stack, we'll add it back on later if we need to
    stack.remove( stack.size() - 1 );
    
    // get all open neighbors of this vertex
    IntList openNeighbors = new IntList();
    for( int n = 0; n < graph[currentIndex].neighbors.size(); n++ ){
      if( graph[graph[currentIndex].neighbors.get(n)].edge == -1 ){
        int neighborIndex = graph[currentIndex].neighbors.get(n);
        openNeighbors.appendUnique( neighborIndex );
      }
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

  }else if( finalFrame == -1 ){

    // no more stack, make the sketch end 60 frames from now
    finalFrame = frameCount + 60;

  }
  
  if( finalFrame == -1 || ( finalFrame > -1 && frameCount < finalFrame ) ){

    // output this frame if option is chosen and we're still running
    if( RECORD ) saveFrame("output/frame-####.png");

  }else{

    // later, jerks
    println("Done");
    noLoop();

  }
}