#!/bin/bash

if [ $# -ne 2 ]; then
    echo "usage: $0 workers runs"
    echo ""
    echo "workers: 4, 8, 16, 32, 64, or 128"
    exit -1
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

WORKERS=$1
RUNS=$2

case ${WORKERS} in
    4)   GRAPHS=(amazon google patents);
         TOL=(0.408805 2.306985 2.220446E-16);   # for PageRank
         SRC=(0 0 6009554);;  # for SSSP
    8)   GRAPHS=(amazon google patents);
         TOL=(0.408805 2.306985 2.220446E-16);
         SRC=(0 0 6009554);;
    16)  GRAPHS=(livejournal orkut arabic);
         TOL=(0.392500 0.011872 75.448252);
         SRC=(0 1 3);;
    32)  GRAPHS=(livejournal orkut arabic);
         TOL=(0.392500 0.011872 75.448252);
         SRC=(0 1 3);;
    64)  GRAPHS=(livejournal orkut arabic twitter uk0705);
         TOL=(0.392500 0.011872 75.448252);
         SRC=(0 1 3 0 0);;
    128) GRAPHS=(livejournal orkut arabic twitter uk0705);
         TOL=(0.392500 0.011872 75.448252);
         SRC=(0 1 3 0 0);;
    *) echo "Invalid workers"; exit -1;;
esac

#################
# Sync run
#################
# we split the algs up for simplicity
for j in "${!GRAPHS[@]}"; do
    for ((i = 1; i <= RUNS; i++)); do
        ./pagerank.sh "${GRAPHS[$j]}-adj.txt" ${WORKERS} 0 ${TOL[$j]}
    done
done
 
for j in "${!GRAPHS[@]}"; do
    for ((i = 1; i <= RUNS; i++)); do
        ./sssp.sh "${GRAPHS[$j]}-adj.txt" ${WORKERS} 0 ${SRC[$j]}
    done
done
 
for graph in "${GRAPHS[@]}"; do
    for ((i = 1; i <= RUNS; i++)); do
        ./wcc.sh "${graph}-adj.txt" ${WORKERS}
    done
done

#for graph in "${GRAPHS[@]}"; do
#    for ((i = 1; i <= RUNS; i++)); do
#        ./dimest.sh "${graph}-adj.txt" ${WORKERS}
#    done
#done

#################
# Async Run
#################
for j in "${!GRAPHS[@]}"; do
    for ((i = 1; i <= RUNS; i++)); do
        ./pagerank.sh "${GRAPHS[$j]}-adj.txt" ${WORKERS} 1 ${TOL[$j]}
    done
done

for j in "${!GRAPHS[@]}"; do
    for ((i = 1; i <= RUNS; i++)); do
        ./sssp.sh "${GRAPHS[$j]}-adj.txt" ${WORKERS} 1 ${SRC[$j]}
    done
done

# no WCC
# no dimest