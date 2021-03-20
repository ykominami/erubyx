# frozen_string_literal: true

module Erubyx
  class TestGroup
    attr_reader :name, :test_cases, :size, :content_name_of_make_arg

    def initialize(name, make_arg_basename, extra = nil)

      @name = name
      @test_cases = []
      @size = 0
      @content_name_of_make_arg = [make_arg_basename, name].join('_')
      @extra = extra
    end

    def to_s
      @name
    end

    def add_test_case(testcase_name, dir, test_1, test_1_value, test_2, test_2_value, extra = nil)
      @test_cases << TestCase.new(self, testcase_name, dir, test_1, test_1_value, test_2, test_2_value, extra)
      @size += 1
    end

    def print
      Loggerxcm.debug '# TestGroup'
      Loggerxcm.debug @name
      @test_cases.map(&:print)
    end
  end
end
