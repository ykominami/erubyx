# frozen_string_literal: true

require 'spec_helper'
require 'pry'

RSpec.describe 'command-line', type: :aruba do
  include UtilHelper
  include TestConf

  let(:original_output_dir_pn) { Pathname.new('_DATA').join('hier1') }
  let(:original_output_dir) { original_output_dir_pn.to_s }
#  let(:conf) { TestConf::TestConf.new( original_spec_dir, original_output_dir) }
  let(:conf) { TestConf::TestConf.new( 'make_script', '', __FILE__, original_output_dir) }
  let(:o) { conf.o }

  context 'make script' do
    before(:each) do
      tsv_fname = o.misc_tsv_fname
    end

    def make_cmdline_1(test_case_dir, *file_list)
      option_extra = []

      o.cmdline_0.make_cmdline_1(test_case_dir, o.result, option_extra.join(' '), file_list)
    end

    context 'make_script-1' do
      before(:each) do
        puts("o.target_parent_dir=#{o.target_parent_dir}")
        test_case_dir = 1
        cmdline = make_cmdline_1(test_case_dir, ['-d', o.target_parent_dir, '-t', o.misc_tsv_fname, '-c', 'all', '-s', o.start_char, '-l', o.limit])
        # pry
        run_command("bash #{cmdline}")
      end
      it '', test_normal_sh:true do expect(last_command_started).to be_successfully_executed end
      it '', test_normal_sh_out:true do expect(last_command_started).not_to have_output(/error:/) end
#      it '', test_normal_sh_out_error:true do expect(last_command_started).to have_output(/error:/) end
    end
  end
end