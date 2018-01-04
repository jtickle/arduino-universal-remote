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

