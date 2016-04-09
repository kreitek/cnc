$fn = 20;
interruptor = [30, 16, 10];
dagujero = 3.2;

module posiciona_agujero() {
    xoffsets = [1.2, 23.7];
    yoffsets = [1.3, -1.2];
    x0 = interruptor[0]/2 - dagujero/2;
    y0 = interruptor[1]/2 - dagujero/2;
    translate([-x0+xoffsets[0], +y0-yoffsets[0], 0])
        children(0);
    translate([-x0+xoffsets[1], -y0-yoffsets[1], 0])
        children(0);
}

module interruptor(adornos=false) {
    difference() {
        color("gray")
            cube(interruptor, center=true);
        posiciona_agujero()
            cylinder(d=dagujero, h=interruptor[2]*1.01, center=true);
    }
    bultito = [2.7, 2.7, 4.2];
    terminal = [10.5, 0.6, 4.7];
    if (adornos) {
        color("black")
            translate([-interruptor[0]/2+bultito[0]/2+3.5, -interruptor[1]/2-bultito[1]/2, 0])
                cube(bultito, center=true);
        color("orange") {
            for(yoffset=[5.5, 11.1])
                translate([interruptor[0]/2+terminal[0]/2, -interruptor[1]/2+terminal[1]/2+yoffset, 0])
                    cube(terminal, center=true);
            translate([terminal[0]/2, interruptor[1]/2-terminal[1]/2+3, 0])
                cube(terminal, center=true);
            translate([0, 5.7, 0])
                rotate([0, 0, 90])
                    cube(terminal, center=true);
        }
    }
}

module soporte() {
    chapa = [32, 24, 4];
    aletas = 0;
    despegado = 0.5;
    yoffset = 4;

    base = [chapa[0], chapa[2], despegado*2+chapa[2]*2+interruptor[2]+aletas];

    for(zoffset=[-1, +1])
        translate([0, yoffset, zoffset*(chapa[2]/2+interruptor[2]/2+despegado)]) {
            difference() {
                cube(chapa, center=true);
                translate([0, -yoffset, 0])
                    posiciona_agujero()
                        cylinder(d=dagujero, h=chapa[2]*1.01, center=true);
            }
        }
    translate([0, base[1]/2+chapa[1]/2+yoffset, 0]) {
        difference() {
            cube(base, center=true);
            for (i=[-1, 1])
                translate([-i*8, 0, 0])
                    rotate([90, 0, 0])
                        cylinder(d=dagujero, h=chapa[2]*1.01, center=true);
        }
    }
}

interruptor(adornos=true);
soporte();
