/*
 *  Ardunio Universal Remote
 *  Copyright (C) 2019 Jeff Tickle
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

SLOP=0.5;

DISPLAY_BOARD_WIDTH_OUTER = 62.3;
DISPLAY_BOARD_WIDTH_INNER = 50.8;
DISPLAY_BOARD_HEIGHT = 81.6;
DISPLAY_BOARD_DEPTH = 1.54;
DISPLAY_DEPTH = 3.7;
DISPLAY_WIDTH = 50.2;
DISPLAY_HEIGHT = 69.3;

HOLE_DIAMETER = 3.15;
DISPLAY_MOUNT_RECT_LENGTH = 3.25;
DISPLAY_MOUNT_RECT_WIDTH = 5.00;

BETWEEN_ARDUINO_AND_DISPLAY = 07.0;
BETWEEN_ARDUINO_AND_BOTTOM  = 10.0;

ARDUINO_LENGTH = 33.7;
ARDUINO_WIDTH = 18.6;
ARDUINO_DEPTH = 01.0;
ARDUINO_MAX_DEPTH = 2.1;
ARDUINO_CORNER_WIDTH = 1.5;
ARDUINO_CORNER_LENGTH = 3.0;
ARDUINO_RESET = 3.20;
ARDUINO_CUTOUT = 3.00;

CASE_BORDER = 3.0;
CASE_LIP = 1.00;

DISPLAY_BORDER = 8.00;
BEZEL_TOP_OUT  = DISPLAY_BORDER + CASE_BORDER;
BEZEL_TOP_IN   = 2.40;
BEZEL_TOP_TOT  = BEZEL_TOP_OUT + BEZEL_TOP_IN;
BEZEL_SIDE_OUT = DISPLAY_BORDER + CASE_BORDER;
BEZEL_SIDE_IN  = 2.40;
BEZEL_SIDE_TOT = BEZEL_SIDE_OUT + BEZEL_SIDE_IN;
BEZEL_BOT_OUT  = BETWEEN_ARDUINO_AND_BOTTOM + ARDUINO_LENGTH
               + BETWEEN_ARDUINO_AND_DISPLAY + DISPLAY_BORDER;
BEZEL_BOT_IN   = 8.00;
BEZEL_BOT_TOT  = BEZEL_BOT_OUT + BEZEL_BOT_IN;

SCREEN_WIDTH = DISPLAY_WIDTH - (BEZEL_SIDE_IN * 2);
SCREEN_HEIGHT = DISPLAY_HEIGHT - (BEZEL_TOP_IN + BEZEL_BOT_IN);

POWER_HEIGHT     = 63.4;
POWER_WIDTH      = 37.1;
POWER_DEPTH      = 16.0;
POWER_SW_SQR     = 3.00;
POWER_SW_TOP     = 3.75;
POWER_SW_SIDE    = 8.40;
POWER_WIRE_HOLE  = 8.00;
POWER_TOP_DEPTH  = 6.00;
POWER_TOP_SLIDE  = 1.50;
POWER_LIP_WIDTH  = 12.0;
POWER_LIP_HEIGHT = 4.50;

TOTAL_DEPTH = DISPLAY_DEPTH + DISPLAY_BOARD_DEPTH + 0.5;

CASE_WIDTH = CASE_BORDER*2 + BEZEL_SIDE_TOT*2 + SCREEN_WIDTH;
CASE_HEIGHT = CASE_BORDER*2 + BEZEL_TOP_TOT + BEZEL_BOT_TOT + SCREEN_HEIGHT;

PIN_BELOW = 3.00;
PIN_BASE = 2.55;
PIN_DIM = 1.00;
PIN_ANGLE_HEIGHT = 2.00;
PIN_ANGLE_LEN = 9.00;
PIN_STRAIGHT_HEIGHT = 6.00;
SHROUD_LENGTH = 14.1;

SCREW_LEN = 9.80;
SCREW_HEAD_DEPTH = 3.00;
SCREW_HEAD_DIAM = 8.00;
SCREW_THREAD_OUTER_D = 4.00;
SCREW_THREAD_INNER_D = 3.10;

HEATSET_BIG_D = 6.4;
HEATSET_SMALL_D = 5.84;
HEATSET_HEIGHT = 4.8;

SCREEN_CENTER = [
    CASE_WIDTH / 2,
    CASE_HEIGHT - CASE_BORDER - BEZEL_TOP_TOT - (SCREEN_HEIGHT / 2)
];

module drawStraightPin(cutout = false, xtralen = 0.0) {
    if(cutout) {
        dx = -(PIN_BASE/2 + SLOP);
        sx = PIN_BASE + (SLOP * 2);
        
        translate([dx, dx, -(PIN_BELOW + SLOP)]) {
            cube([sx, sx, PIN_BELOW + PIN_BASE + SHROUD_LENGTH + SLOP + xtralen]);
        }
    } else {
        
        dim = (PIN_BASE - PIN_DIM) / 2;
        translate([-PIN_BASE/2, -PIN_BASE/2, 0]) {
            
            // Pin
            translate([dim, dim, -PIN_BELOW]) {
                cube([PIN_DIM, PIN_DIM, PIN_BELOW + PIN_BASE + PIN_STRAIGHT_HEIGHT + xtralen]);
            }
            
            // Plastic Guide
            cube([PIN_BASE, PIN_BASE, PIN_BASE]);
        }
    }
}

module drawAnglePin(cutout = false, xtralen = 0.0) {
    if(cutout) {
        dx = -(PIN_BASE/2 + SLOP);
        sx = PIN_BASE + SLOP*2;
        hull() {
            translate([dx, dx, -(PIN_BELOW + SLOP)]) {
                cube([sx, sx, PIN_BELOW + PIN_BASE + PIN_ANGLE_HEIGHT + SLOP*2]);
            }
            translate([dx, dx, PIN_BASE + PIN_ANGLE_HEIGHT + PIN_DIM/2 - PIN_BASE/2 - SLOP]) {
                cube([sx, PIN_BASE/2 + SLOP + PIN_ANGLE_LEN, sx]);
            }
        }
        translate([dx, dx, PIN_BASE + PIN_ANGLE_HEIGHT + PIN_DIM/2 - PIN_BASE/2 - SLOP]) {
            cube([sx, PIN_BASE/2 + SLOP + SHROUD_LENGTH + xtralen, sx]);
        }
    } else {
        dim = (PIN_BASE - PIN_DIM) / 2;
        translate([-PIN_BASE/2, -PIN_BASE/2, 0]) {
            
            // Straight Part
            translate([dim, dim, -PIN_BELOW]) {
                cube([PIN_DIM, PIN_DIM, PIN_BELOW + PIN_BASE + PIN_ANGLE_HEIGHT]);
            }
            
            // Bent Over Part
            translate([dim, dim, PIN_BASE + PIN_ANGLE_HEIGHT]) {
                cube([PIN_DIM, PIN_ANGLE_LEN + xtralen, PIN_DIM]);
            }
            
            // Plastic Guide
            cube([PIN_BASE, PIN_BASE, PIN_BASE]);
        }
    }
}

module drawManyPins(count, flip = false) {
    for(pin = [0 : count - 1]) {
        translate([PIN_BASE * pin, 0, 0]) {
            rotate([180, 0, 0]) {
                if(flip) {
                    mirror([0, 1, 0]) children();
                } else {
                    children();
                }
            }
        }
    }
}


module drawDisplayMount() {
    
    circle_tx = [DISPLAY_MOUNT_RECT_WIDTH / 2, 0, 0];
    difference() {
        
        // Draw the general shape
        union() {
            square([DISPLAY_MOUNT_RECT_WIDTH,
                    DISPLAY_MOUNT_RECT_LENGTH]);
            translate(circle_tx) {
                    circle(d = DISPLAY_MOUNT_RECT_WIDTH, $fn = 25);
                }
        }
        
        // Subtract the screw hole
        translate(circle_tx) {
            circle(d = HOLE_DIAMETER, $fn = 25);
        }
    }
}

module drawDisplayMountSide() {
    drawDisplayMount();
    translate([DISPLAY_BOARD_HEIGHT - DISPLAY_MOUNT_RECT_WIDTH, 0, 0]) {
        drawDisplayMount();
    }
}

module drawDisplayModule(cutout=false, pins=true) {
    translate([DISPLAY_MOUNT_RECT_LENGTH + (DISPLAY_MOUNT_RECT_WIDTH / 2), 0, 0]) {
        union() {
            if(cutout) {
                translate([-SLOP*2, 0, -2.5])
                    cube([DISPLAY_BOARD_WIDTH_INNER + SLOP*4, DISPLAY_BOARD_HEIGHT - 5, 2.5]);
            }
            linear_extrude(height = DISPLAY_BOARD_DEPTH) {
                union() {
                    if(cutout) {
                        translate([-1, -1]) {
                            // Display board inner portion with wiggle room
                            square([DISPLAY_BOARD_WIDTH_INNER + 2,
                                    DISPLAY_BOARD_HEIGHT + 2]);
                            
                            // Display board mounts with wiggle room
                            msq = DISPLAY_MOUNT_RECT_WIDTH + 2;
                            translate([-(DISPLAY_MOUNT_RECT_LENGTH + (DISPLAY_MOUNT_RECT_WIDTH/2)), 0, 0]) {
                                for(x=[0:1]) {
                                    for(y=[0:1]) {
                                        translate([x * (DISPLAY_BOARD_WIDTH_OUTER - msq + 2),
                                                   y * (DISPLAY_BOARD_HEIGHT - msq + 2)]) {
                                            square([msq, msq]);
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                    
                        // Display Board inner portion
                        square([DISPLAY_BOARD_WIDTH_INNER,
                               DISPLAY_BOARD_HEIGHT]);
                        
                        // Display Board Mounts - right side
                        if(cutout) {
                        } else {
                            translate([DISPLAY_BOARD_WIDTH_INNER + DISPLAY_MOUNT_RECT_LENGTH, 0, 0]) {
                                rotate([0, 0, 90]) {
                                    drawDisplayMountSide();
                                }
                            }
                        }
                        
                        // Display Board Mounts - left side
                        if(cutout) {
                        } else {
                            translate([0 - DISPLAY_MOUNT_RECT_LENGTH, DISPLAY_BOARD_HEIGHT, 0]) {
                                rotate([0, 0, 270]) {
                                    drawDisplayMountSide();
                                }
                            }
                        }
                    }
                }
            }
            translate([DISPLAY_BOARD_WIDTH_INNER/2 - DISPLAY_WIDTH/2,(DISPLAY_BOARD_HEIGHT - DISPLAY_HEIGHT) / 2,DISPLAY_BOARD_DEPTH]) {
                if(cutout) {
                    translate([-SLOP, -SLOP, -0.01]){
                        cube([DISPLAY_WIDTH + SLOP*2,
                              DISPLAY_HEIGHT + SLOP*2,
                              DISPLAY_DEPTH + SLOP]);
                        translate([BEZEL_SIDE_IN, BEZEL_BOT_IN, DISPLAY_DEPTH])
                            cube([SCREEN_WIDTH, SCREEN_HEIGHT, 10]);
                    }
                } else {
                        
                    difference() {
                        // Display Module
                        cube([DISPLAY_WIDTH,
                              DISPLAY_HEIGHT,
                              DISPLAY_DEPTH]);
                        
                        // Subtract to show Screen borders
                        translate([BEZEL_SIDE_IN, BEZEL_BOT_IN,
                                   DISPLAY_DEPTH - 0.1])
                            cube([SCREEN_WIDTH,
                                  SCREEN_HEIGHT,
                                  10]);
                    }
                }
            }
        }
        
        // Draw Pins
        if(pins || cutout) {
            translate([DISPLAY_BOARD_WIDTH_INNER/2 - (20*PIN_BASE)/2 + PIN_BASE/2, DISPLAY_MOUNT_RECT_WIDTH/2, 0]) {
                drawManyPins(20) {
                    drawAnglePin(cutout=cutout);
                }
            }
        }
    }
}

module translateForDisplayModule() {
    translate([BEZEL_SIDE_OUT - CASE_BORDER, BEZEL_BOT_OUT - CASE_BORDER, 1.00]) {
        children();
    }
}

module absoluteDrawDisplayModule(cutout = false, pins = true) {
    translateForDisplayModule() {
        drawDisplayModule(cutout, pins);
    }
}


module drawScreenCenter() {
    translate([SCREEN_CENTER[0], SCREEN_CENTER[1], 0]) {
        cylinder(10, r=1);
    }
}


module drawPowerSlideLid(length=POWER_TOP_SLIDE, extra=0) {
    lip_dist = (POWER_WIDTH/2) - (POWER_LIP_WIDTH/2);
    
    translate([extra, 0, extra]) {
        rotate([90, 0, 0]) {
            linear_extrude(length) {
                polygon([[0-extra, 0-extra],
                         [0-extra, POWER_TOP_DEPTH+extra],
                         [lip_dist-extra, POWER_TOP_DEPTH+extra],
                         [lip_dist-extra, POWER_TOP_DEPTH + POWER_LIP_HEIGHT+extra],
                         [lip_dist+extra + POWER_LIP_WIDTH, POWER_TOP_DEPTH+extra + POWER_LIP_HEIGHT],
                         [lip_dist+extra + POWER_LIP_WIDTH, POWER_TOP_DEPTH+extra],
                         [POWER_WIDTH+extra, POWER_TOP_DEPTH+extra],
                         [POWER_WIDTH+extra, 0-extra]]);
            }
        }
    }
}


module drawPowerModuleSlideCutout() {
    M = [[1, 0, 0  , 0],
         [0, 1, 0  , 0],
         [0, 1.2, 1  , 0],
         [0, 0, 0  , 1]];
    translate([0, 0, POWER_TOP_SLIDE/2+1.1]) {
        multmatrix(M) {
            drawPowerSlideLid(15, extra=SLOP);
        }
    }
}

module drawPowerModule(cutout=false) {
    translate([cutout?-SLOP:0, cutout?-SLOP:0, cutout?-1:0]) {
        
        // Power Module plus a bonus mm to cut clean through
        cube([POWER_WIDTH + (cutout?SLOP*2:0),
              POWER_HEIGHT + (cutout?SLOP*2:0),
              POWER_DEPTH + (cutout?1:0)]);
            
        // Sliding Lid Edge
        drawPowerSlideLid(extra=cutout?SLOP:0);
        
        if(cutout) {
            // Big space for power switch (stuck in on-position)
            translate([POWER_SW_SIDE - 1, POWER_SW_TOP - 1, POWER_DEPTH - 1]) {
                cube(POWER_SW_SQR + 2);
            }
            
            // Space for Power Module Wiring
            translate([POWER_WIDTH - 5.67, 0, POWER_DEPTH - 5.67 + 1]) {
                rotate([90, 0, 0]) cylinder(h=10, d=4, $fn=4);
            }
            
            // Space for Sliding Lid
            // This matrix has to do with skew
            drawPowerModuleSlideCutout();
            
        } else {
            // Power Switch (stuck in on-position)
            translate([POWER_SW_SIDE, POWER_SW_TOP, POWER_DEPTH - 1]) {
                cube(POWER_SW_SQR);
            }
            
            // Wiring
            translate([POWER_WIDTH - 3.67, -1, POWER_DEPTH - 3.67]) {
                rotate([-90, 180, 0]) {
                    drawManyPins(2) {
                        drawStraightPin();
                    }
                }
            }
        }
    }
}

module translateForPowerModule() {
    translate([CASE_WIDTH/2 - POWER_WIDTH/2, CASE_HEIGHT - POWER_HEIGHT - 15, -POWER_DEPTH - 2.7]) {
        children();
    }
}

module absoluteDrawPowerModule(cutout=false) {
    translateForPowerModule() {
        drawPowerModule(cutout=cutout);
    }
}


module drawArduino(cutout=false, pins=false, xtralen_prog = 0, xtralen_side = 0) {
        
    // The arduino board is just a really flat cube.
    cube([ARDUINO_WIDTH, ARDUINO_LENGTH, ARDUINO_DEPTH]);
    
    chip_support_base = PIN_BASE * 7.0 + SLOP;
    chip_support_length = PIN_BASE * 2;
    upper_base = chip_support_base + chip_support_length;
    upper_length = ARDUINO_LENGTH - upper_base;
    
    // If this is a cutout, add negative supports and a reset button hole
    if(cutout) {
        // Space above programming side of the board
        translate([PIN_BASE, 0, ARDUINO_DEPTH]) {
            cube([ARDUINO_WIDTH - PIN_BASE*2,
                  chip_support_base, ARDUINO_MAX_DEPTH + 1]);
        }
        

        // Contact area for atmega chip
        translate([PIN_BASE, chip_support_base, 0]) {
            cube([ARDUINO_WIDTH - PIN_BASE*2,
                  chip_support_length, ARDUINO_MAX_DEPTH]);
        }
        
        // Space above reset side of board
        translate([PIN_BASE, upper_base, ARDUINO_DEPTH]) {
            cube([ARDUINO_WIDTH - PIN_BASE*2,
                  upper_length, ARDUINO_MAX_DEPTH + 1]);
        }
    
        // Reset Hole
        translate([ARDUINO_WIDTH / 2, ARDUINO_LENGTH - ARDUINO_RESET, 0]) {
            cylinder(25, d=2.00, $fn=8);
        }
    }
    
    if(pins || cutout) {
        // Programming Pins
        translate([PIN_BASE/2 + (ARDUINO_WIDTH/2 - PIN_BASE*3), PIN_BASE / 2, 0]) {
            drawManyPins(6) {
                drawAnglePin(cutout=cutout, xtralen=xtralen_prog);
            }
        }
        
        // Side Pins
        translate([PIN_BASE/2, ARDUINO_LENGTH - PIN_BASE/2, 0]) {
            for(i = [0 : 1]) {
                translate([i * (ARDUINO_WIDTH - PIN_BASE), 0, 0]) {
                    rotate([0, 0, 270]) {
                        drawManyPins(4, flip = i == 1) {
                            drawAnglePin(cutout=cutout, xtralen=xtralen_side);
                        }
                        translate([PIN_BASE * 6, 0, 0]) {
                            drawManyPins(3, flip = i == 1) {
                                drawAnglePin(cutout=cutout, xtralen=xtralen_side);
                            }
                        }
                    }
                }
            }
        }
    }
}

module translateForArduino() {
    translate([(CASE_WIDTH / 2) + (ARDUINO_WIDTH / 2),
               BETWEEN_ARDUINO_AND_BOTTOM,
               -POWER_DEPTH + 4]) {
        rotate([0, 180, 0]) children();
    }
}
module absoluteDrawArduino(pins=true, cutout=false, xtralen_prog=0, xtralen_side=0) {
    translateForArduino() {
        drawArduino(pins=pins, cutout=cutout,
            xtralen_prog=xtralen_prog, xtralen_side=xtralen_side);
    }
}


module drawLED(cutout=false) {
    rotate([270, 0, 0]) {
        
        // Main LED Cylinder
        cylinder(6.0, d=5.0 + SLOP, $fn=30);
        
        // LED Round Hed
        translate([0, 0, 6.0]) sphere(d=5.0 + SLOP, $fn=30);
        
        // Notched LED Base Cylinder for mounting
        translate([0, 0, -SLOP/2]){
            difference() {
                cylinder(1 + SLOP, d=6.0 + SLOP, $fn=30);
                translate([2.5 + SLOP/2, -3, 0]) {
                    cube([3, 6, 3]);
                }
            }
        }
        
        /*translate([-PIN_BASE/2, 0, -PIN_BELOW - SLOP]) {
            drawManyPins(2) {
                drawStraightPin(cutout=cutout);
            }
        }*/
        
        if(cutout) {
            // LED Transmit Opening
            translate([0, 0, 6.0]) {
                cylinder(10, d1=5, d2=50);
            }
            
            // Space for LED Leads
            cube([4, 2, 8], center=true);
        }
    }
}

