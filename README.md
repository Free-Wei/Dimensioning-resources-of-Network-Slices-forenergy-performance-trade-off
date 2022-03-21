
# Dimensioning resources of Network Slices forenergy-performance trade-off
This code is a part of the paper "Dimensioning resources of Network Slices forenergy-performance trade-off". If you find it useful for your work, please consider citation.

In the paper we provide a strategy for a network operator to perform optimal slice resource dimensioning, via dimensioning capacities of multiple Jackson networks, each corresponding to a slice, co-existing in the same resource-constrained physical network.

The source code contained in this repository shows numerically that our solution is able to achieve both minimize energy consumption and at the same time and satisfying the latency requirements of heterogeneous SPs, differently from classic approaches, which assume that the amount of resources assigned to slices is fixed a-priori.

## Requirements
Matlab v2021b

## Usage
Run the script directly in Matlab.

The routing and components placement are the same as our paper, which has 2 SP with 5 ingress nodes.
