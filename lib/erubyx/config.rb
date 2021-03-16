# frozen_string_literal: true

require 'pathname'
require 'fileutils'

module Erubyx
  class Config < Objectx
    attr_reader :spec_dir_pn, :test_dir_pn, :misc_dir_pn, :output_dir_pn, 
    :output_script_dir_pn, :output_template_and_data_dir_pn, :output_test_case_dir_pn,
    :archive_dir_pn

    # spec
    #     /test
    #          /_test_archive
    #     　　　/misc
    # test-output
    # test-output/script
    # test-output/test_case
    # test-output/template_and_data
    # test-output/setting
    #
    SPEC_DIR = 'spec'
    TEST_DIR = 'test'

    TEST_ARCHIVE_DIR = '_test_archive'
    MISC_DIR = 'misc'

#    ROOT_OUTPUT_DIR = 'output'
    ROOT_OUTPUT_DIR = 'test_output'
    OUTPUT_SCRIPT_DIR = 'script'
    OUTPUT_TEST_CASE_DIR = 'test_case'
    OUTPUT_TEMPLATE_AND_DATA_DIR = 'template_and_data'

    def initialize(spec_dir, output_dir, test_case_dir = nil)
      super()

      @spec_dir_pn = Pathname.new(spec_dir)

      @test_dir_pn = @spec_dir_pn + TEST_DIR

      @misc_dir_pn = @test_dir_pn + MISC_DIR
      top_pn = @spec_dir_pn + ".."
      @root_output_dir_pn = top_pn + ROOT_OUTPUT_DIR

      pn = @root_output_dir_pn + output_dir
      pn.mkpath unless pn.exist?
      @output_dir_pn = pn

      @output_template_and_data_dir_pn = setup_directory(OUTPUT_TEMPLATE_AND_DATA_DIR)
      @output_script_dir_pn = setup_directory(OUTPUT_SCRIPT_DIR)
      if test_case_dir
        pn = Pathname.new(test_case_dir)
        pn.mkpath unless pn.exist?
        @output_test_case_dir_pn = pn
      else
        @output_test_case_dir_pn = setup_directory(OUTPUT_TEST_CASE_DIR)
      end

      @archive_dir_pn = @test_dir_pn + TEST_ARCHIVE_DIR
      setup_archive_dir
    end

    def setup_archive_dir
      FileUtils.copy_entry(@archive_dir_pn, @output_template_and_data_dir_pn) if @archive_dir_pn.exist?
    end

    def setup_directory(dir)
      pn = @output_dir_pn + dir
      pn.mkpath unless pn.exist?
      pn
    end

    def make_path_under_misc_dir(fname)
      @misc_dir_pn + fname
    end

    def make_path_under_template_and_data_dir(fname)
      @output_template_and_data_dir_pn + fname
    end

    def make_path_under_script_dir(fname)
      @output_script_dir_pn + fname
    end

    def make_path_under_test_case_dir(fname)
      @output_test_case_dir_pn + fname
    end
  end
end
