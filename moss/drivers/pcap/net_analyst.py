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

from moss.drivers.pcap.plugin import Plugin

SRC_OFF = 12
DST_OFF = 16
ETHER_TYPE_OFF = 12
ETHER_HEADER_LEN = 14
ETHER_LEN_OFF = ETHER_HEADER_LEN + 2
ETHERTYPE_IP = 0x0800

DELAY = 3


class Package(object):
    def __init__(self, timestamp, pkt):
        self.date_time = formate_date_time(timestamp + 1)
        self._pkt = pkt

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
    def dest(self):
        return self.addr(ETHER_HEADER_LEN + DST_OFF)


dst_dict = partial(defaultdict, int)
src_dict = partial(defaultdict, dst_dict)


def time_is_over(date_time):
    now = get_now_second_datetime(delay=DELAY)
    return now > date_time


def list_flows(flows, date_time):
    values = list()
    for src in flows:
        for dst in flows[src]:
            values.append(dict(value=flows[src][dst],
                               time=to_timestamp(date_time),
                               src=src,
                               dst=dst,
                               meta=dict(src=src, dst=dst )
                               )
                          )
    return values


class NetFlowRate(object):
    def __init__(self):
        self.net_flows = defaultdict(src_dict)

    def add(self, package):
        self.net_flows[package.date_time][package.src][package.dest] += package.length

    def pop_flows(self, closed=False):
        """
        :param closed: type bool mean if device is close
        :return: list type, metrics array
        """
        flows = list()
        for date_time in self.net_flows.keys():
            if time_is_over(date_time) or closed:
                flows.extend(self._pop_date_time_flows(date_time))
        return flows

    def _pop_date_time_flows(self, date_time):
        return list_flows(self.net_flows.pop(date_time), date_time)

    def __str__(self):
        values = list()
        for date_time, flows in self.net_flows.iteritems():
            values.extend(list_flows(flows, date_time))
        return '\n'.join(values)


class NetFlowRateAnalyst(Plugin):
    def __init__(self):
        self.name = 'flow_rate'
        self.net_flow_rate = NetFlowRate()

    def _collect(self, package):
        self.net_flow_rate.add(package)

    def collet(self, timestamp, pkt):
        package = Package(timestamp, pkt)
        if package.valid():
            self._collect(package)

    def report(self, closed=True):
        return self.net_flow_rate.pop_flows(closed)

    def __str__(self):
        return self.name
