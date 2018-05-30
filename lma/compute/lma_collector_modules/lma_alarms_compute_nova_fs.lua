local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'nova-fs-critical',
    ['description'] = 'The filesystem\'s free space is too low (compute node)',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'fs_space_percent_free',
          ['fields'] = {
            ['fs'] = '/var/lib/nova',
          },
          ['relational_operator'] = '<',
          ['threshold'] = '5',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'min',
          ['group_by'] = {
          },
        },
      },
    },
  },
  {
    ['name'] = 'nova-fs-warning',
    ['description'] = 'The filesystem\'s free space is low (compute node)',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'fs_space_percent_free',
          ['fields'] = {
            ['fs'] = '/var/lib/nova',
          },
          ['relational_operator'] = '<',
          ['threshold'] = '10',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'min',
          ['group_by'] = {
          },
        },
      },
    },
  },
}

return alarms
