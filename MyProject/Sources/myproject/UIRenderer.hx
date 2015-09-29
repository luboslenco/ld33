package myproject;

import lue.Root;
import lue.Trait;
import lue.sys.importer.PsdFormat;
import lue.sys.importer.PsdData;
import lue.sys.Input;
import zui.Zui;
import zui.Id;
import zui.Ext;

class UIRenderer extends Trait {

	var data:PsdData;

	var menuLayer:TPsdLayer;
	var musicLayer:TPsdLayer;
	var soundLayer:TPsdLayer;
	var respawnLayer:TPsdLayer;
	var compassLayer:TPsdLayer;

	var soundOffset:Float = -100;
	var musicOffset:Float = -100;
	var respawnOffset:Float = -100;

	var menuOn = false;

	var ui:Zui;
	var editW:String = "5";
	var editH:String = "5";
	var editX:String = "0";
	var editY:String = "0";
	var editDir:String = "0";

	public function new() {
		super();

		data = new PsdData(lue.sys.Assets.getString("ui_metadata"));
        menuLayer = data.getLayer("menu");
        musicLayer = data.getLayer("music");
        soundLayer = data.getLayer("sound");
        respawnLayer = data.getLayer("respawn");
        compassLayer = data.getLayer("compass");

        ui = new Zui(lue.sys.Assets.getFont("helvetica_neue", 18),
                     lue.sys.Assets.getFont("helvetica_neue", 16));

        requestUpdate(update);
        requestRender2D(render2D);
	}

	function update() {
		if (Input.released) {
			if (Input.x >= menuLayer.x && Input.x <= menuLayer.x + menuLayer.w &&
				Input.y >= menuLayer.y && Input.y <= menuLayer.y + menuLayer.h) {

				menuOn = !menuOn;

				if (menuOn) {
					lue.sys.Tween.to(this, 0.2, {soundOffset: 0});
					lue.sys.Tween.to(this, 0.2, {musicOffset: 0}, null, 0.05);
					lue.sys.Tween.to(this, 0.2, {respawnOffset: 0}, null, 0.1);
				}
				else {
					lue.sys.Tween.to(this, 0.5, {soundOffset: -100}, null, 0.1);
					lue.sys.Tween.to(this, 0.5, {musicOffset: -100}, null, 0.05);
					lue.sys.Tween.to(this, 0.5, {respawnOffset: -100});
				}
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

	function render2D(g:kha.graphics2.Graphics) {
		g.color = kha.Color.White;
		g.opacity = 1;
		data.drawLayer(g, menuLayer, menuLayer.x, menuLayer.y);

		if (soundOffset > -100) {
			if (lue.sys.Audio.musicOn) { g.opacity = 1; }
			else { g.opacity = 0.5; }
			data.drawLayer(g, musicLayer, musicLayer.x, musicLayer.y + musicOffset);

			if (lue.sys.Audio.soundOn) { g.opacity = 1; }
			else { g.opacity = 0.5; }
			data.drawLayer(g, soundLayer, soundLayer.x, soundLayer.y + soundOffset);

			g.opacity = 1;
			data.drawLayer(g, respawnLayer, respawnLayer.x, respawnLayer.y + respawnOffset);
		}

		//data.drawLayer(g, compassLayer, compassLayer.x, compassLayer.y);

		
		if (soundOffset > -100) {
			g.end();
			ui.begin(g);

	        if (ui.window(Id.window(), Root.w - 250, 0, 250, Root.h)) {
	            if (ui.node(Id.node(), "level", 2, true)) {
	                for (i in 0...FloorsData.numLevels) {
	                	var r = FloorsData.numLevels - i;
	                	if (i % 2 == 0 && r >= 2) ui.row([1/2, 1/2]);
	                	if (ui.button(i + "")) {
	                		MazeGenerator.setFloor(i);
							MazeGenerator.inst.reset();
							break;
	                	}
	                }
	            }
	            if (ui.node(Id.node(), "editor", 2, true)) {
	            	ui.row([1/2, 1/2]);
	            	editW = ui.textInput(Id.textInput(), editW, "w");
	            	editH = ui.textInput(Id.textInput(), editH, "h");
	            	if (ui.button("make")) {
	            		var f = FloorsData.getEmptyFloor(Std.parseInt(editW), Std.parseInt(editH));
	            		MazeGenerator.inst.reset(f);
	            	}
	            	ui.button("save");
	            }
	            if (ui.node(Id.node(), "start", 2, true)) {
	            	ui.row([1/3, 1/3, 1/3]);
	            	editX = ui.textInput(Id.textInput(), editX, "x");
	            	editY = ui.textInput(Id.textInput(), editY, "y");
	            	editDir = ui.textInput(Id.textInput(), editDir, "dir");
	            }
	            if (ui.node(Id.node(), "tile", 2, true)) {
	            	ui.textInput(Id.textInput(), "", "dir");
	            	ui.row([1/2, 1/2]);
	            	ui.button("Empty");
	            	ui.button("Wall");
	            	ui.row([1/2, 1/2]);
	            	ui.button("Stairs Up");
	            	ui.button("Stairs Down");
	            }
	            if (ui.node(Id.node(), "thing", 2, true)) {
	            	ui.textInput(Id.textInput(), "", "dir");
	            	ui.textInput(Id.textInput(), "", "id");
	            	ui.textInput(Id.textInput(), "", "targetId");
	            	ui.textInput(Id.textInput(), "", "state");
	            	ui.textInput(Id.textInput(), "", "rate");
	            	ui.textInput(Id.textInput(), "", "i");
	            	ui.row([1/2, 1/2]);
	            	ui.button("Lever");
	            	ui.button("Gate");
	            	ui.row([1/2, 1/2]);
	            	ui.button("Hammer");
	            	ui.button("Spike");
	            	ui.row([1/2, 1/2]);
	            	ui.button("Mover");
	            	ui.button("Gun");
	            }
	        }

	        ui.end();
	        g.begin(false);
	    }
	}
}
