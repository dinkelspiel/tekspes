import { toList } from "./gleam.mjs";

export function do_astar(grid, start, end) {
  let col = {};

  let value = grid;
  while (value.tail) {
    col[value.head[0][0] + "," + value.head[0][1]] = value.head[1];
    // console.log(col[value.head[0][0] + "," + value.head[0][1]]);
    value = value.tail;
  }

  let g = [];

  for (var y = 0; y < 28; y++) {
    g.push([]);
    for (var x = 0; x < 128; x++) {
      g[y][x] = col[x + "," + y] === undefined ? false : col[x + "," + y];
      // console.log(g[y][x]);
    }
  }

  const graph = new Graph(g);

  var start = graph.grid[0][0];
  var end = graph.grid[1][2];
  var result = astar.search(graph, start, end);
  // result is an array containing the shortest path
  var graphDiagonal = new Graph(
    [
      [1, 1, 1, 1],
      [0, 1, 1, 0],
      [0, 0, 1, 1],
    ],
    { diagonal: true },
  );

  var start = graphDiagonal.grid[0][0];
  var end = graphDiagonal.grid[1][2];
  var resultWithDiagonals = astar.search(graphDiagonal, start, end, {
    heuristic: astar.heuristics.diagonal,
  });
  // Weight can easily be added by increasing the values within the graph, and where 0 is infinite (a wall)
  var graphWithWeight = new Graph([
    [1, 1, 2, 30],
    [0, 4, 1.3, 0],
    [0, 0, 5, 1],
  ]);
  var startWithWeight = graphWithWeight.grid[0][0];
  var endWithWeight = graphWithWeight.grid[1][2];
  var resultWithWeight = astar.search(
    graphWithWeight,
    startWithWeight,
    endWithWeight,
  );
  //
}

// Example Usage
// const grid = [
//   [1, 1, 1, 1],
//   [1, 0, 0, 1],
//   [1, 1, 1, 1],
//   [1, 1, 0, 1],
// ];

// const start = [0, 0];
// const end = [3, 3];
// console.log(aStar(grid, start, end));
