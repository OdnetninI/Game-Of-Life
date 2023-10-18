module lcd;

import types;

import std::io;
import raylib;

const UInt32 FRAME_WIDTH = 512;
const UInt32 FRAME_HEIGHT = 512;

struct Lcd {
  UInt8[types::HEIGHT][types::WIDTH] framebuffer;
  UInt8[types::HEIGHT*types::WIDTH*4] pixels;
  raylib::Image img;
  raylib::Texture tex;
}

float zoom = 1;
float sx = 0;
float sy = 0;

fn void Lcd.init(Lcd* lcd) {
  raylib::init_window(FRAME_WIDTH, FRAME_HEIGHT, "Game Of Life");
  
  raylib::set_target_fps(60);

  lcd.img = raylib::gen_image_color(types::WIDTH, types::HEIGHT, raylib::RED);
  raylib::image_format(&lcd.img, UNCOMPRESSED_R8G8B8A8);
  lcd.tex = raylib::load_texture_from_image(lcd.img);

  for(UInt32 y = 0; y < types::HEIGHT; ++y) {
    for (UInt32 x = 0; x < types::WIDTH; ++x) {
      lcd.framebuffer[y][x] = 0;
    }
  }

  lcd.redraw();
}

fn void Lcd.redraw(Lcd* lcd) {

  if (sx < 0) sx = 0;
  if (sy < 0) sy = 0;

  if (sx + (FRAME_WIDTH / zoom) > types::WIDTH) sx = types::WIDTH - (FRAME_WIDTH / zoom);
  if (sy + (FRAME_HEIGHT / zoom) > types::HEIGHT) sy = types::HEIGHT - (FRAME_HEIGHT / zoom);

  for(UInt32 y = 0; y < types::HEIGHT; ++y) {
    for (UInt32 x = 0; x < types::WIDTH; ++x) {
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
      lcd.pixels[(x + y * types::WIDTH) * 4 + 0] = color.r;
      lcd.pixels[(x + y * types::WIDTH) * 4 + 1] = color.g;
      lcd.pixels[(x + y * types::WIDTH) * 4 + 2] = color.b;
      lcd.pixels[(x + y * types::WIDTH) * 4 + 3] = 0xff;
    }
  }
  raylib::update_texture(lcd.tex, &lcd.pixels);

  raylib::begin_drawing();
    raylib::clear_background(raylib::RAYWHITE);
    raylib::draw_texture_pro(lcd.tex, 
      {sx, sy, types::WIDTH, types::HEIGHT}, 
      {0, 0, (float)(types::WIDTH * zoom), (float)(types::HEIGHT * zoom)},
      {0, 0},
      0.0f, raylib::RAYWHITE);
  raylib::end_drawing();
}

fn void Lcd.update(Lcd* lcd, Table view) {
  for(UInt32 y = 0; y < types::HEIGHT; ++y) {
    for (UInt32 x = 0; x < types::WIDTH; ++x) {
      lcd.framebuffer[y][x] = view.read(x, y);
    }
  }
}

fn void Lcd.close(Lcd* lcd) {
  raylib::close_window();
}