package myproject;

import lue.Root;
import lue.core.Trait;
import lue.core.IRenderable2D;
import lue.sys.importer.PsdFormat;
import lue.sys.importer.PsdData;

class IntroTextRenderer extends Trait implements IRenderable2D {

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

        motion.Actuate.tween(this, 2, {bgOp: 0}).delay(3);
	}

	public function render2D(g:kha.graphics2.Graphics) {

		if (bgOp > 0) {
			g.color = kha.Color.fromFloats(0, 0, 0, bgOp);
			g.fillRect(0, 0, Root.w, Root.h - 90);
		}

		g.color = kha.Color.White;
		g.opacity = bgOp;
		data.drawLayer(g, titleLayer, titleLayer.x, titleLayer.y);
		data.drawLayer(g, lineLayer, lineLayer.x, lineLayer.y);

		g.opacity = 1;
		g.color = kha.Color.fromFloats(0, 0, 0, 0.7);
		g.fillRect(0, Root.h - 90, Root.w, 90);
		g.color = kha.Color.White;
		data.drawLayer(g, controlsLayer, controlsLayer.x, controlsLayer.y);
	}
}
