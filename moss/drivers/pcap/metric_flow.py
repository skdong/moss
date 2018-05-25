from collections import defaultdict
from abc import abstractmethod
import re
import pcap

from util import get_now_second_datetime
from util import formate_date_time
from util import to_timestamp
from util import DELAY


PACAGE_NUM = 1024
NET_DEV = '/proc/net/dev'
DEV_PATTERN = re.compile(r'tap\w*-\w*')

class Devices(dict):

    def __getattr__(self, key):
        return self[key]

    def __setattr__(sekf, key, value):
        self[key] = value

    def report_device(self):
        metrics = list()
        for device in self.values():
           metrics.extend(device.report_packages())
        self._clean_dirty_devices()
        return metrics

    def _clean_dirty_devices(self):
        for device in self.values():
           if device.closed:
              self.pop(device.name)

    def _add_device(self, device):
        if device not in self.keys():
            self[device] = Device(device)

    def load_net_devices(self, devices):
        for key in self.keys():
           if key not in devices:
               self[key].close()
        for device in devices:
           self._add_device(device)

    def __str__(self):
        return '\n'.join(['%s: %s'%(k,v) for k,v in self.items()])

    def close(self):
        for device in self.values():
           device.close()


class Plugin(object):

    @abstractmethod
    def collet(self, timestamp, pkt):
        pass

    @abstractmethod
    def report(self):
        pass

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


from functools import partial
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


class Device(object):
    def __init__(self, name=None):
        self.name = name
        self._driver = pcap.pcap(name)
        self.plugins = [NetFlowRateAnalyst()]

    def _collect_package(self, timestamp, pkt):
        for plugin in self.plugins:
            plugin.collet(timestamp, pkt)

    def _report_aggregate(self):
        aggregates = list()
        for plugin in self.plugins:
            for aggregate in plugin.report(self.closed):
                aggregate['device'] = self.name
                aggregate['meta']['plugin'] = plugin.name
                aggregates.append(aggregate)
        return aggregates

    def report_packages(self):
        if self._driver:
            self._driver.dispatch(PACAGE_NUM, self._collect_package)
        return self._report_aggregate()

    def close(self):
        try:
            self._driver.close()
        except:
            pass
        self._driver=None

    @property
    def closed(self):
        return bool(self._driver)

    def __str__(self):
        return 'device name: %s\n\tpackage %s'%(self.name,self.counter)

import json
def dump_aggregates(aggregates):
    with open('/var/log/bright_2.table', 'a') as fp:
        for aggregate in aggregates:
            fp.write('%s\tvaluse:%s\n'%(json.dumps(aggregate['meta']),
                                         aggregate['value']))


class DevicesManager(object):
    def __init__(self, net_dev=NET_DEV, dev_pattern=DEV_PATTERN):
        self._net_dev = net_dev
        self._dev_pattern = dev_pattern
        self._devices = Devices()

    def dump_devices(self):
        return str(self._devices)

    def _get_net_devices(self):
        devices = list()
        with open(self._net_dev) as fp:
            for device in fp.readlines():
                match = self._dev_pattern.match(device)
                if match:
                     devices.append(match.group())
        return devices

    def _load_pattern_devices(self):
        devices = self._get_net_devices()
        self._devices.load_net_devices(devices)

    def load_devices(self):
        self._load_pattern_devices()

    def report_metrics(self):
        self._load_pattern_devices()
        return self._devices.report_device()

    def shutdown(self):
        self._devices.close()
        self._devices = None

    def close(self):
        self._devices.close()


def main():
    manage = DevicesManager()
    manage.report_metrics()
    manage.close()


if __name__ == '__main__':
    main()
