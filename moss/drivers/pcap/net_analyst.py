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
    def dst(self):
        return self.addr(ETHER_HEADER_LEN + DST_OFF)

    def report(self):
        return dict(time=self.date_time,
                    src=self.src,
                    dst=self.dst,
                    value=self.length)


class NetFlowRateAnalyst(Plugin):
    def __init__(self):
        self.name = 'flow_rate'
        self.net_flow_rate = list()

    def _collect(self, package):
        self.net_flow_rate.append(package.report())

    def collet(self, timestamp, pkt):
        package = Package(timestamp, pkt)
        if package.valid():
            self._collect(package)

    def report(self, closed=True):
        flows = self.net_flow_rate
        self.net_flow_rate = list()
        return flows

    def __str__(self):
        return self.name
