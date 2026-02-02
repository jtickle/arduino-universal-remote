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

#include "ur_touch.h"

// Initialize TouchScreen Library

URTouch::URTouch() {
  _tftw = 240;
  _tfth = 320;
}

void URTouch::load_touch() {
  _point = ts.getPoint();
}

bool URTouch::is_valid_data() {
  return _point.z < TS_MAXZ;
}

bool URTouch::is_touching() {
  return _point.z > TS_MINZ;
}

int16_t URTouch::get_x() {
  return map(_point.x, TS_MINX, TS_MAXX, 0, _tftw);
}

int16_t URTouch::get_y() {
  return map(_point.y, TS_MINY, TS_MAXY, 0, _tfth);
}

