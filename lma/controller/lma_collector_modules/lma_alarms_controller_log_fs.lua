local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'log-fs-critical',
    ['description'] = 'The log filesystem\'s free space is too low',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'fs_space_percent_free',
          ['fields'] = {
            ['fs'] = '/var/log',
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
    ['name'] = 'log-fs-warning',
    ['description'] = 'The log filesystem\'s free space is low',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'fs_space_percent_free',
          ['fields'] = {
            ['fs'] = '/var/log',
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
