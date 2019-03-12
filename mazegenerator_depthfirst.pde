Graph g;

void settings() {
  int wi = S + (2 * S * W);
  int hi = S + (2 * S * H);
  size( wi, hi, P2D );
}

void setup() {
  g = new Graph( W*H );
  g.stackTopIndex = START;

  // load graph array
  for( int x = 0; x < W; x++ ){
    for( int y = 0; y < H; y++ ){
      int nodeIndex = y*W+x;
      g.nodes[nodeIndex] = new Vertex(x,y);
      if( y > 0 )   g.nodes[nodeIndex].addNeighbor((y-1) * W + x); // north
      if( x < W-1 ) g.nodes[nodeIndex].addNeighbor(y * W + (x+1)); // east
      if( y < H-1 ) g.nodes[nodeIndex].addNeighbor((y+1) * W + x); // south
      if( x > 0 )   g.nodes[nodeIndex].addNeighbor(y * W + (x-1)); // west
      g.nodes[nodeIndex].neighbors.shuffle();
    }
  }

  // Start with the first point
  g.nodes[ g.stackTopIndex ].edgeIndex = g.stackTopIndex;
  g.stack.append( g.stackTopIndex );

  background(0);
}


void draw() {
  g.update();
  g.render();

  // save this frame if recording is set
  if( RECORD ) saveFrame("output/frame-####.png");

  // keep running until the stack is empty
  if( g.stack.size() == 0 ) noLoop();
}