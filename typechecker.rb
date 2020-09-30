# typed: false

require 'rubygems'
require 'bundler/setup'
require 'sorbet-runtime'
require 'open3'

class Typechecker
  class << self
    def run_checks_on
      output, status = Open3.capture2e('srb tc --ignore=.bundle/')
      puts lineify(status_text("Static Check", status.success?))
      puts "#{output}\n"

      puts lineify("🎬 Start of runtime evaluation")
      begin
        yield
      rescue => exc
        puts "\n#{lineify("❌ Runtime check")}"
        raise exc.to_s # it shortens the stacktrace so it looks better
      end
      puts "#{lineify("🔚 End of runtime evaluation")}\n\n"
      puts lineify("✅ Runtime check")
    end

    private

    def status_text(str, success)
      if success
        "✅ #{str}"
      else
        "❌ #{str}"
      end
    end

    def lineify(str, line_len = 50)
      str_len = str.length
      spacer_count = (line_len - str_len)/2
      spacer = "-"*spacer_count
      "#{spacer} #{str} #{spacer}"
    end
  end
end