import pygame
import os
import numpy as np
from mnist_dnn.dataset import MNIST
from mnist_dnn.layer import Dense
from mnist_dnn.model import Sequential
from mnist_dnn.util.tool import Display
train_data, test_data = MNIST.load_data()
model = Sequential()
model.add(Dense(nodes = 32, input_nodes = 28 * 28, activation = 'relu'))
model.add(Dense(nodes = 10, activation = 'softmax'))
model.compile(loss = 'categorical_crossentropy', optimizer = 'gradient_descent')
model.train(train_data, epochs = 1, batch_size = 2)
model.test(test_data)

def clear_terminal():
    # Check the operating system and use the appropriate command to clear the terminal
    if os.name == 'nt':  # For Windows
        os.system('cls')
    else:  # For Unix/Linux/MacOS
        os.system('clear')

# Canvas settings
canvas_width, canvas_height = 560, 560
background_color = (255, 255, 255)  # White

# Box settings
box_size = 20
box_rows, box_cols = canvas_width // box_size, canvas_height // box_size

# Initialize the canvas
pygame.init()
canvas = pygame.display.set_mode((canvas_width, canvas_height))
canvas.fill(background_color)
pygame.display.set_caption("Mouse Drawing")
clock = pygame.time.Clock()

# Variables to track drawing state
drawing = False
last_pos = None

# Main game loop
running = True
while running:
    # Process events
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1:  # Left mouse button
                drawing = True
                last_pos = pygame.mouse.get_pos()
        elif event.type == pygame.MOUSEBUTTONUP:
            if event.button == 1:  # Left mouse button
                drawing = False
                last_pos = None
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:
                pass
            elif event.key == pygame.K_r:
                # Clear the canvas when 'R' is pressed
                canvas.fill(background_color)
    
    if drawing:
        # Divide canvas into boxes and evaluate blackness
        l = []
        for row in range(box_rows):
            for col in range(box_cols):
                box_rect = pygame.Rect(
                    col * box_size, row * box_size, box_size, box_size
                )
                sub_surface = canvas.subsurface(box_rect)
                blackness = sum(pygame.transform.average_color(sub_surface)[:3])
                gray_value = int(255 - (blackness / (255 * 3)) * 255)
                l.append(gray_value)

        l = np.array(l)
        clear_terminal()
        model.predict(l)

    # Drawing on canvas
    if drawing:
        current_pos = pygame.mouse.get_pos()
        if last_pos is not None:
            pygame.draw.line(canvas, (0, 0, 0), last_pos, current_pos, 35)
        last_pos = current_pos
    else:
        last_pos = None

    # Update the canvas
    pygame.display.flip()
    clock.tick(60)

# Quit the program
pygame.quit()


"""
[[  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  40,  94, 115,  97,  66,  27,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  47, 179, 215, 162, 141, 159, 190, 217,   6,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   9, 136, 208,  77,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,  26, 197, 120,   2,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,  24, 175,  51,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   5, 193,  59,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0, 106, 150,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0, 215,  41,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,  40, 216,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,  85, 185,  93, 141, 164, 177, 191, 192, 171, 111,  37,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,  90, 242, 163, 115,  92,  79,  65,  64,  85, 145, 219, 183,  50,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,  73, 183,   0,   0,   0,   0,   0,   0,   0,   0,   1,  73, 204, 141,   6,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,  21, 231,   4,   0,   0,   0,   0,   0,   0,   0,   0,   0,   2, 115, 154,   6,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0, 164,  92,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 147, 109,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,  14, 163,  70,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 108, 148,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,  15, 183, 131,  11,   0,   0,   0,   0,   0,   0,   0,   0, 140, 116,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   4, 125, 222, 121,  23,   0,   0,   0,   0,   0,  36, 194,  20,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  23, 135, 231, 196, 131,  87,  84, 154, 213,  29,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   2,  60, 125, 169, 172, 102,   8,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0],
 [  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0]]
"""