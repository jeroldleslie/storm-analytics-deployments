
echo "Start Zookeeper"
ssh sneha@zookeeper-1 '/opt/zookeeper/bin/zkServer.sh start'

sleep 3
echo "Start Kafka cluster"
ssh sneha@kafka-storm-1 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'
echo 'kafka-1 started'
ssh sneha@kafka-storm-2 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'
echo 'kafka-2 started'
ssh sneha@kafka-storm-3 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'
echo 'kafka-3 started'

echo "Start Storm Cluster"
ssh sneha@kafka-storm-1 'nohup /opt/storm/bin/storm nimbus &' &
echo 'Storm nimbus started'
ssh sneha@kafka-storm-1 'nohup /opt/storm/bin/storm ui &' &
echo 'Storm ui started'
ssh sneha@kafka-storm-2 'nohup /opt/storm/bin/storm supervisor&' &
echo 'Storm supervisor started'
ssh sneha@kafka-storm-3 'nohup /opt/storm/bin/storm supervisor&' &
echo 'Storm supervisor started'