module translateForLED() {
    translate([CASE_WIDTH/2, CASE_HEIGHT - 7.5, -5]) {
        children();
    }
}

module absoluteDrawLED(cutout=false) {
    translateForLED() {
        drawLED(cutout);
    }
}



module actuallyDrawHeatset(cutout=false) {
    translate([0, 0, -(SCREW_LEN - SCREW_HEAD_DEPTH)]) {
        rotate([0, 0, 90]) {
            // Heat-Set Insert
            translate([0, 0, SCREW_LEN - HEATSET_HEIGHT])
                cylinder(HEATSET_HEIGHT,
                         d1=HEATSET_BIG_D,
                         d2=HEATSET_SMALL_D);
            
            if(cutout) {
                // Chamfer for Insert
                translate([0, 0, SCREW_LEN - HEATSET_HEIGHT])
                    cylinder(1,
                            d1=HEATSET_BIG_D+1,
                            d2=HEATSET_BIG_D-1);
            }
        }
    }
}

module drawHeatset(cutout=false) {
    if(cutout) {
        actuallyDrawHeatset(cutout=cutout);
    } else {
        difference() {
            actuallyDrawHeatset(cutout=cutout);
            translate([0, 0, 1]) drawScrew(cutout=cutout);
        }
    }
}

module drawScrew(cutout=false, extendHoriz=false, $fn=24) {
    translate([0, 0, -(SCREW_LEN - SCREW_HEAD_DEPTH) - 1.0]) {
        rotate([0, 0, 90]) {
            // Threaded Portion
            cylinder(SCREW_LEN,
                     d=SCREW_THREAD_OUTER_D + (cutout?SLOP:0));
            
            // Head Portion
            translate([0, 0, 0]) {
                cylinder(SCREW_HEAD_DEPTH,
                         d1=SCREW_HEAD_DIAM + (cutout?SLOP:0),
                         d2=SCREW_THREAD_OUTER_D + (cutout?SLOP:0));
            }
            
            // Screw Channel (for cutout)
            if(cutout) {
                translate([0, 0, -20]) {
                    cylinder(20, d=SCREW_HEAD_DIAM + SLOP);
                    if(extendHoriz) {
                        translate([-5, 0, 0]) {
                            cube([SCREW_HEAD_DIAM + SLOP, 20, 20]);
                        }
                    }
                }
            }
            
            // Extend Screw Channel outward
            /*if(cutout && extendHoriz) {
                translate([0, 10, 0]) {
                    rotate([90, 0, 0]) {
                        linear_extrude(20, center=true) {
                            polygon([[-SCREW_THREAD_OUTER_D/2, SCREW_HEAD_DEPTH],
                                     [ SCREW_THREAD_OUTER_D/2, SCREW_HEAD_DEPTH],
                                     [ SCREW_HEAD_DIAM/2, 0],
                                     [-SCREW_HEAD_DIAM/2, 0]]);
                                     
                        }
                    }
                }
            }*/
        }
    }
}

