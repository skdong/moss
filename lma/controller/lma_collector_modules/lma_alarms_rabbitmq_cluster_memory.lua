local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'rabbitmq-memory-limit-critical',
    ['description'] = 'RabbitMQ has reached the memory threshold. All producers are blocked',
    ['severity'] = 'critical',
    ['no_data_policy'] = 'okay',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'rabbitmq_remaining_memory',
          ['fields'] = {
          },
          ['relational_operator'] = '<=',
          ['threshold'] = '0',
          ['window'] = '20',
          ['periods'] = '0',
          ['function'] = 'min',
          ['group_by'] = {
          },
        },
      },
    },
  },
  {
    ['name'] = 'rabbitmq-memory-limit-warning',
    ['description'] = 'RabbitMQ is getting close to the memory threshold',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'okay',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'rabbitmq_remaining_memory',
          ['fields'] = {
          },
          ['relational_operator'] = '<=',
          ['threshold'] = '104857600',
          ['window'] = '20',
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
