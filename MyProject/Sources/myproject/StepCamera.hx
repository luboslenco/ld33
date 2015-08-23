package myproject;

import kha.Key;
import kha.input.Keyboard;
import lue.core.Trait;
import lue.core.IUpdateable;
import lue.trait.camera.Camera;
import lue.trait.Transform;
import lue.Root;

class StepCamera extends Trait implements IUpdateable {

	@inject
	var camera:Camera;

	@inject
	var transform:Transform;

	var maze:MazeGenerator;

	public var posX:Int;
	public var posY:Int;
	var dir:Int;

	var rotCurrent = 0.0;
	var posCurrent = 0.0;
	var strafeCurrent = 0.0;
	var liftCurrent = 0.0;
	var rotLast = 0.0;
	var posLast = 0.0;
	var strafeLast = 0.0;
	var liftLast = 0.0;
	var moveComplete = true;

	var moveForward = false;
    var moveBackward = false;
    var strafeLeft = false;
    var strafeRight = false;
    var turnLeft = false;
    var turnRight = false;

    public function new() {
        super();

        Keyboard.get().notify(onKeyDown, onKeyUp);
        Root.registerInit(init);
    }

    function init() {
    	maze = Root.getChild("Maze").getTrait(MazeGenerator);
    	posX = maze.floor.startX;
    	posY = maze.floor.startY;
    	dir = maze.floor.startDir;

    	// Set camera position
    	camera.transform.x = maze.getWorldX(posX);
    	camera.transform.y = maze.getWorldY(posY);
    	if (dir != 0) camera.roll(-dir * lue.math.Math.degToRad(90));
    	camera.transform.dirty = true;
    	camera.transform.update();
    	camera.updateMatrix();
    }

    public function update() {
    	var rotDif = rotCurrent - rotLast;
    	var posDif = posCurrent - posLast;
    	var strafeDif = strafeCurrent - strafeLast;
    	var liftDif = liftCurrent - liftLast;
    	rotLast = rotCurrent;
    	posLast = posCurrent;
    	strafeLast = strafeCurrent;
    	liftLast = liftCurrent;

    	if (rotDif != 0) camera.roll(rotDif);
    	if (posDif != 0) camera.moveForward(posDif);
    	if (strafeDif != 0) {
    		if (dir == 1 || dir == 3) { camera.moveRight(-strafeDif); }
    		else { camera.moveRight(strafeDif); }
    	}
    	if (liftDif != 0) {
    		camera.moveUp(-liftDif);
    	}

    	// Controls
    	if (moveForward) move(1);
    	else if (moveBackward) move(-1);
    	else if (strafeLeft) {
    		if (dir == 1 || dir == 3) { strafe(-1); }
    		else { strafe(1); }
    	}
    	else if (strafeRight) {
    		if (dir == 1 || dir == 3) { strafe(1); }
    		else { strafe(-1); }
    	}

    	if (turnLeft) turn(1);
    	else if (turnRight) turn(-1);
    }

	function move(dist:Int) {
		if (!moveComplete) return;

		var targetX = posX;
		var targetY = posY;

		if (dir == 1) targetX += dist;
		else if (dir == 2) targetY -= dist;
		else if (dir == 3) targetX -= dist;
		else targetY += dist;

		moveTo(targetX, targetY, dist, "move");
	}

	function strafe(dist:Int) {
		if (!moveComplete) return;

		var targetX = posX;
		var targetY = posY;

		if (dir == 1) targetY -= dist;
		else if (dir == 2) targetX += dist;
		else if (dir == 3) targetY += dist;
		else targetX -= dist;

		moveTo(targetX, targetY, dist, "strafe");
	}

	function delayMove(t = 0.2) {
		moveComplete = false;
		motion.Actuate.timer(t).onComplete(moved);
	}

	function moved() {
		moveComplete = true;
		maze.moveThings();
	}

