# Spark standalone server on a Slurm cluster

Simple script to deploy a Spark (with workers) server on a Slurm cluster

## Prerequisites

- A Slurm server with a shared folder to all computing nodes.
- A [latest Spark biniary](https://spark.apache.org/downloads.html) unzipped in that shared folder (`$SPARK_HOME`).

## Steps

### Setup Spark environment

Using the following command to setup the necessary environment `$JAVA_HOME`,  `$SPARK_HOME` and `SPARK_CONF`

``` shell
source setup-spark-env.sh
```


### Allocate cluster resources

Do not leave the current shell and run

```shell
srun --export=ALL --nodes 3 --cpus-per-task 56 --mem=240G --time=24:00:00 --pty /usr/bin/bash
```

The above command will allocate three nodes with an interactive session on the first node.


### Start the Spark cluster in the Slurm Job session

Make sure you have the essential environment variables `JAVA_HOME`, `SPARK_HOME` and `SPARK_CONF_DIR` set. If not, please edit `start_spark_standalone_on_slurm.sh` and set in there.

```shell
bash start_spark_standalone_on_slurm.sh
```

This script firstly writes the `spark-defaults.conf` file with the first allocated Slurm node as the master and writes a `workers` file with other nodes as workers. And then start the master and workers.

## Using Spark

### Use it in a batch mode

```shell
$SPARK_HOME/bin/spark-submit <application.py>
```

### Start an interactive Spark shell

```shell
$SPARK_HOME/bin/pyspark
```

## Stop Spark cluster

- If you terminated your Slurm Job with `scancel`, the Spark server will be terminated unconditionally.

- If you want to terminate your Spark server within a Slurm job session, you could run

```shell
$SPARK_HOME/sbin/stop-all.sh
```
