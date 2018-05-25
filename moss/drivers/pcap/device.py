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

import re
import pcap

from moss.drivers.pcap.net_analyst import NetFlowRateAnalyst


PACAGE_NUM = 0
NET_DEV = '/proc/net/dev'
DEV_PATTERN = re.compile(r'tap\w*-\w*')


class Device(object):
    def __init__(self, name=None):
        self.name = name
        self._driver = pcap.pcap(name)
        self.fileno = self._driver.fileno()
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

    def collec_package(self):
        if self._driver:
            self._driver.dispatch(PACAGE_NUM, self._collect_package)

    def report_packages(self):
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
        return 'device name: %s\n\tpackage %s'%(self.name,self.plugins)

