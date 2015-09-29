package myproject;

import lue.Root;
import lue.Trait;
import lue.sys.importer.PsdFormat;
import lue.sys.importer.PsdData;

class IntroTextRenderer extends Trait {

	var data:PsdData;
	
	var titleLayer:TPsdLayer;
	var lineLayer:TPsdLayer;
	var controlsLayer:TPsdLayer;

	var bgOp:Float = 0.7;

	public function new() {
		super();

		data = new PsdData(lue.sys.Assets.getString("intro_metadata"));
        titleLayer = data.getLayer("title");
        lineLayer = data.getLayer("line");
        controlsLayer = data.getLayer("controls");

        lue.sys.Tween.to(this, 2, {bgOp: 0}, null, 3);
        kha.input.Keyboard.get().notify(onDown, null);

        requestRender2D(render2D);
	}

	function render2D(g:kha.graphics2.Graphics) {

		if (bgOp > 0) {
			g.color = kha.Color.fromFloats(0, 0, 0, bgOp);
			g.fillRect(0, 0, Root.w, Root.h - 90);
		}

		g.color = kha.Color.White;
		g.opacity = 1 * (bgOp * 1.4);
		data.drawLayer(g, titleLayer, Root.w / 2 - titleLayer.w / 2, titleLayer.y);
		data.drawLayer(g, lineLayer, Root.w / 2 - lineLayer.w / 2, lineLayer.y);

		g.opacity = 1;
		g.color = kha.Color.fromFloats(0, 0, 0, 0.7);
		g.fillRect(0, Root.h - 90, Root.w, 90);
		g.color = kha.Color.White;
		data.drawLayer(g, controlsLayer, Root.w / 2 - controlsLayer.w / 2, Root.h - (640 - controlsLayer.y));
	}

	function onDown(key:kha.Key, char:String) {
		kha.input.Keyboard.get().remove(onDown, null);
		
		//motion.Actuate.stop(this);
		//motion.Actuate.tween(this, 2, {bgOp: 0});
	}
}
