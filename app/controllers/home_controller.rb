class HomeController < ApplicationController
  def index
  end
  def wredata
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'http://ranking.orienteering.org/ranking'
    browser.select(id: "FederationRegion").wait_until(&:present?)
    browser.select(id: "FederationRegion").select("MDA")
    sleep 0.5
    browser.button(id: "MainContent_btnShowRanking").click
    browser.span(class: "flag-MDA").wait_until(&:present?)
    ids = ["8458"]
    ids += persons(browser)

    browser.select(id: "MainContent_ddlGroup").select("Women")
    sleep 0.5
    browser.button(id: "MainContent_btnShowRanking").click
    browser.select(id: "MainContent_ddlGroup").wait_until { |val| val.value == "WOMEN"}
    ids += persons(browser)

    @runners = ids.map do |id|
      browser.goto "https://ranking.orienteering.org/PersonView?person=#{id}"
      browser.table(class: "ranktable").wait_until(&:present?)
      html = Nokogiri::HTML(browser.html)
      name ="#{html.at_css("span#MainContent_RunnerDetails_Label1").text} #{html.at_css("span#MainContent_RunnerDetails_Label3").text}"
      rankings = {
        forest: html.at_css("span.badge-rank").text,
        sprint: html.css("span.badge-rank").last.text
      }

      results = html.at_css("table.ranktable").css("tr").drop(1).map do |tr|
        {
          date: tr.at_css("td").text,
          competition: tr.css("td")[1].text,
          points: tr.css("td")[-2].text
        }

      end
      {
          name: name,
          rankings: rankings,
          results: results
        }
    end
    render json: { data: @runners}
  end


  def persons(browser)
    browser.links(href: /PersonView/).map do |link|
      link.href[/\d+/]
    end
  end
end
