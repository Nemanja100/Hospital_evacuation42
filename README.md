# MATLAB FS12 – Research Plan

> * Group Name: DENG Hospital
> * Group participants names: Andric Nemanja, Balestra Gioele, Betts Duncan, Fattorini Elisa
> * Project Title: Hospital Evacuation

## General Introduction

Evacuation of buildings is an important issue for safety. Until now a lot of evacuation plans have been developed for different purposes. Here we want to study in more detail the evacuation of an hospital, which is particularly interesting and difficult because of the different movement capabilities of people within.


## The Model

Our goal is to find the best strategy to evacuate an hospital in the shortest time. The model variables are the ratio between staff members and hospitalized people, which are either able to walk or not, the number of relatives present in the building which can influence the pedestrian flow, the placement and number of the incapacitated people (according to the degree of their boundedness) in the rooms and the geometry of the building (number and location of doors, layout of corridors, etc.). In order to evaluate the best strategy we consider the evacuation time.
This model is a good simplification because it represents a general situation in an hospital where we have patients, staff and relatives, but it considers only one floor and the same behaviour for people of the same category.


## Fundamental Questions

1- What is the optimal ratio between staff members and patients?
	a) For a given building and patient number, how many staff do we need?
	b) How the number of bedbounded people influence the evacuation time? 
2- What is the best organizational strategy?
	a) Should the staff be organized (evacuate first one room or several room at the same time)?
	b) Should the relatives help the staff or just evacuate themselves?
3- What is the best location for bedbounded people at the floor?



## Expected Results

1- a) We expect to find out that the number of staff needed is almost equal to the number of bedbounded patient so that there will be only one directional flow (the staff members do not have to go back into the hospital to rescue other people). Altough, this could maybe result in an unreasonable number of staff, which is not attainable for the hospital.
1- b) We expect to have an asympthotical increase of the evacuation time with the number of bedbounded people.
2- a) The organized staff will probably be more efficient.
2- b) The relatives should help the staff in the evacuation (if we neglect their emotionality).
3- The bedbounded people should be located the closest possible to the evacuation exit.
  

## References 

- Hospital evacuation protocol, NYCTP, 2006
- Social force model for pedestrian dynamics, Dirk Helbing and Peter Molnar, 1995
- Simulating dynamical features of escape panic, Dirk Helbing et al., 2000
- Self-Organized Pedestrian Crowd Dynamics: Experiments, Simulations and Design Solutions, Dirk Helbing et al., 2005
- Pedestrian Dynamics: Airplane Evacuation Simulation


## Research Methods

Our simulation is based on the social force model. This kind of modeling has already been applied, but in our case we plan to differenciate the movement behaviour of the different kind of people and also the direction of them (staff has to go back to rescue other people).


## Other

niente
