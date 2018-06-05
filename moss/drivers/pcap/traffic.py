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

from collections import defaultdict
from functools import partial

from moss.common.utils import get_now_second_datetime
from moss.common.utils import formate_date_time
from moss.common.utils import to_timestamp

from moss.common.logging import logger

from moss.drivers.pcap.plugin import Plugin

SRC_OFF = 12
DST_OFF = 16
ETHER_TYPE_OFF = 12
ETHER_HEADER_LEN = 14
ETHER_LEN_OFF = ETHER_HEADER_LEN + 2
ETHERTYPE_IP = 0x0800

DELAY = 1


class Package(object):
    def __init__(self, timestamp, pkt):
        self._timestamp = timestamp
        self.date_time = formate_date_time(timestamp + 1)
        self._pkt = pkt

    def _log_package(self):
        if self.valid() and self.src == '192.168.0.37' and self.dst == '192.168.0.36':
            logger.warning("%s src: %s dst: %s len %s"%(
                             self._timestamp, self.src, self.dst,self.length))
    @property
    def ether_type(self):
        return (ord(self._pkt[ETHER_TYPE_OFF]) * 16 * 16
                + ord(self._pkt[ETHER_TYPE_OFF + 1]))

    def addr(self, offset):
        return ('.'.join(str(ord(self._pkt[i]))
                         for i in range(offset, offset + 4)))

    def valid(self):
        return ETHERTYPE_IP == self.ether_type

    @property
    def length(self):
        return (ord(self._pkt[ETHER_LEN_OFF]) * 16 * 16
                + ord(self._pkt[ETHER_LEN_OFF + 1]))

    @property
    def src(self):
        return self.addr(ETHER_HEADER_LEN + SRC_OFF)

    @property
    def dst(self):
        return self.addr(ETHER_HEADER_LEN + DST_OFF)

    @property
    def direction(self):
        return '{src}->{dst}'.format(src=self.src,
                                     dst=self.dst)

    def report(self):
        return dict(time=self.date_time,
                    src=self.src,
                    dst=self.dst,
                    value=self.length,
                    meta=dict())

dst_dict = partial(defaultdict, int)
src_dict = partial(defaultdict, dst_dict)


def time_is_over(date_time):
    now = get_now_second_datetime(delay=DELAY)
    return now > date_time


def list_rates(rates, date_time):
    values = list()
    for src in rates:
        for dst in rates[src]:
            values.append(dict(value=rates[src][dst],
                               time=to_timestamp(date_time),
                               meta=dict(src=src, dst=dst),
                               )
                          )
    return values


class NetTraffic(object):
    def __init__(self):
        self._rates = defaultdict(src_dict)

    def _log_packages(self, package):
        if package.src == '192.168.0.37' and package.dst == '192.168.0.36':
            logger.warning("%s src: %s dst: %s len %s"%(
                             package.date_time, package.src, package.dst,
                             self._rates[package.date_time][package.src][package.dst]))

    def add(self, package):
        self._rates[package.date_time][package.src][package.dst] += package.length

    def pop_rates(self, closed=False):
        """
        :param closed: type bool mean if device is close
        :return: list type, metrics array
        """
        rates = list()
        for date_time in self._rates.keys():
            if time_is_over(date_time) or closed:
                rates.extend(self._pop_date_time_rates(date_time))
        return rates

    def _pop_date_time_rates(self, date_time):
        return list_rates(self._rates.pop(date_time), date_time)

    def __str__(self):
        values = list()
        for date_time, flows in self._rates.iteritems():
            values.extend(list_rates(flows, date_time))
        return '\n'.join(values)


class TrafficCounter(Plugin):
    def __init__(self):
        self.name = 'traffic_counter'
        self.net_traffic = NetTraffic()

    def _collect(self, package):
        self.net_traffic.add(package)

    def collect(self, timestamp, pkt):
        package = Package(timestamp, pkt)
        if package.valid():
            self._collect(package)

    def report(self, closed=False):
        return self.net_traffic.pop_rates(closed)

    def __str__(self):
        return self.name
