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

from abc import abstractmethod


class Plugin(object):
    @abstractmethod
    def collet(self, timestamp, pkt):
        pass

    @abstractmethod
    def report(self):
        """
        :return: metric list, etch item has time and value key
            time is timestamp type, value is int or float type
            example:
            [{
              'time': 1527215978.0,
              'value': 120},
             {
              'time': 1527215979.0,
              'value': 44},
              ]
        """
        pass
