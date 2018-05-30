local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'cpu-critical-controller',
    ['description'] = 'The CPU usage is too high (controller node)',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'cpu_idle',
          ['fields'] = {
          },
          ['relational_operator'] = '<=',
          ['threshold'] = '5',
          ['window'] = '120',
          ['periods'] = '0',
          ['function'] = 'avg',
          ['group_by'] = {
          },
        },
        {
          ['metric'] = 'cpu_wait',
          ['fields'] = {
          },
          ['relational_operator'] = '>=',
          ['threshold'] = '35',
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
    ['name'] = 'cpu-warning-controller',
    ['description'] = 'The CPU usage is high (controller node)',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'cpu_idle',
          ['fields'] = {
          },
          ['relational_operator'] = '<=',
          ['threshold'] = '15',
          ['window'] = '120',
          ['periods'] = '0',
          ['function'] = 'avg',
          ['group_by'] = {
          },
        },
        {
          ['metric'] = 'cpu_wait',
          ['fields'] = {
          },
          ['relational_operator'] = '>=',
          ['threshold'] = '25',
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