module drawScrewSide() {
    children();
    translate([0, 70, 0]) {
        children();
    }
}

module drawScrews() {
    translate([8.5, 30, 1.5]) {
        drawScrewSide()
            children();
        translate([DISPLAY_BOARD_WIDTH_OUTER - 1, 0, 0])
            mirror([-1, 0, 0])
                drawScrewSide()
                    children();
    }
}

module absoluteDrawScrews(cutout=false, extendHoriz=false) {
    drawScrews()
        drawScrew(cutout=cutout, extendHoriz=extendHoriz);
}

module absoluteDrawHeatsets(cutout=false) {
    drawScrews()
        drawHeatset(cutout=cutout);
}


module drawTaperSlicer(horiz=false) {
    if(horiz) {
        rotate([0, 0, -90])
            translate([-sqrt(200), 0, sqrt(200)])
                rotate([0, 45, 0])
                    cube([20, CASE_WIDTH, 20]);
    } else {
        translate([-sqrt(200), 0, sqrt(200)])
            rotate([0, 45, 0])
                cube([20, CASE_HEIGHT, 20]);
    }
}

module drawTopTaper(cutout=false) {
    if(cutout) {
        union() {
            drawTaperSlicer(false);
            drawTaperSlicer(true);
            translate([CASE_WIDTH, 0, 0]) drawTaperSlicer(false);
            translate([0, CASE_HEIGHT, 0]) drawTaperSlicer(true);
        }
    }
}

