local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'network-critical-dropped-rx',
    ['description'] = 'Too many received packets have been dropped',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'if_dropped_rx',
          ['fields'] = {
          },
          ['relational_operator'] = '>',
          ['threshold'] = '1000',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'avg',
          ['group_by'] = {
          },
        },
      },
    },
  },
  {
    ['name'] = 'network-warning-dropped-rx',
    ['description'] = 'Some received packets have been dropped',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'if_dropped_rx',
          ['fields'] = {
          },
          ['relational_operator'] = '>',
          ['threshold'] = '100',
          ['window'] = '60',
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
