docker rm -f $(docker ps -aq)
docker run -d -p 22 -p 2181 --privileged -h zookeeper-1 --name zookeeper-1 zookeeper-1:sneha
docker run -d -p 22 -p 9092 --privileged -h kafka-1 --name kafka-1 kafka-storm-1:sneha
docker run -d -p 22 -p 9092 --privileged -h kafka-2 --name kafka-2 kafka-storm-2:sneha
docker run -d -p 22 -p 2181 --privileged -h kafka-3 --name kafka-3 kafka-storm-3:sneha