module translateForTopTaper() {
    translate([0, 0, 0]) children();
}



module absoluteDrawTopTaper(cutout=false) {
    translateForTopTaper() drawTopTaper(cutout=cutout);
}

module drawWiringSpace(cutout=false) {
    if(cutout) {
        // Wiring for display and arduino
        difference() {
            union() {
                cube([DISPLAY_BOARD_WIDTH_INNER + SLOP*4, ARDUINO_LENGTH + 15, POWER_DEPTH + 1]);
                cube([DISPLAY_BOARD_WIDTH_INNER + SLOP*4, ARDUINO_LENGTH + 24, POWER_DEPTH - 3]);
            }
            translate([DISPLAY_BOARD_WIDTH_INNER/2 + 1, ARDUINO_LENGTH/2 + 12, SLOP/2 + 0.1]) {
                cylinder(h=POWER_DEPTH+1, d=10, $fn=12);
            }
            
        }
            
        // Side Channels
        translate([0, CASE_BORDER + ARDUINO_LENGTH + 20, -3]) {
            cube([5, DISPLAY_BOARD_HEIGHT - 4, POWER_DEPTH - 3.6]);
            translate([DISPLAY_BOARD_WIDTH_INNER - 3, 0, 0]) {
                cube([5, DISPLAY_BOARD_HEIGHT - 4, POWER_DEPTH - 3.6]);
            }
        }
        
        // Area for LED Wiring
        translate([0, ARDUINO_LENGTH + 14 + DISPLAY_BOARD_HEIGHT, -3]) {
            cube([DISPLAY_WIDTH, BEZEL_TOP_TOT - 9, POWER_DEPTH - 3.6]);
            cube([DISPLAY_WIDTH/2 - 4.5, BEZEL_TOP_TOT - 8, POWER_DEPTH - 3.6]);
            translate([DISPLAY_WIDTH/2 + 7.1, 0]) {
                cube([DISPLAY_WIDTH/2 - 4.5, BEZEL_TOP_TOT - 8, POWER_DEPTH - 3.6]);
            }
            translate([0, 0, 10-SLOP/2])
                cube([DISPLAY_WIDTH, BEZEL_TOP_TOT - 8.2, 2.57]);
        }
    }
}


