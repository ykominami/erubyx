# frozen_string_literal: true

module TestConf
  require 'pathname'
  require 'ostruct'
  require 'clitest'

  class TestConf
    attr_reader :o

    def initialize(target_cmd_1, target_cmd_2, original_spec_file_path, original_output_dir = nil)
      o = OpenStruct.new
      pn = Pathname.new(original_spec_file_path)
      if pn.dirname == "spec"
        spec_pn = pn.parent
      else
        pn = Pathname.new(ENV['PWD'])
        spec_pn = pn.join("spec")
        spec_pn = nil unless spec_pn.exist?
      end
      if spec_pn == nil
        if ENV['SPEC_DIR']
          spec_pn = Pathname.new(ENV['SPEC_DIR'])
          spec_pn = nil unless spec_pn.exist?
        end
      end
      #
      o.spec_pn = spec_pn
      #
      o.spec_dir = o.spec_pn.to_s
      o.top_dir_pn = o.spec_pn.parent
      o.top_dir = o.top_dir_pn.to_s

      o.target_cmd_1 = target_cmd_1 #'make_script'
      o.target_cmd_2 = target_cmd_2 #''
      pn = o.top_dir_pn.join("bin")
      if pn.exist?
        o.bin_dir_pn = pn
        pn2 = o.bin_dir_pn.join(o.target_cmd_1)
        o.target_cmd_1_pn = pn2
        pn2 = o.bin_dir_pn.join(o.target_cmd_2)
        o.target_cmd_2_pn = pn2
      end
      pn3 = o.top_dir_pn.join("exe")
      if pn3.exist?
        o.exe_dir_pn = pn3
        if o.target_cmd_1_pn
          pn4 = o.exe_dir_pn.join(o.target_cmd_1)
          if pn4.exist?
            o.target_cmd_1_pn = pn4
          end
        end
        if o.target_cmd_2_pn
          pn5 = o.exe_dir_pn.join(o.target_cmd_2)
          if pn5.exist?
            o.target_cmd_2_pn = pn5
          end
        end
      end
      o.make_arg_basename = 'make_cmdline_1'

      o.test_root_dir_pn = o.top_dir_pn.join('test_auto')
      o.test_root_dir = o.test_root_dir_pn.to_s

      if original_output_dir != nil
        o.target_parent_dir_pn = o.test_root_dir_pn.join(original_output_dir)
      else
        o.target_parent_dir_pn = o.test_root_dir_pn.join('test_data2' ,'test_case')
      end
      o.target_parent_dir = o.target_parent_dir_pn
      o.result = 'result.txt'
      o._test_data_dir_pn = o.test_root_dir_pn.join('_test_data')
      o.misc_dir_pn = o.test_root_dir_pn.join('misc')
      o.tsv_fname = 'testlist-x.txt'
      o.misc_tsv_fname = o.misc_dir_pn.join(o.tsv_fname)

      #
      o.output_dir_pn = o.target_parent_dir_pn
      o.output_dir = o.output_dir_pn.to_s
      #
      o.output_template_and_data_dir_pn = o.output_dir_pn.join("template_and_data")
      o.output_template_and_data_dir = o.output_template_and_data_dir_pn.to_s
      o.output_script_dir_pn = o.output_dir_pn.join("script")
      o.output_script_dir = o.output_script_dir_pn.to_s
      o.output_test_case_root_dir_pn = o.output_dir_pn.join("test_case")
      o.output_test_case_root_dir = o.output_test_case_root_dir_pn.to_s

      o.template_and_data_dir_pn = o.target_parent_dir_pn.join("template_and_data")
      o.target_parent_dir_pn
      o._output_dir_pn = o.test_root_dir_pn.join('_output')
      o._output_dir = o._output_dir_pn.to_s
      o._test_case_dir_pn = o._output_dir_pn.join("test_case")
      o._test_case_dir = o._test_case_dir_pn.to_s
      o._template_and_data_dir_pn = o._output_dir_pn.join("template_and_data")
      o._template_and_data_dir = o._template_and_data_dir_pn.to_s
      o._script_dir_pn = o._output_dir_pn.join("script")
      o._script_dir = o._script_dir_pn.to_s
      o.content_fname = 'content.txt'
      o.testdata_fname = 'testdata.txt'
      o.yaml_fname = 'a.yml'
      o._yaml_fname = 'a.yml'
      o._config = Erubyx::Config.new(o.spec_dir, o._output_dir)
      o._data_dir_pn = o._template_and_data_dir_pn.join('a')
    #
      o.data_dir_pn = o.output_template_and_data_dir_pn.join('a')
    #
      o.config_0 = Erubyx::Config.new(o.spec_dir, o.output_dir).setup
      o.asp_dir = o.test_root_dir_pn.join("asp" , "tecs")
      o.asp3_dir = o.test_root_dir_pn.join("asp3")
      o.start_char = 'a'
      o.limit = 6
      o.test_1 = 'test_1'
      o.test_2 = 'test_2'
      o.format_fname = 'format.txt'
      o.number_of_testgroup = 59
      o.number_of_testscript = 19
      o.number_of_testgroup_of_first_testscript = 3
      o.tgroup_0_name = 'mruby-MrubyBridge'
      o.tgroup_0_name_normalize = 'mruby_MrubyBridge'
      o.cmdline_0 = Clitest::Cmdline.new(nil, nil, o.target_parent_dir_pn, o.target_cmd_1_pn)
      @o = o
    end

    def make_script_name(name)
      %(#{name}_spec.rb)
    end

    def make_absolute_target_dir(target_parent_dir, test_case_dir = nil)
      absolute_path = ''
      if target_parent_dir
        target_parent_pn = Pathname.new(target_parent_dir)
        absolute_path = if test_case_dir && test_case_dir !~ /^\s*$/
                target_parent_pn.join(test_case_dir.to_s)
              else
                target_parent_pn
              end
      elsif test_case_dir && test_case_dir !~ /^\s*$/
        absolute_path = Pathname.new(test_case_dir.to_s)
      end

      absolute_path.to_s
    end

    def make_result_file_path(target_dir, result)
      ret = ''
      if target_dir
        target_pn = Pathname.new(target_dir)
        ret = if result
                target_pn.join(result)
              else
                target_pn
              end
      elsif result
        result_pn = Pathname.new(result)
        ret = result_pn
      end

      ret.to_s
    end

    def make_absolute_target_dir_and_result_file_path(target_parent_dir, test_case_dir, result)
      absolute_target_dir = make_absolute_target_dir(target_parent_dir, test_case_dir)
      result_file_path = make_result_file_path(absolute_target_dir, result)

      [absolute_target_dir, result_file_path]
    end

    def create_instance_of_config
      Erubyx::Config.new(@o.spec_dir, @o.output_dir).setup
    end

    def create_instance_of_root
      Erubyx::Loggerxcm.debug("output_dir=#{@o.output_dir}")
      yml_path = @o.config_0.make_path_under_template_and_data_dir( Pathname.new('a').join(@o.yaml_fname))
      Erubyx::Loggerxcm.debug("yml_path=#{yml_path}")
      Erubyx::Root.new(yml_path, @o.config_0)
    end

    def create_instance_of_item(content_path, yaml_path)
      level = 1
      tag = 'make_arg_data_flat'
      hash = {}
      #              (size,  name, outer_hash,   content_path, yaml_path, config)
      @o._config.setup
      Erubyx::Item.new(level, 0, tag,  hash,         content_path, yaml_path, @o._config)
    end

    def create_instance_of_setting
      testscript = create_instance_of_testscript
      config = create_instance_of_config
      func_name_of_make_arg = o.make_arg_basename
      Erubyx::Setting.new(testscript, config, func_name_of_make_arg)
    end

    def create_instance_of_testscript
      name = o.start_char
      limit = o.limit
      Erubyx::TestScript.new(name, limit)
    end

    def create_instance_of_templatex
      setting = create_instance_of_setting
      Erubyx::Templatex.new(setting)
    end

    def create_instance_of_testgroup_0
      make_arg_basename = o.make_arg_basename
      tgroup_0 = o.tgroup_0_name
      tgroup = tgroup_0.tr('-', '_').tr('.', '_')
      Erubyx::TestGroup.new(tgroup, make_arg_basename)
    end

    def create_instance_of_testcase
      make_arg_basename = o.make_arg_basename
      tgroup_0 = 'mruby-MrubyBridge'
      tgroup = tgroup_0.tr('-', '_').tr('.', '_')
      test_group = create_instance_of_testgroup(tgroup, make_arg_basename)
      tcase_0 = '6.2'
      tcase = tcase_0.tr('-', '_').tr('.', '_')
      test_1 = nil
      test_1_value = nil
      test_2 = nil
      test_2_value = nil
      extra = nil
      Erubyx::TestCase.new(test_group, tcase, test_1, test_1_value, test_2, test_2_value, extra)
    end

    def create_instance_of_testgroup(tgroup, make_arg_basename)
      Erubyx::TestGroup.new(tgroup, make_arg_basename)
    end

    def create_instance_of_testscript
      name = o.start_char
      limit = o.limit
      Erubyx::TestScript.new(name, limit)
    end

    def create_instance_of_testscriptgroup
      fname = @o.misc_tsv_fname
      start_char = o.start_char
      limit = o.limit
      make_arg_basename = o.make_arg_basename
      Erubyx::TestScriptGroup.new(fname, start_char, limit, make_arg_basename)
    end

    def create_instance_of_testscript
      name = o.start_char
      limit = o.limit
      Erubyx::TestScript.new(name, limit)
    end

    def create_instance_of_mkscript(argv)
      Erubyx::Mkscript.new(argv)
    end

    def create_instance_of_mkscript(argv)
      Erubyx::Mkscript.new(argv)
    end
  end
end