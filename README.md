# Bender
Bender2D
by Mariano Arnaiz 2020

Bender2D is a simple raytracing code developed using the notes on Nolet 2010 (book) and Koulakov 2010 (paper).

In its current version, it traces a ray from a source to a receiver (both inside a velocity  model: a matrix). This is done by "bending" an initial linear ray until the travel time is minimum (Fermat's Principle). It is very strict so it can recreate refraction and critical refraction on its own (if the conditions are given).

The sample code reads the input parameters and runs GetModels function to set everything for the ray tracer. Then RayBender function runs until the traveltime is minimized. 

Parameters:

Model.txt: Velocity Model from an input file. This must be in the same directory as Bender2D.m
SOURCE: (x,z) position of the source (0 is accepted)
RECEIVER:  (x,z) position of the receiver (0 is accepted)
dx=10: Cell size of the model in X direction 
dz=5: Cell size of the model in Z direction
dray=0.025: percentage of dz to bend the ray up and down. Smaller values increase accuracy but make the code slower. 
dr=20: number of nodes on the ray. Larger values increase accuracy but make the code slower. 

Tips:

I suggest you begin by running the code and see how it uses the functions on it.

Lines 73,74,77 and 78 are commented as they are not needed in general, but if the ray go out of the model you can uncomment them (this will make the code run slower). I would suggest you make your model bigger than as avoid using this lines as the true raypath could be outside the "box".

To use in your own script I suggest adding lines from 6 to 19 to your code and then lines 34 to 104 to the end of your Matlab script. Raybender can be inside a for loop to trace several rays at once. This is not done automatically as the goal of this code is to be efficient (which many raytracer written for Matlab are not). You could also turn the functions at the end to Matlab functions files instead. 


