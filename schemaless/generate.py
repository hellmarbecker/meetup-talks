import math, random
import json
from datetime import date, datetime, timedelta
from faker import Faker
import sys

ROWSPERSEC = 1
NUMSCHEMA = 5
STEPUP = 24 # add more fields after each STEPUP rows

dim_types = { 'd': ['word'], 'm': ['pyfloat'], 'v': ['pyint', 'word', 'pyfloat'] }

fake = Faker()

def datetimerange(start_date):
    for n in range(3 * 24): # 3 days, 1 record per hour
        yield start_date + timedelta(hours=n)

def genspec(n):
    dim_list = ['d' + str(i) for i in range(n)] + ['m' + str(i) for i in range(n)] + ['v' + str(i) for i in range(n)]
    spec = []
    for n in range(NUMSCHEMA):
        fields = fake.words(nb = 5, ext_word_list = dim_list) 
        spec.append({ f : fake.word(ext_word_list = dim_types[f[0]]) for f in fields })
    return spec

def main():

    rows = 0
    ndims = 10
    spec = genspec(ndims)

    start_date = datetime(2022, 1, 1)
    for ts in datetimerange(start_date):
        this_dt = ts.strftime("%Y-%m-%dT%H:%M:%SZ")
        for i in range(ROWSPERSEC):
            obj = json.loads(fake.json(data_columns=spec[fake.random_int(0, NUMSCHEMA-1)], num_rows=1))
            row = dict([("ts", this_dt)]) | obj
            print(json.dumps(row))
            rows += 1
            if (rows % STEPUP == 0):
                ndims += 10
                spec = genspec(ndims)


if __name__ == "__main__":
    main()
