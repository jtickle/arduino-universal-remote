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
