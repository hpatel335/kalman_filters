# Kalman Filters

## Overview 
Sensor fusion is a powerful processing framework that at its most fundamental level leverages multiple sources of information to produce an increasingly more reliable estimate than compared to any estimate that could be drawn by the same sources in isolation. Sensor fusion techniques are widly appled for robotic applications, especially for systems which require a high accuracy of state estimation. While there are a number of different algorithms, this walkthrough will focus on *kalman filters*. This project should serve to demonstrate just how useful kalman filters can be for multisensor systems, and provide an introductory understanding of their implimentation. 

## Basics 
Kalman Filters generally work by taking in a series of observations, their uncertainties, and a dynamical model of the states to produce a more accurate estimate of an unkonwn state that considers both the observed and expected behaviours. There are several sources that I used to understand kalman filters, that do a way better job of detailing them (far better than I could ever do), so I'll refer the readers to them. 

### References 
- [Fundamentals of Spacecraft Attitude Determination and Control](https://link.springer.com/book/10.1007/978-1-4939-0802-8)
- [Optimal Estimation of Dynamic Systems](https://www.routledge.com/Optimal-Estimation-of-Dynamic-Systems/Crassidis-Junkins/p/book/9781439839850)
- [Fundamentals of Kalman Filtering: A Practical Approach](https://arc.aiaa.org/doi/book/10.2514/4.102776)
- [Tracking and Kalman Filtering Made Easy](https://www.wiley.com/en-us/Tracking+and+Kalman+Filtering+Made+Easy-p-9780471184072)

## Basic Walkthrough 
To demonstrate the capabilities of a Kalman Filter, we'll walk through a simple example involving a stationary system (imagine a plane parked on a tarmac). Let's say you want to find the position (will only consider the simple 1D case now) of the system, and you have at your dispoal measurements from an INS (which provide accelerations) and position from a GPS system). 

### Uncorrected Position 
Trying the simplest thing first, lets look at the position estimates we get from the GPS and the INS. The GPS directly provides the position, but we'll need to integrate the accelerations from the INS to get position.

<img src="./plots/uncorrected_pos.png" width="650">

### Corrected Position 
