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

#ifndef _UR_DISPLAY_H_
#define _UR_DISPLAY_H_

#include <Adafruit_GFX.h>
#include <Adafruit_ILI9341.h>
#include <SPI.h>
#include <SD.h>

#include <stdint.h>

#include "ur_config.h"

class URDisplay {
  public:
    URDisplay();
    void clear();
    void print(const char* msg);
    void println(const char* msg);
    void show(const char *filename, int16_t ox, int16_t oy);
    void showPart(const char* filename, int16_t ox, int16_t oy,
                  int16_t ax, int16_t ay, int16_t bx, int16_t by);
    Adafruit_ILI9341 tft = Adafruit_ILI9341(TFT_CS, TFT_DC);

  protected:
    void bmpDraw(const char *filename, int16_t x, int16_t y,
                 int16_t ax, int16_t ay, int16_t bx, int16_t by);
    uint16_t read16(File &f);
    uint32_t read32(File &f);
};

#endif // _UR_DISPLAY_H_
