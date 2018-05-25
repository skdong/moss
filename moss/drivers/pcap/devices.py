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

import select

from moss.drivers.pcap.device import Device
from moss.common.logging import logger


class Devices(object):
    def __init__(self):
        self._handler = DevicesHandler()
        self._ports = dict()

    def report_device(self):
        self._handler.collect_device()
        return self._report_device()

    def _report_device(self):
        metrics = list()
        for device in self._ports.values():
            metrics.extend(device.report_packages())
        self._clean_dirty_devices()
        return metrics

    def _clean_dirty_devices(self):
        for device in self._ports.values():
            if device.closed:
                self._ports.pop(device.name)

    def _add_device(self, device):
        if device not in self._ports.keys():
            self._ports[device] = Device(device)
            self._handler.add_device(self._ports[device])

    def load_net_devices(self, devices):
        for key in self._ports.keys():
            if key not in devices:
                self._close_device(key)
        for device in devices:
            self._add_device(device)

    def __str__(self):
        return '\n'.join(['%s: %s' % (k, v) for k, v in self._ports.items()])

    def _close_device(self, name):
        device = self._ports.get(name)
        self._handler.del_device(device)

    def close(self):
        self._handler.close()
        for device in self._ports.values():
            device.close()



class DevicesHandler(object):

    def __init__(self):
        self._epoll = select.epoll()
        self._handlers = dict()

    def close(self):
        self._epoll.close()

    def add_device(self, device):
        if device.fileno and device.fileno not in self._handlers:
            self._handlers[device.fileno]  = device
            self._epoll.register(device.fileno, select.EPOLLIN)

    def del_device(self, device):
        self.collect_device()
        self._handlers.pop(device.fileno, None)
        if device.fileno:
            self._epoll.unregister(device.fileno)
        device.close()

    def collect_device(self):
        logger.warning('epoll device begin')
        for handle, event in self._epoll.poll():
            logger.warning('%s has package'%handle)
            device = self._handlers[handle]
            device.collec_package()
        logger.warning('epoll device over')

