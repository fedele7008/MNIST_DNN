"""
encoder module provides multiple encoding methods.
"""

import numpy as np
import cv2


class One_hot():
    """
    One_hot class provides features related with one-hot encoding.

    Static Attributes:
        <No static attributes>

    Class Attributes:
        <No class attributes>
    """
    
    @staticmethod
    def encode(y: list[int] | np.ndarray, size: int = 10) -> np.ndarray:
        """
        Encodes a list of integers into list of one-hot vectors.

        Args:
            * 'y' must be list of integers or numpy.ndarray of integers
            * 'size' is integer that denotes the size of each one-hot vector.
        
        Returns:
            numpy.ndarray of one-hot vectors. (This is 2D array)

        Requires:
            * each elemenets of 'y' must not exceed the size of the one-hot vector.
        
        Note:
            * 'size' is defaulted to 10.
        """

        # Verify if 'all' elements of 'y' are less than the size
        if np.max(y) >= size:
            raise ValueError('All elements of y must not exceed the size of the one-hot vector.')

        return np.array([np.eye(size)[i] for i in y])


class ImageModifications():
    @staticmethod
    def crop_or_pad_image(image, size):
        h, w = image.shape
        target_h, target_w = size

        if h == target_h and w == target_w:
            return image

        if h < target_h or w < target_w:
            # Pad image
            top_pad = (target_h - h) // 2
            bottom_pad = target_h - h - top_pad
            left_pad = (target_w - w) // 2
            right_pad = target_w - w - left_pad
            padded_image = np.pad(image, ((top_pad, bottom_pad), (left_pad, right_pad)), mode='constant')
            return padded_image

        # Crop image
        top = (h - target_h) // 2
        left = (w - target_w) // 2
        cropped_image = image[top:top+target_h, left:left+target_w]
        return cropped_image

    @staticmethod
    def apply_random_transformations(images):
        num_images = images.shape[0]
        transformed_images = np.empty_like(images)

        for i in range(num_images):
            image = images[i].reshape(28, 28)  # Reshape image to 28x28
            translation_x = np.random.randint(-3, 4)  # Random translation in x-axis [-3, 3]
            translation_y = np.random.randint(-3, 4)  # Random translation in y-axis [-3, 3]
            scale = np.random.uniform(0.75, 1.25)  # Random scale between 0.75 and 1.25

            # Apply translation
            translation_matrix = np.float32([[1, 0, translation_x], [0, 1, translation_y]])
            translated_image = cv2.warpAffine(image, translation_matrix, (28, 28))

            # Apply scaling
            scaled_image = cv2.resize(translated_image, None, fx=scale, fy=scale, interpolation=cv2.INTER_LINEAR)

            # Crop or pad the scaled image to 28x28
            scaled_image = ImageModifications.crop_or_pad_image(scaled_image, size=(28, 28))

            transformed_images[i] = scaled_image.flatten()  # Flatten the image and store in transformed_images

        return transformed_images