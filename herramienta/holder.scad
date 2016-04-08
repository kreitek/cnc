htotal = 15;

dagujero = 46; // diametro de la herramienta
eagujero = 12; // espesor de lo que aprieta a la herramienta
dtotal = dagujero + 2*eagujero;

egap = 3;

xtotal = 89;
ytotal = 35;
yoffset = 16;  // separacion de la herramienta con la pared

dagujerolateral = 2;
yagujerolateral = 6;

dagujeroapretar = 4;

apretar = 12; // dimensiones de los cubos para apretar


difference() {
    union() {
        // base cuadrada
        translate([0, ytotal/2, 0])
            cube([xtotal, ytotal, htotal], center=true);
        // parte redonda
        translate([0, yoffset + dtotal/2-eagujero, 0])
            cylinder(h=htotal, d=dtotal, center=true);
        // apretador
        translate([0, yoffset + dagujero + (apretar+eagujero)/2, 0])
            cube([apretar*2+egap, apretar+eagujero, htotal], center=true);
    }
    // agujero para herramienta
    translate([0, yoffset + dagujero/2, 0])
        cylinder(h=htotal*1.01, d=dagujero, center=true);
    // gap para apretar
    translate([0, yoffset+dagujero+(eagujero+apretar)/2, 0])
        cube([egap*1.01, (eagujero+apretar)*1.02, htotal*1.01], center=true);
    // agujeros laterales para sostener con base
    translate([0, yagujerolateral, 0])
        rotate([0, 90, 0])
            cylinder(h=xtotal*1.01, d=dagujerolateral, center=true);
    // agujeros laterales para apretar herramienta
    translate([0, yoffset + dagujero + eagujero + apretar/2, 0])
        rotate([0, 90, 0])
            cylinder(h=xtotal*1.01, d=dagujeroapretar, center=true);
    
}