	function moveTo(targetX:Int, targetY:Int, dist:Int, type:String) {
		if (maze.gameOver) return;

		// Check for things
		var things = maze.floor.things;
		for (t in things) {
			// Thing found
			if (t.x == targetX && t.y == targetY) {
				// Lever
				if (t.type == MazeGenerator.THING_LEVER) {
					// Set state of target
					var tt = maze.getThingById(t.targetId);
					if (tt != null && tt.type == MazeGenerator.THING_GATE) {
						maze.leverAction(t);
						maze.gateAction(tt);
						delayMove();
					}
					return;
				}
				// Gate
				else if (t.type == MazeGenerator.THING_GATE) {
					// Gate closed
					if (t.state == 0) { return; }
				}
				// Hammer
				else if (t.type == MazeGenerator.THING_HAMMER) {
					// Hammer down
					if (t.state == 0) { return; }
				}
				// Mover
				else if (t.type == MazeGenerator.THING_MOVER) {
					return;
				}
			}
		}

		// Move
		if (!maze.isWall(targetX, targetY) && !maze.isStairsDown(targetX, targetY)) {

			lue.sys.Audio.playSound("step");

			moveComplete = false;
			if (type == "move") {
				posCurrent = 0;
				posLast = 0;
			}
			else if (type == "strafe") {
				strafeCurrent = 0;
				strafeLast = 0;
			}

			var isStairs = maze.isStairs(targetX, targetY);
			//var isStairsDown = maze.isStairsDown(targetX, targetY);
			var moveTime = isStairs ? 1.0 : 0.2;

			posX = targetX;
			posY = targetY;

			if (type == "move") {
				motion.Actuate.tween(this, moveTime, {posCurrent:MazeGenerator.tileSize * dist}).onComplete(moved);
			}
			else if (type == "strafe") {
				motion.Actuate.tween(this, moveTime, {strafeCurrent:MazeGenerator.tileSize * dist}).onComplete(moved);
			}

			// Level completed
			if (isStairs) {
				// Next floor
				MazeGenerator.nextFloor();

				// Camera up
				motion.Actuate.tween(this, moveTime, {liftCurrent:MazeGenerator.tileSize * dist}).onComplete(function() {});

				// Reset and load next floor
				maze.reset();
			}
			/*else if (isStairsDown) {
				MazeGenerator.previousFloor();
				// Camera down
				motion.Actuate.tween(this, moveTime, {liftCurrent:-MazeGenerator.tileSize * dist}).onComplete(function() {});
				maze.reset();
			}*/
		}
	}

	function turn(sign:Int) {
		if (!moveComplete) return;

		moveComplete = false;
		rotCurrent = 0;
		rotLast = 0;

		dir -= sign;
		if (dir < 0) dir = 3;
		else if (dir > 3) dir = 0;
		motion.Actuate.tween(this, 0.2, {rotCurrent:lue.math.Math.degToRad(90 * sign)}).onComplete(function() {moveComplete = true;});
	}

	function onKeyDown(key:Key, char:String) {
		if (key == Key.UP || (key == Key.CHAR && char == "w")) {
			moveForward = true;
		}
		else if (key == Key.DOWN || (key == Key.CHAR && char == "s")) {
			moveBackward = true;
		}
		else if (key == Key.LEFT || (key == Key.CHAR && char == "a")) {
			turnLeft = true;
		}
		else if (key == Key.RIGHT || (key == Key.CHAR && char == "d")) {
			turnRight = true;
		}
		else if ((key == Key.CHAR && char == "q")) {
			strafeLeft = true;
		}
		else if ((key == Key.CHAR && char == "e")) {
			strafeRight = true;
		}
	}

	function onKeyUp(key:Key, char:String) {
		if (key == Key.UP || (key == Key.CHAR && char == "w")) {
			moveForward = false;
		}
		else if (key == Key.DOWN || (key == Key.CHAR && char == "s")) {
			moveBackward = false;
		}
		else if (key == Key.LEFT || (key == Key.CHAR && char == "a")) {
			turnLeft = false;
		}
		else if (key == Key.RIGHT || (key == Key.CHAR && char == "d")) {
			turnRight = false;
		}
		else if ((key == Key.CHAR && char == "q")) {
			strafeLeft = false;
		}
		else if ((key == Key.CHAR && char == "e")) {
			strafeRight = false;
		}
	}
}
