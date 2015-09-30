package myproject;

import lue.Root;
import lue.Trait;
import lue.sys.importer.PsdFormat;
import lue.sys.importer.PsdData;

class FloorTextRenderer extends Trait {

	var data:PsdData;

	var floorLayer:TPsdLayer;

	var bgOp:Float = 0.7;

	public function new(floorPos:Int) {
		super();

		data = new PsdData(lue.sys.Assets.getString("floor_metadata"));
        floorLayer = data.getLayer("floor" + floorPos);

        lue.sys.Tween.to(this, 2, {bgOp: 0}, null, 3);
        kha.input.Keyboard.get().notify(onDown, null);

        requestRender2D(render2D);
	}

	function render2D(g:kha.graphics2.Graphics) {
		if (bgOp > 0) {
			g.color = kha.Color.fromFloats(0, 0, 0, bgOp);
			g.fillRect(0, 0, Root.w, Root.h);
		}

		g.color = kha.Color.White;
		g.opacity = 1 * (bgOp * 1.4);
		data.drawLayer(g, floorLayer, Root.w / 2 - floorLayer.w / 2, Root.h / 2 - floorLayer.h / 2);
	}

	function onDown(key:kha.Key, char:String) {
		kha.input.Keyboard.get().remove(onDown, null);

		lue.sys.Tween.stop(this);
		lue.sys.Tween.to(this, 2, {bgOp: 0});
	}
}
