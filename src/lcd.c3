module lcd;

import types;

import std::io;
import raylib;

const UInt8 FRAME_WIDTH = 160;
const UInt8 FRAME_HEIGHT = 160;

struct Lcd {
  UInt8[FRAME_HEIGHT][FRAME_WIDTH] framebuffer;
  UInt8[FRAME_HEIGHT*FRAME_WIDTH*4] pixels;
  raylib::Image img;
  raylib::Texture tex;
}

UInt8 zoom = 3;

fn void Lcd.init(Lcd* lcd) {
  raylib::init_window(FRAME_WIDTH * zoom, FRAME_HEIGHT * zoom, "Game Of Life");
  
  raylib::set_target_fps(60);

  lcd.img = raylib::gen_image_color(FRAME_WIDTH, FRAME_HEIGHT, raylib::RED);
  raylib::image_format(&lcd.img, UNCOMPRESSED_R8G8B8A8);
  lcd.tex = raylib::load_texture_from_image(lcd.img);

  for(UInt8 y = 0; y < FRAME_HEIGHT; ++y) {
    for (UInt8 x = 0; x < FRAME_WIDTH; ++x) {
      lcd.framebuffer[y][x] = 0;
    }
  }

  lcd.redraw();
}

fn void Lcd.redraw(Lcd* lcd) {
  for(UInt8 y = 0; y < FRAME_HEIGHT; ++y) {
    for (UInt8 x = 0; x < FRAME_WIDTH; ++x) {
      raylib::Color color;
      switch(lcd.framebuffer[y][x]) {
        case 0: color = raylib::RAYWHITE;
        case 1: color = raylib::LIGHTGRAY;
        case 2: color = raylib::DARKGRAY;
        case 3: color = raylib::BLACK;
        case 4: color = raylib::YELLOW;
        case 5: color = raylib::PINK;
        default: color = raylib::RED;
      }
      //raylib::draw_pixel(x, y, color);
      lcd.pixels[(x + y * FRAME_WIDTH) * 4 + 0] = color.r;
      lcd.pixels[(x + y * FRAME_WIDTH) * 4 + 1] = color.g;
      lcd.pixels[(x + y * FRAME_WIDTH) * 4 + 2] = color.b;
      lcd.pixels[(x + y * FRAME_WIDTH) * 4 + 3] = 0xff;
    }
  }
  raylib::update_texture(lcd.tex, &lcd.pixels);

  raylib::begin_drawing();
    raylib::clear_background(raylib::MAGENTA);
    raylib::draw_texture_pro(lcd.tex, 
      {0, 0, FRAME_WIDTH, FRAME_HEIGHT}, 
      {0, 0, (float)(FRAME_WIDTH * zoom), (float)(FRAME_HEIGHT * zoom)},
      {0, 0},
      0.0f, raylib::RAYWHITE);
  raylib::end_drawing();
}

fn void Lcd.update(Lcd* lcd, UInt8[FRAME_HEIGHT][FRAME_WIDTH] data) {
  for(UInt8 y = 0; y < FRAME_HEIGHT; ++y) {
    for (UInt8 x = 0; x < FRAME_WIDTH; ++x) {
      lcd.framebuffer[y][x] = data[y][x];
    }
  }
}

fn void Lcd.close(Lcd* lcd) {
  raylib::close_window();
}