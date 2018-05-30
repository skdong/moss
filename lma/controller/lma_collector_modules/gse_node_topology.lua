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

clusters = {
    ['compute']={
        ['members']={'cpu','hdd-errors','network-rx','network-tx','nova-fs','other-fs','root-fs','swap'},
        ['hints']={},
        ['group_by']='hostname',
        ['policy']='majority_of_node_members'
    },
    ['controller']={
        ['members']={'cpu','hdd-errors','log-fs','network-rx','network-tx','other-fs','root-fs','swap'},
        ['hints']={},
        ['group_by']='hostname',
        ['policy']='status_of_members'
    },
    ['elasticsearch-nodes']={
        ['members']={'cpu','data-fs','hdd-errors','network-rx','network-tx','root-fs','swap'},
        ['hints']={},
        ['group_by']='hostname',
        ['policy']='status_of_members'
    },
    ['influxdb-nodes']={
        ['members']={'cpu','data-fs','hdd-errors','network-rx','network-tx','root-fs','swap'},
        ['hints']={},
        ['group_by']='hostname',
        ['policy']='status_of_members'
    },
    ['mysql-nodes']={
        ['members']={'mysql-fs'},
        ['hints']={},
        ['group_by']='hostname',
        ['policy']='status_of_members'
    },
    ['storage']={
        ['members']={'cpu','hdd-errors','network-rx','network-tx','osd-disk','other-fs','root-fs','swap'},
        ['hints']={},
        ['group_by']='hostname',
        ['policy']='majority_of_node_members'
    },
}

return M
