// pieza cnc para unir eje Y con la varilla roscada anti-backslash

dcilindro = 12;  // radio varilla de 12
ycilindro = 15;  // largo zona cilindro   <<< esto es estetico
dtuerca = 21.4;  // radio de una tuerca de 12
ytuerca = 40;    // largo zona tuerca     <<< esto es medida 2 tuercas + resorte con la compresion que se quiera

xtotal = 70;   // ancho pieza
ytotal = ytuerca + ycilindro; // largo pieza
ydescentre = ytuerca/2 - ycilindro/2; // offset largo
zbase = 3;  // alto base pieza

zvarilla = 25.2; // separacion del centro de la varilla al suelo

xpegote = dtuerca * 0.8;  // ancho del cube que pega el elemento con la base cilindro

dagujeros = 6;   // diametro agujeros en el suelo
fagujeros = 0.12; // factor de pegado al borde de los agujeros (entre 0-0.25)

module elemento_solido() {
    hull() {
        translate([0, 0, -ytuerca/2]) 
            cylinder(d=dtuerca*1.5, h=ytuerca, $fn=6, center=true);
        translate([0, 0, ycilindro/2]) 
            cylinder(d=dcilindro*2, h=ycilindro, $fn=20, center=true);
    }
}

module elemento_agujero() {
    translate([0, 0, -ytuerca/2]) 
        cylinder(d=dtuerca, h=ytuerca*1.01, $fn=6, center=true);
    translate([0, 0, ycilindro/2]) 
        cylinder(d=dcilindro*1.2, h=ycilindro*1.01, $fn=20, center=true);
}

difference() {
    union() {
        translate([0, ydescentre, 0]) {
            // la base plana
            translate([0, 0, zbase/2]) 
                cube([xtotal, ytotal, zbase], center=true);
            // el pegote
            translate([0, 0, zvarilla/2]) 
                cube([xpegote, ytotal, zvarilla], center=true);
            // el triangulo
            rotate([90, 0, 0])
                linear_extrude(zbase*2, center=true) 
                    polygon([[-xtotal/2, 0], [-xtotal*0.2, zvarilla], [xtotal*0.2, zvarilla], [xtotal/2, 0]]);
        }
        // el elemento
        translate([0, 0, zvarilla])
            rotate([90, 0, 0]) 
                elemento_solido();
    }
    // el agujero del elemento
    translate([0, 0, 25.2])
        rotate([90, 0, 0]) 
            elemento_agujero();
    // los agujeros en la base
    for (x=[fagujeros, 1-fagujeros])
        for (y=[fagujeros, 1-fagujeros]) 
            translate([(x-0.5)*xtotal, (y-0.5)*ytotal+ydescentre, zbase/2]) 
                cylinder(d=dagujeros, h=zbase*1.01, center=true);
}
