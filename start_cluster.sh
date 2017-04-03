
echo "Start Zookeeper"
ssh sneha@zookeeper-1 '/opt/zookeeper/bin/zkServer.sh start'

sleep 3
echo "Start 3 node Kafka cluster"
ssh sneha@kafka-storm-1 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'
ssh sneha@kafka-storm-2 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'
ssh sneha@kafka-storm-3 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'


