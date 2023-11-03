import math, random
import json
from datetime import date, datetime, timedelta
from faker import Faker
import sys

fake = Faker()

def datetimerange(start_date):
    for n in range(7): # 3 days, 1 record per hour
        yield start_date + timedelta(days=n)

def main():

    start_date = datetime(2023, 1, 3)
    for ts in datetimerange(start_date):
        this_dt = ts.strftime("%Y-%m-%dT%H:%M:%SZ")
        for ad_network in (['gaagle']):
            row = {
                "date": this_dt,
                "ad_network": ad_network,
                "ads_impressions": fake.random_int(1000, 10000),
                "ads_revenue": fake.random_int(5000, 50000) / 100.0
            }
            print(json.dumps(row))

if __name__ == "__main__":
    main()
