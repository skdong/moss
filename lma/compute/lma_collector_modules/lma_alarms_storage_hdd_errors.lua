local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'hdd-errors-critical',
    ['description'] = 'Errors on hard drive(s) have been detected',
    ['severity'] = 'critical',
    ['no_data_policy'] = 'okay',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'hdd_errors_rate',
          ['fields'] = {
          },
          ['relational_operator'] = '>',
          ['threshold'] = '0',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'max',
          ['group_by'] = {
              device,
          },
        },
      },
    },
  },
}

return alarms
