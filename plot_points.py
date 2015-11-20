#! /usr/bin/env python
import pdb
from plotting import plot

def plot_line(start_x, start_y, end_x, end_y):
    start = create_point(start_x, start_y)
    end = create_point(end_x, end_y)

    equation = end - start

    line = line_to_point(equation, 100)
    transformed_line = translate_line(line, start)
    plot(transformed_line, 3)

def translate_line(line, translator):
    return [ translator + point for point in line ]

def line_to_point(point, scale):
    return [ (scalar + 1) / float(scale) * point for scalar in range(scale) ]

def scalar_vector_mult(scalar, vector):
    return { scalar * element for element in vector }

def create_point(x, y):
    return x + y * (1j)
