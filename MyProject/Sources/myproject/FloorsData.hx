package myproject;

class Thing {
	public function new(_type:Int, _x:Int, _y:Int) {
		type = _type; x = _x; y = _y;
	}
	public var type:Int;
	public var x:Int;
	public var y:Int;
	public var dir:Int = 0;
	public var id:Int = -1;
	public var targetId:Int = -2;
	public var state:Int = 0;
	public var rate:Int = 2;
	public var i:Int = 0;
	public var object:lue.core.Object;
}

class Floor {
	public function new() {}
	public var data:Array<Array<Int>>;
	public var dirs:Array<Array<Int>>;
	public var startX:Int;
	public var startY:Int;
	public var startDir:Int;
	public var things:Array<Thing> = [];
	public var text:String = "";
}

class FloorsData {

	public static function getFloor(i:Int):Floor {
		var f = new Floor();

		if (i == 0) {
			f.text = "Hello";
			f.data = [
				[1, 1, 1, 1, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 1, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 1, 2, 1, 1]
			];
			f.dirs = [
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 3, 0, 0]
			];
			f.startX = 2;
			f.startY = 1;
			f.startDir = 0;
		}



		else if (i == 1) {
			f.data = [
				[1, 1, 3, 1, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 1, 0, 1, 1],
				[1, 0, 0, 0, 1],
				[2, 0, 0, 0, 1],
				[1, 1, 1, 1, 1]
			];
			f.dirs = [
				[0, 0, 3, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0]
			];
			f.startX = 2;
			f.startY = 1;
			f.startDir = 0;
			f.things.push(makeGate(2, 4, 3, 0));
			f.things.push(makeLever(3, 3, 0));
		}



		if (i == 2) {
			f.data = [
				[1, 1, 1, 1, 1],
				[3, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 1, 2, 1, 1]
			];
			f.dirs = [
				[0, 0, 0, 0, 0],
				[2, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 3, 0, 0]
			];
			f.startX = 1;
			f.startY = 1;
			f.startDir = 0;
			f.things.push(makeHammer(1, 3, 1));
			f.things.push(makeHammer(2, 3, 0));
			f.things.push(makeHammer(3, 3, 1));
		}



		if (i == 3) {
			f.data = [
				[1, 1, 3, 1, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 1, 2, 1, 1]
			];
			f.dirs = [
				[0, 0, 3, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 3, 0, 0]
			];
			f.startX = 2;
			f.startY = 1;
			f.startDir = 0;
			f.things.push(makeSpike(1, 3, 0));
			f.things.push(makeSpike(2, 3, 0));
			f.things.push(makeSpike(3, 3, 0));
			//
			f.things.push(makeSpike(1, 4, 1));
			f.things.push(makeSpike(3, 4, 1));
			//
			f.things.push(makeSpike(2, 5, 0));
		}



		if (i == 4) {
			f.data = [
				[1, 1, 3, 1, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 1, 2, 1, 1]
			];
			f.dirs = [
				[0, 0, 3, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 3, 0, 0]
			];
			f.startX = 2;
			f.startY = 1;
			f.startDir = 0;
			f.things.push(new Thing(MazeGenerator.THING_MOVER, 1, 3));
			f.things.push(new Thing(MazeGenerator.THING_MOVER, 3, 4));
			f.things.push(new Thing(MazeGenerator.THING_MOVER, 2, 6));
		}



		if (i == 5) {
			f.data = [
				[1, 1, 3, 1, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 1, 2, 1, 1]
			];
			f.dirs = [
				[0, 0, 3, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 3, 0, 0]
			];
			f.startX = 2;
			f.startY = 1;
			f.startDir = 0;

			f.things.push(makeGun(0, 3, 0));
			f.things.push(makeGun(f.data[0].length - 1, 5, 1));
		}



		if (i == 6) {
			f.data = [
				[1, 3, 1, 2, 1],
				[1, 0, 1, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 1, 1, 1, 1]
			];
			f.dirs = [
				[0, 3, 0, 1, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0]
			];
			f.startX = 1;
			f.startY = 1;
			f.startDir = 0;
			f.things.push(makeGate(3, 1, 1, 0));
			f.things.push(makeLever(3, 7, 0));
			f.things.push(makeSpike(2, 3, 0));
			f.things.push(makeHammer(2, 5, 0));
		}

		return f;
	}

	static function makeGate(x:Int, y:Int, dir:Int, id:Int):Thing {
		var t = new Thing(MazeGenerator.THING_GATE, x, y);
		t.dir = dir;
		t.id = id;
		return t;
	}

	static function makeLever(x:Int, y:Int, targetId:Int):Thing {
		var t = new Thing(MazeGenerator.THING_LEVER, x, y);
		t.targetId = targetId;
		return t;
	}

	static function makeHammer(x:Int, y:Int, state:Int):Thing {
		var t = new Thing(MazeGenerator.THING_HAMMER, x, y);
		t.state = state;
		return t;
	}

	static function makeSpike(x:Int, y:Int, i:Int):Thing {
		var t = new Thing(MazeGenerator.THING_SPIKE, x, y);
		t.i = i;
		return t;
	}

	static function makeGun(x:Int, y:Int, i:Int):Thing {
		var t = new Thing(MazeGenerator.THING_GUN, x, y);
		t.i = i;
		return t;
	}
}
