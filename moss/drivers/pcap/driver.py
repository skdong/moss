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
import threading

from moss.drivers.pcap.devices import Devices

PACAGE_NUM = 1024
NET_DEV = '/proc/net/dev'
DEV_PATTERN = re.compile(r'tap\w*-\w*')

TIME_OUT = 5


class DevicesDriver(object):
    def __init__(self, net_dev=NET_DEV, dev_pattern=DEV_PATTERN):
        self._net_dev = net_dev
        self._dev_pattern = dev_pattern
        self._devices = Devices()

        self.stopped = True
        self.collector = threading.Thread(target=self._collect_samples)

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

    def report_metrics(self):
        return self._devices.report_device()

    def _collect_samples(self):
        while True:
            if not self._devices or self.stopped:
                break
            self._load_pattern_devices()
            self._devices.collect_samples(timeout=TIME_OUT)

    def start(self):
        self.stopped = False
        self.collector.start()

    def shutdown(self):
        self.stopped = True
        self._devices.close()
        self._devices = None

    def close(self):
        self._devices.close()

