// Graph class contains a set of vertices
class Graph {
  int size, stackTopIndex;
  Vertex[] nodes;
  IntList stack;
  

  Graph( int _size ) {
    this.size = _size;
    this.nodes = new Vertex[ _size ];
    this.stack = new IntList();
  }


  IntList getOpenNeighbors( int thisNodeIndex ){
    IntList openNeighbors = new IntList();
    for( int n = 0; n < this.nodes[ thisNodeIndex ].neighbors.size(); n++ ){
      int neighborNodeIndex = this.nodes[ thisNodeIndex ].neighbors.get(n);
      if( this.nodes[ neighborNodeIndex ].edgeIndex == -1 ){
        // a neighbor is only open if it has no edgeIndex yet
        openNeighbors.appendUnique( neighborNodeIndex );
      }
    }
    return openNeighbors;
  }


  void update() {

    // get top of stack
    stackTopIndex = this.stack.get( this.stack.size() - 1 );
    Vertex thisVertex = this.nodes[ stackTopIndex ];
    
    // pop it off the stack, we'll add it back on later if we need to
    this.stack.remove( this.stack.size() - 1 );
    
    // get all open neighbors of this vertex
    IntList openNeighbors = getOpenNeighbors( stackTopIndex );  

    if( stackTopIndex != GOAL && openNeighbors.size() > 0 ){
      
      // select random neighbor (already pre-shuffled in the vertex's neighbor intlist)
      int randomNeighborIndex =  openNeighbors.get(0);
      
      // push this vertex back on the stack, it's not done yet
      this.stack.append( stackTopIndex );
      
      // push neighbor on the stack
      this.stack.append( randomNeighborIndex );
      
      // mark the neighbor as coming from this vertex
      this.nodes[ randomNeighborIndex ].edgeIndex = g.stackTopIndex;

    }
  }
  

  void render() {
    
    noStroke();
    background(0);
    
    for( int i = 0; i < size; i++ ){
      Vertex node = this.nodes[i];

      if( node.edgeIndex > -1 ){
        
        if( stackTopIndex == i && this.stack.size() > 0 ){
          fill( HEAD_CLR );  // this node is the top of the stack
        }else if( this.stack.hasValue(i) ){
          fill( OPEN_CLR ); // this node is still in the stack
        }else {
          fill( FILL_CLR );  // this node's path has been determined
        }

        // draw vertex
        int x1 = S + (S * 2 * node.x);
        int y1 = S + (S * 2 * node.y);
        rect( x1, y1, S, S );

        // draw edge
        int x2 = S + (S * ( node.x + this.nodes[ node.edgeIndex ].x ));
        int y2 = S + (S * ( node.y + this.nodes[ node.edgeIndex ].y ));
        rect( x2, y2, S, S );
      }
    }
  
  }

}