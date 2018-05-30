local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'ceph-capacity-critical',
    ['description'] = 'Ceph free capacity is too low',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'ceph_pool_total_percent_free',
          ['fields'] = {
          },
          ['relational_operator'] = '<',
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
  {
    ['name'] = 'ceph-capacity-warning',
    ['description'] = 'Ceph free capacity is low',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'ceph_pool_total_percent_free',
          ['fields'] = {
          },
          ['relational_operator'] = '<',
          ['threshold'] = '5',
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
