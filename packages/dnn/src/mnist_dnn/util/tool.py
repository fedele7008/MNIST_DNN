import numpy as np
import math

"""
Primary purpose of this module is to provide tools to aid development.
"""

class Display():
    """
    Display class is used to debug dataset, especially to display the image on
      screen either through Graphics or Command Line Interface.
    """
        
    _GREYSCALE_MODE = {
        'ascii': [' ', '.', "'", '`', '^', '"', ',', ':', ';', 'I', 'l', '!', 'i', 
                '>', '<', '~', '+', '_', '-', '?', ']', '[', '}', '{', '1', ')',
                '(', '|', '\\', '/', 't', 'f', 'j', 'r', 'x', 'n', 'u', 'v', 'c',
                'z', 'X', 'Y', 'U', 'J', 'C', 'L', 'Q', '0', 'O', 'Z', 'm', 'w', 
                'q', 'p', 'd', 'b', 'k', 'h', 'a', 'o', '*', '#', 'M', 'W', '&', 
                '8', '%', 'B', '@', '$'],
        'simple-ascii': [' ', '.', ':', '-', '=', '+', '*', '#', '%', '@']
    }

    @staticmethod
    def show_img(image, is_normalized = True, display_mode = 'graphic'):
        """
        Display the given image vector on screen.

        Requires:
            * matplotlib 3.6.3
            * image must be 1D numpy vector with shape of (784,)
            * 0 <= image[i] <= 255, for every i

        Args:
            image: 1D numpy vector object with dimension of 784
            is_normalized (Default: True): determine if given input image is 
            normalized value or greyscaled
            display_mode (Default: 'graphic'): chooses how image will be displayed
            * 'graphic': use pyplot library to display fancy gui plot
            * 'ascii': create ascii display available for CLI
            * 'simple-ascii': create simple ascii display available for CLI

        Return:
            <No return value>
        """
        # Copy image
        img = image

        # Determine if image is normalized scale it
        if is_normalized:
            img = img * 255

        # Reshape the image
        img = img.reshape((28, 28))

        # Display the image
        if display_mode == 'ascii' or display_mode == 'simple-ascii':
            for row in range(28):
                line = ''
                for col in range(28):
                    line += Display._GREYSCALE_MODE[display_mode][math.floor(img[row][col] 
                    / 255 * (len(Display._GREYSCALE_MODE[display_mode]) - 1))]
                print(line)
        else:
            import matplotlib.pyplot as plot
            plot.gray()
            plot.imshow(img, interpolation='nearest')
            plot.show()

