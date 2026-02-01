SCREEN_WIDTH = 45.6;
SCREEN_HEIGHT = 58.3;
HOLE_DIAMETER = 3.15;
DISPLAY_BOARD_WIDTH_OUTER = 62.3;
DISPLAY_BOARD_WIDTH_INNER = 50.8;
DISPLAY_BOARD_HEIGHT = 81.6;
DISPLAY_BOARD_DEPTH = 0.50;
DISPLAY_DEPTH = 3.7;
DISPLAY_WIDTH = 50.2;
DISPLAY_HEIGHT = 69.3;

DISPLAY_MOUNT_RECT_LENGTH = 3.25;
DISPLAY_MOUNT_RECT_WIDTH = 5.00;

BEZEL_TOP = 10.00;
BEZEL_LEFT = 8.70;
BEZEL_BOTTOM = 13.3;
BEZEL_RIGHT = 8.70;

TOTAL_DEPTH = DISPLAY_DEPTH + DISPLAY_BOARD_DEPTH + 0.5;

SCREEN_CENTER = [
    DISPLAY_BOARD_WIDTH_OUTER / 2,
    (DISPLAY_BOARD_HEIGHT / 2) + (BEZEL_BOTTOM - BEZEL_TOP)
];

// Clipped Draw Side
module drawSide(height, width, length) {
    intersection() {
        rotate([90, 0, 0]) {
            linear_extrude(
                height = length) {
                    polygon([
                             [0.00, -1.00],
                             [0.00, 2.00],
                             [height - 2.00, height],
                             [width - 1.00, height],
                             [width, height - 0.50],
                             [height - 3.00 + sqrt(2), height - 0.50],
                             [1.00, sqrt(2)],
                             [1.00, 0.00],
                             [0.50, 0.00],
                             [0.50, -1.00]]);
            }
                //linear_extrude(
                //    height = height * 2,
                //    center=true) {

                //}
            //}
        }
        linear_extrude(height = height * 3, center = true) {
            polygon([[0, 0],
                     [height - 2, -(height - 2)],
                     [width, -(height - 2)],
                     [width, -(length - (height - 2))],
                     [height - 2, -(length - (height - 2))],
                     [0, -length]]);
        }
    }
}

module drawDisplayMount() {
    circle_tx = [DISPLAY_MOUNT_RECT_WIDTH / 2, 0, 0];
    difference() {
        union() {
            square([DISPLAY_MOUNT_RECT_WIDTH,
                    DISPLAY_MOUNT_RECT_LENGTH]);
            translate(circle_tx) {
                    circle(d = DISPLAY_MOUNT_RECT_WIDTH, $fn = 25);
                }
        }
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

module drawDisplayModule() {
    translate([DISPLAY_MOUNT_RECT_LENGTH + (DISPLAY_MOUNT_RECT_WIDTH / 2), 0, 0]) {
        union() {
            linear_extrude(height = DISPLAY_BOARD_DEPTH) {
                    union() {
                        square([DISPLAY_BOARD_WIDTH_INNER,
                               DISPLAY_BOARD_HEIGHT]);
                        translate([DISPLAY_BOARD_WIDTH_INNER + DISPLAY_MOUNT_RECT_LENGTH, 0, 0]) {
                            rotate([0, 0, 90]) {
                                drawDisplayMountSide();
                            }
                        }
                        translate([0 - DISPLAY_MOUNT_RECT_LENGTH, DISPLAY_BOARD_HEIGHT, 0]) {
                            rotate([0, 0, 270]) {
                                drawDisplayMountSide();
                            }
                        }
                    }
            }
            translate([0,(DISPLAY_BOARD_HEIGHT - DISPLAY_HEIGHT) / 2,DISPLAY_BOARD_DEPTH]) {
                difference() {
                    cube([DISPLAY_BOARD_WIDTH_INNER,
                          DISPLAY_HEIGHT,
                          DISPLAY_DEPTH]);
                    translate([(DISPLAY_BOARD_WIDTH_INNER / 2) - (SCREEN_WIDTH / 2),
                               (DISPLAY_HEIGHT / 2) - (SCREEN_HEIGHT / 2) + BEZEL_BOTTOM - BEZEL_TOP,
                               DISPLAY_DEPTH - 0.1]) {
                        cube([SCREEN_WIDTH,
                              SCREEN_HEIGHT,
                              10]);
                    }
                }
            }
        }
    }
}

module drawScreenCenter() {
    translate([SCREEN_CENTER[0], SCREEN_CENTER[1], 0]) {
        cylinder(10, r=1);
    }
}

module drawTopHalf() {

    // Draw Top Side
    translate([2, DISPLAY_BOARD_HEIGHT - BEZEL_TOP, 0]) {
        translate([DISPLAY_BOARD_WIDTH_OUTER, BEZEL_TOP + 2, 0]) {
            rotate([0, 0, 270]) {
                drawSide(TOTAL_DEPTH, BEZEL_TOP, DISPLAY_BOARD_WIDTH_OUTER + 4);
            }
        }
    }

    // Draw Bottom Side
    translate([-2, -2, 0]) {
        translate([0, 0, 0]) {
            rotate([0, 0, 90]) {
                drawSide(TOTAL_DEPTH, BEZEL_BOTTOM + 4, DISPLAY_BOARD_WIDTH_OUTER + 4);
            }
        }
    }

    // Draw Left Side
    translate([-2, DISPLAY_BOARD_HEIGHT + 2, 0]) {
        drawSide(TOTAL_DEPTH, BEZEL_LEFT + 2, DISPLAY_BOARD_HEIGHT + 4);
    }

    // Draw Right Side
    translate([DISPLAY_BOARD_WIDTH_OUTER, 0, 0]) {
        translate([2, -2, 0]) {
            rotate([0, 0, 180]) {
                drawSide(TOTAL_DEPTH, BEZEL_RIGHT + 2, DISPLAY_BOARD_HEIGHT + 4);
            }
        }
    }
}

// Disable for printing
*drawScreenCenter();

// Disable for printing
*drawDisplayModule();

// Enable for prin
drawTopHalf();