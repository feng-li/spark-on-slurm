# Spark standalone server on Slurm cluster

Simple script to deploy a Spark (with workers) server on a Slurm cluster


## Steps

### Use `srun` to allocate cluster resources

``` shell
srun --export=ALL --nodes 3 --cpus-per-task 56 --mem=240G --time=24:00:00 --pty /usr/bin/bash
```

The above command will allocate three nodes with an interactive session on the first node.


### Start the Spark cluster

``` shell
bash start_spark_standalone_on_slurm.sh
```

This script firstly writes the `spark-defaults.conf` file with the first allocated Slurm node as the master and writes a `workers` file with other nodes as workers. And then start the server.
