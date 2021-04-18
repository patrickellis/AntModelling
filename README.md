Ant Pheromone Model [![GitHub version](https://badge.fury.io/gh/patrickellis%2Fantmodelling.svg)](https://badge.fury.io/gh/patrickellis%2Fantmodelling)
======
<a href="https://www.patrickellis.dev/all/projects/project" target="_blank"> View the project page on my site </a>
## Description
This model aims to simulate the foraging behaviour of ants using an agent-based approach with both stochastic and deterministic components.

The model uses pheromone diffusion in order to demonstrate path formation in ant colonies.

## Mathematical components
The model implements a 2D diffusion grid for each of the two pheromones involved in the path formation process. Each time step, ants deposit a fixed amount of pheromone at their exact [x,y] coordinates. 2D Laplace Transformations are then applied to each deposition for each timestep since they occurred, which are summed into one grid. See below for visualisations.

<p align="center">
  <img src = "https://github.com/patrickellis/Portfolio/blob/master/images/docs/ant-gif.gif" style="padding-top:100px; width:350px;height:350px;" width="650" />
</p>

## Emergent Behaviour 
One objective of the project is to model emergent behaviour, in this case formation of efficient routes to and from food sources close to an ant colony. Only surface level charactersitics have been programmed, e.g. position, velocity, direction of motion, antennae length and ant length. 

<p align="center">
  <img src = "https://github.com/patrickellis/Portfolio/blob/master/images/docs/anti-gif-2.gif" style="padding-top:100px; width:350px;height:350px;" width="650" />
</p>
