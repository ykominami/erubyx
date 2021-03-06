# frozen_string_literal: true

require 'pathname'
require 'fileutils'

module Mkspec
  class Config
    attr_reader :spec_dir_pn, :test_dir_pn, :misc_dir_pn, :output_dir_pn,
                :output_script_dir_pn, :output_template_and_data_dir_pn, :output_test_case_dir_pn,
                :archive_dir_pn

    # spec
    #     /test
    #          /_test_archive
    #     　　　/misc
    # test_output
    # test_output/script
    # test_output/test_case
    # test_output/template_and_data
    #
    SPEC_DIR = 'spec'
    TEST_DIR = 'test'

    TEST_ARCHIVE_DIR = '_test_archive'
    TEST_CASE_ARCHIVE_DIR = '_test_case_archive'
    MISC_DIR = 'misc'

    ROOT_OUTPUT_DIR = 'test_auto'
    OUTPUT_SCRIPT_DIR = 'script'
    OUTPUT_TEST_CASE_DIR = 'test_case'
    OUTPUT_TEMPLATE_AND_DATA_DIR = 'template_and_data'

    def initialize(spec_dir, output_dir, script_dir, tad_dir, test_case_dir = nil)
      @setup_count = 0
      @spec_dir_pn = Pathname.new(spec_dir)

      @test_dir_pn = @spec_dir_pn.join(TEST_DIR)

      @misc_dir_pn = @test_dir_pn.join(MISC_DIR)
      top_pn = @spec_dir_pn.parent
      @root_output_dir_pn = top_pn.join(ROOT_OUTPUT_DIR)

      @output_dir = output_dir
      @script_dir = script_dir
      @tad_dir = tad_dir
      @test_case_dir = test_case_dir
    end

    def setup
      return self if @setup_count.positive?
      Loggerxcm.debug("Config.setup #{@setup_count} self=#{self}")
      Loggerxcm.debug(["caller=" , caller].join("\n"))
      _output_dir_pn = Pathname.new(@output_dir)
      if _output_dir_pn.absolute?
        pn = _output_dir_pn
      else
        pn = @root_output_dir_pn.join(@output_dir)
      end
      Loggerxcm.debug("Config.setup pn=#{pn}")
      pn.mkpath unless pn.exist?
      @output_dir_pn = pn

      @script_absolute_dir_pn = check_absolute_dir(@script_dir) 
      @tad_absolute_dir_pn = check_absolute_dir(@tad_dir)
      @test_case_absolute_dir_pn = check_absolute_dir(@test_case_dir) 

      @output_script_dir_pn = setup_dir(@script_absolute_dir_pn, @script_dir, OUTPUT_SCRIPT_DIR)
      @output_template_and_data_dir_pn = setup_dir(@tad_absolute_dir_pn, @tad_dir, OUTPUT_TEMPLATE_AND_DATA_DIR)
      @output_test_case_dir_pn = setup_dir(@test_case_absolute_dir_pn, @test_case_dir, OUTPUT_TEST_CASE_DIR)

      @test_case_archive_dir_pn = @test_dir_pn.join(TEST_CASE_ARCHIVE_DIR) 
      Loggerxcm.debug("@test_case_archive_dir_pn=#{@test_case_archive_dir_pn}")
      if @output_template_and_data_dir_pn.exist?
        setup_dir_content(@test_case_archive_dir_pn, @output_test_case_dir_pn)
      else
        Loggerxcm.error("Can't find #{@test_case_archive_dir_pn}")
        raise(Mkspec::MkspecDebugError, "config.rg 1")
      end

      @archive_dir_pn = @test_dir_pn.join(TEST_ARCHIVE_DIR)
      if @archive_dir_pn.exist?
        setup_dir_content(@archive_dir_pn, @output_template_and_data_dir_pn)
      else
        Loggerxcm.error("Can't find #{@archive_dir_pn}")
        raise(Mkspec::MkspecDebugError, "config.rb 2")
      end
      @setup_count += 1

      self
    end

    def setup_dir(absolute_pn, dir, default_dir)
      if absolute_pn
        absolute_pn
      else
        if dir
          Loggerxcm.debug("setup_dir 1 dir=#{dir}")
          setup_directory(dir)
        else
          Loggerxcm.debug("setup_dir 21 dir=#{dir}")
          Loggerxcm.debug("setup_dir 22 default_dir=#{default_dir}")
          setup_directory(default_dir)
        end
      end
    end

    def check_absolute_dir( dir )
      if dir
        hash = { given: dir, absolute: nil }
        check_dir(hash)
        hash[:absolute]
      else
        nil
      end
    end

    def check_dir( hash )
      given_dir = hash[:given]
      if given_dir
        pn = Pathname.new(given_dir)
        hash[:absolute] = pn.absolute? ? pn : pn.realpath if pn.exist?
      end
    end

    def setup_dir_content(src_dir, dest_dir)
      FileUtils.copy_entry(src_dir, dest_dir)
    end

    def setup_directory(dir)
      pn = @output_dir_pn + dir
      Loggerxcm.debug("setup_directory pn=#{pn}")
      pn.mkpath unless pn.exist?
      pn
    end

    def make_path_under_misc_dir(fname)
      @misc_dir_pn.join(fname)
    end

    def make_path_under_template_and_data_dir(fname)
      @output_template_and_data_dir_pn.join(fname)
    end

    def make_path_under_script_dir(fname)
      @output_script_dir_pn.join(fname)
    end

    def make_path_under_test_case_dir(fname)
      @output_test_case_dir_pn.join(fname)
    end
  end
end
