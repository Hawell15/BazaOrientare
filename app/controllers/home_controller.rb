class HomeController < ApplicationController
  def index
  end

  def wre_id
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'http://ranking.orienteering.org/ranking'
    browser.select(id: "FederationRegion").wait_until(&:present?)
    browser.select(id: "FederationRegion").select("MDA")
    sleep 0.5
    browser.button(id: "MainContent_btnShowRanking").click
    browser.span(class: "flag-MDA").wait_until(&:present?)
    ids = [{ surname: "Roman" ,name: "Ciobanu", id: "8458", gender: "M" }]
    ids += persons(browser, "M")

    browser.select(id: "MainContent_ddlGroup").select("Women")
    sleep 0.5
    browser.button(id: "MainContent_btnShowRanking").click
    browser.select(id: "MainContent_ddlGroup").wait_until { |val| val.value == "WOMEN"}
    ids += persons(browser, "F")

    new_ids = []
    exist_ids = []
    new_runner_ids = []

    ids.each do |id|
       if Runner.find_by(wre_id: id[:id])
        exist_ids << id[:id]
        next
      end
      runner =  Runner.find_by(runner_name: id[:name], surname: id[:surname])

      if runner
        runner.update(wre_id: id[:id])
        new_ids << id[:id]
      else
        new_runner_ids << id[:id]
        Runner.create(runner_name: id[:name], surname: id[:surname], gender: id[:gender], wre_id: id[:id], club_id: 0, category_id: 10 )
      end
    end
    browser.close

    render json: { new_ids: new_ids, exist_ids: exist_ids, new_runner_ids: new_runner_ids}
  end

  def wre_results
    @results_count = 0
    runners = Runner.where.not(wre_id: nil)
    browser = Watir::Browser.new :chrome, headless: true
    runners.each do |runner|
      browser.goto "https://ranking.orienteering.org/PersonView?person=#{runner[:wre_id]}"
      browser.table(class: "ranktable").wait_until(&:present?)
      html = Nokogiri::HTML(browser.html)
      # name ="#{html.at_css("span#MainContent_RunnerDetails_Label1").text} #{html.at_css("span#MainContent_RunnerDetails_Label3").text}"
      runner.update(
        forest_wre_ranking: html.at_css("a.list-group-item:not(:contains('Sprint')) span")&.text.to_i,
        sprint_wre_ranking: html.at_css("a.list-group-item:contains('Sprint') span")&.text.to_i
      )
      parse_results(html, runner)

      next unless browser.link(href: "#list", text: /Sprint/).present?

      browser.link(href: "#list", text: /Sprint/).click
      browser.table(class: "ranktable", text:/Sprint/).wait_until(&:present?)
      html = Nokogiri::HTML(browser.html)
      parse_results(html, runner, "Sprint")
    end

    browser.close

    render json: { competitions: @results_count}
  end

  def wredata
    runners = Runner.where.not(wre_id: nil)

    data = runners.map do |runner|
      results = runner.results.where.not(wre_points: nil).map do |res|
        {
          date: res.group.competition.date.as_json,
          name: res.group.competition.competition_name,
          place: res.place,
          points: res.wre_points,
          category: res.category.category_name
        }
      end
      {
        name: "#{runner.runner_name} #{runner.surname}",
        wre_id: runner.wre_id,
        forest_wre_ranking: runner.forest_wre_ranking,
        sprint_wre_ranking: runner.sprint_wre_ranking,
        results: results
      }
    end
    render json: { data: data}
  end


  def persons(browser, gender)
    browser.links(href: /PersonView/).map do |link|
      {
        surname: link.text.split.first,
        name:    link.text.split.last,
        id:      link.href[/\d+/],
        gender:  gender
      }
    end
  end

  def parse_results(html, runner, distance_type = nil)
    html.at_css("table.ranktable").css("tr").drop(1).each do |tr|
      time  =tr.css("td")[4].text.split(":")
      data = {
        date: Date.strptime(tr.at_css("td").text, '%m/%d/%Y'),
        competition_name: tr.css("td")[1].text,
        cometition_id: tr.css("td")[1].at_css("a")["href"][/event=\d+/][/\d+/],
        points: tr.css("td")[-2].text.to_i,
        place: tr.css("td")[3].text.to_i,
        time: time.first.to_i * 60 + time.last.to_i
      }
      distance_type ||= case data[:competition_name]
      when /Long/i then "Long"
      when /Middle/i then "Middle"
      end

      competition = Competition.find_or_create_by(
        competition_name: data[:competition_name],
        date: data[:date],
        wre_id: data[:cometition_id],
        distance_type: distance_type
      )
      group = Group.find_or_create_by(competition: competition, group_name: "#{runner.gender.upcase.sub("F", "W")}21E")
      next if Result.find_by(runner: runner, group: group)

      category_id = case data[:points]
      when 700..999 then 3
      when 1000..1299 then 2
      when 1300..1500 then 1
      else 10
      end
      @results_count += 1
      Result.create(group: group, runner: runner, place: data[:place], time: data[:time], category_id: category_id, wre_points: data[:points] )
    end
  end
end
