// Auto-generated
package ;
class Main {
    public static function main() {
        CompileTime.importPackage("lue.trait");
        CompileTime.importPackage("myproject");
        #if js
        untyped __js__("
            function loadScript(url, callback) {
                var head = document.getElementsByTagName('head')[0];
                var script = document.createElement('script');
                script.type = 'text/javascript';
                script.src = url;
                script.onreadystatechange = callback;
                script.onload = callback;
                head.appendChild(script);
            }
        ");
        untyped loadScript("ammo.js", start);
        #else
        start();
        #end
    }
    static function start() {
        var starter = new kha.Starter();
        starter.start(new lue.Root("Lue", "room1", Game));
    }
}
class Game {
    public function new() {
        lue.Root.setSceneByName(lue.Root.gameData.scene);
    }
}
