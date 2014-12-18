module WinRM
  # This class holds raw output as a hash, and has convenience methods to parse.
  class Output < Hash
    def initialize
      super
      self[:data] = []
    end

    def output
      self[:data].flat_map do | line |
        [line[:stdout], line[:stderr]]
      end.compact.join
    end

    def stdout
      self[:data].map do | line |
        line[:stdout]
      end.compact.join
    end

    def stderr
      self[:data].map do | line |
        line[:stderr]
      end.compact.join
    end

    def stderr_text
      doc = REXML::Document.new(stderr)
      text = doc.root.get_elements('//S').map(&:text).join
      text.gsub(/_x(\h\h\h\h)_/) do
        code = Regexp.last_match[1]
        code.hex.chr
      end
    end
  end
end
