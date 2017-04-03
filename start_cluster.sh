sleep 5
echo "Start Zookeeper"
docker exec -it zookeeper-1 /opt/zookeeper/bin/zkServer.sh start

sleep 5
echo "Start 3 Kafka"
docker exec -it kafka-1 /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
docker exec -it kafka-2 /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
docker exec -it kafka-3 /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties