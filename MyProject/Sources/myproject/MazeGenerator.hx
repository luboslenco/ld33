package myproject;

import lue.core.Trait;
import lue.core.Object;
import lue.Root;
import lue.sys.importer.SceneFormat;
import myproject.FloorsData;

class MazeGenerator extends Trait {

	static var currentFloor = 0;

	public static inline var tileSize = 2;

	public static inline var TILE_EMPTY = 0;
	public static inline var TILE_WALL = 1;
	public static inline var TILE_STAIRS = 2;
	public static inline var TILE_STAIRS_DOWN = 3;

	public static inline var THING_LEVER = 0;
	public static inline var THING_GATE = 1;
	public static inline var THING_HAMMER = 2;
	public static inline var THING_SPIKE = 3;
	public static inline var THING_MOVER = 4;
	public static inline var THING_GUN = 5;

	var cam:StepCamera;

	public var floor:Floor;
	var maze:Array<Array<Int>>;
	var mazeDirs:Array<Array<Int>>;
	var mazeWidth:Int; 
	var mazeHeight:Int;
	var things:Array<Thing>;

    static var firstInstance = true;
    public static var inst:MazeGenerator = null;

    public var gameOver = false;

    static var editorFloor:Floor = null;
    public static var godMode = true;

    public function new() {
        super();

        inst = this;

        floor = editorFloor == null ? FloorsData.getFloor(currentFloor) : editorFloor;
        maze = floor.data;
        mazeDirs = floor.dirs;
        mazeWidth =  maze[0].length;
        mazeHeight = maze.length;
        things = floor.things;

        Root.registerInit(init);

        if (firstInstance) {
            firstInstance = false;

            //if (lue.sys.Storage.getValue(S.StorageVersion) != STORAGE_VERSION) {
                createStorage();
            //}
            lue.sys.Audio.musicOn = lue.sys.Storage.getValue(S.MusicOn);
            lue.sys.Audio.soundOn = lue.sys.Storage.getValue(S.SoundOn);

            lue.sys.Audio.playMusic("music");
        }
    }

