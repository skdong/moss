local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'apache-check',
    ['description'] = 'Apache cannot be checked',
    ['severity'] = 'down',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'apache_check',
          ['fields'] = {
          },
          ['relational_operator'] = '==',
          ['threshold'] = '0',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'last',
          ['group_by'] = {
          },
        },
      },
    },
  },
}

return alarms
