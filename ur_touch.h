#ifndef _UR_TOUCH_H_
#define _UR_TOUCH_H_

#include <SPI.h>
#include <Wire.h>
#include <TouchScreen.h>
#include <stdint.h>

#include "ur_config.h"

class URTouch {
  public:
    URTouch();
    void load_touch();
    bool is_valid_data();
    bool is_touching();
    int16_t get_x();
    int16_t get_y();
    TouchScreen ts = TouchScreen(TS_XP, TS_YP, TS_XM, TS_YM, TS_RES);
    
  protected:
    TSPoint _point;
    int16_t _tftw;
    int16_t _tfth;
};

#endif // _UR_TOUCH_H_
