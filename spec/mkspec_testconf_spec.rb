# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mkspec do
  include TestConf

  let(:original_output_dir_pn) { Pathname.new('_DATA') + 'hier9' }
  let(:original_output_dir) { original_output_dir_pn.to_s }
  let(:target_cmd_1) { 'tecsgen' }
  let(:target_cmd_2) { 'tecsmerge' }
  let(:conf) { TestConf::TestConf.new( ENV['GLOBAL_YAML'], target_cmd_1, target_cmd_2, __FILE__, original_output_dir) }
  let(:o) { conf.o }
#
  context 'call instance method of TestConf class' do
    before(:each) do

    end
    it 'call get_path' , xcmd:1 do
      target_cmd_1 = 'mkspec'
      target_cmd_2 = nil
      _tmp, target_cmd_1_pn, target_cmd_2_pn = conf.get_path(o.top_dir_pn, '.', target_cmd_1, target_cmd_2)
      expect(o.top_dir_pn).to_not eq(nil)
      expect(target_cmd_1_pn).to eq(nil)
    end

    it 'call get_path' , xcmd:2 do
      target_cmd_1 = 'mkspec'
      target_cmd_2 = nil
      _tmp, target_cmd_1_pn, target_cmd_2_pn = conf.get_path(o.top_dir_pn, 'bin', target_cmd_1, target_cmd_2)
      expect(o.top_dir_pn).to_not eq(nil)
      expect(target_cmd_1_pn).to_not eq(nil)
    end
  end
end
