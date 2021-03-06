-- Copyright 2015 Mirantis, Inc.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

-- list of fields that are added to Heka messages by the collector
tags = {
    ['deployment_id'] = '1',
    ['environment_label'] = 'env-1',
    ['openstack_region'] = 'RegionOne',
    ['openstack_release'] = 'mitaka-9.0',
    ['openstack_roles'] = 'ceph-osd,compute',
}

return M
