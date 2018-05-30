local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'rabbitmq-pacemaker-down',
    ['description'] = 'The RabbitMQ cluster is down',
    ['severity'] = 'down',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'and',
      ['rules'] = {
        {
          ['metric'] = 'pacemaker_resource_percent',
          ['fields'] = {
            ['resource'] = 'rabbitmq',
            ['status'] = 'up',
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
  {
    ['name'] = 'rabbitmq-pacemaker-critical',
    ['description'] = 'The RabbitMQ cluster is critical because less than half of the nodes are up',
    ['severity'] = 'critical',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'and',
      ['rules'] = {
        {
          ['metric'] = 'pacemaker_resource_percent',
          ['fields'] = {
            ['resource'] = 'rabbitmq',
            ['status'] = 'up',
          },
          ['relational_operator'] = '<',
          ['threshold'] = '50',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'last',
          ['group_by'] = {
          },
        },
      },
    },
  },
  {
    ['name'] = 'rabbitmq-pacemaker-warning',
    ['description'] = 'The RabbitMQ cluster is degraded because some RabbitMQ nodes are missing',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'and',
      ['rules'] = {
        {
          ['metric'] = 'pacemaker_resource_percent',
          ['fields'] = {
            ['resource'] = 'rabbitmq',
            ['status'] = 'up',
          },
          ['relational_operator'] = '<',
          ['threshold'] = '100',
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