    var cube2Node:TNode;
    function init() {
    	cam = Root.getChild("Camera").getTrait(StepCamera);

    	var scene = Root.gameScene;
		var nodes:Array<TNode> = [];
		nodes.push(scene.getNode("Floor"));
		var ceilNodes = [scene.getNode("Ceil"), scene.getNode("Ceil2"), scene.getNode("Ceil3")];
		nodes.push(scene.getNode("Cube"));
        cube2Node = scene.getNode("Cube2");
		nodes.push(scene.getNode("Stairs"));
		nodes.push(scene.getNode("StairsDown"));

		var thingNodes:Array<TNode> = [];
		thingNodes.push(scene.getNode("Lever"));
		thingNodes.push(scene.getNode("Gate"));
		thingNodes.push(scene.getNode("Hammer"));
		thingNodes.push(scene.getNode("Spike"));
		thingNodes.push(scene.getNode("Mover"));
		thingNodes.push(scene.getNode("Gun"));

		// Tiles
		for (i in 0...mazeHeight) {
			for (j in 0...mazeWidth) {
				var m = maze[i][j];
				placeNode(nodes, m, i, j);
				// Ceiling
				if (m == TILE_EMPTY || m == TILE_STAIRS_DOWN) {
					placeNode(ceilNodes, 0, i, j, true);
				}
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
			initThing(t);
			//owner.addChild(o);
		}

        // UI
        var uio = new Object();
        uio.addTrait(new UIRenderer());
        Root.addChild(uio);

        // Floor text
        if (editorFloor == null) {
            var cf = lue.sys.Storage.getValue(S.CurrentFloor);
            if (currentFloor == 0) {
                var ft = new IntroTextRenderer();
                var fto = new Object();
                fto.addTrait(ft);
                Root.addChild(fto);
            }
            else if ((currentFloor <= 6 || currentFloor == 11) && cf < currentFloor) {
                var ft = new FloorTextRenderer(currentFloor);
                var fto = new Object();
                fto.addTrait(ft);
                Root.addChild(fto);
            }
            lue.sys.Storage.setValue(S.CurrentFloor, currentFloor);
        }
    }

    function placeNode(nodes:Array<TNode>, nodePos:Int, i:Int, j:Int, ceiling = false) {
    	var scene = Root.gameScene;

        var node = nodes[nodePos];
        //if (!ceiling && nodePos == 1 && Std.random(2) == 0) node = cube2Node;
    	var o = scene.createNode(node);
		o.transform.x = getWorldX(j);
		o.transform.y = getWorldY(i);

		var md = mazeDirs[i][j];
		if (md != 0) {
			o.transform.rotateZ(lue.math.Math.degToRad(md * 90));
		}

		//owner.addChild(o);
    }

    public function isWall(x:Int, y:Int) {
    	if (x < 0 || x > mazeWidth - 1 || y < 0 || y > mazeHeight - 1) return true;
    	return maze[y][x] == TILE_WALL ? true : false;
    }

    public function isStairs(x:Int, y:Int) {
    	if (x < 0 || x > mazeWidth - 1 || y < 0 || y > mazeHeight - 1) return false;
    	return maze[y][x] == TILE_STAIRS ? true : false;
    }

    public function isStairsDown(x:Int, y:Int) {
    	if (x < 0 || x > mazeWidth - 1 || y < 0 || y > mazeHeight - 1) return false;
    	return maze[y][x] == TILE_STAIRS_DOWN ? true : false;
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

    public static function previousFloor() {
    	currentFloor--;
    }

    public static function setFloor(i:Int) {
        currentFloor = i;
    }

    public function getThingById(id:Int):Thing {
    	for (t in things) {
    		if (t.id == id) return t;
    	}
    	return null;
    }

    public function leverAction(t:Thing) {
        lue.sys.Audio.playSound("lever");
        // Open
        if (t.state == 0) {
            t.state = 1;
            motion.Actuate.tween(t.object.transform, 0.2, {z: -0.5});
        }
        // Close
        else {
            t.state = 0;
            motion.Actuate.tween(t.object.transform, 0.2, {z: 0});
        }
    }

    public function gateAction(t:Thing) {
    	// Open
    	if (t.state == 0) {
    		t.state = 1;
    		motion.Actuate.tween(t.object.transform, 0.2, {z: 1.8});
    	}
    	// Close
    	else {
    		t.state = 0;
    		motion.Actuate.tween(t.object.transform, 0.2, {z: 0});
    	}
    }

    public function moveThings() {
    	for (t in things) {
    		// Hammers
    		if (t.type == THING_HAMMER) {
    			t.i++;
    			if (t.i >= t.rate) {
    				t.i = 0;
	    			// Move up
	    			if (t.state == 0) {
	    				t.state = 1;
	    				motion.Actuate.tween(t.object.transform, 0.2, {z: 1.8});
	    			}
	    			// Move down
	    			else {
	    				t.state = 0;
	    				motion.Actuate.tween(t.object.transform, 0.2, {z: 0});
	    				// Check player
	    				if (t.x == cam.posX && t.y == cam.posY) {
	    					die();
	    				}
	    			}
	    		}
    		}
    		// Spikes
    		else if (t.type == THING_SPIKE) {
    			t.i++;
    			if (t.i >= t.rate) {
    				t.i = 0;
    				// Hit
    				var originZ = t.object.transform.z;
    				motion.Actuate.tween(t.object.transform, 0.1, {z: 0}).onComplete(function() {
    					motion.Actuate.tween(t.object.transform, 0.1, {z: originZ});
    				});
    				// Check player
    				if (t.x == cam.posX && t.y == cam.posY) {
    					die();
    				}
    			}
    		}
    		// Movers
    		else if (t.type == THING_MOVER) {
    			// Set state when wall is hit
    			if (t.state == 0 && isWall(t.x + 1, t.y)) { t.state = 1; }
    			else if (t.state == 1 && isWall(t.x - 1, t.y)) { t.state = 0; }
    			// Move
    			if (t.state == 0) { t.x++; }
    			else if (t.state == 1) { t.x--; }
    			motion.Actuate.tween(t.object.transform, 0.2, {x: getWorldX(t.x)});
    			// Check player
    			if (t.x == cam.posX && t.y == cam.posY) {
    				die();
    			}
    		}
    		// Guns
    		else if (t.type == THING_GUN) {
    			t.i++;
    			if (t.i >= t.rate) {
    				t.i = 0;
    				// Move
    				if (t.x == 0) t.x = mazeWidth - 1;
    				else t.x = 0;
    				motion.Actuate.tween(t.object.transform, 0.2, {x: getWorldX(t.x)});
    				// Check player
    				if (t.y == cam.posY) {
    					die();
    				}
    			}
    		}
    	}
    }

    function initThing(t:Thing) {
    	if (t.type == THING_GATE || t.type == THING_HAMMER) {
    		if (t.state == 1) {
    			t.object.transform.z = 1.8;
    		}
    	}
    	else if (t.type == THING_SPIKE) {
    		t.object.transform.z = -0.8;
    	}
    }

    function die() {
        if (godMode) return;

        lue.sys.Audio.playSound("die");
        reset();
    }

    public function reset(floor:Floor = null) {
        editorFloor = floor;

        gameOver = true;
    	var trans = new lue.trait2d.effect.TransitionTrait(lue.Root.gameData.scene, 0.3);
		var o = new Object();
		o.addTrait(trans);
		Root.addChild(o);
    }

    static inline var STORAGE_VERSION = 1;
    function createStorage() {
        lue.sys.Storage.setValue(S.MusicOn, true);
        lue.sys.Storage.setValue(S.SoundOn, true);
        lue.sys.Storage.setValue(S.CurrentFloor, 0);
    }
}
