require 'test_helper'
require 'epo/ops/register'
require 'epo/ops/ipc_class_util'

module Epo
  class IpcClassUtilTest < Minitest::Test
    def test_valid
      positives = ['A',
                   'B',
                   'A23',
                   'A32F',
                   'A62B35/04',
                   'A62B1/14',
                   'G06T17/20',
                   'A62B33/00',
                   'A01B63/112']
      positives.each { |t| assert Epo::Ops::IpcClassUtil.valid_for_search?(t) }
      refute Epo::Ops::IpcClassUtil.valid_for_search? 'A32B23'
      refute Epo::Ops::IpcClassUtil.valid_for_search? 'AB23'
      refute Epo::Ops::IpcClassUtil.valid_for_search? 'AB'
    end

    def test_parse_generic
      pairs = {
        'A01B0003000000' => 'A01B3/00',
        'A01B0003120000' => 'A01B3/12',
        'A01B0035120000' => 'A01B35/12',
        'A01B0063112000' => 'A01B63/112'
      }
      pairs.each do |generic, parsed|
        assert_equal parsed, Epo::Ops::IpcClassUtil.parse_generic_format(generic)
      end
    end
  end
end
