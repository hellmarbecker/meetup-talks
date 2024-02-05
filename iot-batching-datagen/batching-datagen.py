#!/usr/bin/env python3

import yaml
import json
import random
import math
import time
import argparse, sys, logging
import socket
from faker import Faker
from confluent_kafka import Producer
from confluent_kafka.serialization import StringSerializer, SerializationContext, MessageField, Serializer
from mergedeep import merge



fake = Faker()
NUM_RECS = 10
NUM_SENSORS = 10
NUM_SAMPLES = 100


class PlainJSONSerializer(Serializer): # serialize json without schema registry
    def __call__(self, obj, ctx=None):        
        return json.dumps(obj)
        
msgCount = 0

def emit(producer, topic, key, emitRecord):
    global msgCount

    if producer is None:
        print(f'{key}|{json.dumps(emitRecord)}')
    else:
        producer.produce(topic, key=str(key), value=json.dumps(emitRecord))
        msgCount += 1
        if msgCount >= 2000:
            producer.flush()
            msgCount = 0
        producer.poll(0)

# Read configuration

def readConfig(ifn):
    logging.debug(f'reading config file {ifn}')
    with open(ifn, 'r') as f:
        cfg = yaml.load(f, Loader=yaml.FullLoader)
        includecfgs = []
        # get include files if present
        for inc in cfg.get("IncludeOptional", []):
            try:
                logging.debug(f'reading include file {inc}')
                c = yaml.load(open(inc), Loader=yaml.FullLoader)
                includecfgs.append(c)
            except FileNotFoundError:
                logging.debug(f'optional include file {inc} not found, continuing')
        merge(cfg, *includecfgs)
        logging.info(f'Configuration: {cfg}')
        return cfg


def genDataSet(sensors, t0):

    rec = {
        "CollectionType": "Online",
        "DataStream": "Live",
        "TriggerType": "Trend",
        "SampleSets": [
            {
                "TagId": u["TagId"],
                "SampleType": "StaticDataSample",
                "Samples": [
                    {
                        "Timestamp": (t0 + 1000 * s) * 10000 + 621355968000000000,
                        "DataStatus": 0,
                        "NodeStatus": 0,
                        "Value": random.gauss(u["mu"], u["sigma"])
                    }
                    for s in range(NUM_SAMPLES)
                ]
            }
            for u in sensors
        ]
    }
    return rec

def main():

    logLevel = logging.INFO
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--debug', help='Enable debug logging', action='store_true')
    parser.add_argument('-q', '--quiet', help='Quiet mode (overrides Debug mode)', action='store_true')
    parser.add_argument('-f', '--config', help='Configuration file for session state machine(s)', required=True)
    # parser.add_argument('-m', '--mode', help='Mode for session state machine(s)', default='default')
    parser.add_argument('-n', '--dry-run', help='Write to stdout instead of Kafka',  action='store_true')
    args = parser.parse_args()

    if args.debug:
        logLevel = logging.DEBUG
    if args.quiet:
        logLevel = logging.ERROR

    logging.basicConfig(format='%(asctime)s [%(levelname)s] %(message)s', level=logLevel)

    cfgfile = args.config

    config = readConfig(cfgfile)
    if args.dry_run:
        producer = None
        topic = None
    else:   
        topic = config['General']['topic']
        logging.debug(f'topic: {topic}')
                        
        kafkaconf = config['Kafka']
        kafkaconf['client.id'] = socket.gethostname()
        logging.debug(f'Kafka client configuration: {kafkaconf}')
        producer = Producer(kafkaconf)

    sensors = [
        {
            "TagId": fake.uuid4(),
            "mu": random.uniform(10.0, 20.0),
            "sigma": random.uniform(2.0, 5.0)
        }
        for i in range(NUM_SENSORS)
    ]
    t0 = int(time.time() * 1000)
    while True:
    # for nRec in range(NUM_RECS):
        r = genDataSet(sensors, t0)
        emit(producer, topic, None, r)
        t0 += 1000 * NUM_SAMPLES
        
    # print(json.dumps(r))
    # print(json.dumps(r, indent=4))

if __name__ == "__main__":
    main()
