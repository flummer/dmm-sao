/* 
 * Rotary knob for SAO DMM
 *
 * Design: hxr.social/@thomasflummer
 *
 * License: CC-BY-SA
 *
 */

module knob(pcb_spacing, pcb_thickness, extension, diameter, rounding)
{
    difference()
    {
        union()
        {
            translate([0, 0, (pcb_spacing - 0.2)/2])
                cylinder(r = diameter/2 + 1, h = pcb_spacing, center = true, $fn = 200);

            minkowski()
            {
                difference()
                {
                    intersection()
                    {
                        translate([0, 0, (pcb_spacing + pcb_thickness + extension)/2])
                            cylinder(r = diameter/2, h = pcb_spacing + pcb_thickness + extension + 1, center = true, $fn = 200);

                        translate([0, 0, -(pcb_spacing + pcb_thickness + extension)*3])
                            sphere(r = (pcb_spacing + pcb_thickness + extension)*4, $fn = 300);
                    }
                    difference()
                    {
                        translate([0, 0, (pcb_spacing + pcb_thickness + extension)*5-3.7])
                            sphere(r = (pcb_spacing + pcb_thickness + extension)*4 - rounding, $fn = 300);

                        translate([0, 0, 0])
                            cube([diameter + 2, 3, 25], center = true);

                    }
                }
                //sphere(r = rounding, $fn = 15);
            }
        }
        union()
        {
            translate([0, 0, -3/2])
                cube([diameter + 2, diameter + 2, 3], center = true);

            translate([0, 0, (3)/2])
                cylinder(r = 9.5, h = 3.1, center = true, $fn = 200);

            translate([-8.5, 0, 7])
                sphere(d = 1.7, $fn = 30);
                
            for (a = [30, 60, 90, 120, 150, 180])
            {
                translate([0, 0, -0.4])
                rotate(a, [0, 0, 1])
                rotate(90, [1, 0, 0])
                rotate(45, [0, 0, 1])
                    cube([1, 1, 30], center = true);
            }

            for (a = [0 : 15 : 360])
            {
                translate([0, 0, 0])
                rotate(a, [0, 0, 1])
                translate([11.2, 0, 0])
                rotate(45, [0, 0, 1])
                    cube([1, 1, 30], center = true);
            }

        }
    }
    difference()
    {
        union()
        {
            translate([0, 0, (3.2)/2])
                cylinder(d = 4, h = 3.2, center = true, $fn = 50);        
        }
        union()
        {
            translate([0, 3, 5/2])
                cube([3, 3, 5.1], center = true);

            translate([0, -3, 5/2])
                cube([3, 3, 5.1], center = true);
        }
    }
}

/*
color("#222222")
difference()
{
    translate([0, 0, 1.6/2 + 4.3])
        cube([50, 50, 1.6], center = true);
    
    translate([0, 0, 0])
        cylinder(d = 20, h = 20, center = true, $fn = 50);
}
*/

difference()
{
    knob(4.9, 1.6, 2, 9.9*2, 0.6);
    
//    translate([50/2, 0, 0])
//        cube([50, 50, 50], center = true);
}


