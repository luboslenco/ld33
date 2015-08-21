var solution = new Solution('Empty');
var project = new Project('Empty');
project.setDebugDir('build/osx');
project.addSubProject(Solution.createProject('build/osx-build'));
project.addSubProject(Solution.createProject('/Users/lubos/Documents/Sublime/ld33/MyProject/Kha'));
project.addSubProject(Solution.createProject('/Users/lubos/Documents/Sublime/ld33/MyProject/Kha/Kore'));
solution.addProject(project);
if (fs.existsSync(path.join('Libraries/lue', 'korefile.js'))) {
	project.addSubProject(Solution.createProject('Libraries/lue'));
}
if (fs.existsSync(path.join('Libraries/zui', 'korefile.js'))) {
	project.addSubProject(Solution.createProject('Libraries/zui'));
}
if (fs.existsSync(path.join('Libraries/haxebullet', 'korefile.js'))) {
	project.addSubProject(Solution.createProject('Libraries/haxebullet'));
}
if (fs.existsSync(path.join('Libraries/dependencies', 'korefile.js'))) {
	project.addSubProject(Solution.createProject('Libraries/dependencies'));
}
return solution;
