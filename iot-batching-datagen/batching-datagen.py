#!/usr/bin/env python3

import time
import json
import random
from faker import Faker


fake = Faker()
NUM_RECS = 10
NUM_SENSORS = 10
NUM_SAMPLES = 100

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
                        "Timestamp": t0 + 1000 * s,
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

    sensors = [
        {
            "TagId": fake.uuid4(),
            "mu": random.uniform(10.0, 20.0),
            "sigma": random.uniform(2.0, 5.0)
        }
        for i in range(NUM_SENSORS)
    ]
    t0 = int(time.time() * 1000)
    for nRec in range(NUM_RECS):
        r = genDataSet(sensors, t0)
        t0 += 1000 * NUM_SAMPLES
        
    print(json.dumps(r))
    # print(json.dumps(r, indent=4))

if __name__ == "__main__":
    main()
