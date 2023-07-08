export SPARK_HOME=$HOME/.local/mapreduce/spark
export SPARK_CONF_DIR=$HOME/.local/mapreduce/spark-on-slurm/spark_conf

# Find Java installation home based on the system java executable
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

py4j=$(find "$SPARK_HOME/python/lib/" -maxdepth 1 -type f -name "*src.zip")
export PYTHONPATH=$SPARK_HOME/python:$py4j:$PYTHONPATH

export PATH=$SPARK_HOME/bin:$PATH

export PYARROW_IGNORE_TIMEZONE=1
