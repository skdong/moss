local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'cpu-critical-compute',
    ['description'] = 'The CPU usage is too high (compute node)',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'cpu_wait',
          ['fields'] = {
          },
          ['relational_operator'] = '>=',
          ['threshold'] = '30',
          ['window'] = '120',
          ['periods'] = '0',
          ['function'] = 'avg',
          ['group_by'] = {
          },
        },
      },
    },
  },
  {
    ['name'] = 'cpu-warning-compute',
    ['description'] = 'The CPU usage is high (compute node)',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'cpu_wait',
          ['fields'] = {
          },
          ['relational_operator'] = '>=',
          ['threshold'] = '20',
          ['window'] = '120',
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
