class HomeController < ApplicationController
  def index
    options = Selenium::WebDriver::Chrome::Options.new

    # make a directory for chrome if it doesn't already exist
    chrome_dir = File.join Dir.pwd, %w(tmp chrome)
    FileUtils.mkdir_p chrome_dir
    user_data_dir = "--user-data-dir=#{chrome_dir}"
    # add the option for user-data-dir
    options.add_argument user_data_dir

    # let Selenium know where to look for chrome if we have a hint from
    # heroku. chromedriver-helper & chrome seem to work out of the box on osx,
    # but not on heroku.
    if chrome_bin = ENV["GOOGLE_CHROME_SHIM"]
      options.add_argument "--no-sandbox"
      options.binary = chrome_bin
    end

    # headless!
    options.add_argument "--window-size=1200x600"
    options.add_argument "--headless"
    options.add_argument "--disable-gpu"

    # make the browser
    browser = Watir::Browser.new :chrome, options: options
    browser.goto 'www.google.com'
    @aaa = browser.text[0..-1]
  end
end
