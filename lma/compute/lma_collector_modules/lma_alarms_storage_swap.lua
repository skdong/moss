local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'swap-usage-critical',
    ['description'] = 'There is no more swap free space',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'swap_free',
          ['fields'] = {
          },
          ['relational_operator'] = '==',
          ['threshold'] = '0',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'max',
          ['group_by'] = {
          },
        },
      },
    },
  },
  {
    ['name'] = 'swap-activity-warning',
    ['description'] = 'The swap activity is high',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'swap_io_in',
          ['fields'] = {
          },
          ['relational_operator'] = '>=',
          ['threshold'] = '1048576',
          ['window'] = '120',
          ['periods'] = '0',
          ['function'] = 'avg',
          ['group_by'] = {
          },
        },
        {
          ['metric'] = 'swap_io_out',
          ['fields'] = {
          },
          ['relational_operator'] = '>=',
          ['threshold'] = '1048576',
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
    ['name'] = 'swap-usage-warning',
    ['description'] = 'The swap free space is low',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'swap_percent_used',
          ['fields'] = {
          },
          ['relational_operator'] = '>=',
          ['threshold'] = '0.8',
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
