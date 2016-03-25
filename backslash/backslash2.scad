// pieza cnc para unir eje Y con la varilla roscada anti-backslash

dcilindro = 12;  // radio varilla de 12
dtuerca = 21.4;  // radio de una tuerca de 12
ytuerca1 = 5;   // largo zona tuerca 1  <<< esto es medida 1 tuerca, un poco menos
ycilindro = 5;   // largo zona cilindro  <<< esto es que haya un minimo de material de tope
ytuerca2 = 40;   // largo zona tuerca 2  <<< esto es medida 1 tuerca + resorte con la compresion que se quiera

xtotal = 70;   // ancho pieza
ytotal = ytuerca1 + ycilindro + ytuerca2; // largo pieza
ydescentre = (ytuerca2 - ytuerca1)/2; // offset largo
zbase = 3;  // alto base pieza

zvarilla = 25.2; // separacion del centro de la varilla al suelo

xpegote = dtuerca * 0.4;  // ancho del cube que pega el elemento con la base cilindro
zpegote = zvarilla;

dagujeros = 6;   // diametro agujeros en el suelo
dagujeros2 = 4;   // diametro agujeros para la arandela de presion
fagujeros = 0.14; // factor de pegado al borde de los agujeros (entre 0-0.25)

module elemento_solido() {
    hull() {
        rotate([0, 0, 360/12])
            translate([0, 0, ydescentre])
                cylinder(d=dtuerca*1.3, h=ytotal, $fn=6, center=true);
    }
}

module elemento_agujero() {
    cylinder(d=dcilindro*1.2, h=ycilindro, $fn=20, center=true);
    rotate([0, 0, 360/12]) {
        translate([0, 0, -ytuerca1/2-ycilindro/2]) 
            cylinder(d=dtuerca, h=ytuerca1*1.01, $fn=6, center=true);
        translate([0, 0, ytuerca2/2+ycilindro/2]) 
            cylinder(d=dtuerca, h=ytuerca2*1.01, $fn=6, center=true);
    }
}

module pieza1 () {
    translate([0, ydescentre, 0]) 
        difference() {
            union() {
                translate([0, -ydescentre, 0]) {
                    // la base plana
                    translate([0, 0, zbase/2]) 
                        cube([xtotal, ytotal, zbase], center=true);
                    // el pegote
                    translate([0, 0, zpegote/2]) 
                        cube([xpegote, ytotal, zpegote], center=true);
                    // el triangulo
                    rotate([90, 0, 0])
                        linear_extrude(zbase*2, center=true) 
                            polygon([[-xtotal/2, 0], [-xtotal*0.27, zvarilla*1.27], [0, zvarilla*1.55], [xtotal*0.27, zvarilla*1.27], [xtotal/2, 0]]);
                }
                // el elemento
                translate([0, 0, zvarilla])
                    rotate([90, 0, 0]) 
                        elemento_solido();
            }
            // el agujero del elemento
            translate([0, 0, zvarilla])
                rotate([90, 0, 0]) 
                    elemento_agujero();
            // los agujeros en la base
            for (x=[fagujeros, 1-fagujeros])
                for (y=[fagujeros, 1-fagujeros]) 
                    translate([(x-0.5)*xtotal, (y-0.5)*ytotal-ydescentre, zbase/2]) 
                        cylinder(d=dagujeros, h=zbase*1.01, center=true);
            for (x=[-17, 17])
                translate([x, -ydescentre, zvarilla])
                    rotate([90, 0, 0])
                        cylinder(d=dagujeros2, h=2*zbase*1.01, center=true, $fn=20);
                
        }
}

module pieza2(h1=zbase, h2=2*zbase) {
    translate([0, 0, h1/2])
        difference() {
            union() {
                rotate([0, 0, 360/12])
                    translate([0, 0, h1/2+h2/2])
                        difference() {
                            cylinder(d=dtuerca*1.5, h=h2, $fn=6, center=true);
                            cylinder(d=dtuerca*1.3, h=h2*1.01, $fn=6, center=true);
                        }
                hull() {
                    translate([-16, 0, 0]) cylinder(d=15, h=h1, center=true);
                    translate([+16, 0, 0]) cylinder(d=15, h=h1, center=true);
                    translate([0, 0, 0]) cylinder(d=dtuerca*1.51, h=h1, center=true);
                }
            }
            
            cylinder(d=dcilindro*1.2, h=h1*1.01, $fn=20, center=true);
            for (x=[-17, 17])
                translate([x, 0, 0])
                    cylinder(d=dagujeros2, h=h1*1.01, center=true, $fn=20);
            translate([0, dtuerca*0.7, h1/2+h2/2])
                cube([xpegote, xpegote, h2*1.01], center=true);
        }
}

pieza1();
translate([0, 70, 0]) 
    rotate([0, 0, 180]) 
        pieza2();

/*
%translate([0, 70, zvarilla]) 
    rotate([90, 180, 0]) 
        pieza2();
*/
