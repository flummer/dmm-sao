/* 
 * Case for SAO DMM
 *
 * Design: hxr.social/@thomasflummer
 *
 * License: CC-BY-SA
 *
 */

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
                            cylinder(r = 1, h = 3.01, center = true, $fn = 80);
                    }
                }
            }
            
            // side, for boot/reset
            translate([-5, 0, 1.5])
            hull()
            {
                translate([1, 0, 10/2])
                    cube([0.1, 4, 10], center = true);

                translate([0, 0, 10/2])
                    cube([0.1, 2, 10], center = true);
            }

            // top for Fn
            translate([0, 7/2, 1.5])
            rotate(-90, [0, 0, 1])
            hull()
            {
                translate([1, 0, 10/2])
                    cube([0.1, 4, 10], center = true);

                translate([0, 0, 10/2])
                    cube([0.1, 2, 10], center = true);
            }

        }        
    }
}

spacer(4.9);