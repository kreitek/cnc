ALL: endstop.png endstop.stl

endstop.png: endstop.scad
	openscad-nightly endstop.scad -o endstop.png --camera=0,0,0,55,0,55,150 --imgsize=1024,768
endstop.stl: endstop.scad
	openscad-nightly endstop.scad -o endstop.stl
