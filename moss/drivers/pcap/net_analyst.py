from collections import defaultdict
from functools import partial
import re
import pcap

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

class Package(object):
    def __init__(self, timestamp, pkt):
        self.date_time = formate_date_time(timestamp)
        self._pkt = pkt

    @property
    def ether_type(self):
        return (ord(self._pkt[ETHER_TYPE_OFF]) * 16 * 16
                + ord(self._pkt[ETHER_TYPE_OFF+1]))

    def addr(self, offset):
        return ('.'.join(str(ord(self._pkt[i])) 
                 for i in range(offset, offset + 4)))

    def valid(self):
        return ETHERTYPE_IP == self.ether_type

    @property
    def length(self):
        return (ord(self._pkt[ETHER_LEN_OFF]) * 16 * 16
                + ord(self._pkt[ETHER_LEN_OFF+1]))

    @property
    def src(self):
        return self.addr(ETHER_HEADER_LEN+SRC_OFF)

    @property
    def dest(self):
        return self.addr(ETHER_HEADER_LEN+DST_OFF)


dst_dict = partial(defaultdict, int)
src_dict = partial(defaultdict, dst_dict)

class NetFlowRate(object):
    def __init__(self):
        self.net_flows = defaultdict(src_dict)

    def add(self, package):
        self.net_flows[package.date_time][package.src][package.dest] += package.length

    def pop_flows(self, closed=False):
        flows = {}
        now = get_now_second_datetime()
        for date_time in self.net_flows.keys():
            if now > date_time or closed:
               flows[date_time] = self.net_flows.pop(date_time)
        return flows


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

    def _report(self, flows):
        values = list()
        for date_time in flows:
            for src in flows[date_time]:
                for dst in flows[date_time][src]:
                    values.append(dict(value=flows[date_time][src][dst],
                                       time=to_timestamp(date_time),
                                       src=src,
                                       dst=dst,
                                       meta=dict(src=src,
                                                 dst=dst,))
                                 )
        return values

    def report(self, closed=True):
        flows = self.net_flow_rate.pop_flows(closed)
        return self._report(flows)


