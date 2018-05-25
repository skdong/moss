import unittest
import pprint
from moss.drivers.pcap.driver import DevicesDriver

def print_metrics(metrics):
    pprint.pprint(metrics)

class DevicesDriverTest(unittest.TestCase):
    def setUp(self):
        self._driver = DevicesDriver()

    def test_report_metrics(self):
        metrics = self._driver.report_metrics()
        print_metrics(metrics)

    def tearDown(self):
        self._driver.shutdown()
        self._driver = None
