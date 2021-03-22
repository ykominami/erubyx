# frozen_string_literal: true

module Erubyx
  class TestScriptGroup
    attr_reader :testscripts, :name

    #                 test_1 test_1_value                test_2    test_2_value
    DEFAULT_VALUES = ['to',  'be_successfully_executed', 'not_to', 'have_output(/error:/)'].freeze

    def initialize(tsv_path, start_char, limit, make_arg_basename)
      @tsv_path = tsv_path
      @name = start_char
      @limit = limit
      @make_arg_basename = make_arg_basename
      @testscripts = []
      @current_testscript = make_testscript(@name)
    end

    def setup_test_group(l, state)
      # tgroup, tcase, tmp = l.chomp.split(/\s+|\t+/)
      tgroup, tcase, *tmp = l.chomp.split("\t")
      return if tgroup.nil?

      return if tgroup =~ /^\s*#/

      return if tcase.nil?

      return if tcase =~ /^\s*#/

      tgroup = tgroup.tr('-', '_').tr('.', '_')
      testgroup = (state[tgroup] ||= TestGroup.new(tgroup, @make_arg_basename))
      tcase = tcase.tr('-', '_').tr('.', '_')
      array = DEFAULT_VALUES.zip(tmp[0, 4]).map { |lh, rh| rh.nil? ? lh : rh }
      extra = tmp[4, tmp.size]
      test_1, test_1_value, test_2, test_2_value = array
      testgroup.add_test_case("#{testgroup}_#{tcase}", tcase, test_1, test_1_value, test_2, test_2_value, extra)
      self
    end

    def setup_from_tsv
      File.readlines(@tsv_path).each_with_object({}) do |l, state|
        setup_test_group(l, state)
      end
    end

    def setup
      @data = setup_from_tsv
      @data.each do |x|
        testgroup = x[1]
        # TestScriptは1個以上のTestGroupを含む。
        # TestGroupは1個以上のTestCaseを含む。
        # TestScriptに含まれるTestCaseの個数の上限が設定されている。
        # TestScriptに1個のTestGroupのみが存在する場合、TestCaseの総数が上限を超えていてもよい
        # (そうしなければ、上限を超えたTestCaseが含むTestGroupを、TestScriptが持つことができない)
        if @current_testscript.grouping(testgroup) != :NOT_EMPTY
          @current_testscript = make_testscript(next_name)
          @current_testscript.grouping(testgroup)
        end
      end
      self
    end

    def make_testscript(name)
      ts = TestScript.new(name, @limit)
      @testscripts << ts
      ts
    end

    def next_name
      @name = @name.succ
    end

    def result
      @testscripts
    end
  end
end
