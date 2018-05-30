local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'rabbitmq-queue-warning',
    ['description'] = 'The number of outstanding messages is too high',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'okay',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'rabbitmq_messages',
          ['fields'] = {
          },
          ['relational_operator'] = '>=',
          ['threshold'] = '200',
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
