require 'email_format_validator/version'
require 'ipaddress'

module EmailFormatValidator
  class Address
    LocalPartChars             = ((?A..?Z).to_a + (?a..?z).to_a + (0..9).to_a).join + %q[!#$%&'*-/=?+-^_`{|}~]
    LocalPartQuotedStringChars = %q[()<>[]:;@,.] << ' '

    PERIOD =        '.'
    BACKSLASH =     '\\'
    DOUBLE_QUOTE =  '"'
    DOMAIN_LITERAL_RE = /\A\[(?<ip_addr>.+)\]\z/

    attr_reader :local_part, :domain_part

    def initialize(address)
      @domain_part, @local_part = address.reverse.split('@', 2).map(&:reverse)
    end

    def valid?
      valid_local_part? && valid_domain_part?
    end

    def to_s
      [@local_part, @domain_part].join('@')
    end

    def valid_local_part?
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
          (0 < i) && \
          (i < local_part.length - 1) && \
          (in_quoted_string || local_part[i + 1] != PERIOD) # can't be followed by a period

        else
          LocalPartChars.include?(char) || \
          (in_quoted_string && LocalPartQuotedStringChars.include?(char))

        end
      end

      is_valid && !in_quoted_string
    end

    def valid_domain_part?
      if match = DOMAIN_LITERAL_RE.match(domain_part)
        valid_domain_literal?(match[:ip_addr])
      else
        valid_fqdn_domain_part?
      end
    end

    def valid_domain_literal?(domain)
      begin
        IPAdress.new(domain)
      rescue
        false
      end
    end

    def valid_fqdn_domain_part?
      parts = domain_part.downcase.split('.', -1)

      return false if parts.length <= 1

      return false if parts.any? do |part|
        part.nil? || part.empty? || part !~ /\A[[:alnum:]\-]+\z/ || part.start_with?('-') || part.end_with?('-')
      end

      return false if parts.last.length < 2 || parts.last !~ /[a-z\-]/

      return true
    end
  end
end