module translateForWiringSpace() {
    translate([CASE_WIDTH/2 - DISPLAY_BOARD_WIDTH_INNER/2 - SLOP*2, 4, -POWER_DEPTH + ARDUINO_DEPTH + 2.99]) {
        children();
    }
}

module absoluteDrawWiringSpace(cutout=false) {
    if(cutout) {
        difference() {
            translateForWiringSpace() {
                drawWiringSpace(cutout=cutout);
            }
            translate([-SLOP, -3-SLOP, 3.75-SLOP])
                translateForPowerModule()
                    drawPowerModuleSlideCutout();
            translate([0, 0, -3]) drawTaperSlicer(true);
            drawUpperMountExt(h=100, z=-20);
        }
    }
}

module drawBorderPiece(horiz=false, expand=false) {
    vsize = 6 + (expand ? SLOP/2 : 0);
    hsize = 4 + (expand ? SLOP : 0); 
    translate([0, 0, -(vsize-1)]) {
        if(horiz) {
            cube([CASE_WIDTH, hsize, vsize]);
        } else {
            cube([hsize, CASE_HEIGHT, vsize]);
        }
    }
}

module drawUpperMountExt(z = 0, h = 100.0, extra = 0) {
    translate([0, 0, z])
        drawScrews()
            cylinder(h=h, d=SCREW_HEAD_DIAM + 4 + extra);
}

