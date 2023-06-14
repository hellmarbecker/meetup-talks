import yaml
import json
import time
import socket
import argparse, sys, logging
from faker import Faker
from confluent_kafka import Producer

TOPIC = "ksql_shop_users"
fake = Faker()
msgCount = 0
person_version = [ 0 ] * 10

def emitPersonRec(producer, topic, timestamp):

    global msgCount
    person_id = fake.random_int(min=0, max=9)
    rec = {
        "id": person_id,
        "version": person_version[person_id],
        "name": fake.name(),
        "address": fake.address()
    }
    rec_json = json.dumps(rec)
    producer.produce(topic, key=str(rec["id"]), value=rec_json, timestamp=timestamp)
    msgCount += 1
    person_version[person_id] += 1
    if msgCount >= 2000:
        producer.flush()
        msgCount = 0
    producer.poll(0)


def main():

    logLevel = logging.INFO
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--debug', help='Enable debug logging', action='store_true')
    parser.add_argument('-q', '--quiet', help='Quiet mode (overrides Debug mode)', action='store_true')
    parser.add_argument('-f', '--config', help='Configuration file for session state machine(s)', required=True)
    # parser.add_argument('-n', '--dry-run', help='Write to stdout instead of Kafka',  action='store_true')
    args = parser.parse_args()
                    
    if args.debug:  
        logLevel = logging.DEBUG
    if args.quiet:  
        logLevel = logging.ERROR
                    
    logging.basicConfig(format='%(asctime)s [%(levelname)s] %(message)s', level=logLevel)
                    
    cfgfile = args.config 
    logging.debug(f'reading config file {cfgfile}')
    with open(cfgfile, 'r') as f:
        kafkaconf = yaml.load(f, Loader=yaml.FullLoader)

    kafkaconf['client.id'] = socket.gethostname()
    logging.debug(f'Kafka client configuration: {kafkaconf}')
    producer = Producer(kafkaconf)

    start_time_ms = time.time() * 1000 - 1000 * 86400
    for i in range(0, 100000):
        emitPersonRec(producer, TOPIC, int(start_time_ms + 1000 * i))


if __name__ == "__main__":
    main()
