import datetime
import time
import pcap

_ISO8601_TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'
DATA_LINK = 1
DELAY = 3

def formate_date_time(timestamp):
    date_time = datetime.datetime.fromtimestamp(timestamp)
    return date_time.strftime(_ISO8601_TIME_FORMAT)

def to_timestamp(date_time):
    date_time = datetime.datetime.strptime(date_time,_ISO8601_TIME_FORMAT)
    return time.mktime(date_time.timetuple())

def get_now_second_datetime():
    now = datetime.datetime.now() - datetime.timedelta(seconds=DELAY)
    return now.strftime(_ISO8601_TIME_FORMAT)

def get_dl_off(link=DATA_LINK):
    return pcap.dltoff[link]
