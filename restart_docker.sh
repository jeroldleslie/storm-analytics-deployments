docker stop $(docker ps -aq)
docker rm -f $(docker ps -aq)
docker run -d -p 22 -p 2181 --privileged -h zookeeper-1 --name zookeeper-1 zoo-kafka-storm-base:sneha
docker run -d -p 22 -p 9092 --privileged -h kafka-storm-1 --name kafka-storm-1 zoo-kafka-storm-base:sneha
docker run -d -p 22 -p 9092 --privileged -h kafka-storm-2 --name kafka-storm-2 zoo-kafka-storm-base:sneha
docker run -d -p 22 -p 9092 --privileged -h kafka-storm-3 --name kafka-storm-3 zoo-kafka-storm-base:sneha

