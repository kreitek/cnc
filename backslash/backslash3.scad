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
ztotal = zvarilla*2;

dagujeros = 6;   // diametro agujeros en el suelo
dagujeros2 = 4;   // diametro agujeros para la arandela de presion
fagujeros = 0.2; // factor de pegado al borde de los agujeros (entre 0-0.25)

module triangulo() {
    linear_extrude(zbase*2, center=true) 
        polygon([[-ytotal/2, zbase], [-zbase/2, ztotal], [zbase/2, ztotal],  [ytotal/2, zbase]]);
}

module agujeros(h, r=14) {
    for (a=[0:90:270])
        rotate([0, 0, a])
            translate([r, 0, h/2])
                cylinder(d=dagujeros2, h=h*1.01, center=true, $fn=20);
}

module agujeros2(h, r=14) {
    for (a=[0:90:270])
        rotate([0, 0, a])
            rotate_extrude(angle=45)
                polygon([[r-dagujeros2/2, -0.01], [r+dagujeros2/2, -0.01], [r+dagujeros2/2, h*1.01], [r-dagujeros2/2, h*1.01]]);
}

module pieza1 () {
    translate([0, ydescentre, 0]) 
        difference() {
            union() {
                translate([0, -ydescentre, 0]) {
                    // la base plana
                    translate([0, 0, zbase/2]) 
                        cube([xtotal, ytotal, zbase], center=true);
                    // el triangulo
                    translate([-xtotal/2+zbase, 0, 0])
                        rotate([90, 0, 90])
                            triangulo();
                    translate([xtotal/2-zbase, 0, 0])
                        rotate([90, 0, 90])
                            triangulo();
                    translate([0, 0, ztotal/2])
                        cube([xtotal, zbase, ztotal], center=true);
                }
            }
            // el agujero del elemento
            translate([0, -ydescentre, zvarilla])
                rotate([90, 0, 0]) 
                    cylinder(d=dcilindro*1.2, h=ycilindro, $fn=20, center=true);
            // los agujeros en la base
            for (x=[fagujeros, 1-fagujeros])
                for (y=[fagujeros, 1-fagujeros]) 
                    translate([(x-0.5)*xtotal, (y-0.5)*ytotal-ydescentre, zbase/2]) 
                        cylinder(d=dagujeros, h=zbase*1.01, center=true);
            translate([0, -ydescentre+zbase, zvarilla])
                rotate([90, 0, 0])
                    agujeros(2*zbase);
                
        }
}

module pieza2(h1=zbase, h2=2*zbase, bandas=true) {
    h = h1 + h2;
    difference() {
        translate([0, 0, h/2])
            cylinder(d=dtuerca*1.7, h=h, $fn=30, center=true);

        translate([0, 0, h1+h2/2])
            cylinder(d=dtuerca, h=h2*1.01, $fn=6, center=true);

        translate([0, 0, h1/2])
            cylinder(d=dcilindro*1.2, h=h1*1.01, $fn=20, center=true);

        if (bandas) 
            agujeros2(h);
        else   
            agujeros(h);
    }
}

pieza1();
translate([0, 60, 0]) 
    pieza2();
translate([0, -60, 0]) 
    pieza2(bandas=false);

/*
%translate([0, 70, zvarilla]) 
    rotate([90, 180, 0]) 
        pieza2();
*/