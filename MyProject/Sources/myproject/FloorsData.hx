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
}

class FloorsData {

	public static function getFloor(i:Int):Floor {
		var f = new Floor();

		if (i == 0) {
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
				[1, 1, 1, 1, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 0, 0, 0, 1],
				[1, 1, 0, 1, 1],
				[1, 0, 0, 0, 1],
				[2, 0, 0, 0, 1],
				[1, 1, 1, 1, 1]
			];
			f.dirs = [
				[0, 0, 0, 0, 0],
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
			var t1 = new Thing(MazeGenerator.THING_LEVER, 3, 3);
			t1.targetId = 0;
			f.things.push(t1);
			var t2 = new Thing(MazeGenerator.THING_GATE, 2, 4);
			t2.id = 0;
			t2.dir = 3;
			f.things.push(t2);
		}



		if (i == 2) {
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

		return f;
	}
}
