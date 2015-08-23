package myproject;

import lue.Root;
import lue.core.Trait;
import lue.core.IRenderable2D;
import lue.sys.importer.PsdFormat;
import lue.sys.importer.PsdData;

class FloorTextRenderer extends Trait implements IRenderable2D {

	var data:PsdData;

	var floorLayer:TPsdLayer;

	var bgOp:Float = 0.7;

	public function new(floorPos:Int) {
		super();

		data = new PsdData(lue.sys.Assets.getString("floor_metadata"));
        floorLayer = data.getLayer("floor" + floorPos);

        motion.Actuate.tween(this, 2, {bgOp: 0}).delay(3);
        kha.input.Keyboard.get().notify(onDown, null);
	}

	public function render2D(g:kha.graphics2.Graphics) {

		if (bgOp > 0) {
			g.color = kha.Color.fromFloats(0, 0, 0, bgOp);
			g.fillRect(0, 0, Root.w, Root.h);
		}

		g.color = kha.Color.White;
		g.opacity = 1 * (bgOp * 1.4);
		data.drawLayer(g, floorLayer, floorLayer.x, floorLayer.y);
	}

	function onDown(key:kha.Key, char:String) {
		kha.input.Keyboard.get().remove(onDown, null);
		motion.Actuate.stop(this);
		motion.Actuate.tween(this, 2, {bgOp: 0});
	}
}
