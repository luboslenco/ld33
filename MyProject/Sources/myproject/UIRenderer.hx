package myproject;

import lue.Root;
import lue.core.Trait;
import lue.core.IUpdateable;
import lue.core.IRenderable2D;
import lue.sys.importer.PsdFormat;
import lue.sys.importer.PsdData;
import lue.sys.Input;

class UIRenderer extends Trait implements IRenderable2D implements IUpdateable {

	var data:PsdData;

	var menuLayer:TPsdLayer;
	var musicLayer:TPsdLayer;
	var soundLayer:TPsdLayer;
	var respawnLayer:TPsdLayer;
	var compassLayer:TPsdLayer;

	var menuOn = false;

	public function new() {
		super();

		data = new PsdData(lue.sys.Assets.getString("ui_metadata"));
        menuLayer = data.getLayer("menu");
        musicLayer = data.getLayer("music");
        soundLayer = data.getLayer("sound");
        respawnLayer = data.getLayer("respawn");
        compassLayer = data.getLayer("compass");
	}

	public function update() {

		if (Input.released) {
			if (Input.x >= menuLayer.x && Input.x <= menuLayer.x + menuLayer.w &&
				Input.y >= menuLayer.y && Input.y <= menuLayer.y + menuLayer.h) {

				menuOn = !menuOn;
			}

			if (menuOn) {
				if (Input.x >= soundLayer.x && Input.x <= soundLayer.x + soundLayer.w &&
					Input.y >= soundLayer.y && Input.y <= soundLayer.y + soundLayer.h) {

					lue.sys.Audio.soundOn = !lue.sys.Audio.soundOn;
				}

				if (Input.x >= musicLayer.x && Input.x <= musicLayer.x + musicLayer.w &&
					Input.y >= musicLayer.y && Input.y <= musicLayer.y + musicLayer.h) {

					if (lue.sys.Audio.musicOn) {
						lue.sys.Audio.stopMusic();
						lue.sys.Audio.musicOn = false;
					}
					else {
						lue.sys.Audio.musicOn = true;
						lue.sys.Audio.playMusic("music");
					}
				}

				if (Input.x >= respawnLayer.x && Input.x <= respawnLayer.x + respawnLayer.w &&
					Input.y >= respawnLayer.y && Input.y <= respawnLayer.y + respawnLayer.h) {
					MazeGenerator.inst.reset();
				}
			}
		}
	}

	public function render2D(g:kha.graphics2.Graphics) {

		g.color = kha.Color.White;
		g.opacity = 1;
		data.drawLayer(g, menuLayer, menuLayer.x, menuLayer.y);

		if (menuOn) {
			if (lue.sys.Audio.musicOn) { g.opacity = 1; }
			else { g.opacity = 0.5; }
			data.drawLayer(g, musicLayer, musicLayer.x, musicLayer.y);

			if (lue.sys.Audio.soundOn) { g.opacity = 1; }
			else { g.opacity = 0.5; }
			data.drawLayer(g, soundLayer, soundLayer.x, soundLayer.y);

			g.opacity = 1;
			data.drawLayer(g, respawnLayer, respawnLayer.x, respawnLayer.y);
		}

		//data.drawLayer(g, compassLayer, compassLayer.x, compassLayer.y);
	}
}
