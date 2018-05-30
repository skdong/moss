local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'instance-creation-time-warning',
    ['description'] = 'Instance creation takes too much time',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'okay',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_nova_instance_creation_time',
          ['fields'] = {
          },
          ['relational_operator'] = '>',
          ['threshold'] = '20',
          ['window'] = '600',
          ['periods'] = '0',
          ['function'] = 'avg',
          ['group_by'] = {
          },
        },
      },
    },
  },
}

return alarms
