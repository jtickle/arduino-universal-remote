#include "ur_config.h"
#include "ur_data.h"
#include "ur_display.h"
#include "ur_touch.h"

#include <IRLibSendBase.h>
#include <IRLib_P01_NEC.h>
#include <IRLib_P02_Sony.h>
#include <IRLib_P03_RC5.h>
#include <IRLib_P04_RC6.h>
#include <IRLib_P05_Panasonic_Old.h>
#include <IRLib_P06_JVC.h>
#include <IRLib_P07_NECx.h>
#include <IRLib_P08_Samsung36.h>
#include <IRLib_P09_GICable.h>
#include <IRLib_P10_DirecTV.h>
#include <IRLib_P11_RCMM.h>
#include <IRLib_P12_CYKM.h>
#include <IRLibCombo.h>

URData ur_data;

bool was_touching = false;
int16_t last_x = 0;
int16_t last_y = 0;

void irsend(CmdIRSend c) {
  Serial.print(F("IRSend "));
  Serial.print(c.protocol);
  Serial.print(F(" "));
  Serial.print(c.data, HEX);
  Serial.print(F(" "));
  Serial.print(c.data2, HEX);
  Serial.print(F(" "));
  Serial.println(c.khz);
  
  IRsend ur_sender;
  ur_sender.send(c.protocol, c.data, c.data2, c.khz);
}

void showpage(CmdShowPage c) {
  Serial.print(F("ShowPage "));
  Serial.print(c.slot);
  Serial.print(F(" "));
  Serial.print(c.page);
  
  Page p;
  URDisplay ur_display;

  ur_data.get_page(&p, c.page);
  ur_display.show((const char*) p.disabled_img, p.extents.ax, p.extents.ay);

  ur_data.active_pages[c.slot] = c.page;
  ur_data.extents[c.slot] = p.extents;
}

void process_commands() {
  Command c;

  if(!ur_data.has_next_command()) {
    Serial.println(F("No Commands"));
    return;
  } else {
    Serial.println(F("Processing Commands"));
  }
  
  while(ur_data.has_next_command()) {
    ur_data.next_command(&c);
    Serial.print(c.command_id);
    Serial.print(F(" "));
    switch(c.command_id) {
      case 1:
        irsend(c.irsend);
        break;
      case 2:
        showpage(c.showpage);
        break;
    }
    Serial.println(F(""));
  }
}

void button_update(const char* filename, Extents *p, Extents *b) {
  URDisplay ur_display;
  ur_display.showPart(filename, p->ax, p->ay,
    p->ax + b->ax, p->ay + b->ay,
    p->ax + b->bx, p->ay + b->by);
}

void handle_touch_down(int16_t x, int16_t y) {
  Page p;
  HitBox b;

  ur_data.get_page(&p, 0);
  if(ur_data.get_hitbox(&b, &p, x, y)) {
    // Issue Commands
    ur_data.load_commands(b.command_start, b.command_count);
    process_commands();

    // Update Button Gfx
    button_update((const char*) p.enabled_img, &p.extents, &b.extents);
  }
}

void handle_touch_up(int16_t x, int16_t y) {
  Page p;
  HitBox b;

  // Show Animation
  ur_data.get_page(&p, 0);
  if(ur_data.get_hitbox(&b, &p, x, y)) {
    // Update Button Gfx
    button_update((const char*) p.disabled_img, &p.extents, &b.extents);
  }
}

void setup() {
  Serial.begin(9600);
  Serial.println(F("Starting Up..."));
  
  ur_data.init(SD_CS);

  Serial.println(F("SD Loaded"));

  URDisplay ur_display;
  ur_display.clear();
  ur_display.println("Initializing...");

  ur_data.load_initcmds();
  ur_display.println("Loading initial commands...");

  process_commands();
}

bool get_touch_data(int16_t *x, int16_t *y, bool* is_touching) {
  URTouch ur_touch;
  ur_touch.load_touch();

  *x = ur_touch.get_x();
  *y = ur_touch.get_y();
  *is_touching = ur_touch.is_touching();

  return ur_touch.is_valid_data();
}

void loop() {
  int16_t x;
  int16_t y;
  bool is_touching;

  if(!get_touch_data(&x, &y, &is_touching)) {
    return;
  }

  if(is_touching && !was_touching) {
    was_touching = true;  

    Serial.print(F("Touch Down "));
    Serial.print(x);
    Serial.print(F(" "));
    Serial.println(y);

    handle_touch_down(x, y);

    last_x = x;
    last_y = y;
  } else if(!is_touching && was_touching) {
    was_touching = false;

    Serial.print(F("Touch Up "));
    Serial.print(last_x);
    Serial.print(F(" "));
    Serial.println(last_y);

    handle_touch_up(last_x, last_y);
  }
}
