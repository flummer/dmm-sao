/* 
 * Button caps for SAO DMM
 *
 * Design: hxr.social/@thomasflummer
 *
 * License: CC-BY-SA
 *
 */

module button(pcb_spacing, pcb_thickness, extension, diameter, rounding)
{
    difference()
    {
        union()
        {
            minkowski()
            {
                intersection()
                {
                    translate([0, 0, (pcb_spacing + pcb_thickness + extension + 1)/2+(pcb_spacing-1.5-0.5)])
                        cylinder(r = diameter/2 - rounding, h = pcb_spacing + pcb_thickness + extension, center = true, $fn = 100);

                    translate([0, 0, 0])
                        sphere(r = pcb_spacing + pcb_thickness + extension - rounding, $fn = 200);
                }
                
                sphere(r = rounding, $fn = 70);
            }

            translate([0, 0, (pcb_spacing)/2])
                cylinder(r = diameter/2 + 0.75, h = pcb_spacing, center = true, $fn = 50);

        }
        union()
        {
            translate([0, 0, 0])
                cube([diameter + 2, diameter + 2, 3], center = true);
        
        }
    }
}

module spacer(pcb_spacing)
{
    difference()
    {
        union()
        {
            hull()
            {
                for (x = [-1, 1])
                {
                    for (y = [-1, 1])
                    {
                        translate([x*(10/2 - 1), y*(7/2 - 1), pcb_spacing/2])
                            cylinder(r = 1, h = pcb_spacing, center = true, $fn = 80);
                    }
                }
            }
        }
        union()
        {
            hull()
            {
                for (x = [-1, 1])
                {
                    for (y = [-1, 1])
                    {
                        translate([x*(7/2 - 1), y*(4/2 - 1), 3/2])
                            cylinder(r = 1.1, h = 3.01, center = true, $fn = 80);
                    }
                }
            }
            
            // side, for boot/reset
            translate([-5, 0, 1.5])
            hull()
            {
                translate([1, 0, 10/2])
                    cube([0.2, 4, 10], center = true);

                translate([0, 0, 10/2])
                    cube([0.2, 2.2, 10], center = true);
            }

            // top for Fn
            translate([0, 7/2, 1.5])
            rotate(-90, [0, 0, 1])
            hull()
            {
                translate([1, 0, 10/2])
                    cube([0.2, 4, 10], center = true);

                translate([0, 0, 10/2])
                    cube([0.2, 2.2, 10], center = true);
            }

        }        
    }
}
if(true)
{
    color("#ffcc00")
    spacer(4.9);
}

if(true)
{
    color("#9977ff")
    union()
    {
        translate([-13, 24, 0])
            button(4.8, 1.6, 1, 4.7, 0.6);

        translate([-13, 24 - 18/2, 0.8/2+1.5])
            cube([2, 18, 0.8], center = true);

        translate([-13/2, 7, 0.8/2+1.5])
            cube([13, 2, 0.8], center = true);

        translate([0, 3.5+4.5/2, 0.8/2+1.5])
            cube([2, 4.5, 0.8], center = true);

        // top for Fn
        translate([0, 7/2, 1.5])
        rotate(-90, [0, 0, 1])
        hull()
        {
            translate([1, 0, 2/2])
                cube([0.1, 4-0.3, 2], center = true);

            translate([0, 0, 2/2])
                cube([0.1, 2, 2], center = true);
        }
    }
}

if(true)
{
    color("#444444")
    union()
    {
        translate([-13, 1, 0])
            button(4.8, 1.6, 0.3, 4.7, 0.6);

        translate([-13, -8, 0])
            button(4.8, 1.6, 0.3, 4.7, 0.6);

        translate([-13, -3.5, 0.8/2+1.5])
            cube([2, 9, 0.8], center = true);

        translate([-13+6/2, -3.5, 0.8/2+1.5])
            cube([6, 2, 0.8], center = true);

        translate([-13+5, -5.5/2+1, 0.8/2+1.5])
            cube([2, 5.5, 0.8], center = true);

        translate([-5-4/2, 0, 0.8/2+1.5])
            cube([4, 2, 0.8], center = true);

        translate([-5, 0, 1.5])
        hull()
        {
            translate([1, 0, 2/2])
                cube([0.1, 4-0.3, 2], center = true);

            translate([0, 0, 2/2])
                cube([0.1, 2, 2], center = true);
        }
    }
}
