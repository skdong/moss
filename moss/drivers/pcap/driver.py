from collections import defaultdict
from abc import abstractmethod
import re
import pcap

from moss.drivers.pcap.devices import Devices


PACAGE_NUM = 1024
NET_DEV = '/proc/net/dev'
DEV_PATTERN = re.compile(r'tap\w*-\w*')

class DevicesDriver(object):
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

    def report_metrics(self):
        self._load_pattern_devices()
        return self._devices.report_device()

    def shutdown(self):
        self._devices.close()
        self._devices = None

    def close(self):
        self._devices.close()


def main():
    manage = DevicesDriver()
    manage.report_metrics()
    manage.close()


if __name__ == '__main__':
    main()
