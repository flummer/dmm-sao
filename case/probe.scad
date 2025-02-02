/* 
 * Probes for SAO DMM
 *
 * Design: hxr.social/@thomasflummer
 *
 * License: CC-BY-SA
 *
 */

module probe(length, diameter)
{
    difference()
    {
        union()
        {
            // top section
            translate([0, 0, length*3/16/2+length*13/16])
                cylinder(d1 = diameter-2*1.5, d2 = 3, h = length*3/16, center = true, $fn = 80);

            translate([0, 0, length/16/2+length*3/4])
                cylinder(d = diameter-2*1.5, h = length/16, center = true, $fn = 80);

            // middle section
            translate([0, 0, length/2/2+length/4])
                cylinder(d = diameter-2*1.5, h = length/2, center = true, $fn = 80);

            // bottom above finger stop
            difference()
            {
                hull()
                {
                    translate([0, 0, length/8/2+length/8])
                        cylinder(d = diameter, h = length/8-1, center = true, $fn = 80);

                    translate([0, 0, length/8/2+length/8])
                        cylinder(d = diameter-1, h = length/8, center = true, $fn = 80);
                }
                for (a = [0 : 30 : 360])
                {
                    translate([0, 0, length*3/16])
                    rotate(a, [0, 0, 1])
                    translate([diameter/2+0.4, 0, 0])
                    rotate(45, [0, 0, 1])
                        cube([1, 1, 30], center = true);
                }                
            }
            // finger stop
            difference()
            {
                hull()
                {
                    translate([0, 0, length/8])
                        cylinder(d = diameter*1.8, h = 0.6, center = true, $fn = 80);

                    translate([0, 0, length/8])
                        cylinder(d = diameter*1.2, h = 2, center = true, $fn = 80);
                }
                
                // space for tip sleeve
                hull()
                {
                    translate([0, 0, length/8/2])
                        cylinder(d = diameter+0.4, h = length/8-2, center = true, $fn = 80);

                    translate([0, 0, length/8/2])
                        cylinder(d = diameter+0.4-2, h = length/8, center = true, $fn = 80);
                }
            }
            // tip below finger stop
            translate([0, 0, length/16/2+length/16])
                cylinder(d = diameter-2*1.5, h = length/16, center = true, $fn = 80);

            translate([0, 0, length/16/2])
                cylinder(d1 = 2, d2 = diameter-2*1.5, h = length/16, center = true, $fn = 80);
        
        }
        union()
        {
            // for holding top sleeve
            translate([0, 0, length*3/4 + length/16/2])
            rotate_extrude($fn = 50)
            translate([diameter/2-0.5-0.2, 0, 0])
                circle(r = 1, $fn = 50);

            // for wire
            translate([0, 0, length*3/4/2+length/4])
                cylinder(d = 2, h = length*3/4+3, center = true, $fn = 80);            

            // for solder connection
            translate([0, 0, length/8/2+length/8])
                cylinder(d = diameter-3, h = length/8-2, center = true, $fn = 80);

            // for pogo pin
            translate([0, 0, length/4/2])
                cylinder(d = 1.4, h = length/4+0.1, center = true, $fn = 80);
            
            translate([0, diameter*5/2, length/2])
                cube([diameter*5, diameter*5, length*1.5], center = true);
            
            // for holding tip sleeve
            translate([0, 0, length/16 + length/16/2])
            rotate_extrude($fn = 50)
            translate([diameter/2-0.5-0.2, 0, 0])
                circle(r = 1, $fn = 50);
        }
    }
}

module top_sleeve(length, diameter)
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    hull()
                    {
                        translate([0, 0, length*3/16/2+length*13/16])
                            cylinder(d1 = diameter, d2 = 3 + 1 * 1.5-1, h = length*3/16, center = true, $fn = 80);

                        translate([0, 0, length*3/16/2+length*13/16-0.5/2])
                            cylinder(d1 = diameter, d2 = 3 + 1 * 1.5, h = length*3/16-0.5, center = true, $fn = 80);
                    }
                    hull()
                    {
                        translate([0, 0, length/16/2+length*3/4+0.5/2])
                            cylinder(d = diameter, h = length/16-0.5, center = true, $fn = 80);

                        translate([0, 0, length/16/2+length*3/4])
                            cylinder(d = diameter-1, h = length/16, center = true, $fn = 80);
                    }
                }
                union()
                {
                    translate([0, 0, length*3/16/2+length*13/16])
                        cylinder(d1 = diameter-2*1.5+0.3, d2 = 3 + 0.2, h = length*3/16 + 0.01, center = true, $fn = 80);

                    translate([0, 0, length/16/2+length*3/4])
                        cylinder(d = diameter-2*1.5+0.3, h = length/16 + 0.01, center = true, $fn = 80);
                }
            }
            intersection()
            {
                translate([0, 0, length/16/2+length*3/4])
                    cylinder(d = diameter, h = length/16, center = true, $fn = 80);

                translate([0, 0, length*3/4 + length/16/2])
                rotate_extrude($fn = 50)
                translate([diameter/2-0.5-0.2, 0, 0])
                    circle(r = 1-0.25, $fn = 50);
            }
        }
        union()
        {
            //translate([0, diameter*5/2, length/2])
            //    cube([diameter*5, diameter*5, length*1.5], center = true);
        
        }
    }
}

