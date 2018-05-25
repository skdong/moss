import re
import pcap

from moss.drivers.pcap.net_analyst import NetFlowRateAnalyst


PACAGE_NUM = 1024
NET_DEV = '/proc/net/dev'
DEV_PATTERN = re.compile(r'tap\w*-\w*')


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
        while True:
            if self._driver:
                num = self._driver.dispatch(PACAGE_NUM, self._collect_package)
                if num == 0:
                    break
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

