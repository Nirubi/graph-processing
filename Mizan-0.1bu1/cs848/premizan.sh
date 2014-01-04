#!/bin/bash -e

# partition type is either 1 (hash) or 2 (range)
if [ $# -ne 3 ]; then
    echo "usage: $0 [input graph] [workers] [partition type]"
    exit -1
fi

inputgraph=$(basename $1)

logname=premizan_${inputgraph}_${2}_${3}_"$(date +%F-%H-%M-%S)"
logfile=${logname}.txt

## start logging memory + network usage
./bench_init.sh ${logname}

cd ../preMizan/hadoopScripts/

# modified from preMizan/preMizan.sh
case $3 in
    [1]*) ./hadoop_run_modhash.sh $inputgraph $2 true 2>&1 | tee -a ../../cs848/${logfile};;
    [2]*) ./hadoop_run_range.sh $inputgraph $2 true 2>&1 | tee -a ../../cs848/${logfile};;
    *) echo "Error: invalid partition type!";;
esac

cd ../../cs848/
touch premizan_${inputgraph}_${2}_${3}_"$(date +%F-%H-%M-%S)"_done.txt

## finish logging memory + network usage
./bench_finish.sh ${logname}