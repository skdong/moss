local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'nova-aggregates-free-memory-critical',
    ['description'] = 'The nova aggregates free memory percent is too low',
    ['severity'] = 'critical',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_nova_aggregate_free_ram_percent',
          ['fields'] = {
          },
          ['relational_operator'] = '<',
          ['threshold'] = '1.0',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'min',
          ['group_by'] = {
              aggregate,
          },
        },
      },
    },
  },
  {
    ['name'] = 'nova-aggregates-free-memory-warning',
    ['description'] = 'The nova aggregates free memory percent is low',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_nova_aggregate_free_ram_percent',
          ['fields'] = {
          },
          ['relational_operator'] = '<',
          ['threshold'] = '10.0',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'min',
          ['group_by'] = {
              aggregate,
          },
        },
      },
    },
  },
}

return alarms
