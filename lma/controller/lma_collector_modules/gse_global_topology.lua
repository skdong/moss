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
    ['apache']={
        ['members']={'apache'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['ceilometer']={
        ['members']={'ceilometer-api','ceilometer-api-check'},
        ['hints']={'keystone','rabbitmq'},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['ceph']={
        ['members']={'ceph-mon-cluster','ceph-mon-service','ceph-osd-service'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['cinder-control-plane']={
        ['members']={'cinder-api','cinder-api-check','cinder-api-endpoint','cinder-logs','cinder-scheduler','cinder-v2-api-check'},
        ['hints']={'keystone','mysql','rabbitmq'},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['elasticsearch']={
        ['members']={'elasticsearch-cluster','elasticsearch-service'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['glance']={
        ['members']={'glance-api','glance-api-check','glance-api-endpoint','glance-logs','glance-registry-api'},
        ['hints']={'keystone','mysql'},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['haproxy-openstack']={
        ['members']={'haproxy-openstack'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['heat']={
        ['members']={'heat-api','heat-api-check','heat-api-endpoint','heat-cfn-api','heat-cfn-api-check','heat-cfn-api-endpoint','heat-cloudwatch-api','heat-logs'},
        ['hints']={'cinder-control-plane','glance','keystone','mysql','neutron-control-plane','nova-control-plane','rabbitmq'},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['horizon']={
        ['members']={'horizon-web'},
        ['hints']={'apache','keystone'},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['influxdb']={
        ['members']={'influxdb-api-check','influxdb-service'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['keystone']={
        ['members']={'keystone-admin-api','keystone-logs','keystone-public-api','keystone-public-api-check','keystone-public-api-endpoint','keystone-response-time'},
        ['hints']={'apache','mysql'},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['memcached']={
        ['members']={'memcached-service'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['mysql']={
        ['members']={'mysql','mysqld-tcp'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['neutron-control-plane']={
        ['members']={'neutron-api','neutron-api-check','neutron-api-endpoint','neutron-dhcp','neutron-l3','neutron-logs','neutron-metadata','neutron-openvswitch'},
        ['hints']={'keystone','mysql','rabbitmq'},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['neutron-data-plane']={
        ['members']={'neutron-logs-compute','neutron-openvswitch'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['nova-control-plane']={
        ['members']={'nova-api','nova-api-check','nova-api-endpoint','nova-cert','nova-conductor','nova-consoleauth','nova-logs','nova-metadata-api','nova-novncproxy-websocket','nova-scheduler'},
        ['hints']={'cinder-control-plane','glance','keystone','mysql','neutron-control-plane','rabbitmq'},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['nova-data-plane']={
        ['members']={'libvirt-service','nova-aggregates-free-memory','nova-compute','nova-free-memory','nova-free-vcpu','nova-instances','nova-logs-compute'},
        ['hints']={'neutron-data-plane'},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['pacemaker']={
        ['members']={'pacemaker-service'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
    ['rabbitmq']={
        ['members']={'rabbitmq-cluster','rabbitmq-service'},
        ['hints']={},
        ['group_by']='member',
        ['policy']='highest_severity'
    },
}

return M
