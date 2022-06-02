class HomeController < ApplicationController
  def index
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'http://ranking.orienteering.org/ranking'
    browser.select(id: "FederationRegion").wait_until(&:present?)
    browser.select(id: "FederationRegion").select("MDA")
    sleep 0.5
    browser.button(id: "MainContent_btnShowRanking").click
    browser.span(class: "flag-MDA").wait_until(&:present?)
    @ids = persons(browser)

    browser.select(id: "MainContent_ddlGroup").select("Women")
    sleep 0.5
    browser.button(id: "MainContent_btnShowRanking").click
    sleep 10
    browser.select(id: "MainContent_ddlGroup").wait_until { |val| val.value == "WOMEN"}
    @ids += persons(browser)
  end


  def persons(browser)
    browser.links(href: /PersonView/).map do |link|
      link.href[/\d+/]
    end
  end
end
