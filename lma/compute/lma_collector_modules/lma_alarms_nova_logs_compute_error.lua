local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'nova-logs-error',
    ['description'] = 'Too many errors have been detected in Nova logs',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'okay',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'log_messages',
          ['fields'] = {
            ['service'] = 'nova',
            ['level'] = 'error',
          },
          ['relational_operator'] = '>',
          ['threshold'] = '0.1',
          ['window'] = '70',
          ['periods'] = '0',
          ['function'] = 'max',
          ['group_by'] = {
          },
        },
      },
    },
  },
}

return alarms
