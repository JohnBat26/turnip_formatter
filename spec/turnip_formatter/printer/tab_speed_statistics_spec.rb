require 'spec_helper'
require 'turnip_formatter/printer/tab_speed_statistics'

module TurnipFormatter::Printer
  describe TabSpeedStatistics do
    let :statistics do
      TurnipFormatter::Printer::TabSpeedStatistics
    end

    let :passed_scenarios do
      ([passed_example] * 3).map do |ex|
        TurnipFormatter::Scenario::Pass.new(ex)
      end.each { |s| allow(s).to receive(:run_time).and_return(rand) }
    end

    describe '.print_out' do
      it 'should get string as HTML table' do
        html = statistics.print_out(passed_scenarios)

        passed_scenarios.sort { |a,b| a.run_time <=> b.run_time }.each.with_index(1) do |scenario, index|
          tag_feature_name  = "<span>#{scenario.feature_name}</span>"
          tag_scenario_name = "<a href=\"\##{scenario.id}\">#{scenario.name}</a>"
          tag_run_time      = "<span>#{scenario.run_time} sec</span>"

          expect_match = [
            '<tr>',
            "<td>#{tag_feature_name}</td>",
            "<td>#{tag_scenario_name}</td>",
            "<td>#{tag_run_time}</td>",
            '</tr>'
          ].join

          expect(html).to match %r(#{expect_match})
        end
      end
    end

    describe '.speed_analysis' do
      it 'should get array of scenario order by run_time' do
        scenarios = statistics.send(:speed_analysis, passed_scenarios)
        expect(scenarios.size).to eq 3

        run_time_list = scenarios.map(&:run_time)
        expect(run_time_list.sort).to eq run_time_list
      end
    end
  end
end