module drawInnerBorder(expand = false) {
    difference() {
        union() {
            // Left
            drawBorderPiece(horiz=false, expand=expand);
            // Bottom
            drawBorderPiece(horiz=true, expand=expand);
            // Right
            translate([CASE_WIDTH, 0, 0])
                mirror([1, 0, 0])
                    drawBorderPiece(horiz=false, expand=expand);
            // Top
            translate([0, CASE_HEIGHT, 0])
                mirror([0, 1, 0])
                    drawBorderPiece(horiz=true, expand=expand);
            // Arduino Pressure Stub
            translate([CASE_WIDTH/2,
                       ARDUINO_LENGTH/2 + 16,
                       -POWER_DEPTH + 4 + SLOP/2])
                cylinder(h=POWER_DEPTH-2, d=14, $fn=12);
            // LED Pressure Stub
            difference() {
                translate([CASE_WIDTH/2 - 5 - (expand?SLOP/2:0),
                           CASE_HEIGHT - CASE_BORDER - 3.5 - (expand?SLOP/2:0),
                           -5 - (expand?SLOP/2:0)])
                    cube([10 + (expand?SLOP:0),
                           5 + (expand?SLOP:0),
                           6 + (expand?SLOP/2:0)]);
                absoluteDrawLED(cutout=true);
            }
        }
        drawUpperMountExt(z=-10, h=8.20, extra=expand?0:SLOP);
    }
}

