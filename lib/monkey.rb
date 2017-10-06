require "monkey/version"
require 'mini_magick'

class Monkey

  def initialize(verbose: false, &block)
    instance_eval &block if block
    @verbose = verbose
  end

  def text(string)
    adb_shell "input text #{string}"
  end

  def keyevent(keycode, longpress: false)
    keycode = KEYCODE[keycode] if keycode.kind_of? String
    command = "input keyevent #{keycode}"
    command += " --longpress" if longpress
    adb_shell command
  end

  def tap(x, y)
    adb_shell "input tap #{x} #{y}"
  end

  def swipe(x1, y1, x2, y2, duration = nil)
    command = "input swipe #{x1} #{y1} #{x2} #{y2}"
    command += " #{duration}" if duration
    adb_shell command
  end

  def press
    adb_shell "input press"
  end

  def roll(dx, dy)
    adb_shell "input roll #{dx} #{dy}"
  end

  def wait(time)
    sleep time.to_f / 1000
  end

  def start(package, activity, options = nil)
    command = "am start #{package}/#{activity}"
    command += " #{options}" if options
    adb_shell command
  end

  def stop(package)
    adb_shell "am force-stop #{package}"
  end

  def install(path, package = nil)
    return if package && adb_capture("shell pm list packages | grep #{package}") != ""
    adb "install -rdg #{path}"
  end

  def adb_shell(subcommand)
    adb "shell #{subcommand}"
  end

  def pull(path)
    adb "pull #{path}"
  end

  def push(path)
    adb "push #{path}"
  end

  def adb(subcommand)
    command = "adb #{subcommand}"
    puts "Run command: #{command}" if @verbose
    system command
  end

  def adb_capture(subcommand)
    command = "adb #{subcommand}"
    puts "Run command: #{command}" if @verbose
    `#{command}`
  end

  def screencap
    bytes = adb_capture "exec-out screencap"
    width, height, ptype = bytes.unpack('LLL')
    raise RuntimeError, "cannot handle pixel format: #{ptype}, check https://developer.android.com/reference/android/graphics/PixelFormat.html for more details" unless ptype == 1
    MiniMagick::Image.import_pixels bytes, width, height, 8, 'rgba'
  end

  KEYCODE = {
    # "UNKNOWN" => 0,
    # "MENU" => 1,
    "SOFT_RIGHT" => 2,
    "HOME" => 3,
    "BACK" => 4,
    "CALL" => 5,
    "ENDCALL" => 6,
    "0" => 7,
    "1" => 8,
    "2" => 9,
    "3" => 10,
    "4" => 11,
    "5" => 12,
    "6" => 13,
    "7" => 14,
    "8" => 15,
    "9" => 16,
    "STAR" => 17,
    "POUND" => 18,
    "DPAD_UP" => 19,
    "DPAD_DOWN" => 20,
    "DPAD_LEFT" => 21,
    "DPAD_RIGHT" => 22,
    "DPAD_CENTER" => 23,
    "VOLUME_UP" => 24,
    "VOLUME_DOWN" => 25,
    "POWER" => 26,
    "CAMERA" => 27,
    "CLEAR" => 28,
    "A" => 29,
    "B" => 30,
    "C" => 31,
    "D" => 32,
    "E" => 33,
    "F" => 34,
    "G" => 35,
    "H" => 36,
    "I" => 37,
    "J" => 38,
    "K" => 39,
    "L" => 40,
    "M" => 41,
    "N" => 42,
    "O" => 43,
    "P" => 44,
    "Q" => 45,
    "R" => 46,
    "S" => 47,
    "T" => 48,
    "U" => 49,
    "V" => 50,
    "W" => 51,
    "X" => 52,
    "Y" => 53,
    "Z" => 54,
    "COMMA" => 55,
    "PERIOD" => 56,
    "ALT_LEFT" => 57,
    "ALT_RIGHT" => 58,
    "SHIFT_LEFT" => 59,
    "SHIFT_RIGHT" => 60,
    "TAB" => 61,
    "SPACE" => 62,
    "SYM" => 63,
    "EXPLORER" => 64,
    "ENVELOPE" => 65,
    "ENTER" => 66,
    "DEL" => 67,
    "GRAVE" => 68,
    "MINUS" => 69,
    "EQUALS" => 70,
    "LEFT_BRACKET" => 71,
    "RIGHT_BRACKET" => 72,
    "BACKSLASH" => 73,
    "SEMICOLON" => 74,
    "APOSTROPHE" => 75,
    "SLASH" => 76,
    "AT" => 77,
    "NUM" => 78,
    "HEADSETHOOK" => 79,
    "FOCUS" => 80,
    "PLUS" => 81,
    "MENU" => 82,
    "NOTIFICATION" => 83,
    "SEARCH" => 84,
  }
end
