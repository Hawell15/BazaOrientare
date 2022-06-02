module ApplicationHelper
  def aaa
    opts = {
      headless: true
    }

    if (chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil))
      opts.merge!( options: {binary: chrome_bin})
    end

    browser = Watir::Browser.new :phantomjs
    browser.goto 'www.google.com'
    browser.text[0..-1]
  end
end