module drawTop() {
    
    cover = 0.50;
    
    translate([0, 0, 1.0])
        cube([CASE_WIDTH, CASE_HEIGHT, 6.3]);
    
    drawUpperMountExt(h = 2.0, z = -1.8);
    
    drawInnerBorder();

}

module drawMiddle() {
    width = CASE_WIDTH;
    height = CASE_HEIGHT;
    difference() {
        translate([0, 0, -2.3])
            cube([width, height, 3]);
            drawUpperMountExt(h = 2.0, z = -1.8, extra = SLOP);
        drawInnerBorder(expand=true);
    }
}


module drawBottom() {
    // Two big blocks are the general shape plus lip to match
    // with first layer
    difference() {
        translate([0, 0, -POWER_DEPTH - 2.7]) {
            translate([CASE_LIP, CASE_LIP, 0]) {
                cube([CASE_WIDTH - CASE_LIP*2, CASE_HEIGHT - CASE_LIP*2, POWER_DEPTH]);
            }
            cube([CASE_WIDTH, CASE_HEIGHT, POWER_DEPTH - 2]);
        }
        drawInnerBorder(expand=true);
    }
}


module select(which) {
    children(which);
}

defaultParts=[0, 1, 2, 3, 4, 5, 6, 7];
defaultUnits=[0, 1, 2];
UNIT_TOP=0;
UNIT_MIDDLE=1;
UNIT_BOTTOM=2;
PART_DISPLAY=0;
PART_ARDUINO=1;
PART_LED=2;
PART_POWER_MODULE=3;
PART_SCREWS=4;
PART_HEATSETS=5;
PART_WIRING_SPACE=6;
PART_TOP_TAPER=7;
module drawParts(cutout=false, which = defaultParts) {
    select(which) {
        absoluteDrawDisplayModule(cutout=cutout);
        absoluteDrawArduino(cutout=cutout, pins=true);
        absoluteDrawLED(cutout=cutout);
        absoluteDrawPowerModule(cutout=cutout);
        absoluteDrawScrews(cutout=cutout);
        absoluteDrawHeatsets(cutout=cutout);
        absoluteDrawWiringSpace(cutout=cutout);
        absoluteDrawTopTaper(cutout=cutout);
    }
}


