import concurrent.futures
from multiprocessing import Process
from subprocess import PIPE, Popen
import os
import random
import sys
from typing import List

import pygame

class Screen:
    screen = None

class Clock:
    def __init__(self, time_left_seconds, fps):
        self._clock = pygame.time.Clock()
        self._time_left = time_left_seconds * fps
        self._fps = fps

    def tick(self):
        print("Time left:", self._time_left)
        self._clock.tick(self._fps)
        self._time_left -= 1
        return self._time_left > 0

class Color:
    lightsaber_green = (47, 249, 36)

class SkullPixel:
    pixel_size = 25

    def __init__(self, initial_x, initial_y):
        self._rect = pygame.Rect(
            initial_x * SkullPixel.pixel_size,
            initial_y * SkullPixel.pixel_size,
            SkullPixel.pixel_size,
            SkullPixel.pixel_size,
        )

    def draw(self, color):
        pygame.draw.rect(Screen.screen, color, self._rect)

class Line:
    def __init__(self, color):
        self.color = color
        self.pixels: List[SkullPixel] = []

    def draw(self):
        for pixel in self.pixels:
            pixel.draw(self.color)

class HorizontalLine(Line):
    def __init__(self, color, start_x, start_y, num_pixels):
        super().__init__(color)
        self.define_pixels(start_x, start_y, num_pixels)

    def define_pixels(self, start_x, start_y, num_pixels):
        for i in range(0, num_pixels):
            self.pixels.append(SkullPixel(
                start_x + i,
                start_y,
            ))

class VerticalLine(Line):
    def __init__(self, color, start_x, start_y, num_pixels):
        super().__init__(color)
        self.define_pixels(start_x, start_y, num_pixels)

    def define_pixels(self, start_x, start_y, num_pixels):
        for i in range(0, num_pixels):
            self.pixels.append(SkullPixel(
                start_x,
                start_y + i,
            ))

class Skull:
    def __init__(self):
        self._color = Color.lightsaber_green
        self._components = [
            # Outer frame
            HorizontalLine(self._color, start_x=5, start_y=1, num_pixels=10),
            VerticalLine(self._color, start_x=4, start_y=2, num_pixels=5),
            HorizontalLine(self._color, start_x=5, start_y=7, num_pixels=2),
            HorizontalLine(self._color, start_x=7, start_y=8, num_pixels=2),
            HorizontalLine(self._color, start_x=9, start_y=9, num_pixels=2),
            HorizontalLine(self._color, start_x=11, start_y=8, num_pixels=2),
            HorizontalLine(self._color, start_x=13, start_y=7, num_pixels=2),
            VerticalLine(self._color, start_x=15, start_y=2, num_pixels=5),

            # Eyes
            HorizontalLine(self._color, start_x=7, start_y=3, num_pixels=2),
            HorizontalLine(self._color, start_x=11, start_y=3, num_pixels=2),
        ]

    def draw(self):
        for component in self._components:
            component.draw()

def evil_laugh():
    process = Popen(["spd-say", "--wait", "Haha. Hahaha. Hahaha."],
                    stdout=PIPE, stderr=PIPE)
    stdout, stderr = process.communicate()
    if len(stdout) != 0:
        print("Process returned non-empty stdout:", stdout.decode("utf-8"))
    if len(stderr) != 0:
        print("Process returned non-empty stderr:", stderr.decode("utf-8"))

def quit():
    pygame.quit()

def handle_quit():
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            return False
    return True

def main():
    program_running_seconds = int(sys.argv[1])
    should_laugh = sys.argv[2] == "true"
    print("Program running seconds:", program_running_seconds)
    print("Should laugh:", should_laugh)

    swidth = 500
    sheight = 500
    fps = 60        


    skull = Skull()
    clock = Clock(program_running_seconds, fps)
    running = True
    laughs_left = 3
    laugh_process = None
    while laughs_left > 0:
        if laugh_process is None:
            # Set initial screen position
            os.environ["SDL_VIDEO_WINDOW_POS"] = "{},{}".format(
                # TODO: use window dimensions
                random.randint(0, 1000),
                random.randint(0, 500),
            )
            os.environ["SDL_VIDEO_CENTERED"] = "0"
            pygame.quit()
            pygame.init()
            Screen.screen = pygame.display.set_mode((swidth, sheight))
            if should_laugh:
                laugh_process = Process(target=evil_laugh)
                laugh_process.start()

        skull.draw()
        
        running = clock.tick()
        if not running:
            quit()
            break
        running = handle_quit()
        if not running:
            quit()
            break
        
        pygame.display.flip()

        if laugh_process is not None:
            if not laugh_process.is_alive():
                laugh_process = None
                laughs_left -= 1

if __name__ == "__main__":
    main()
