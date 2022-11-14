#! /usr/bin/env bash

# Set Spark environment if you have not set them elsewhere
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.ea.28-7.el7.x86_64
# export SPARK_HOME=$HOME/.local/mapreduce/spark-current
# export SPARK_CONF_DIR=$HOME/.local/mapreduce/spark-on-slurm
# export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH
# export PATH=$JAVA_HOME/bin:$SPARK_HOME/bin:$PATH

if [[ -z $SLURMD_NODENAME ]]; then
    echo -e "Please run this command in a SLURM job session with something similar as

    srun --export=ALL --nodes 3 --cpus-per-task 56 --mem=240G --time=24:00:00 --pty /usr/bin/bash
    "
    exit 0;
fi

if [[ -z $JAVA_HOME ]]; then
    echo '$JAVA_HOME not set!'
    exit 0;
fi
if [[ -z $SPARK_HOME ]]; then
    echo '$SPARK_HOME not set!'
    exit 0;
fi
if [[ -z $SPARK_CONF_DIR ]]; then
    echo '$SPARK_CONF_DIR not set!'
    exit 0;
fi


if [[ -f $SPARK_CONF_DIR/workers ]]; then
    mv $SPARK_CONF_DIR/workers $SPARK_CONF_DIR/worker.old
fi

if [[ -f $SPARK_CONF_DIR/spark-defaults.conf ]]; then
    cp $SPARK_CONF_DIR/spark-defaults.conf $SPARK_CONF_DIR/spark-defaults.old
else
    touch $SPARK_CONF_DIR/spark-defaults.conf
fi

# Set Spark master and workers
nodelist=`scontrol show hostnames`
for node in $nodelist
do
    if [[ $node == $SLURMD_NODENAME ]]; then
	sed -i 's/^spark.master/# &/' $SPARK_CONF_DIR/spark-defaults.conf
	echo -e "spark.master     spark://${node}:7077" >> $SPARK_CONF_DIR/spark-defaults.conf
	echo Set $node as spark master
    else
	echo Add workers
        echo $node >> ${SPARK_CONF_DIR}/workers
    fi
done

# Start masters and workers
eval ${SPARK_HOME}/sbin/start-all.sh
