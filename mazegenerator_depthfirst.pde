// Config
final int S = 24; // 22x22 @ 24px = 1080x1080
final int W = 22;
final int H = 22;
final color HEAD_CLR  = color(255,0,0);
final color STACK_CLR = color(102);
final color FILL_CLR  = color(255);
final Boolean RECORD  = true; // set to true to save out frames
final int START = 0;
final int GOAL  = W*H-1;

// Varaibles
Vertex[] graph = new Vertex[W * H];
int[]    edges = new int[W * H];
IntList  stack = new IntList();
int finalFrame = -1;


// Vertex class for each square
class Vertex {
  int x, y;
  IntList neighbors = new IntList();
  Vertex( int _x, int _y ){
    x = _x;
    y = _y;
    if( y > 0 )   neighbors.append((y-1) * W + x); // north
    if( x < W-1 ) neighbors.append(y * W + (x+1)); // east
    if( y < H-1 ) neighbors.append((y+1) * W + x); // south
    if( x > 0 )   neighbors.append(y * W + (x-1)); // west
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
      edges[v] = -1;
    }
  }

  // Start with the first point
  edges[START] = START;
  stack.append(START);

}


void draw() {

  background(0);
  
  // draw the maze
  for( int thisVertex = 0; thisVertex < W * H; thisVertex++ ){
    
    if( edges[thisVertex] > -1 ){
      if( stack.hasValue( thisVertex ) ){
        fill( STACK_CLR ); // still in the stack
      }else{
        fill( FILL_CLR ); // fully backtracked
      }
      Vertex v1 = graph[thisVertex];
      Vertex v2 = graph[edges[thisVertex]];
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
      if( edges[graph[currentIndex].neighbors.get(n)] == -1 ){
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
      edges[ randomNeighborIndex ] = currentIndex;

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