#!/usr/bin/python
# Copyright 2015 Mirantis, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import json
import traceback
import collectd

from metric_flow import DevicesManager


INTERVAL = 10

PLUGIN = 'pcap'
PLUGIN_INSTANCE = ''

class Pcap(object):
    """Pcap class for writing Python plugins."""

    def __init__(self, collectd, service_name=None, local_check=True):
        self.debug = False
        self.timeout = 5
        self.max_retries = 3
        self.logger = collectd
        self.collectd = collectd
        # attributes controlling whether the plugin is in collect mode or not
        self.depends_on_resource = None
        self.do_collect_data = True

        self.service_name = service_name
        self.local_check = True
        self._devices_manage = None

    def init_callback(self):
        self._devices_manage = DevicesManager()
        self._devices_manage.load_devices()

    def config_callback(self, conf):
        for node in conf.children:
            if node.key == "Debug":
                if node.values[0] in ['True', 'true']:
                    self.debug = True
            elif node.key == "Timeout":
                self.timeout = int(node.values[0])
            elif node.key == 'MaxRetries':
                self.max_retries = int(node.values[0])
            elif node.key == 'DependsOnResource':
                self.depends_on_resource = node.values[0]

    def read_callback(self):
        try:
            for metric in self._devices_manage.report_metrics():
                self.dispatch_metric(metric)
        except Exception as e:
            msg = '{}: Failed to get metrics: {}'.format(PLUGIN, e)
            self.logger.warning(msg)


    def dispatch_metric(self, metric):
        try:
            v = self.collectd.Values(
                time=metric.get('time'),
                plugin_instance=metric.get('device'),
                plugin=PLUGIN,
                type='gauge',
                type_instance=(metric.get('src')+'-'+metric.get('dst')),
                values=[metric.get('value'),],
                meta=metric.get('meta')
            )
            v.dispatch()
        except Exception as e:
            msg = '{}: Failed dispatch metric: {}'.format(PLUGIN, e)
            self.logger.warning(msg)

    def notification_callback(self, notification):
        if not self.depends_on_resource:
            return

        try:
            data = json.loads(notification.message)
        except ValueError:
            return

        if 'value' not in data:
            self.logger.warning(
                "%s: missing 'value' in notification" %
                self.__class__.__name__)
        elif 'resource' not in data:
            self.logger.warning(
                "%s: missing 'resource' in notification" %
                self.__class__.__name__)
        elif data['resource'] == self.depends_on_resource:
            do_collect_data = data['value'] > 0
            if self.do_collect_data != do_collect_data:
                # log only the transitions
                self.logger.notice("%s: do_collect_data=%s" %
                                   (self.__class__.__name__, do_collect_data))
            self.do_collect_data = do_collect_data

    def shutdown_callback(self):
        self._devices_manage.shutdown()


plugin = Pcap(collectd, 'pcap')


def init_callback():
    plugin.init_callback()


def config_callback(conf):
    plugin.config_callback(conf)


def read_callback():
    plugin.read_callback()


def shutdown_callback():
    plugin.shutdown_callback()


collectd.register_init(init_callback)
collectd.register_shutdown(shutdown_callback)
collectd.register_config(config_callback)
collectd.register_read(read_callback, INTERVAL)
