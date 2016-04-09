all: endstop.png endstop.stl
	
clean:
	rm -f endstop.stl endstop.png
endstop.png: endstop.scad
	openscad-nightly endstop.scad -o endstop.png --camera=0,0,0,71,0,78,150 --imgsize=1024,768
endstop.stl: endstop.scad
	openscad-nightly endstop.scad -o endstop.stl
