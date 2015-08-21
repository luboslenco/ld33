package myproject;

import lue.core.Trait;
import lue.Root;

class MazeGenerator extends Trait {

	public static var tileSize = 2;

	var maze:Array<Array<Int>>;
	var mazeWidth:Int; 
	var mazeHeight:Int;
	var posX = 1;
	var posY = 1;
	var moves:Array<Int>;

    public function new(mazeWidth = 25, mazeHeight = 25) {
        super();

        this.mazeWidth = mazeWidth;
        this.mazeHeight = mazeHeight;

        maze = [];
		for (i in 0...mazeHeight) {
			maze.push([]);
			for(j in 0...mazeWidth) {
				maze[i].push(1);
			}
		}
		
		maze[posX][posY] = 0;
		
		moves = [];
		moves.push(posY + posY * mazeWidth);

		generateMaze();

        Root.registerInit(init);
    }

    function generateMaze() {
		if (moves.length > 0) {
			var possibleDirections:Array<String> = [];
			
			if (posX + 2 > 0 && posX + 2 < mazeHeight -1 && maze[posX + 2][posY] == 1) {
				possibleDirections.push("S");
			}
			if (posX - 2 > 0 && posX - 2 < mazeHeight -1 && maze[posX - 2][posY] == 1) {
				possibleDirections.push("N");
			}
			if (posY - 2 > 0 && posY - 2 < mazeWidth - 1 && maze[posX][posY - 2] == 1) {
				possibleDirections.push("W");
			}
			if (posY + 2 > 0 && posY + 2 < mazeWidth - 1 && maze[posX][posY + 2] == 1) {
				possibleDirections.push("E");
			}
			
			if (possibleDirections.length > 0) {
				var move = Std.random(possibleDirections.length);
				switch(possibleDirections[move]) {
					case "N":
						maze[posX - 2][posY] = 0;
						maze[posX - 1][posY] = 0;
						posX-=2;
					case "S":
						maze[posX + 2][posY] = 0;
						maze[posX + 1][posY] = 0;
						posX += 2;
					case "W":
						maze[posX][posY - 2] = 0;
						maze[posX][posY - 1] = 0;
						posY -= 2;
					case "E":
						maze[posX][posY + 2] = 0;
						maze[posX][posY + 1] = 0;
						posY += 2;
				}
				moves.push(posY + posX * mazeWidth);   
			}
			else {
				var back = moves.pop();
				posX = Std.int(back / mazeWidth);
				posY = back % mazeWidth;
			}

			// Recursive
			generateMaze();
		}
	}

    function init() {
    	var scene = Root.gameScene;
		var node = scene.getNode("Cube");

		for (i in 0...mazeHeight) {
			for (j in 0...mazeWidth) {
				if (maze[i][j] == 1) {
					var o = scene.createNode(node);
					o.transform.x = getWorldX(j);
					o.transform.y = getWorldY(i);
					owner.addChild(o);
				}
			}
		}
    }

    public function isWall(x:Int, y:Int) {
    	if (x < 0 || x > mazeWidth - 1 || y < 0 || y > mazeHeight - 1) return true;
    	return maze[y][x] == 1 ? true : false;
    }

    public function getWorldX(x:Int) {
    	return x * tileSize - (mazeWidth - 1) * tileSize / 2;
    }

    public function getWorldY(y:Int) {
    	return y * tileSize - (mazeHeight - 1) * tileSize / 2;
    }
}
