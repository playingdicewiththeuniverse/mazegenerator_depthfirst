class Vertex {
  int x, y, edgeIndex;
  IntList neighbors;

  Vertex( int _x, int _y ){
    this.x = _x;
    this.y = _y;
    this.edgeIndex = -1;
    this.neighbors = new IntList();
  }

  void addNeighbor( int i ){
    this.neighbors.appendUnique( i );
  }
  
}
