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