module showUnitIntersections(which = [0, 1]) {
    select(which) {
        intersection() {
            drawTop();
            drawMiddle();
        }
        intersection() {
            drawMiddle();
            drawBottom();
        }
    }
}

module translateForExploded(z) {
    translate([0, 0, z]) {
        children();
    }
}

module translateAndCutoutForExploded(z, whichCutout) {
    translateForExploded(z) {
        difference() {
            intersection() {
                children();
                translate([CASE_WIDTH / 2, 0, 0]) {
                    rotate([270, 0, 0]) {
                        cylinder(CASE_HEIGHT, d = CASE_WIDTH, $fn=120);
                    }
                }
            }
            drawParts(cutout=true, which=whichCutout);
        }
    }
}

module drawWholeUnit(coeff = 0, whichUnit = defaultUnits, whichPart = defaultParts, whichCutout = defaultParts) {
    
    // Draw Units
    select(whichUnit) {
        translateAndCutoutForExploded(coeff * 6, whichCutout) drawTop();
        translateAndCutoutForExploded(coeff * 3, whichCutout) drawMiddle();
        translateAndCutoutForExploded(coeff * 1, whichCutout) drawBottom();
    }
    
    select(whichPart) {
        translateForExploded(coeff * 4) absoluteDrawDisplayModule(pins=true);
        translateForExploded(coeff * 2) absoluteDrawArduino(pins=true);
        translateForExploded(coeff * 2) absoluteDrawLED();
        translateForExploded(coeff * 0) absoluteDrawPowerModule();
        translateForExploded(coeff * 0) absoluteDrawScrews();
        translateForExploded(coeff * 5) absoluteDrawHeatsets();
    }
        
}

module showPartIntersections(whichUnit = defaultUnits, whichPart = defaultParts) {
    intersection() {
        drawWholeUnit(whichUnit=whichUnit, whichPart=[]);
        drawParts(whichPart=whichPart);
    }
}

// Disable for printing
*difference() {
    absoluteDrawWiringSpace(cutout=true);
    drawParts(cutout=true, which=[0,1,2,3,4,5,7]);
}

// Disable for printing
*difference() {
    drawWholeUnit(0, whichUnit=[0,1,2], whichPart=[0,1,2,3,4,5,6,7]);
    translate([-100, -170, -100])
        cube([200, 200, 200]);
}

// Disable for printing
*drawScreenCenter();

// Ensure individual sections are not intersecting
// Disable for printing
*showUnitIntersections();

// Ensure parts are not intersecting with the model
// Disable for printing
*showPartIntersections();

// THIS IS THE ONLY THING TO ENABLE WHEN PRINTING
drawWholeUnit(
// Set the spacing for exploded view.
// Maybe set to 0 for printing?
coeff=0,
// Select one or more layers below.
// They are arranged for easy commenting-out.
whichUnit = [
//UNIT_TOP,
//UNIT_MIDDLE,
UNIT_BOTTOM,
],
// Select one or more parts below.
// Comment out all for printing.
,whichPart = [
//PART_DISPLAY,
//PART_ARDUINO,
//PART_LED,
//PART_POWER_MODULE,
//PART_SCREWS,
//PART_HEATSETS,
]
);
