local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'cinder-scheduler-all-down',
    ['description'] = 'All Cinder schedulers are down',
    ['severity'] = 'down',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_cinder_services',
          ['fields'] = {
            ['service'] = 'scheduler',
            ['state'] = 'up',
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
    ['name'] = 'cinder-scheduler-majority-down',
    ['description'] = 'Less than 50% of Cinder schedulers are up',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_cinder_services_percent',
          ['fields'] = {
            ['service'] = 'scheduler',
            ['state'] = 'up',
          },
          ['relational_operator'] = '<=',
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
    ['name'] = 'cinder-scheduler-one-down',
    ['description'] = 'At least one Cinder scheduler is down',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_cinder_services',
          ['fields'] = {
            ['service'] = 'scheduler',
            ['state'] = 'down',
          },
          ['relational_operator'] = '>',
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
