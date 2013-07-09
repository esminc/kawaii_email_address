require "email_format_validator/version"

module EmailFormatValidator
  class Address
    LocalPartChars             = ((?A..?Z).to_a + (?a..?z).to_a + (0..9).to_a).join + %q[!#$%&'*-/=?+-^_`{|}~]
    LocalPartQuotedStringChars = %q[()<>[]:;@,.] << ' '

    PERIOD =        '.'
    BACKSLASH =     '\\'
    DOUBLE_QUOTE =  '"'

    attr_reader :local_part, :domain_part

    class << self
      attr_accessor :period_restriction_violate_domains
    end

    self.period_restriction_violate_domains = %w[docomo.ne.jp ezweb.ne.jp]

    def initialize(address)
      @domain_part, @local_part = address.reverse.split('@', 2).map(&:reverse)
    end

    def valid?
      valid_local_part?
    end

    def to_s
      [local_part, domain_part].join('@')
    end

    def valid_local_part?
      return false if invalid_period_position?

      in_quoted_pair    = false
      in_quoted_string  = false

      is_valid = local_part.chars.each.with_index.all? do |char, i|
        # accept anything if it's got a backslash before it
        if in_quoted_pair
          in_quoted_pair = false
          next true
        end

        case char
        when BACKSLASH # backslash signifies the start of a quoted pair
          # must be in quoted string per http://www.rfc-editor.org/errata_search.php?rfc=3696
          if (i < local_part.length - 1) && in_quoted_string
            in_quoted_pair = true
            next true
          end

        when DOUBLE_QUOTE # double quote delimits quoted strings
          in_quoted_string = !in_quoted_string
          next true

        when PERIOD
          period_restriction_violate_domain? ||
          in_quoted_string ||
          local_part[i + 1] != PERIOD

        else
          LocalPartChars.include?(char) || \
          (in_quoted_string && LocalPartQuotedStringChars.include?(char))

        end
      end

      is_valid && !in_quoted_string
    end

    private

    def period_restriction_violate_domain?
      self.class.period_restriction_violate_domains.include?(domain_part)
    end

    def invalid_period_position?
      return false if period_restriction_violate_domain?

      local_part.start_with?(PERIOD) || local_part.end_with?(PERIOD)
    end
  end
end
