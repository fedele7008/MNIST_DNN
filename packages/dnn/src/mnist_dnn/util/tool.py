"""
Primary purpose of this module is to provide tools to aid development.
"""

import numpy as np
import math

class Display():
    """
    Display class is used to debug dataset, especially to display the image on
        screen either through Graphics or Command Line Interface.

    Static Attributes:
        * _GREYSCALE_MODE: dictionary of ascii characters that maps to greyscale
            image.

    Class Attributes:
        <No class attributes>
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
    def show_img(data, display_mode = 'graphic', display_resolution = (1280, 720), plot_dimension = (8, 4), font_size = 8):
        """
        Display the given image vector on screen.

        Requires:
            * matplotlib 3.6.3
            * image in the data must be 1D numpy vector with shape of (784,)
            * 0 <= data.image[i] <= 255, for every i

        Args:
            * data: Tuple of (label, image) or list of tuple of (label, image),
                * label can either be None or a string
                * image is 1D numpy vector object with dimension of 784
            * display_resolution (default (1280, 720)): Chooses the size of plot
                window, this option is only available when display_mode is 'graphic'.
                * (1920, 1080): 1080p
                * (1280, 720) : 720p [default]
                * (852, 480)  : 480p
            * plot_dimension (default (8, 4)): Chooses the dimension of plots
                e.g. (8, 4) means it will show 8 columns and 4 rows in one page
            * font_size (default 8): Chooses the font size of plot title
            * display_mode (Default: 'graphic'): chooses how image will be displayed
                * 'graphic': use pyplot library to display fancy gui plot
                * 'ascii': create ascii display available for CLI
                * 'simple-ascii': create simple ascii display available for CLI

        Return:
            <No return value>

        Raises:
            ValueError: raises exception whenever wrong argument type is given
        """

        # Determine if the data is tuple of (label, image) or list of tuples of
        #   (label, image)
        if isinstance(data, tuple):
            # Extract tuple
            label, image = data

            # Raise ValueError if label is not None or String
            if label is not None and not isinstance(label, str):
                raise ValueError('label must be None or String')

            # Raise ValueError if image is not 1D numpy vector
            if not isinstance(image, np.ndarray):
                raise ValueError('image must be 1D numpy vector')

            # Determine if maximum value in the image is less than or equal to 1,
            #   if then, scale it by 255
            if np.max(image) <= 1:
                image = image * 255

            # Reshape the image
            image = image.reshape((28, 28))

            # Display the image
            if display_mode == 'ascii' or display_mode =='simple-ascii':
                # Print label if exist
                if label is not None:
                    print(label)
                
                # Print ascii art
                for row in range(28):
                    line = ''
                    for col in range(28):
                        line += Display._GREYSCALE_MODE[display_mode][math.floor(image[row][col] 
                        / 255 * (len(Display._GREYSCALE_MODE[display_mode]) - 1))]
                    print(line)
            else:
                import matplotlib.pyplot as plot

                # Set color map to gray
                plot.gray()

                # Set the image on plot
                plot.imshow(image.squeeze(), interpolation='nearest')

                # Set the label if exist
                if label is not None:
                    plot.title(label)

                # Disable the axis
                plot.axis(False)

                # Show the plot
                plot.show()
        elif isinstance(data, list):
            for label, image in data:
                # If label is not None or string, raise exception
                if label is not None and not isinstance(label, str):
                    raise ValueError('every label must be None or String')

                # If image is not 1D numpy vector, raise exception
                if not isinstance(image, np.ndarray):
                    raise ValueError('every image must be 1D numpy vector')

            # Create parallel lists for label and images in same index
            label = []
            image = []

            # Copy the label and images from tuple(which is immutable) to list
            for l, i in data:
                label.append(l)
                image.append(i)

            for i in range(len(data)):
                # If maximum value of image is less than or equal to 1, scale
                #   the image by 255
                if np.max(image[i]) <= 1:
                    image[i] = image[i] * 255

                # Reshape the image
                image[i] = image[i].reshape((28, 28))

            # Display the image
            if display_mode == 'ascii' or display_mode =='simple-ascii':
                for i in range(len(data)):
                    # Print label if exist
                    if label[i] is not None:
                        print(label[i])
                    
                    # Print ascii art
                    for row in range(28):
                        line = ''
                        for col in range(28):
                            line += Display._GREYSCALE_MODE[display_mode][math.floor(image[i][row][col] / 255 * (len(Display._GREYSCALE_MODE[display_mode]) - 1))]
                        print(line)
            else:
                import matplotlib.pyplot as plot
                
                # Set plot rows & column
                col, row = plot_dimension

                # Set max pages
                max_page = math.ceil(len(data) / (col * row))

                for page in range(max_page):
                    # Split the data
                    index_from = col * row * page
                    index_to = col * row * (page + 1)

                    page_label = label[index_from:index_to]
                    page_image = image[index_from:index_to]

                    # Set margin of window
                    margin = 0.02

                    # Create a plot figure
                    plot.figure(figsize=(3 * col, 3 * row))

                    # Addjust the style of figure
                    plot.subplots_adjust(left=margin, bottom=margin, right=1-margin,
                                        top=1-margin, wspace=0.1, hspace=0)
                    plot.rcParams['font.size'] = font_size

                    for i in range(len(page_image)):
                        # Create a subplot
                        plot.subplot(row, col, i + 1)

                        # Configure the subplot
                        plot.imshow(page_image[i].squeeze(), interpolation='nearest', cmap='gray')

                        # Set the label if exist
                        if page_label[i] is not None:
                            plot.title(page_label[i])

                        # Disable the axis
                        plot.axis(False)

                    # Set the title
                    figManager = plot.get_current_fig_manager()
                    figManager.set_window_title(f'MNIST image viewer ({page + 1}/{max_page})')

                    # Resize the screen
                    screen_width, screen_height = display_resolution
                    figManager.resize(screen_width, screen_height)

                    # Show the plot
                    plot.show()
        else:
            raise ValueError('data must be tuple of (label, image) or list (label, image)')