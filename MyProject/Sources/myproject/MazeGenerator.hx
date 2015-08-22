package myproject;

import lue.core.Trait;
import lue.Root;
import lue.sys.importer.SceneFormat;
import myproject.FloorsData;

class MazeGenerator extends Trait {

	static var currentFloor = 1;

	public static inline var tileSize = 2;

	public static inline var TILE_EMPTY = 0;
	public static inline var TILE_WALL = 1;
	public static inline var TILE_STAIRS = 2;

	public static inline var THING_LEVER = 0;
	public static inline var THING_GATE = 1;

	public var floor:Floor;
	var maze:Array<Array<Int>>;
	var mazeDirs:Array<Array<Int>>;
	var mazeWidth:Int; 
	var mazeHeight:Int;
	var things:Array<Thing>;

    public function new() {
        super();

        floor = FloorsData.getFloor(currentFloor);
        maze = floor.data;
        mazeDirs = floor.dirs;
        mazeWidth =  maze[0].length;
        mazeHeight = maze.length;
        things = floor.things;

        Root.registerInit(init);
    }

    function init() {
    	var scene = Root.gameScene;
		var nodes:Array<TNode> = [];
		nodes.push(scene.getNode("Floor"));
		nodes.push(scene.getNode("Cube"));
		nodes.push(scene.getNode("Stairs"));

		var thingNodes:Array<TNode> = [];
		thingNodes.push(scene.getNode("Lever"));
		thingNodes.push(scene.getNode("Gate"));

		// Tiles
		for (i in 0...mazeHeight) {
			for (j in 0...mazeWidth) {
				var m = maze[i][j];
				var o = scene.createNode(nodes[m]);
				o.transform.x = getWorldX(j);
				o.transform.y = getWorldY(i);

				var md = mazeDirs[i][j];
				if (md != 0) {
					o.transform.rotateZ(lue.math.Math.degToRad(md * 90));
				}

				owner.addChild(o);
			}
		}

		// Things
		for (t in things) {
			var o = scene.createNode(thingNodes[t.type]);
			o.transform.x = getWorldX(t.x);
			o.transform.y = getWorldY(t.y);

			if (t.dir != 0) {
				o.transform.rotateZ(lue.math.Math.degToRad(t.dir * 90));
			}

			t.object = o;
			owner.addChild(o);
		}
    }

    public function isWall(x:Int, y:Int) {
    	if (x < 0 || x > mazeWidth - 1 || y < 0 || y > mazeHeight - 1) return true;
    	return maze[y][x] == TILE_WALL ? true : false;
    }

    public function isStairs(x:Int, y:Int) {
    	if (x < 0 || x > mazeWidth - 1 || y < 0 || y > mazeHeight - 1) return false;
    	return maze[y][x] == TILE_STAIRS ? true : false;
    }

    public function getWorldX(x:Int) {
    	return x * tileSize - (mazeWidth - 1) * tileSize / 2;
    }

    public function getWorldY(y:Int) {
    	return y * tileSize - (mazeHeight - 1) * tileSize / 2;
    }

    public static function nextFloor() {
    	currentFloor++;
    }

    public function getThingById(id:Int):Thing {
    	for (t in things) {
    		if (t.id == id) return t;
    	}
    	return null;
    }

    public function gateAction(t:Thing) {
    	// Open
    	if (t.state == 0) {
    		t.state = 1;
    		t.object.transform.z = 1.8;
    	}
    	// Close
    	else {
    		t.state = 0;
    		t.object.transform.z = 0;
    	}
    }
}
