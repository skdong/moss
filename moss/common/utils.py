# Copyright (c) 2018 Slancer Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import datetime
import time
import pcap

_ISO8601_TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'
DATA_LINK = 1


def formate_date_time(timestamp):
    date_time = datetime.datetime.fromtimestamp(timestamp)
    return date_time.strftime(_ISO8601_TIME_FORMAT)


def to_timestamp(date_time):
    date_time = datetime.datetime.strptime(date_time, _ISO8601_TIME_FORMAT)
    return time.mktime(date_time.timetuple())


def get_now_second_datetime(delay=0):
    """
    :param delay: type int , now time delay seconds
    :return: type string, now time delay delay seconds iso8601 type string
    """
    now = datetime.datetime.now() - datetime.timedelta(seconds=delay)
    return now.strftime(_ISO8601_TIME_FORMAT)


def get_dl_off(link=DATA_LINK):
    return pcap.dltoff[link]