module middle_sleeve(length, diameter)
{
    difference()
    {
        union()
        {
            hull()
            {
                translate([0, 0, length/2/2+length/4])
                    cylinder(d = diameter, h = length/2-0.2-1, center = true, $fn = 80);

                translate([0, 0, length/2/2+length/4])
                    cylinder(d = diameter-1, h = length/2-0.2, center = true, $fn = 80);
            }
        }
        union()
        {
            translate([0, 0, length/2/2+length/4])
                cylinder(d = diameter-2*(1.5 - 0.1), h = length/2+0.1, center = true, $fn = 80);

            for (a = [0 : 60 : 360])
            {
                translate([0, 0, length/2])
                rotate(a, [0, 0, 1])
                translate([diameter/2+0.4, 0, 0])
                hull()
                {
                    translate([0, 0, (length/4 - 5)])
                        sphere(r = 1, $fn = 20);

                    translate([0, 0, - (length/4 - 5)])
                        sphere(r = 1, $fn = 20);
                }
            }                
        }
    }   
}

module middle_sleeve_alternative(length, diameter)
{
    difference()
    {
        union()
        {
            hull()
            {
                translate([0, 0, length/2/2+length/4])
                    cylinder(d = diameter, h = length/2-0.2-1, center = true, $fn = 80);

                translate([0, 0, length/2/2+length/4])
                    cylinder(d = diameter-1, h = length/2-0.2, center = true, $fn = 80);
            }
            for (a = [0 : 30 : 360])
            {
                translate([0, 0, length/2])
                rotate(a, [0, 0, 1])
                translate([diameter/2-0.1, 0, 0])
                hull()
                {
                    translate([0, 0, (length/4 - 5)])
                        sphere(r = 0.5, $fn = 20);

                    translate([0, 0, - (length/4 - 5)])
                        sphere(r = 0.5, $fn = 20);
                }
            }                
        }
        union()
        {
            translate([0, 0, length/2/2+length/4])
                cylinder(d = diameter-2*(1.5 - 0.1), h = length/2+0.1, center = true, $fn = 80);
        }
    }   
}

module tip_sleeve(length, diameter)
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    hull()
                    {
                        translate([0, 0, length/32/2 + length*3/32 - 0.1])
                            cylinder(d = diameter+0.4-2, h = length/32, center = true, $fn = 80);

                        translate([0, 0, length/32/2 + length*3/32 - 1 + 0.4 - 0.1])
                            cylinder(d = diameter-0.4, h = length/32, center = true, $fn = 80);

                        translate([0, 0, length/16/2])
                            cylinder(d = 3, h = length/16, center = true, $fn = 80);
                    }
                }
                union()
                {
                    // tip below finger stop
                    translate([0, 0, length/16/2+length/16])
                        cylinder(d = diameter-2*(1.5-0.1), h = length/16, center = true, $fn = 80);

                    translate([0, 0, length/16/2])
                        cylinder(d1 = 2 + 0.1, d2 = diameter-2*(1.5 - 0.1), h = length/16, center = true, $fn = 80);
                }
            }
            intersection()
            {
                translate([0, 0, length/32/2 + length*3/32 - 1 + 0.4 - 0.1])
                    cylinder(d = diameter-0.4, h = length/32, center = true, $fn = 80);

                translate([0, 0, length/16 + length/16/2])
                rotate_extrude($fn = 50)
                translate([diameter/2-0.5-0.2, 0, 0])
                    circle(r = 1-0.25, $fn = 50);
            }
        }
        union()
        {
            //translate([0, diameter*5/2, length/2])
            //    cube([diameter*5, diameter*5, length*1.5], center = true);
        }
    }   
}

LENGHT = 80;
DIAMETER = 8;


color("#999999")
    probe(LENGHT, DIAMETER);
color("#999999")
rotate(180, [0, 0, 1])
    probe(LENGHT, DIAMETER);

color("#999999")
    top_sleeve(LENGHT, DIAMETER);

color("#cc0000")
    middle_sleeve(LENGHT, DIAMETER);

color("#cc0000")
    tip_sleeve(LENGHT, DIAMETER);

