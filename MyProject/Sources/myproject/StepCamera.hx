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

	var posX = 1;
	var posY = 1;
	var dir = 0;

	var rotCurrent = 0.0;
	var posCurrent = 0.0;
	var rotLast = 0.0;
	var posLast = 0.0;
	var moveComplete = true;

	var upPressed = false;
    var downPressed = false;
    var leftPressed = false;
    var rightPressed = false;

    public function new() {
        super();

        Keyboard.get().notify(onKeyDown, onKeyUp);
        Root.registerInit(init);
    }

    function init() {
    	maze = Root.getChild("Maze").getTrait(MazeGenerator);

    	// Set camera position
    	camera.transform.x = maze.getWorldX(posX);
    	camera.transform.y = maze.getWorldY(posY);
    	camera.transform.dirty = true;
    	camera.transform.update();
    	camera.updateMatrix();
    }

    public function update() {
    	var rotDif = rotCurrent - rotLast;
    	var posDif = posCurrent - posLast;
    	rotLast = rotCurrent;
    	posLast = posCurrent;

    	if (rotDif != 0) camera.roll(rotDif);
    	if (posDif != 0) camera.moveForward(posDif);

    	if (upPressed) move(1);
    	else if (downPressed) move(-1);

    	if (leftPressed) turn(1);
    	else if (rightPressed) turn(-1);
    }

	function move(dist:Int) {
		if (!moveComplete) return;

		var targetX = posX;
		var targetY = posY;

		if (dir == 1) targetX += dist;
		else if (dir == 2) targetY -= dist;
		else if (dir == 3) targetX -= dist;
		else targetY += dist;

		if (!maze.isWall(targetX, targetY)) {
			moveComplete = false;
			posCurrent = 0;
			posLast = 0;

			posX = targetX;
			posY = targetY;
			motion.Actuate.tween(this, 0.15, {posCurrent:MazeGenerator.tileSize * dist}).onComplete(function() {moveComplete = true;});
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
		if (key == Key.UP) upPressed = true;
		else if (key == Key.DOWN) downPressed = true;
		else if (key == Key.LEFT) leftPressed = true;
		else if (key == Key.RIGHT) rightPressed = true;
	}

	function onKeyUp(key:Key, char:String) {
		if (key == Key.UP) upPressed = false;
		else if (key == Key.DOWN) downPressed = false;
		else if (key == Key.LEFT) leftPressed = false;
		else if (key == Key.RIGHT) rightPressed = false;
	}
}
