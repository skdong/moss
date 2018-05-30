local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'ceph-health-critical',
    ['description'] = 'Ceph health is critical',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'ceph_health',
          ['fields'] = {
          },
          ['relational_operator'] = '==',
          ['threshold'] = '3',
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
    ['name'] = 'ceph-health-warning',
    ['description'] = 'Ceph health is warning',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'ceph_health',
          ['fields'] = {
          },
          ['relational_operator'] = '==',
          ['threshold'] = '2',
          ['window'] = '60',
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
