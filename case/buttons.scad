/* 
 * Button caps for SAO DMM
 *
 * Design: hxr.social/@thomasflummer
 *
 * License: CC-BY-SA
 *
 */

/*
 * Variables for Customizer
 * ==================================================================
 *
 */

// in mm (usually 1.5 og 2.0mm)
ButtonHeight = 2.0;

 
module button(pcb_spacing, pcb_thickness, button_height, extension, diameter, rounding)
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

            translate([0, 0, (pcb_spacing-0.2)/2])
                cylinder(r = diameter/2 + 0.75, h = pcb_spacing, center = true, $fn = 50);

        }
        union()
        {
            translate([0, 0, -10/2 + button_height])
                cube([diameter + 2, diameter + 2, 10], center = true);
        
        }
    }
}

module spacer(pcb_spacing, button_height)
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
                            cylinder(r1 = 1.2, r2 = 2, h = pcb_spacing, center = true, $fn = 80);
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
            translate([-5, 0, button_height])
            hull()
            {
                translate([0.7, 0, 10/2])
                    cube([0.5, 4, 10], center = true);
                translate([0.7, 0, 10-1/2])
                    cube([0.5, 5, 1], center = true);

                translate([0, 0, 10/2])
                    cube([0.2, 2.2, 10], center = true);
                translate([0, 0, 10-1/2])
                    cube([0.5, 2.5, 1], center = true);
            }

            translate([-6, 0, 10/2 + button_height])
                cube([2, 2.2, 10], center = true);

            // top for Fn
            translate([0, 7/2, button_height])
            rotate(-90, [0, 0, 1])
            hull()
            {
                translate([0.7, 0, 10/2])
                    cube([0.5, 4, 10], center = true);
                translate([0.7, 0, 10-1/2])
                    cube([0.5, 5, 1], center = true);

                translate([0, 0, 10/2])
                    cube([0.2, 2.2, 10], center = true);
                translate([0, 0, 10-1/2])
                    cube([0.5, 2.5, 1], center = true);
            }

            translate([0, 7/2+1, button_height])
            rotate(-90, [0, 0, 1])
            translate([0, 0, 10/2])
                cube([2, 2.2, 10], center = true);

        }        
    }
}

// Black spacer
if(true)
{
    color("#ffcc00")
    spacer(4.9, ButtonHeight);
}

// Purple Fn button
if(true)
{
    color("#9977ff")
    union()
    {
        translate([-13, 26, 0])
            button(4.8, 1.6, ButtonHeight, 1, 4.7, 0.6);

        translate([-13+8/2+1, 26, 0.8/2+ButtonHeight])
            cube([8, 2, 0.8], center = true);

        translate([-5, 26 - 20/2, 0.8/2+ButtonHeight])
            cube([2, 20, 0.8], center = true);

        translate([-5/2, 7, 0.8/2+ButtonHeight])
            cube([5, 2, 0.8], center = true);

        translate([0, 3.5+4.5/2, 0.8/2+ButtonHeight])
            cube([2, 4.5, 0.8], center = true);

        // top for Fn
        translate([0, 7/2, ButtonHeight])
        rotate(-90, [0, 0, 1])
        hull()
        {
            translate([0.7, 0, 2/2])
                cube([0.45, 4-0.3, 2], center = true);

            translate([0, 0, 2/2])
                cube([0.1, 2, 2], center = true);
        }
    }
}

// Black Boot and Reset buttons
if(true)
{
    color("#444444")
    union()
    {
        translate([-13, 1, 0])
            button(4.8, 1.6, ButtonHeight, 0.3, 4.7, 0.6);

        translate([-13, -8, 0])
            button(4.8, 1.6, ButtonHeight, 0.3, 4.7, 0.6);

        translate([-13, -3.5, 0.8/2+ButtonHeight])
            cube([2, 9, 0.8], center = true);

        translate([-13+6/2, -3.5, 0.8/2+ButtonHeight])
            cube([6, 2, 0.8], center = true);

        translate([-13+5, -5.5/2+1, 0.8/2+ButtonHeight])
            cube([2, 5.5, 0.8], center = true);

        translate([-5-4/2, 0, 0.8/2+ButtonHeight])
            cube([4, 2, 0.8], center = true);

        translate([-5, 0, ButtonHeight])
        hull()
        {
            translate([0.7, 0, 2/2])
                cube([0.45, 4-0.3, 2], center = true);

            translate([0, 0, 2/2])
                cube([0.1, 2, 2], center = true);
        }
    }
}
