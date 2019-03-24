Graph g;

int index( int x, int y ){
  return y * W + x;
}

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
      if( y > 0 )   g.nodes[nodeIndex].addNeighbor( index(x, y-1) ); // north
      if( x < W-1 ) g.nodes[nodeIndex].addNeighbor( index(x+1, y) ); // east
      if( y < H-1 ) g.nodes[nodeIndex].addNeighbor( index(x, y+1) ); // south
      if( x > 0 )   g.nodes[nodeIndex].addNeighbor( index(x-1, y) ); // west
      g.nodes[nodeIndex].neighbors.shuffle();
    }
  }

  // Start with the first point
  g.nodes[ g.stackTopIndex ].edgeIndex = g.stackTopIndex;
  g.stack.append( g.stackTopIndex );
  waterMark(W-5,H-5);
  background(0);
}


void draw() {
  g.update();
  g.render();
  if( RECORD ) saveFrame("output/frame-####.png");
  if( g.finalFrame <= frameCount ){
    noLoop();
    println("Done");
  }
}


void waterMark( int x, int y ) {
  // places a PDWTU watermark in the maze
  g.nodes[ index( x+2, y+2 ) ].edgeIndex = index( x+3, y+2 );
  g.nodes[ index( x+3, y+2 ) ].edgeIndex = index( x+4, y+2 );
  g.nodes[ index( x+4, y+2 ) ].edgeIndex = index( x+3, y+2 );
  g.nodes[ index( x+3, y+3 ) ].edgeIndex = index( x+3, y+2 );
  g.nodes[ index( x+2, y+3 ) ].edgeIndex = index( x+2, y+4 );
  g.nodes[ index( x+2, y+4 ) ].edgeIndex = index( x+3, y+4 );
  g.nodes[ index( x+3, y+4 ) ].edgeIndex = index( x+4, y+4 );
  g.nodes[ index( x+4, y+4 ) ].edgeIndex = index( x+4, y+3 );
  g.nodes[ index( x+4, y+3 ) ].edgeIndex = index( x+4, y+4 );
  g.nodes[ index( x+2, y+0 ) ].edgeIndex = index( x+2, y+1 );
  g.nodes[ index( x+2, y+1 ) ].edgeIndex = index( x+3, y+1 );
  g.nodes[ index( x+3, y+1 ) ].edgeIndex = index( x+4, y+1 );
  g.nodes[ index( x+4, y+1 ) ].edgeIndex = index( x+4, y+0 );
  g.nodes[ index( x+4, y+0 ) ].edgeIndex = index( x+4, y+1 );
  g.nodes[ index( x+3, y+0 ) ].edgeIndex = index( x+3, y+1 );
  g.nodes[ index( x+0, y+2 ) ].edgeIndex = index( x+0, y+1 );
  g.nodes[ index( x+0, y+1 ) ].edgeIndex = index( x+0, y+0 );
  g.nodes[ index( x+0, y+0 ) ].edgeIndex = index( x+1, y+0 );
  g.nodes[ index( x+1, y+0 ) ].edgeIndex = index( x+1, y+1 );
  g.nodes[ index( x+1, y+1 ) ].edgeIndex = index( x+0, y+1 );
  g.nodes[ index( x+1, y+2 ) ].edgeIndex = index( x+1, y+3 );
  g.nodes[ index( x+1, y+3 ) ].edgeIndex = index( x+1, y+4 );
  g.nodes[ index( x+1, y+4 ) ].edgeIndex = index( x+0, y+4 );
  g.nodes[ index( x+0, y+4 ) ].edgeIndex = index( x+0, y+3 );
  g.nodes[ index( x+0, y+3 ) ].edgeIndex = index( x+1, y+3 );
}