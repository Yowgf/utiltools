import concurrent.futures
import time
from math import floor
from multiprocessing import Process, Event
from subprocess import PIPE, Popen
import os
import random
import sys
from typing import List

import pygame

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

    def __init__(self, screen, initial_x, initial_y):
        self._screen = screen
        self._rect = pygame.Rect(
            initial_x * SkullPixel.pixel_size,
            initial_y * SkullPixel.pixel_size,
            SkullPixel.pixel_size,
            SkullPixel.pixel_size,
        )

    def draw(self, color):
        pygame.draw.rect(self._screen, color, self._rect)

class Line:
    def __init__(self, screen, color):
        self.screen = screen
        self.color = color
        self.pixels: List[SkullPixel] = []

    def draw(self):
        for pixel in self.pixels:
            pixel.draw(self.color)

class HorizontalLine(Line):
    def __init__(self, screen, color, start_x, start_y, num_pixels):
        super().__init__(screen, color)
        self.define_pixels(start_x, start_y, num_pixels)

    def define_pixels(self, start_x, start_y, num_pixels):
        for i in range(0, num_pixels):
            self.pixels.append(SkullPixel(
                self.screen,
                start_x + i,
                start_y,
            ))

class VerticalLine(Line):
    def __init__(self, screen, color, start_x, start_y, num_pixels):
        super().__init__(screen, color)
        self.define_pixels(start_x, start_y, num_pixels)

    def define_pixels(self, start_x, start_y, num_pixels):
        for i in range(0, num_pixels):
            self.pixels.append(SkullPixel(
                self.screen,
                start_x,
                start_y + i,
            ))

class Skull:
    def __init__(self, screen):
        self._color = Color.lightsaber_green
        self._components = [
            # Outer frame
            HorizontalLine(screen, self._color, start_x=5, start_y=1, num_pixels=10),
            VerticalLine(screen, self._color, start_x=4, start_y=2, num_pixels=5),
            HorizontalLine(screen, self._color, start_x=5, start_y=7, num_pixels=2),
            HorizontalLine(screen, self._color, start_x=7, start_y=8, num_pixels=2),
            HorizontalLine(screen, self._color, start_x=9, start_y=9, num_pixels=2),
            HorizontalLine(screen, self._color, start_x=11, start_y=8, num_pixels=2),
            HorizontalLine(screen, self._color, start_x=13, start_y=7, num_pixels=2),
            VerticalLine(screen, self._color, start_x=15, start_y=2, num_pixels=5),

            # Eyes
            HorizontalLine(screen, self._color, start_x=7, start_y=3, num_pixels=2),
            HorizontalLine(screen, self._color, start_x=11, start_y=3, num_pixels=2),
        ]

    def draw(self):
        for component in self._components:
            component.draw()

shutdown_screen_event = Event()

def new_screen():
    swidth = 500
    sheight = 500
    return pygame.display.set_mode((swidth, sheight))

def evil_laugh():
    time.sleep(3)
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

def draw_skull(program_running_seconds):
    # Set initial screen position
    os.environ["SDL_VIDEO_WINDOW_POS"] = "{},{}".format(
        # TODO: use window dimensions
        random.randint(0, 1000),
        random.randint(0, 500),
    )
    os.environ["SDL_VIDEO_CENTERED"] = "0"
    pygame.quit()
    pygame.init()
    screen = new_screen()
    print("A")
    skull = Skull(screen)
    fps = 60
    clock = Clock(int(program_running_seconds), fps)
    print("b")
    running = True
    while running and not shutdown_screen_event.is_set():
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

def spawn_screens(number_of_screens, program_running_seconds):
    print("Spawning", number_of_screens, "Screens")
    processes = []
    for i in range(number_of_screens):
        process = Process(target=draw_skull,args=[program_running_seconds])
        process.start()
        processes.append(process)
        print("Processes:", processes)
    print("Processes:", processes)
    return processes

def main():
    program_running_seconds = int(sys.argv[1])
    should_laugh = sys.argv[2] == "true"
    print("Program running seconds:", program_running_seconds)
    print("Should laugh:", should_laugh)

    number_of_screens = 1.8

    running = True
    laughs_left = 3
    laugh_process = None
    screen_processes = None
    while laughs_left > 0:
        if laugh_process is None:
            screen_processes = spawn_screens(int(floor(number_of_screens)), program_running_seconds)
            number_of_screens = int(round(number_of_screens ** number_of_screens))
            if should_laugh:
                laugh_process = Process(target=evil_laugh)
                laugh_process.start()

        if laugh_process is not None:
            if not laugh_process.is_alive():
                shutdown_screen_event.set()
                for process in screen_processes:
                    process.join()
                screen_processes = None
                shutdown_screen_event.clear()
                laugh_process = None
                laughs_left -= 1

if __name__ == "__main__":
    main()
